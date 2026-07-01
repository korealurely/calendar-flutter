import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_calendar/repository/ble_manager.dart'; // 导入你的蓝牙单例
import 'package:flutter_calendar/repository/mqtt_manager.dart'; // 导入你的 MQTT 单例
import 'package:flutter_calendar/data/calendar_weight.dart'; // 导入你的数据实体
import 'dart:io';
import 'dart:async';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';

class WeightPage extends StatelessWidget {
  const WeightPage({super.key});

  @override
  Widget build(BuildContext context) {
    // return MaterialApp(
    //   title: 'Compose BLE to Flutter',
    //   // 🚀 【优化 1】：全面解耦硬编码，让它完美支持并自动跟随系统进行日夜切换
    //   theme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(
    //       seedColor: Colors.blue,
    //       brightness: Brightness.light,
    //     ),
    //     useMaterial3: true,
    //   ),
    //   darkTheme: ThemeData(
    //     colorScheme: ColorScheme.fromSeed(
    //       seedColor: Colors.blue,
    //       brightness: Brightness.dark,
    //     ),
    //     useMaterial3: true,
    //   ),
    //   themeMode: ThemeMode.system, // 自动追随系统天色
    //   home: const MainActivity(),
    // );
    return const MainActivity();
  }
}

class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  @override
  void initState() {
    super.initState();

    Future<void> triggerIOSLocalNetworkDialog() async {
      if (!Platform.isIOS) return;
      try {
        print("🌟 正在强行唤醒 iOS 本地网络权限弹窗...");
        final socket = await Socket.connect('192.168.50.254', 80, timeout: const Duration(seconds: 1));
        await socket.close();
      } catch (e) {
        print("👋 弹窗唤醒动作已触发：$e");
      }
    }

    _checkAndRequestPermissions();

    FlutterBluePlus.adapterState.first.then((state) {
      print("冷启动提早唤醒蓝牙大总管，当前状态: $state");
    });
  }

  @override
  void dispose() {
    BleManager.instance.stopScan();
    super.dispose();
  }

  Future<void> _checkAndRequestPermissions() async {
    Map<Permission, PermissionStatus> statuses = await [
      Permission.bluetoothScan,
      Permission.bluetoothConnect,
      Permission.location,
    ].request();

    bool allGranted = statuses.values.every((status) => status.isGranted);
    if (!allGranted) {
      final snackBar = const SnackBar(
        content: Text("请授予蓝牙与定位权限以扫描体脂秤"),
        backgroundColor: Colors.orange,
      );
      _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        // 🚀 【优化 2】：大背景色感应动态换装（白天清亮，夜间收拢为哑光高级黑）
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildScaleScreen(context),
          ),
        ),
      ),
    );
  }

  Widget _buildScaleScreen(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return StreamBuilder<bool>(
      stream: BleManager.instance.isScanning,
      initialData: false,
      builder: (context, scanSnapshot) {
        final bool scanning = scanSnapshot.data ?? false;

        return StreamBuilder<CalendarWeight?>(
          stream: BleManager.instance.scaleState,
          builder: (context, dataSnapshot) {
            final CalendarWeight? data = dataSnapshot.data;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '我的体脂秤',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    // 🚀 【优化 3】：消灭死黑死白字
                    color: Theme.of(context).textTheme.bodyLarge?.color,
                  ),
                ),
                const SizedBox(height: 24),

                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: scanning ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                      elevation: 0, // Material 3 胶囊扁平化高档感
                    ),
                    onPressed: () {
                      if (scanning) {
                        BleManager.instance.stopScan();
                      } else {
                        BleManager.instance.startScan();
                      }
                    },
                    child: Text(scanning ? "停止扫描" : "开始测量", style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  ),
                ),
                const SizedBox(height: 32),

                _buildWeightCard(context, data, scanning),
                const SizedBox(height: 24),

                if (scanning && data == null) ...[
                  const LinearProgressIndicator(),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      '正在寻找 MIBFS 体脂秤...',
                      style: TextStyle(fontSize: 12, color: isDark ? Colors.white38 : Colors.grey),
                    ),
                  ),
                ],

                const Spacer(),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildWeightCard(BuildContext context, CalendarWeight? data, bool scanning) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isDataValid = data != null && data.weight > 0 && scanning;
    final String weightDisplay = isDataValid ? data.weight.toStringAsFixed(2) : "--.-";

    // 🚀 【优化 4】：锁定数值文本在暗黑模式下调亮，避免暗底看纯绿导致视网膜疲劳
    final lockTextColor = isDark ? const Color(0xFF81C784) : const Color(0xFF2E7D32);

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        // 🚀 【优化 5】：卡片背景自适应，夜间采用 Material 3 的标准容器底色，通透有呼吸感
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '实时体重',
              style: TextStyle(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 8),

            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final inAnimation = Tween<Offset>(
                      begin: const Offset(0.0, 0.2),
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOutCubic));

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: inAnimation, child: child),
                    );
                  },
                  child: Text(
                    weightDisplay,
                    key: ValueKey<String>(weightDisplay),
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      // 🚀 【优化 6】：数字跳动过程中的主文字颜色平滑自适应
                      color: (data?.isStable == true && scanning)
                          ? lockTextColor
                          : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 12.0, left: 4.0),
                  child: Text(
                      ' kg',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      )
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),

            Text(
              "身体阻抗: ${(data != null && data.impedance != 0 && scanning) ? "${data.impedance} Ω" : "测量中..."}",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Theme.of(context).colorScheme.onSurface,
              ),
            ),

            if (data?.isStable == true && scanning) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  // 🚀 【优化 7】：锁定状态标签色感应变换。黑夜下使用极淡的半透明绿底遮罩
                  color: isDark ? const Color(0xFF81C784).withValues(alpha: 0.15) : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(6),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                child: Text(
                  '已锁定数值',
                  style: TextStyle(color: lockTextColor, fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }
}