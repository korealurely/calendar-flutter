import 'package:flutter/material.dart';
import 'package:flutter_calendar/l10n/app_localizations.dart';
import 'package:flutter_calendar/pages/calendar_page.dart';
import 'package:flutter_calendar/pages/shift_config_page.dart';
import 'package:flutter_calendar/pages/chart_page.dart';
import 'package:flutter_calendar/pages/my_page.dart';
import 'package:flutter_calendar/provider/main_tab_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  final List<Widget> _pages = const [
    CalendarPage(),
    ShiftConfigPage(),
    ChartPage(),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentIndex = ref.watch(mainTabIndexProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🚀 核心：抽取你的主题主色调（比如白天用蓝色，黑夜用稍微亮一点的淡蓝，或者统一用你的 Color(0xFF4A90E2)）
    final activeColor = isDark ? const Color(0xFF5A9FFF) : const Color(0xFF4A90E2);

    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: NavigationBarThemeData(
          indicatorColor: Colors.transparent,
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              return TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: activeColor, // 🚀 动态跟随激活色
              );
            }
            return TextStyle(
              fontSize: 12,
              color: isDark ? Colors.white38 : Colors.grey, // 🚀 未选中文字颜色适配
            );
          }),
        ),
      ),
      child: Scaffold(
        body: IndexedStack(
          index: currentIndex,
          children: _pages,
        ),
        bottomNavigationBar: NavigationBar(
          selectedIndex: currentIndex,
          onDestinationSelected: (int index) {
            ref.read(mainTabIndexProvider.notifier).state = index;
          },
          height: 60,
          // 🚀 【换装核心 1】：去除死白，让背景自动去读卡片色（白天纯白，夜间深灰 0xFF1E1E1E）
          backgroundColor: Theme.of(context).cardColor,
          elevation: 10,
          animationDuration: const Duration(milliseconds: 300),
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
          destinations: [
            NavigationDestination(
              // 🚀 【换装核心 2】：未选中的图标在黑夜下用半透明白（white54），白天用半透明黑（black54）
              icon: Icon(Icons.calendar_month_outlined, color: isDark ? Colors.white54 : Colors.black54),
              selectedIcon: Icon(Icons.calendar_month, color: activeColor),
              label: AppLocalizations.of(context)!.homePage,
            ),
            NavigationDestination(
              icon: Icon(Icons.schedule_outlined, color: isDark ? Colors.white54 : Colors.black54),
              selectedIcon: Icon(Icons.schedule, color: activeColor),
              label: AppLocalizations.of(context)!.shift,
            ),
            NavigationDestination(
              icon: Icon(Icons.android_outlined, color: isDark ? Colors.white54 : Colors.black54),
              selectedIcon: Icon(Icons.android, color: activeColor),
              label: AppLocalizations.of(context)!.statistic,
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: isDark ? Colors.white54 : Colors.black54),
              selectedIcon: Icon(Icons.person, color: activeColor),
              label: AppLocalizations.of(context)!.my,
            ),
          ],
        ),
      ),
    );
  }
}