import 'package:isar/isar.dart';

part 'calendar_weight.g.dart';

@collection
class CalendarWeight {
  Id id = Isar.autoIncrement;

  @Index()
  late int dateId;//日期索引

  @Index()
  late double weight;//体重

  late int impedance;//阻抗

  @ignore
  bool isStable = false;//测量状态是否稳定

  DateTime updatedAt = DateTime.now();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is CalendarWeight &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            dateId == other.dateId &&
            weight == other.weight &&
            impedance == other.impedance &&
            isStable == other.isStable;
  }

  @override
  int get hashCode => Object.hash(id,dateId,weight,impedance,isStable);
}