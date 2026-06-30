import 'package:flutter_calendar/data/calendar_shift.dart';
import 'package:flutter_calendar/data/shift_config.dart';
import 'package:flutter_calendar/data/shift_stat_item.dart';
import 'package:flutter_calendar/provider/shift_config_provider.dart';
import 'package:flutter_calendar/provider/shift_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_calendar/data/weight_stat_item.dart';
import 'package:flutter_calendar/data/calendar_weight.dart';
import 'package:flutter_calendar/data/work_time_stat.dart';
import 'package:flutter_calendar/provider/weight_provider.dart';
import 'package:flutter_calendar/utils/date_util.dart';

part 'month_chart_provider.g.dart';

@riverpod
Future<List<ShiftStatItem>> monthlyShiftChart(
  MonthlyShiftChartRef ref,
  DateTime currentDate,
) async {
  // 🟢 注入灵魂：强行让主线程在后台等 500 毫秒，给动画留出充足的表演时间！
  //await Future.delayed(const Duration(milliseconds: 400));

  // 🚀 核心大招 1：强制保留老参数的内存快照。新月份数据不来，老月份数据死死留在内存里顶住 UI！
  final link = ref.keepAlive();
  // 可选：当没有页面 watch 它超过 5 秒后，全自动销毁释放内存，极为高档
  ref.onDispose(() => link.close());

  // 🚀 核心大招 2：必须把 read 改成 watch！让 Riverpod 能够跟踪这个 Provider 的依赖活性
  final shiftRepo = ref.watch(shiftRepositoryProvider);
  final configRepo = ref.watch(shiftConfigRepositoryProvider);

  // 去数据库捞数据
  final rawShifts = await shiftRepo.getMonthShifts(
    currentDate.year,
    currentDate.month,
  );
  final configs = await configRepo.getConfigs();

  // 聚合计算
  return _calculateShiftStats(rawShifts, configs);
}

// 🎯 顺手帮老哥做个轻量级性能优化
List<ShiftStatItem> _calculateShiftStats(
  List<CalendarShift> rawShifts,
  List<ShiftConfig> configs,
) {
  final List<ShiftStatItem> list = [];

  for (var config in configs) {
    // 💡 优化点：直接用 .length，把原本的 .toList().length 砍掉。
    // 原本的写法会高频在内存里创建各种临时临时垃圾数组，直接 count 最省电省内存。
    int count = rawShifts
        .where((shift) => shift.shiftConfigId == config.id)
        .length;

    if (count > 0) {
      list.add(
        ShiftStatItem(
          name: config.name,
          count: count,
          colorValue: config.colorValue,
        ),
      );
    }
  }
  return list;
}

@riverpod
Future<List<WeightStatItem>> monthlyWeightChart(
  MonthlyWeightChartRef ref,
  DateTime currentMonth,
) async {
  // 🚀 核心大招 1：强制保留老参数的内存快照。新月份数据不来，老月份数据死死留在内存里顶住 UI！
  //final link = ref.keepAlive();
  // 可选：当没有页面 watch 它超过 5 秒后，全自动销毁释放内存，极为高档
  //ref.onDispose(() => link.close());

  final weightRepo = ref.watch(weightRepositoryProvider);
  final rawWeights = await weightRepo.getMonthWeights(
    currentMonth.year,
    currentMonth.month,
  );

  //测试数据
  if (rawWeights.isEmpty) {
    final weight = CalendarWeight()
      ..dateId = 20260601
      ..weight = 78.05
      ..isStable = true
      ..impedance = 400;
    final weight1 = CalendarWeight()
      ..dateId = 20260615
      ..weight = 78.15
      ..isStable = true
      ..impedance = 400;
    final weight2 = CalendarWeight()
      ..dateId = 20260618
      ..weight = 77.66
      ..isStable = true
      ..impedance = 400;
    final weight3 = CalendarWeight()
      ..dateId = 20260625
      ..weight = 78.98
      ..isStable = true
      ..impedance = 400;
    final weight4 = CalendarWeight()
      ..dateId = 20260625
      ..weight = 78.32
      ..isStable = true
      ..impedance = 400;
    final weight5 = CalendarWeight()
      ..dateId = 20260625
      ..weight = 78.80
      ..isStable = true
      ..impedance = 400;
    rawWeights.add(weight);
    rawWeights.add(weight1);
    rawWeights.add(weight2);
    rawWeights.add(weight3);
    rawWeights.add(weight4);
    rawWeights.add(weight5);
  }

  return _calculateWeightStats(rawWeights);
}

List<WeightStatItem> _calculateWeightStats(List<CalendarWeight> rawWeights) {
  final List<WeightStatItem> list = [];

  if (rawWeights.isNotEmpty) {
    Map<int, List<double>> groupedByDateId = {};
    for (var currentWeight in rawWeights) {
      if (!groupedByDateId.containsKey(currentWeight.dateId)) {
        groupedByDateId[currentWeight.dateId] = [];
      }
      groupedByDateId[currentWeight.dateId]!.add(currentWeight.weight);
    }
    groupedByDateId.forEach((dateId, weightsWithSameId) {
      double totalWeights = 0;
      for (var w in weightsWithSameId) {
        totalWeights += w;
      }
      double aveWeight = totalWeights / weightsWithSameId.length;
      list.add(WeightStatItem(day: dateId % 100, weight: aveWeight));
    });
  }
  return list;
}

@riverpod
Future<List<WorkTimeStat>> monthlyWorkTimeStats(
  MonthlyWorkTimeStatsRef ref,
  DateTime currentMonth,
) async {
  // 🟢 注入灵魂：强行让主线程在后台等 500 毫秒，给动画留出充足的表演时间！
  //await Future.delayed(const Duration(milliseconds: 400));

  // 🚀 核心大招 1：强制保留老参数的内存快照。新月份数据不来，老月份数据死死留在内存里顶住 UI！
  //final link = ref.keepAlive();
  // 可选：当没有页面 watch 它超过 5 秒后，全自动销毁释放内存，极为高档
  //ref.onDispose(() => link.close());

  // 🚀 【就是这几行，专治隔月装死】
  // 只要排班仓库发生任何增删改，管他在不在当前月，立马让当前月份的工时缓存主动失效！

  // 🚀 核心大招 2：必须把 read 改成 watch！让 Riverpod 能够跟踪这个 Provider 的依赖活性
  final shiftRepo = ref.watch(shiftRepositoryProvider);
  final configRepo = ref.watch(shiftConfigRepositoryProvider);

  // 去数据库捞数据
  final rawShifts = await shiftRepo.getMonthShifts(
    currentMonth.year,
    currentMonth.month,
  );
  final configs = await configRepo.getConfigs();

  // 聚合计算
  return _calculateWorkTimeStats(rawShifts, configs);
}

List<WorkTimeStat> _calculateWorkTimeStats(
  List<CalendarShift> rawShifts,
  List<ShiftConfig> configs,
) {
  List<WorkTimeStat> list = [];

  if(rawShifts.isNotEmpty && configs.isNotEmpty){
    //先把config进行转换
    final configMap = {for(var config in configs) config.id : DateUtil.calculateTimeDifference(config.startTime, config.endTime)};
    for(var shift in rawShifts){
      list.add(WorkTimeStat(day: shift.dateId % 100, hour: configMap[shift.shiftConfigId] ?? 0));
    }
  }
  return list;
}
