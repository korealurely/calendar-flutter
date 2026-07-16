import 'package:flutter_calendar/provider/shift_provider.dart';
import 'package:isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_calendar/data/shift_config.dart';
import 'package:flutter_calendar/repository/shift_config_repository.dart';
import 'package:flutter_calendar/provider/alarm_service_provider.dart';

part 'shift_config_provider.g.dart';

@riverpod
ShiftConfigRepository shiftConfigRepository(ShiftConfigRepositoryRef ref){
  final isar = ref.watch(isarInstanceProvider).value!;
  return ShiftConfigRepository(isar);
}

@riverpod
class ShiftConfigViewModel extends _$ShiftConfigViewModel {

  @override
  Future<List<ShiftConfig>> build() async {
    // 💡 1. 干净利落地捞数据，干掉之前干扰动画的 watchLazy 尝试
    final repo = ref.watch(shiftConfigRepositoryProvider);
    var list = await repo.getConfigs();

    // 🚀【疯狂造数据】：如果数据库是空的，咱们当场无中生有！
    if (list.isEmpty) {
      final isar = ref.read(isarInstanceProvider).value!;
      final config1 = ShiftConfig()..name = "早班"..label = "早"..startTime = "08:00"..endTime = "16:00"..colorValue = 0xFF4CAF50;
      final config2 = ShiftConfig()..name = "中班"..label = "中"..startTime = "16:00"..endTime = "00:00"..colorValue = 0xFFFF9800;
      final config3 = ShiftConfig()..name = "夜班"..label = "夜"..startTime = "00:00"..endTime = "08:00"..colorValue = 0xFF9C27B0;

      await isar.writeTxn(() async {
        await isar.shiftConfigs.putAll([config1, config2, config3]);
      });
      list = await repo.getConfigs();
    }

    return list;
  }

  Future<void> deleteConfigById(int configId) async {
    // 1. 无论如何，先把数据库里的肉身斩断
    final repo = ref.read(shiftConfigRepositoryProvider);
    await repo.deleteConfigById(configId);
    ref.invalidate(alarmServiceProvider);

    // 2. 🛡️ 边界防御：启动双保险状态机
    if (state.hasValue && !state.isLoading) {
      // 🟢 正常流：内存里有数，且没有处于加载闪断中。
      // 直接走微秒级纯内存过滤，100% 吐出最完美的丝滑滑出动画！
      final previousList = state.value!;
      state = AsyncData(
          previousList.where((config) => config.id != configId).toList()
      );
    } else {
      // 🔴 异常流：万一真的空降进这里（hasValue为假，或者正在loading）
      // 别慌，立刻启动备份天线，冲进数据库捞一把全量最新的真身，强行砸回给 state
      try {
        final newList = await repo.getConfigs();
        state = AsyncData(newList);
        // 💡 注：虽然这次硬刷可能因为组件重建错失删除动画，但它成功做到了“兜底刷新”，绝对不会让页面卡死不响应！
      } catch (err, stack) {
        state = AsyncError(err, stack); // 如果连兜底都翻车，直接抛出标准的 Riverpod 错误状态
      }
    }
  }

  // 修改/新增班次后，为了让列表更新，也要用类似的操作更新状态
  Future<void> changeShiftConfig({
    required int? id,
    required String name,
    required String label,
    required String? startTime,
    required String? endTime,
    required int colorValue,
  }) async {
    final newConfig = ShiftConfig()
      ..id = (id !=null && id != 0) ? id : Isar.autoIncrement
      ..name = name
      ..label = label
      ..startTime = startTime
      ..endTime = endTime
      ..colorValue = colorValue;

    final repo = ref.read(shiftConfigRepositoryProvider);
    await repo.saveConfig(newConfig);
    ref.invalidate(alarmServiceProvider);

    // 保存完后，把新列表全量拉回来并无闪断塞给 state
    final newList = await repo.getConfigs();
    state = AsyncData(newList);
  }
}