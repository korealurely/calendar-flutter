import 'package:isar/isar.dart';
// 💥 加上这行，给自动生成的代码指引回家的路
part 'shift_config.g.dart';

@collection
class ShiftConfig {
  Id id = Isar.autoIncrement;

  late String name; //班次名称
  late String label; //标签

  String? startTime;
  String? endTime;

  late int colorValue;



  @override
  bool operator ==(Object other) =>
      identical(this,other) ||
      other is ShiftConfig &&
        runtimeType == other.runtimeType &&
  id == other.id && name == other.name && label == other.label
  && startTime == other.startTime && endTime == other.endTime &&
  colorValue == other.colorValue ;

  @override
  int get hashCode => Object.hash(id, name,label,startTime,endTime,colorValue);
}
