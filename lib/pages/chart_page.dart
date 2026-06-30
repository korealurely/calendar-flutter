import 'package:flutter/material.dart';
import 'package:flutter_calendar/view/shift_pie_chart_card.dart';
import 'package:flutter_calendar/view/weight_line_chart_card.dart';
import 'package:flutter_calendar/provider/month_chart_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
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
    // 🟢 初始化锁死：天数固定为 1，时分秒微秒全部归零
    _selectMonth = DateTime(now.year, now.month);

    _selectWeightMonth = DateTime(now.year,now.month);

    _selectWorKTimeMonth = DateTime(now.year,now.month);
  }

  @override
  Widget build(BuildContext context) {
    // 🎯 精准拦截 Tab 切换：人肉砸碎缓存重捞
    ref.listen<int>(mainTabIndexProvider, (previous, next) {
      if (next == 2 && previous != 2) {
        print("🚀 [UI] 真正切入图表页，人肉砸碎缓存重捞！");
        final now = DateTime.now();
        setState(() {
          // 🟢 核心修正 1：强制刷新时，也必须锁死到月（1号0点）！绝对不能带毫秒！
          _selectMonth = DateTime(now.year, now.month);
          _selectWeightMonth = DateTime(now.year,now.month);
          _selectWorKTimeMonth = DateTime(now.year,now.month);
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
      backgroundColor: const Color(0xFFF5F7FA), // 浅灰色高档背景
      appBar: AppBar(
        title: const Text(
          "数据统计",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1F1F1F)),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            // 🟢 极其安全的精细化守卫
            ShiftPieChartCard(
              // 如果有值就吐出值，如果没有（比如纯加载中），直接用空列表兜底，绝对不触碰引发崩溃的 .value 强拆
              statList: stats.hasValue ? (stats.value ?? []) : [],
              currentMonth: _selectMonth,

              // 🚀 核心逻辑微调：只有当它确实在 isLoading，且目前手里没有成功拿到的缓存数据时，才叫“开荒加载”
              isLoading: stats.isLoading && !stats.hasValue,
              onMonthChanged: (newMonth) {
                setState(() {
                  _selectMonth = newMonth;
                });
              },
            ),

            WeightLineChartCard(
                // dataList:  [
                //   WeightStatItem(day: 2, weight: 72.5),
                //   WeightStatItem(day: 5, weight: 72.1),
                //   WeightStatItem(day: 10, weight: 71.8),
                //   WeightStatItem(day: 15, weight: 72.3),
                //   WeightStatItem(day: 20, weight: 71.2),
                //   WeightStatItem(day: 25, weight: 70.9),
                // ],
              dataList: weightStats.hasValue ? (weightStats.value ?? []) : [],
                currentMonth: _selectWeightMonth,
                onMonthChanged: (newMonth){
                  setState(() {
                    _selectWeightMonth = newMonth;
                  });
                },
                isLoading: weightStats.isLoading,
                hasError: weightStats.hasError),

            WorkTimeBarChartCard(
              // dataList:  [
              //   WorkTimeStat(day: 1, hour: 12.5),
              //   WorkTimeStat(day: 2, hour: 12.5),
              //   WorkTimeStat(day: 3, hour: 12.5),
              //   WorkTimeStat(day: 5, hour: 12.1),
              //   WorkTimeStat(day: 6, hour: 12.1),
              //   WorkTimeStat(day: 7, hour: 12.1),
              //   WorkTimeStat(day: 8, hour: 12.1),
              //   WorkTimeStat(day: 10, hour: 11.8),
              //   WorkTimeStat(day: 15, hour: 10.3),
              //   WorkTimeStat(day: 20, hour: 8.5),
              //   WorkTimeStat(day: 25, hour: 8.5),
              //   WorkTimeStat(day: 30, hour: 7.8),
              // ],
              dataList: workTimeStats.hasValue ? (workTimeStats.value ?? []) : [],
                onMonthChanged: (newMonth){
                  setState(() {
                    _selectWorKTimeMonth = newMonth;
                  });
                },
                isLoading: workTimeStats.isLoading && !workTimeStats.hasValue,
                hasError: workTimeStats.hasError,
                currentMonth: _selectWorKTimeMonth),
          ],
        ),
      ),
    );
  }
}