import 'package:isar/isar.dart';
import 'package:flutter_calendar/data/calendar_shift.dart';

class ShiftRepository {
  final Isar isar;
  ShiftRepository(this.isar);

  Future<List<CalendarShift>> getMonthShifts(int year,int month) async{
    int start = year * 10000 + month * 100 + 1;
    int end = year * 10000 + month * 100 + 31;

    return await isar.calendarShifts
        .where()
        .dateIdBetween(start,end)
        .findAll();
  }

  Future<CalendarShift?> getShiftById(int dateId) async{
    return await isar.calendarShifts
        .getByDateId(dateId);
  }

  Future<void> saveDayShift(CalendarShift shift) async{
    await isar.writeTxn(() async{
      await isar.calendarShifts.put(shift);
    });
  }

  Future<void> saveShifts(List<CalendarShift> shifts) async{
    await isar.writeTxn(() async{
      await isar.calendarShifts.putAll(shifts);
    });
  }

  Future<void> deleteShiftByDateId(int dateId) async{
    await isar.writeTxn(() async{
      await isar.calendarShifts.deleteByDateId(dateId);
    });
  }

  Future<void> clearAll() async{
    await isar.writeTxn(() async{
      await isar.clear();
    });
  }
}