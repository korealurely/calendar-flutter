import 'package:flutter/material.dart';
import 'package:flutter_calendar/pages/main_screen.dart';
// 🎯 核心引入：必须要导这个包
import 'package:flutter_localizations/flutter_localizations.dart';

// 💥 记住：我们要用 Riverpod，必须在最外层套上 ProviderScope！
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  // 💥 顺手帮你把 Riverpod 的紧箍咒给戴上
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '追梦日历测试',
      debugShowCheckedModeBanner: false, // 去掉右上角的 Debug 红色标签
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,      // 种子颜色设为蓝色，系统会自动计算搭配的衍生色
          primary: Colors.blue,         // 确保主色为标准的蓝色
        ),
        // 也可以单独针对全局的 datePicker 进行样式定制
        datePickerTheme: DatePickerThemeData(
          headerBackgroundColor: Colors.blue,
          headerForegroundColor: Colors.white,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
      // ==================== 🎯 开启中文汉化核心配置 ====================
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate, // 顺手把 iOS 风格组件的国际化也捎上
      ],
      supportedLocales: const [
        Locale('zh', 'CN'), // 简体中文
        Locale('en', 'US'), // 英文（保留兜底）
      ],
      locale: const Locale('zh', 'CN'), // 🎯 强行指定 App 初始语言为中文
      // =============================================================
      home: const MainScreen(), // 完美的入口
    );
  }
}