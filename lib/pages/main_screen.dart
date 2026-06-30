import 'package:flutter/material.dart';
import 'package:flutter_calendar/pages/calendar_page.dart';
import 'package:flutter_calendar/pages/shift_config_page.dart';
import 'package:flutter_calendar/pages/chart_page.dart';
import 'package:flutter_calendar/pages/my_page.dart';
import 'package:flutter_calendar/provider/main_tab_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MainScreen extends ConsumerWidget {
  const MainScreen({super.key});

  // 4个业务页面千层饼
  final List<Widget> _pages = const [
    CalendarPage(),
    //const Center(child: Text('模板', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    ShiftConfigPage(),
    //Center(child: Text('AI', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    ChartPage(),
    //const ShiftPatternPage(),
    //Center(child: Text('我的', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    //Center(child: Text('我的1', style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
    MyPage(),
  ];

  @override
  Widget build(BuildContext context,WidgetRef ref) {
    final currentIndex = ref.watch(mainTabIndexProvider);
    // 💡 顶层包裹 Theme，统一宏观调控 NavigationBar 的文字与胶囊背景
    return Theme(
      data: Theme.of(context).copyWith(
        navigationBarTheme: NavigationBarThemeData(
          // 1. 💥 彻底干掉 Material 3 自带的蓝色椭圆高亮块，回归极简
          indicatorColor: Colors.transparent,

          // 2. 💥 精准控制文字在不同状态下的颜色
          labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((states) {
            if (states.contains(WidgetState.selected)) {
              // 选中时：高亮蓝色，加粗
              return const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.blue,
              );
            }
            // 未选中时：低调灰色（其实未选中时会被下面的 labelBehavior 隐藏，这里作为安全双保险）
            return const TextStyle(
              fontSize: 12,
              color: Colors.grey,
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
          backgroundColor: Colors.white,
          elevation: 10,
          animationDuration: const Duration(milliseconds: 300), // 300ms 切换更干脆丝滑

          // 3. 💥 核心：仅在被选中时才优雅地浮现底部文字标签
          labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,

          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.calendar_month_outlined, color: Colors.black54),
              selectedIcon: Icon(Icons.calendar_month, color: Colors.blue),
              label: '主页',
            ),
            NavigationDestination(
              icon: Icon(Icons.schedule_outlined, color: Colors.black54),
              selectedIcon: Icon(Icons.schedule, color: Colors.blue),
              label: '排班',
            ),
            NavigationDestination(
              icon: Icon(Icons.android_outlined, color: Colors.black54),
              selectedIcon: Icon(Icons.android, color: Colors.blue),
              label: '统计',
            ),
            NavigationDestination(
              icon: Icon(Icons.person_outline, color: Colors.black54),
              selectedIcon: Icon(Icons.person, color: Colors.blue),
              label: '我的',
            ),
          ],
        ),
      ),
    );
  }
}

