import 'dart:ffi';

import 'package:flutter_calendar/data/calendar_weight.dart';
import 'package:flutter_calendar/data/shift_config.dart';
import 'package:flutter_calendar/data/shift_pattern.dart';
import 'package:flutter_calendar/provider/shift_config_provider.dart';
import 'package:flutter_calendar/provider/weight_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_calendar/data/calendar_shift.dart';
import 'package:flutter_calendar/repository/shift_repository.dart';
import 'package:flutter_calendar/provider/month_chart_provider.dart';
import 'package:flutter_calendar/service/calendar_channel_helper.dart';
import 'package:flutter_calendar/src/generated/calendar_api.g.dart';
import 'package:flutter_calendar/src/generated/live_activity_api.g.dart';


// 💥 依然雷打不动，让外挂继续生成后门
part 'shift_provider.g.dart';

/// 1. 异步开辟数据库大门的全局单例（保持不变，全 App 只此一个物理闸门）
@riverpod
Future<Isar> isarInstance(IsarInstanceRef ref) async {
  final dir = await getApplicationDocumentsDirectory();
  return await Isar.open([
    CalendarShiftSchema,
    ShiftConfigSchema,
    ShiftPatternSchema,
    CalendarWeightSchema,
  ], directory: dir.path);
}

/// 2. 把 Repository 做成单例（保持不变，物理搬砖打工人）
@riverpod
ShiftRepository shiftRepository(ShiftRepositoryRef ref) {
  final isar = ref.watch(isarInstanceProvider).value!;
  return ShiftRepository(isar);
}

/// 3. 🔥 终极进化：带天眼监控、带年月参数的智能化月份指挥官
/// 每一个 (year, month) 组合都会在内存里生成一个独立的大脑
@riverpod
class ShiftViewModel extends _$ShiftViewModel {
  @override
  Future<Map<int, CalendarShift>> build(int year, int month) async {
    // 🎯 1. 核心物理切除：把之前那三行 isar.calendarShifts.watchLazy() 和 StreamProvider 彻底干掉！
    // 斩断这个隐形死循环水管，数据库通道瞬间畅通无阻！

    // 先拿到我们造好的班次大字典
    final configListAsync = ref.watch(shiftConfigViewModelProvider);
    final Map<int, ShiftConfig> configMap = configListAsync.maybeWhen(
      data: (list) => {for (var config in list) config.id: config},
      orElse: () => {},
    );

    final repo = ref.watch(shiftRepositoryProvider);
    var list = await repo.getMonthShifts(year, month);

    // ⚡【核心缝合】：把配置织入实体
    for (var shift in list) {
      if (shift.shiftConfigId != null) {
        shift.config = configMap[shift.shiftConfigId];
      }
    }
    return {for (var item in list) item.dateId: item};
  }

  /// 💾 修改当天排班
  Future<void> changeDayShift({
    required int year,
    required int month,
    required int day,
    required int? shiftId,
    required bool isAlarm,
    required DateTime? alarmTime,
  }) async {
    int targetDateId = year * 10000 + month * 100 + day;
    final repo = ref.read(shiftRepositoryProvider);

    final CalendarShift? existingShift = await repo.getShiftById(targetDateId);
    CalendarShift targetShift;

    if (existingShift != null) {
      targetShift = existingShift
        ..shiftConfigId = shiftId
        ..isAlarm = isAlarm
        ..updatedAt = DateTime.now();

      if (alarmTime != null) {
        targetShift.alarmTime = alarmTime;
      }
    } else {
      targetShift = CalendarShift()
        ..dateId = targetDateId
        ..shiftConfigId = shiftId
        ..isAlarm = isAlarm
        ..alarmTime = alarmTime
        ..updatedAt = DateTime.now();
    }

    // 砸进硬盘
    await repo.saveDayShift(targetShift);

    // 🚀【主动国防线】：入库成功后，手动碎掉日历和图表的缓存，通知它们精准刷新！
    // 既省电、又100%安全，绝不堵车！
    ref.invalidateSelf(); // 叫自己（日历）重捞
    ref.invalidate(monthlyShiftChartProvider); // 叫隔壁（图表）顺便重捞
    //ref.invalidate(monthlyWeightChartProvider);
    ref.invalidate(monthlyWorkTimeStatsProvider);
  }

  /// 💾 批量生成排班
  Future<void> generateShifts({
    required String startDate,
    required String endDate,
    required int patternType,
    required List<int> shiftConfigIds,
  }) async {
    DateTime start = DateTime.parse(startDate);
    DateTime end = DateTime.parse(endDate);
    DateTime current = DateTime.parse(startDate);

    List<CalendarShift> shiftList = [];

    if (patternType == 0) {
      // 周固定模式
      if (shiftConfigIds.isNotEmpty && shiftConfigIds.length == 7) {
        while (!current.isAfter(end)) {
          final String formatCurrent =
              "${current.year}-${current.month.toString().padLeft(2, '0')}-${current.day.toString().padLeft(2, '0')}";
          final dayOfWeek = current.weekday - 1;
          final shiftConfigId = shiftConfigIds[dayOfWeek];
          final config = _getCurrentConfigMap()[shiftConfigId];
          final newShift = CalendarShift()
            ..dateId = current.year * 10000 + current.month * 100 + current.day
            ..shiftConfigId = shiftConfigId
            ..isAlarm = false
            ..alarmTime = config != null && config.startTime != null
                ? DateTime.parse("$formatCurrent ${config.startTime!}")
                : null
            ..updatedAt = DateTime.now();
          shiftList.add(newShift);
          current = current.add(const Duration(days: 1));
        }
      }
    } else {
      final cycleLength = shiftConfigIds.length;
      while (!current.isAfter(end)) {
        final String formatCurrent =
            "${current.year}-${current.month.toString().padLeft(2, '0')}-${current.day.toString().padLeft(2, '0')}";
        final dayPassed = current.difference(start).inDays;
        final indexInCycle = dayPassed % cycleLength;
        if (shiftConfigIds.isNotEmpty) {
          final shiftConfigId = shiftConfigIds[indexInCycle];
          final config = _getCurrentConfigMap()[shiftConfigId];
          final newShift = CalendarShift()
            ..dateId = current.year * 10000 + current.month * 100 + current.day
            ..shiftConfigId = shiftConfigId
            ..isAlarm = false
            ..alarmTime = config != null && config.startTime != null
                ? DateTime.parse("$formatCurrent ${config.startTime!}")
                : null
            ..updatedAt = DateTime.now();
          shiftList.add(newShift);
          current = current.add(const Duration(days: 1));
        }
      }
    }

    final repo = ref.read(shiftRepositoryProvider);
    await repo.saveShifts(shiftList);

    // 🚀【主动国防线】：批量入库成功，通杀重刷！
    ref.invalidateSelf();
    ref.invalidate(monthlyShiftChartProvider);
    //ref.invalidate(monthlyWeightChartProvider);
    ref.invalidate(monthlyWorkTimeStatsProvider);
  }

  /// 💾 删除排班
  Future<void> deleteShiftById(int dateId) async {
    final repo = ref.read(shiftRepositoryProvider);
    await repo.deleteShiftByDateId(dateId);

    // 🚀【主动国防线】：删除成功，通杀重刷！
    ref.invalidateSelf();
    ref.invalidate(monthlyShiftChartProvider);
    //ref.invalidate(monthlyWeightChartProvider);
    ref.invalidate(monthlyWorkTimeStatsProvider);
  }

  Map<int, ShiftConfig> _getCurrentConfigMap() {
    final configListAsync = ref.read(shiftConfigViewModelProvider);
    return configListAsync.maybeWhen(
      data: (list) => {for (var config in list) config.id: config},
      orElse: () => {},
    );
  }

  Future<void> clearCache() async {
    await ref.read(shiftRepositoryProvider).clearAll();

    // 2. 顺手把兄弟们和自己一起枪毙，通知全网刷新空状态
    //ref.invalidate(shiftPatternViewModelProvider);
    ref.invalidate(shiftConfigViewModelProvider);
    ref.invalidate(weightViewModelProvider);
    ref.invalidateSelf(); // 重置自己
    ref.invalidate(monthlyShiftChartProvider);
    ref.invalidate(monthlyWeightChartProvider);
    ref.invalidate(monthlyWorkTimeStatsProvider);
  }

  Future<bool> syncAllShiftsToSystem() async {
    bool isSync = false;
    final configListAsync = ref.read(shiftConfigViewModelProvider);
    final Map<int, ShiftConfig> configMap = configListAsync.maybeWhen(
      data: (list) => {for (var config in list) config.id: config},
      orElse: () => {},
    );

    final repo = ref.read(shiftRepositoryProvider);
    final rawShifts = await repo.getAllShifts();

    //List<Map<String, dynamic>> batchData = [];

    // for(var shift in rawShifts){
    //   batchData.add(_generateCalendarData(shift,configMap));
    // }
    // if(batchData.isNotEmpty){
    //   isSync = await CalendarChannelHelper.syncShiftsToSystem(batchData);
    // }
    List<PigeonShift> pigeonShifts = [];
    for (var shift in rawShifts) {
      pigeonShifts.add(_generatePigeonShift(shift, configMap));
    }
    if(pigeonShifts.isNotEmpty){
      isSync = await CalendarHostApi().syncShiftsToSystem(pigeonShifts);
    }
    return isSync;
  }

  Map<String, dynamic> _generateCalendarData(
    CalendarShift shift,
    Map<int, ShiftConfig> configMap,
  ) {
    Map<String, dynamic> mapData = {};
    mapData["title"] = configMap[shift.shiftConfigId]?.name;
    mapData["description"] =
        "${configMap[shift.shiftConfigId]?.label} ${configMap[shift.shiftConfigId]?.startTime} - ${configMap[shift.shiftConfigId]?.endTime}";
    mapData["startTime"] = DateTime.parse(
      "${shift.dateId} ${configMap[shift.shiftConfigId]?.startTime}",
    ).millisecondsSinceEpoch;
    mapData["endTime"] = DateTime.parse(
      "${shift.dateId} ${configMap[shift.shiftConfigId]?.endTime}",
    ).millisecondsSinceEpoch;
    return mapData;
  }

  PigeonShift _generatePigeonShift(
    CalendarShift shift,
    Map<int, ShiftConfig> configMap,
  ) {
    return PigeonShift(
      title: configMap[shift.shiftConfigId]?.name ?? "",
      description: "${configMap[shift.shiftConfigId]?.label} ${configMap[shift.shiftConfigId]?.startTime} - ${configMap[shift.shiftConfigId]?.endTime}",
      startTimeMills: DateTime.parse("${shift.dateId} ${configMap[shift.shiftConfigId]?.startTime}").millisecondsSinceEpoch,
      endTimeMills : DateTime.parse("${shift.dateId} ${configMap[shift.shiftConfigId]?.endTime}").millisecondsSinceEpoch
    );
  }

  Future<void> setShiftToIsland() async{
    final configListAsync = ref.read(shiftConfigViewModelProvider);
    final Map<int, ShiftConfig> configMap = configListAsync.maybeWhen(
      data: (list) => {for (var config in list) config.id: config},
      orElse: () => {},
    );

    final repo = ref.read(shiftRepositoryProvider);
    final dateId = DateTime.now().year * 10000 + DateTime.now().month * 100 + DateTime.now().day;
    final rawShift = await repo.getShiftById(dateId);

    if(rawShift != null){
      final config = configMap[rawShift.shiftConfigId];
      final data = PigeonShiftIslandData(
        shiftName: config?.name ?? "",
        startTimeMills: DateTime.parse("${dateId} ${config?.startTime}").millisecondsSinceEpoch,
        endTimeMills: DateTime.parse("${dateId} ${config?.endTime}").millisecondsSinceEpoch,
        colorHex: config?.colorValue.toString() ?? "",
      );
      await LiveActivityHostApi().startOrUpdateIsland(data);
    }else{
      await LiveActivityHostApi().stopIsland();
    }
  }
}
