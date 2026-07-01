import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_calendar/view/shift_pie_chart_card.dart';
import 'package:flutter_calendar/view/weight_line_chart_card.dart';
import 'package:flutter_calendar/provider/month_chart_provider.dart';
import 'package:flutter_calendar/provider/main_tab_provider.dart';
import 'package:flutter_calendar/data/weight_stat_item.dart';
import 'package:flutter_calendar/view/work_time_bar_chart_card.dart';
import 'package:flutter_calendar/data/work_time_stat.dart';

class ChartPage extends ConsumerStatefulWidget {
  const ChartPage({super.key});

  @override
  ConsumerState<ChartPage> createState() => _ChartPage();
}

class _ChartPage extends ConsumerState<ChartPage> {
  late DateTime _selectMonth;
  late DateTime _selectWeightMonth;
  late DateTime _selectWorKTimeMonth;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _selectMonth = DateTime(now.year, now.month);
    _selectWeightMonth = DateTime(now.year, now.month);
    _selectWorKTimeMonth = DateTime(now.year, now.month);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // 🎯 精准拦截 Tab 切换：人肉砸碎缓存重捞
    ref.listen<int>(mainTabIndexProvider, (previous, next) {
      if (next == 2 && previous != 2) {
        print("🚀 [UI] 真正切入图表页，人肉砸碎缓存重捞！");
        final now = DateTime.now();
        setState(() {
          _selectMonth = DateTime(now.year, now.month);
          _selectWeightMonth = DateTime(now.year, now.month);
          _selectWorKTimeMonth = DateTime(now.year, now.month);
        });
        ref.invalidate(monthlyShiftChartProvider(_selectMonth));
        ref.invalidate(monthlyWeightChartProvider(_selectWeightMonth));
        ref.invalidate(monthlyWorkTimeStatsProvider(_selectWorKTimeMonth));
      }
    });

    // 🎯 稳妥 watch 锁死参数后的 Provider
    final stats = ref.watch(monthlyShiftChartProvider(_selectMonth));
    final weightStats = ref.watch(monthlyWeightChartProvider(_selectWeightMonth));
    final workTimeStats = ref.watch(monthlyWorkTimeStatsProvider(_selectWorKTimeMonth));

    return Scaffold(
      // 🚀 【换装 1】：大背景全自动换装（白天浅灰高档，夜间纯黑/深灰）
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          "数据统计",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).textTheme.bodyLarge?.color, // 🚀 【换装 2】：标题颜色自适应
          ),
        ),
        backgroundColor: Theme.of(context).cardColor, // 🚀 【换装 3】：AppBar 背景感应
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          physics: const BouncingScrollPhysics(), // 丝滑回弹
          children: [
            // 🟢 班次饼图卡片
            ShiftPieChartCard(
              statList: stats.hasValue ? (stats.value ?? []) : [],
              currentMonth: _selectMonth,
              isLoading: stats.isLoading && !stats.hasValue,
              onMonthChanged: (newMonth) {
                setState(() {
                  _selectMonth = newMonth;
                });
              },
            ),

            // 🟢 体重折线图卡片
            WeightLineChartCard(
              dataList: weightStats.hasValue ? (weightStats.value ?? []) : [],
              currentMonth: _selectWeightMonth,
              onMonthChanged: (newMonth) {
                setState(() {
                  _selectWeightMonth = newMonth;
                });
              },
              isLoading: weightStats.isLoading,
              hasError: weightStats.hasError,
            ),

            // 🟢 工时柱状图卡片
            WorkTimeBarChartCard(
              dataList: workTimeStats.hasValue ? (workTimeStats.value ?? []) : [],
              onMonthChanged: (newMonth) {
                setState(() {
                  _selectWorKTimeMonth = newMonth;
                });
              },
              isLoading: workTimeStats.isLoading && !workTimeStats.hasValue,
              hasError: workTimeStats.hasError,
              currentMonth: _selectWorKTimeMonth,
            ),
          ],
        ),
      ),
    );
  }
}