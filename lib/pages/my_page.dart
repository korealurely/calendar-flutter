import 'package:flutter/material.dart';
import 'package:flutter_calendar/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_calendar/provider/theme_provider.dart';

// 🎯 记得引入你刚刚写 appLocaleProvider 的文件路径
import 'package:flutter_calendar/provider/locale_provider.dart';
import 'package:flutter_calendar/provider/shift_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:flutter_calendar/src/generated/calendar_api.g.dart';

class MyPage extends ConsumerStatefulWidget {
  const MyPage({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ConsumerStatefulWidget();
}

class _ConsumerStatefulWidget extends ConsumerState<ConsumerStatefulWidget> {
  final GlobalKey<ScaffoldMessengerState> _scaffoldMessengerKey =
      GlobalKey<ScaffoldMessengerState>();

  late bool _isShowLan;

  @override
  void initState() {
    super.initState();
    _isShowLan = false;
  }

  // 🚀 【优化 1】：二次确认删除弹窗，完美支持暗黑换装
  void _confirmClear(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // 自动读取暗黑下的卡片底色，不亮瞎眼
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          AppLocalizations.of(context)!.clearCache,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.clearHint,
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252), // 暗黑下更通透的红
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              await ref
                  .read(
                    shiftViewModelProvider(
                      DateTime.now().year,
                      DateTime.now().month,
                    ).notifier,
                  )
                  .clearCache();
            },
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmSync(BuildContext context, WidgetRef ref) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        // 自动读取暗黑下的卡片底色，不亮瞎眼
        backgroundColor: Theme.of(context).cardColor,
        title: Text(
          AppLocalizations.of(context)!.sync,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).textTheme.bodyLarge?.color,
          ),
        ),
        content: Text(
          AppLocalizations.of(context)!.syncHint,
          style: TextStyle(color: isDark ? Colors.white70 : Colors.black87),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: TextStyle(color: isDark ? Colors.white38 : Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFFF5252), // 暗黑下更通透的红
              elevation: 0,
            ),
            onPressed: () async {
              Navigator.pop(dialogContext);
              bool syncResult = await ref
                  .read(
                    shiftViewModelProvider(
                      DateTime.now().year,
                      DateTime.now().month,
                    ).notifier,
                  )
                  .syncAllShiftsToSystem();

              // 3. 🔥 核心安全检查：如果异步结束时，用户已经离开了页面，直接拦截，不做任何 UI 操作
              if (!context.mounted) return;
              // 4. 清理之前积压的 SnackBar，保证永远只显示最新的一条
              _scaffoldMessengerKey.currentState?.clearSnackBars();

              final snackBar = SnackBar(
                content: Text(
                  syncResult
                      ? AppLocalizations.of(context)!.syncSuccess
                      : AppLocalizations.of(context)!.syncFailCheck,
                ),
                backgroundColor: syncResult ? Colors.green : Colors.redAccent,
                duration: const Duration(seconds: 2),
              );
              _scaffoldMessengerKey.currentState?.showSnackBar(snackBar);
            },
            child: Text(
              AppLocalizations.of(context)!.confirm,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeMode = ref.watch(appThemeModeProvider);
    final bool isDarkMode = themeMode == ThemeMode.dark;
    // 🚀 【换装天眼】：抓取当前系统的黑夜状态
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return ScaffoldMessenger(
      key: _scaffoldMessengerKey,
      child: Scaffold(
        // 🚀 【优化 1】：大背景动态自适应（白天现代淡灰，黑夜自动收拢）
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.myPageTitle,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              // 🚀 【优化 2】：标题字色自适应主题
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          backgroundColor: Theme.of(context).cardColor,
          // 🚀 【优化 3】：AppBar 底色无缝感应
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
        ),
        body: SafeArea(
          child: ListView(
            padding: const EdgeInsets.only(top: 8), // 给顶部留一点呼吸间距
            children: [
              _buildCard(
                context,
                AppLocalizations.of(context)!.syncData,
                onTap: () async {
                  // =================================================================
                  // 🍎 1. 如果是 iOS 设备：直接走 Swift 纯原生弹窗与写入通道（绕过插件误判）
                  // =================================================================
                  if (Platform.isIOS) {

                    //灵动岛测试
                    await ref
                        .read(
                          shiftViewModelProvider(
                            DateTime.now().year,
                            DateTime.now().month,
                          ).notifier,
                        )
                        .setShiftToIsland();

                    print("🚀 当前是 iOS，通过 Pigeon 调起 Swift 原生日历权限与写入...");
                    try {
                      // 1. 组合成强类型的 PigeonShift 对象列表（告别 Map<String, dynamic> ！）
                      final List<PigeonShift> pigeonShifts = [];

                      // 2. 像调用普通 Dart 方法一样调用原生，带有完美的方法名和类型提示
                      // 💡 注意：根据我们在 Android 端的结论，Pigeon 在 Dart 端生成的类名就是 CalendarHostApi()
                      final api = CalendarHostApi();
                      final bool success = await api.syncShiftsToSystem(
                        pigeonShifts,
                      );

                      if (success) {
                        print("🎉 iOS 原生同步成功！");
                        _confirmSync(context, ref);
                      } else {
                        print("❌ iOS 同步失败，可能用户在系统弹窗里点了拒绝，或者无日历账户");
                      }
                    } catch (e) {
                      print("❌ iOS 通道调用异常: $e");
                    }
                    return; // 🎯 iOS 执行完直接拦截返回
                  }

                  // =================================================================
                  // 🤖 2. 如果是 Android 设备：继续完美跑你原本的权限申请逻辑
                  // =================================================================
                  print("🤖 当前是 Android，启动安卓日历权限流...");
                  Permission permission = Permission.calendarFullAccess;

                  // 1️⃣ 先检查当前真正的权限状态
                  PermissionStatus currentStatus = await permission.status;
                  print("安卓当前日历权限状态: $currentStatus");

                  if (currentStatus.isGranted) {
                    print("🎉 安卓权限本来就是拿下的，直接同步");
                    _confirmSync(context, ref);
                    return;
                  }

                  // 2️⃣ 如果是第一次或者还没决定，才去触发系统弹窗
                  if (currentStatus.isDenied) {
                    print("🚀 安卓状态为 isDenied，准备触发系统原生弹窗...");
                    PermissionStatus requestStatus = await permission.request();
                    print("安卓弹窗后用户选择的结果: $requestStatus");

                    if (requestStatus.isGranted) {
                      _confirmSync(context, ref);
                    } else {
                      print("❌ 安卓用户在弹窗里点了拒绝");
                    }
                  }
                  // 3️⃣ 只有明确被永久拒绝了（过去点过拒绝），才引导去设置页
                  else if (currentStatus.isPermanentlyDenied) {
                    print("❌ 安卓确定过去彻底拒绝过，引导去设置页");
                    openAppSettings();
                  }
                },
              ),
              _buildCard(
                context,
                AppLocalizations.of(context)!.clearCache,
                onTap: () {
                  //实现点击方法
                  _confirmClear(context, ref);
                },
              ),
              _buildCard(
                context,
                AppLocalizations.of(context)!.darkMode,
                trailing: SizedBox(
                  height: 32,
                  child: Switch(
                    value: isDarkMode,
                    activeThumbColor: Colors.white,
                    activeTrackColor: Colors.blue,
                    // 🚀 高级感蓝色轨道
                    inactiveThumbColor: isDark
                        ? const Color(0xFF999999)
                        : Colors.white,
                    inactiveTrackColor: isDark
                        ? Colors.white12
                        : const Color(0xFFE5E5E5),
                    // 🎯 【核心手术】：狙击未打开时的尴尬黑边
                    trackOutlineColor: WidgetStateProperty.resolveWith<Color?>((
                      states,
                    ) {
                      if (!states.contains(WidgetState.selected)) {
                        // 当 Switch 未被选中（未打开）时，强行把边框颜色设为透明，彻底干掉大黑边！
                        return Colors.transparent;
                      }
                      return null; // 打开状态下维持原样或交由系统处理
                    }),
                    onChanged: (value) {
                      // 🚀 【核心修复】：直接通知 Riverpod 改变全局主题，不需要再套一层局部 setState！
                      ref
                          .read(appThemeModeProvider.notifier)
                          .toggleTheme(value);
                    },
                  ),
                ),
              ),
              _buildLanCard(context),
              _buildCard(
                context,
                AppLocalizations.of(context)!.currentVersion,
                onTap: () {
                  //实现点击方法
                },
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      "v1.0.0",
                      style: TextStyle(
                        color: isDark ? Colors.white38 : Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: isDark ? Colors.white38 : const Color(0xFFB0B5C1),
                      size: 20,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard(
    BuildContext context, // 🚀 传入 context 以便获取系统主题
    String title, {
    VoidCallback? onTap,
    Widget? trailing,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    const double cardRadius = 16.0;

    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14),
      // 优化间距，呼吸感更足
      decoration: BoxDecoration(
        // 🚀 【优化 4】：卡片实体底色对接主题色（白天纯白，夜间采用高级暗灰）
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black26
                : Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardRadius),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(cardRadius),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(cardRadius),
                // 🚀 【优化 5】：卡片边框黑夜微调，利用极低透明度的白边取代硬编码
                border: Border.all(
                  color: isDark
                      ? Colors.white.withValues(alpha: 0.04)
                      : Colors.black.withValues(alpha: 0.03),
                  width: 0.8,
                ),
              ),
              padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        // 🚀 【优化 6】：文字颜色动态匹配，白天是高级藏青黑，夜间变亮白
                        color: isDark
                            ? Colors.white.withValues(alpha: 0.9)
                            : const Color(0xFF2D3142),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  trailing ??
                      Icon(
                        Icons.chevron_right_rounded,
                        color: isDark
                            ? Colors.white38
                            : const Color(0xFFB0B5C1),
                        size: 22,
                      ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLanCard(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final currentLocale = ref.watch(appLocaleProvider); // 👁️ 实时监听
    const double cardRadius = 16.0;

    // 🎨 多语言数据套餐
    final List<Map<String, dynamic>> lanOptions = [
      {'name': '简体中文', 'locale': const Locale('zh')},
      {'name': '繁體中文', 'locale': const Locale('zh', 'TW')},
      {'name': 'English', 'locale': const Locale('en')},
      {'name': '日本語', 'locale': const Locale('ja')},
      {'name': '한국어', 'locale': const Locale('ko')},
    ];

    return Container(
      margin: const EdgeInsets.only(bottom: 10, left: 14, right: 14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(cardRadius),
        boxShadow: [
          BoxShadow(
            color: isDark
                ? Colors.black26
                : Colors.black.withValues(alpha: 0.015),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(cardRadius),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(cardRadius),
            border: Border.all(
              color: isDark
                  ? Colors.white.withValues(alpha: 0.04)
                  : Colors.black.withValues(alpha: 0.03),
              width: 0.8,
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 1️⃣ 头部
              InkWell(
                onTap: () => setState(() => _isShowLan = !_isShowLan),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    vertical: 16,
                    horizontal: 16,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          AppLocalizations.of(context)!.language,
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w500,
                            color: isDark
                                ? Colors.white.withValues(alpha: 0.9)
                                : const Color(0xFF2D3142),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      AnimatedRotation(
                        turns: _isShowLan ? 0.25 : 0,
                        duration: const Duration(milliseconds: 200),
                        child: Icon(
                          Icons.chevron_right_rounded,
                          color: isDark
                              ? Colors.white38
                              : const Color(0xFFB0B5C1),
                          size: 22,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // 2️⃣ 列表区
              AnimatedCrossFade(
                firstChild: const SizedBox.shrink(),
                secondChild: Container(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: Column(
                    children: lanOptions.map((opt) {
                      final Locale targetLocale = opt['locale'];

                      // 🎯 【强化判定】：必须两边的 languageCode 和 countryCode 完全咬合
                      bool isSelected = false;
                      if (currentLocale != null) {
                        isSelected =
                            currentLocale.languageCode ==
                                targetLocale.languageCode &&
                            currentLocale.countryCode ==
                                targetLocale.countryCode;
                      } else {
                        // 如果本地没存过（currentLocale == null），那手机当前系统语言如果是这一档，就默认亮起它
                        final systemLocale = Localizations.localeOf(context);
                        isSelected =
                            systemLocale.languageCode ==
                                targetLocale.languageCode &&
                            systemLocale.countryCode ==
                                targetLocale.countryCode;
                      }

                      return InkWell(
                        onTap: () {
                          // 🚀 写入内存 + 写入 Prefs 物理沙盒
                          ref
                              .read(appLocaleProvider.notifier)
                              .changeLocale(targetLocale);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 12,
                            horizontal: 28,
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  opt['name'],
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: isSelected
                                        ? Colors.blue
                                        : (isDark
                                              ? Colors.white60
                                              : const Color(0xFF606266)),
                                    fontWeight: isSelected
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              ),
                              if (isSelected)
                                const Icon(
                                  Icons.check_rounded,
                                  color: Colors.blue,
                                  size: 20,
                                )
                              else
                                const SizedBox(width: 20, height: 20),
                            ],
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                crossFadeState: _isShowLan
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 200),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
