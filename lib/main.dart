import 'package:flutter/material.dart';
import 'package:flutter_calendar/pages/main_screen.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
// 🚀 核心引入：引入你存放全局主题状态的那个 theme_provider 文件
import 'package:flutter_calendar/provider/theme_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
// 🎯 必须用 package:flutter_gen 开头的路径，因为这是官方指定的缓存区映射路径
import 'package:flutter_calendar/l10n/app_localizations.dart';


void main() async {
  // 🎯 核心防闪现起手式：确保 Flutter 引擎骨架以及原生通道在第一帧渲染前完全初始化
  WidgetsFlutterBinding.ensureInitialized();

  // 1. 提早唤醒并读取本地持久化主题缓存
  final prefs = await SharedPreferences.getInstance();
  final savedThemeMode = prefs.getString("app_theme_mode_key");

  // 2. 将缓存的字符串安全转换为 Flutter 原生的 ThemeMode 枚举
  ThemeMode initialThemeMode = ThemeMode.system; // 默认兜底跟随系统
  if (savedThemeMode == ThemeMode.dark.name) {
    initialThemeMode = ThemeMode.dark;
  } else if (savedThemeMode == ThemeMode.light.name) {
    initialThemeMode = ThemeMode.light;
  }

  runApp(
    ProviderScope(
      overrides: [
        // 🎯 完美修复：直接把缓存的枚举通过构造函数优雅地送入类内部
        appThemeModeProvider.overrideWith(() {
          return AppThemeMode(initialThemeMode);
        }),
      ],
      child: const MyApp(),
    ),
  );
}

// 🚀 【核心改动 1】：把 StatelessWidget 改成 ConsumerWidget，让顶层有能力 watch 状态
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 🚀 【核心改动 2】：在这里死死盯住全局的主题模式（白天/黑夜/跟随系统）
    // 采用最新的 @riverpod 注解流生成的 provider 名字全自动转换为小驼峰 appThemeModeProvider
    final themeMode = ref.watch(appThemeModeProvider);

    return MaterialApp(
      title: '追梦日历测试',
      debugShowCheckedModeBanner: false,

      // 🚀 【核心改动 3】：绑定全局的主题模式状态！
      themeMode: themeMode,

      // ==================== ☀️ 1. 动态白天主题 ====================
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light, // 显式声明白天模式
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: const Color(0xFF4A90E2), // 你的主色调
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFF6F8FA), // 浅灰清爽底色
        cardColor: Colors.white, // 白天卡片、底部导航栏全部用纯白

        // 统一配置白天所有的文字颜色（供子页面 Theme.of(context) 读取）
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF2D3142)), // 核心大字用高级藏青黑
          bodyMedium: TextStyle(color: Colors.black87),   // 普通文字
        ),

        datePickerTheme: DatePickerThemeData(
          headerBackgroundColor: const Color(0xFF4A90E2),
          headerForegroundColor: Colors.white,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      // ==================== 🌙 2. 动态黑夜主题 ====================
      darkTheme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark, // 显式声明黑夜模式
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          primary: const Color(0xFF5A9FFF), // 黑夜里用稍微亮一点、温和点的蓝色
          brightness: Brightness.dark,
        ),
        scaffoldBackgroundColor: const Color(0xFF121212), // 纯黑底色，省电护眼
        cardColor: const Color(0xFF1E1E1E), // 🚀 黑夜的卡片和底部导航栏自动变成高级深灰！

        // 统一配置黑夜所有的文字颜色
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFE3E3E6)), // 核心文字全自动变奶白！
          bodyMedium: TextStyle(color: Colors.white70),   // 次要文字全自动变清爽白
        ),

        datePickerTheme: DatePickerThemeData(
          headerBackgroundColor: const Color(0xFF3A3D4A),
          headerForegroundColor: const Color(0xFFE3E3E6),
          backgroundColor: const Color(0xFF1E1E1E), // 弹窗本身变黑
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),

      // ==================== 🎯 开启中文汉化核心配置 ====================
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,

      home: const MainScreen(),
    );
  }
}