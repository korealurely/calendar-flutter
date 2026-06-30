import 'package:isar/isar.dart';
import 'package:flutter_calendar/data/shift_config.dart';

class ShiftConfigRepository {
  final Isar isar;
  ShiftConfigRepository(this.isar);

  Future<List<ShiftConfig>> getConfigs() async{
    return await isar.shiftConfigs
        .where()
        .findAll();
  }

  Future<void> saveConfig(ShiftConfig config) async{
    await isar.writeTxn(( ) async{
      await isar.shiftConfigs.put(config);
    });
  }

  Future<void> deleteConfigById(int configId) async{
    await isar.writeTxn(( ) async{
      await isar.shiftConfigs.delete(configId);
    });
  }
}