import 'package:isar/isar.dart';
import 'package:flutter_calendar/data/calendar_weight.dart';

class WeightRepository {
  final Isar isar;
  WeightRepository(this.isar);

  Future<List<CalendarWeight>> getMonthWeights(int year,int month) async{
    int start = year * 10000 + month * 100 + 1;
    int end = year * 10000 + month * 100 + 31;

    return await isar.calendarWeights
        .where()
        .dateIdBetween(start,end)
        .findAll();
  }

  Stream<List<CalendarWeight>>  getWeightsByDateId(int dataId) {
    return  isar.calendarWeights
        .where()
        .dateIdEqualTo(dataId)
        .watch(fireImmediately: true);
  }

  Future<void> saveDayWeight(CalendarWeight weight) async{
    await isar.writeTxn(() async{
      await isar.calendarWeights.put(weight);
    });
  }

  Future<void> saveWeights(List<CalendarWeight> weights) async{
    await isar.writeTxn(() async{
      await isar.calendarWeights.putAll(weights);
    });
  }

  Future<void> deleteWeightById(int id) async{
    await isar.writeTxn(() async{
      await isar.calendarWeights.delete(id);
    });
  }

  Future<void> deleteWeightByIds(List<int> ids) async{
    await isar.writeTxn(() async{
      await isar.calendarWeights.deleteAll(ids);
    });
  }
}