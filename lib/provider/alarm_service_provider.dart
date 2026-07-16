import 'dart:io';

import 'package:flutter_calendar/provider/shift_config_provider.dart';
import 'package:flutter_calendar/provider/shift_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_calendar/src/generated/calendar_api.g.dart';
import 'package:flutter_calendar/data/calendar_shift.dart';
import 'package:flutter_calendar/data/shift_config.dart';
import 'package:flutter_calendar/service/notification_helper.dart';

part 'alarm_service_provider.g.dart';

@riverpod
Future<void> alarmService(AlarmServiceRef ref) async {
  print("alarmService 被执行");
  final isar = await ref.watch(isarInstanceProvider.future);

  final configRepo = ref.read(shiftConfigRepositoryProvider);
  var configList = await configRepo.getConfigs();

  // 3. 此时 configList 百分之百是有数据的列表了，直接转成 Map 即可
  final Map<int, ShiftConfig> configMap = {
    for (var config in configList) config.id: config
  };

  final repo = ref.read(shiftRepositoryProvider);
  final dataNow = DateTime.now();
  final start = dataNow.year * 10000 + dataNow.month * 100 + dataNow.day;
  final endDataObj = dataNow.add(const Duration(days: 6));
  final end = endDataObj.year * 10000 + endDataObj.month * 100 + endDataObj.day;

  final rawShifts = await repo.getBetweenShifts(start, end);
  List<PigeonShift> pigeonShifts = [];
  for(var shift in rawShifts){
    final config = configMap[shift.shiftConfigId];
    final startParsed = _parseRawDateTime(shift.dateId,config?.startTime);

    if(startParsed != null ){
      pigeonShifts.add(
        PigeonShift(
          title: "${config?.name}提醒",
          description: "您有一个${config?.label}将于 ${config?.startTime} 开始",
          startTimeMills: startParsed.millisecondsSinceEpoch,
          endTimeMills: _parseRawDateTime(shift.dateId, config?.endTime)?.millisecondsSinceEpoch ?? 0,
        )
      );
    }
  }
  if(Platform.isAndroid){
    await CalendarHostApi().setShiftsAlarmToSystem(pigeonShifts);
  }else if(Platform.isIOS){
    await iOSNotificationHelper.schedule7DaysShifts(pigeonShifts);
  }

}

DateTime? _parseRawDateTime(int dateId,String? timeStr){
  if(timeStr == null || timeStr.isEmpty) return null;
  final dateStr = dateId.toString();
  if(dateStr.length != 8) return null;
  final formattedDate = "${dateStr.substring(0, 4)}-${dateStr.substring(4, 6)}-${dateStr.substring(6, 8)}";
  try {
    return DateTime.parse("$formattedDate $timeStr");
  } catch (_) {
    return null;
  }
}
