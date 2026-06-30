import 'package:isar/isar.dart';
import 'package:flutter_calendar/data/shift_pattern.dart';

class ShiftPatternRepository {
  final Isar isar;
  ShiftPatternRepository(this.isar);

  Future<List<ShiftPattern>> getPatterns() async {
    return await isar.shiftPatterns
        .where()
        .sortByUpdatedAtDesc()
        .findAll();
  }

  Future<void> savePattern(ShiftPattern pattern) async {
    await isar.writeTxn(( ) async {
      await isar.shiftPatterns.put(pattern);
    });
  }

  Future<void> deletePatternById(int patternId) async {
    await isar.writeTxn(( ) async {
      await isar.shiftPatterns.delete(patternId);
    });
  }
}