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
    return MaterialApp(
      title: 'Compose BLE to Flutter',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      home: const MainActivity(),
    );
  }
}

class MainActivity extends StatefulWidget {
  const MainActivity({super.key});

  @override
  State<MainActivity> createState() => _MainActivityState();
}

class _MainActivityState extends State<MainActivity> {
  // 用来在全局（甚至 initState 里）弹出 SnackBar 的钥匙
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  // 🌟 核心修复：用变量持久化单例的流订阅，以便在 dispose 时销毁
  //StreamSubscription<String>? _mqttMsgSubscription;

  @override
  void initState() {
    super.initState();

    // 在你连接 MQTT 之前（比如启动 App 时），调用这个方法
    Future<void> triggerIOSLocalNetworkDialog() async {
      if (!Platform.isIOS) return;

      try {
        print("🌟 正在强行唤醒 iOS 本地网络权限弹窗...");
        // 随便找一个内网不可能存在的 IP 去尝试绑定或者连接一次
        final socket = await Socket.connect('192.168.50.254', 80, timeout: const Duration(seconds: 1));
        await socket.close();
      } catch (e) {
        // 这里必然会报错，我们不用管它，因为我们的目的只是为了惊动 iOS 系统，让它弹窗！
        print("👋 弹窗唤醒动作已触发：$e");
      }
    }

    // 1. 启动即检查并动态请求蓝牙与定位权限（对应 Android 的 checkAndRequestPermissions）
    _checkAndRequestPermissions();

    // 2. 对应 LaunchedEffect：监听来自 MQTT 核心层的一次性通知，弹出 SnackBar
    // _mqttMsgSubscription =  MqttManager.instance.isWeightMsgSend.listen((message) {
    //   final snackBar = SnackBar(
    //     content: Text(message),
    //     duration: const Duration(seconds: 2),
    //     behavior: SnackBarBehavior.floating,
    //   );
    //   _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
    // });

    // 3. 顺便模拟连接一下你的 MQTT Broker（实际开发换成你的服务器 IP）
    //MqttManager.instance.connect("192.168.50.150");

    // 在你页面的 initState 里，或者 BleManager 的构造函数里写这行代码：
    FlutterBluePlus.adapterState.first.then((state) {
      print("冷启动提早唤醒蓝牙大总管，当前状态: $state");
    });
  }


  @override
  void dispose() {
    // 4. 对应 Compose 的 DisposableEffect { onDispose { stopScan() } }
    // 当页面退出或应用关闭时，确保断开蓝牙扫描，防止后台疯狂耗电
    BleManager.instance.stopScan();
    //MqttManager.instance.dispose();
    //_mqttMsgSubscription?.cancel();
    super.dispose();
  }

  // 动态权限申请逻辑
  Future<void> _checkAndRequestPermissions() async {
    // 同时请求蓝牙扫描、连接以及定位权限（Android 低版本和某些设备必须开定位才能搜到蓝牙）
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
    // 用 ScaffoldMessenger 包裹，确保弹窗随时可用
    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        body: SafeArea( // 自动处理 EdgeToEdge / 避开刘海屏
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: _buildScaleScreen(context),
          ),
        ),
      ),
    );
  }

  // 核心主大屏（对应 @Composable fun ScaleScreen）
  Widget _buildScaleScreen(BuildContext context) {
    // 利用嵌套 StreamBuilder，完美对应 Compose 的两个 collectAsState()
    return StreamBuilder<bool>(
      stream: BleManager.instance.isScanning,
      initialData: false,
      builder: (context, scanSnapshot) {
        final bool scanning = scanSnapshot.data ?? false;

        return StreamBuilder<CalendarWeight?>(
          stream: BleManager.instance.scaleState,
          builder: (context, dataSnapshot) {
            final CalendarWeight? data = dataSnapshot.data;

            // // 当数据稳定锁定，且处于扫描状态时，自动触发 MQTT 上报
            // if (data != null && data.isStable && scanning) {
            //   // 触发一次性上报，由于在 build 里，内部单例有去重机制或你也可以加个标志位控制次数
            //   MqttManager.instance.publishWeight(data.weight, data.impedance);
            // }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '我的体脂秤',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 24),

                // 1. 控制按钮 (对应 Compose 的 Button)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      // 动态切换颜色：如果是正在扫描显示红色（Error），否则显示默认深色
                      backgroundColor: scanning ? Theme.of(context).colorScheme.error : Theme.of(context).colorScheme.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
                    ),
                    onPressed: () {
                      if (scanning) {
                        BleManager.instance.stopScan();
                      } else {
                        BleManager.instance.startScan();
                      }
                    },
                    child: Text(scanning ? "停止扫描" : "开始测量", style: const TextStyle(fontSize: 16)),
                  ),
                ),
                const SizedBox(height: 32),

                // 2. 体重显示卡片 (对应 Compose 的 Card)
                _buildWeightCard(context, data, scanning),
                const SizedBox(height: 24),

                // 3. 底部雷达进度条：如果正在扫描且没有数据
                if (scanning && data == null) ...[
                  const LinearProgressIndicator(),
                  const Padding(
                    padding: EdgeInsets.only(top: 8.0),
                    child: Text(
                      '正在寻找 MIBFS 体脂秤...',
                      style: TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ),
                ],

                const Spacer(), // 撑开中间，将 MQTT 状态顶到最底下

                // 4. MQTT 状态监控区域
                //_buildMqttStatusSection(),
              ],
            );
          },
        );
      },
    );
  }

  // 抽出封装的体重展示卡片组件
  Widget _buildWeightCard(BuildContext context, CalendarWeight? data, bool scanning) {
    final bool isDataValid = data != null && data.weight > 0 && scanning;
    final String weightDisplay = isDataValid ? data.weight.toStringAsFixed(2) : "--.-";

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
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

            // 🌟 核心特效：带数字跳动动画的文本 (等价于 Compose 的 AnimatedContent)
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 300),
                  // 自定义过渡动画：实现类似 Compose 的垂直滑入滑出 + 渐变
                  transitionBuilder: (Widget child, Animation<double> animation) {
                    final inAnimation = Tween<Offset>(
                      begin: const Offset(0.0, 0.4), // 从下方滑入
                      end: Offset.zero,
                    ).animate(CurvedAnimation(parent: animation, curve: Curves.easeOut));

                    return FadeTransition(
                      opacity: animation,
                      child: SlideTransition(position: inAnimation, child: child),
                    );
                  },
                  // 💡 必须加上这一行 ValueKey！每次文本变动，Switcher 才会认为这是新组件并触发动画
                  child: Text(
                    weightDisplay,
                    key: ValueKey<String>(weightDisplay),
                    style: TextStyle(
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                      // 如果数值锁定了显示绿色（0xFF4CAF50），否则显示默认文字颜色
                      color: (data?.isStable == true && scanning) ? const Color(0xFF4CAF50) : Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.only(bottom: 12.0, left: 4.0),
                  child: Text(' kg', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                ),
              ],
            ),
            const SizedBox(height: 16),

            // 5. 阻抗数据展示
            Text(
              "身体阻抗: ${(data != null && data.impedance != 0 && scanning) ? "${data.impedance} Ω" : "测量中..."}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),

            // 6. 稳定锁定的绿色小标签
            if (data?.isStable == true && scanning) ...[
              const SizedBox(height: 12),
              Container(
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(4),
                ),
                padding: const EdgeInsets.only(left: 8, right: 8, top: 4, bottom: 4),
                child: const Text(
                  '已锁定数值',
                  style: TextStyle(color: Color(0xFF2E7D32), fontSize: 12, fontWeight: FontWeight.bold),
                ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  // 抽出封装的底部 MQTT 连接状态
  Widget _buildMqttStatusSection() {
    return StreamBuilder<bool>(
      stream: MqttManager.instance.isMqttConnected,
      // initialData: false,
      builder: (context, snapshot) {
        final bool isMqttConnected = snapshot.data ?? false;

        if (isMqttConnected) {
          return const Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: Text(
              'Mqtt服务器已连接',
              style: TextStyle(fontSize: 12, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
          );
        } else {
          return Row(
            children: [
              const Text(
                'Mqtt服务器已断开，请重连',
                style: TextStyle(fontSize: 12, color: Colors.red, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              ElevatedButton(
                style: ElevatedButton.styleFrom(visualDensity: VisualDensity.compact),
                onPressed: () {
                  MqttManager.instance.connect("192.168.50.150"); // 点击重连
                },
                child: const Text('重连'),
              )
            ],
          );
        }
      },
    );
  }
}