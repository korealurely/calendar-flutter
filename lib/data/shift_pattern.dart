import 'package:isar/isar.dart';
import 'shift_config.dart';

part 'shift_pattern.g.dart';

@collection
class ShiftPattern {
  Id id = Isar.autoIncrement;

  late int patternType;
  late String startDate;
  late String endDate;

  @ignore
  List<ShiftConfig> shiftConfigs = [];

  late List<int> shiftConfigIds;

  DateTime updatedAt = DateTime.now();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||//
        other is ShiftPattern &&
        runtimeType == other.runtimeType &&
        id == other.id &&
        patternType == other.patternType &&
        startDate == other.startDate &&
        endDate == other.endDate &&
        shiftConfigIds == other.shiftConfigIds;
  }

  @override
  int get hashCode {
    // 使用 Object.hash 替代手动异或
    return Object.hash(
      id,
      patternType,
      startDate,
      endDate,
      shiftConfigIds,
      // 如果 updatedAt 或 shiftConfigs 影响相等性，也应加入
      // updatedAt,
    );
  }
}