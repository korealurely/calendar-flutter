import 'package:isar/isar.dart';

// 💥 这行绝对不能少！CalendarShiftSchema 就是靠这一行生出来的
import 'package:flutter_calendar/data/shift_config.dart';

part 'calendar_shift.g.dart';

@collection
class CalendarShift {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late int dateId; //日期索引

  int? shiftConfigId;

  @Index()
  bool isAlarm = false;

  late DateTime updatedAt;

  @Index()
  DateTime? alarmTime;

  @ignore
  ShiftConfig? config;

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CalendarShift &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            dateId == other.dateId &&
            shiftConfigId == other.shiftConfigId &&
            isAlarm == other.isAlarm &&
            alarmTime == other.alarmTime &&
            config == other.config;
  }

  @override
  int get hashCode {
    // 使用 Object.hash 替代手动异或
    return Object.hash(
      id,
      dateId,
      shiftConfigId,
      isAlarm,
      alarmTime,
      config,
      // 如果 updatedAt 或 shiftConfigs 影响相等性，也应加入
      // updatedAt,
    );
  }
}
