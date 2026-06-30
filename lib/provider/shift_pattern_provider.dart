import 'package:flutter_calendar/data/shift_pattern.dart';
import 'package:flutter_calendar/repository/shift_pattern_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_calendar/provider/shift_provider.dart';
import 'package:flutter_calendar/provider/shift_config_provider.dart';
import 'package:flutter_calendar/data/shift_config.dart';
import 'package:isar/isar.dart';

part 'shift_pattern_provider.g.dart';

@riverpod
ShiftPatternRepository shiftPatternRepository(ShiftPatternRepositoryRef ref) {
  // 🎯 细节安全：如果 isarInstanceProvider 是 AsyncValue，建议配合 watch 的 requireValue
  final isar = ref.watch(isarInstanceProvider).requireValue;
  return ShiftPatternRepository(isar);
}

@riverpod
class ShiftPatternViewModel extends _$ShiftPatternViewModel {
  @override
  Future<List<ShiftPattern>> build() async {
    // 1. 监听 Repo 和原始 Pattern 列表
    final repo = ref.watch(shiftPatternRepositoryProvider);
    var rawList = await repo.getPatterns();

    // 🎯 修正：将只读列表解构成 Flutter 允许自由修改的动态增量列表！
    List<ShiftPattern> list = List<ShiftPattern>.from(rawList);

    // 2. 监听 Config 列表状态
    final configListAsync = ref.watch(shiftConfigViewModelProvider);

    // 3. 将 AsyncValue 优雅转化为 Map 快照
    final Map<int, ShiftConfig> configMap = configListAsync.maybeWhen(
      data: (list) => {for (var config in list) config.id: config},
      orElse: () => {},
    );

    // 5. 调用私有抽取方法进行联合数据拼装
    _combinePatternWithConfigs(list, configMap);

    return list;
  }

  Future<void> deleteShiftPatternById(int patternId) async {
    final repo = ref.read(shiftPatternRepositoryProvider);
    await repo.deletePatternById(patternId);

    if (state.hasValue && !state.isLoading) {
      final previousList = state.value!;
      state = AsyncData(
        previousList.where((pattern) => pattern.id != patternId).toList(),
      );
    } else {
      state = const AsyncLoading(); // 规范：刷新前切到 loading 状态
      try {
        // 重新拉取时，别忘了也要组装一次 Config
        final newList = await repo.getPatterns();
        final configMap = _getCurrentConfigMap();
        _combinePatternWithConfigs(newList, configMap);
        state = AsyncData(newList);
      } catch (err, stack) {
        state = AsyncError(err, stack);
      }
    }
  }

  Future<void> changeShiftPattern({
    required int patternType,
    required String startDate,
    required String endDate,
    required List<int> shiftConfigIds,
    required ShiftPattern? oldPattern,
  }) async {
    // 1. 构建全新对象，带上时间戳
    final newPattern = ShiftPattern()
      ..id = (oldPattern != null && oldPattern.id != 0) ? oldPattern.id : Isar.autoIncrement
      ..patternType = patternType
      ..startDate = startDate
      ..endDate = endDate
      ..shiftConfigIds = shiftConfigIds
      ..updatedAt = DateTime.now();

    final repo = ref.read(shiftPatternRepositoryProvider);

    // 2. 写入数据库并重新抓取最新列表
    await repo.savePattern(newPattern);
    final newList = await repo.getPatterns();

    // 3. 🎯 修正：在异步方法内，必须严格使用 ref.read 获取当前的 Config 映射表！
    final configMap = _getCurrentConfigMap();

    // 4. 数据合体
    _combinePatternWithConfigs(newList, configMap);

    // 5. 吐出全新状态
    state = AsyncData(newList);
  }

  /// 👑 核心重构：抽取出的公共“多合一数据联姻”算法
  void _combinePatternWithConfigs(List<ShiftPattern> patterns, Map<int, ShiftConfig> configMap) {
    if (patterns.isEmpty || configMap.isEmpty) return;
    for (var pattern in patterns) {
      // 每次拼装前先清空，防止多次 Rebuild 时数据重复添加叠罗汉
      pattern.shiftConfigs = [];
      for (var configId in pattern.shiftConfigIds) {
        if (configMap.containsKey(configId)) {
          pattern.shiftConfigs.add(configMap[configId]!);
        }
      }
    }
  }

  /// 👑 核心重构：安全获取当前现成的 Config 缓存映射表
  Map<int, ShiftConfig> _getCurrentConfigMap() {
    final configListAsync = ref.read(shiftConfigViewModelProvider);
    return configListAsync.maybeWhen(
      data: (list) => {for (var config in list) config.id: config},
      orElse: () => {},
    );
  }
}