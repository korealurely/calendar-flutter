import 'package:flutter_calendar/data/calendar_weight.dart';
import 'package:flutter_calendar/repository/weight_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter_calendar/provider/shift_provider.dart';
import 'package:flutter_calendar/repository/ble_manager.dart';

part 'weight_provider.g.dart';

@riverpod
WeightRepository weightRepository(WeightRepositoryRef ref){
  final isar = ref.watch(isarInstanceProvider).value!;
  return WeightRepository(isar);
}

@riverpod
class WeightViewModel extends _$WeightViewModel {

  @override
  Future<Map<int, List<CalendarWeight>>> build(int year, int month) async {
    //添加一个value监听触发
    final isar = ref.watch(isarInstanceProvider).value!;
    final dbStream = isar.calendarWeights.watchLazy();
    ref.watch(StreamProvider((ref) => dbStream));

    final repo = ref.watch(weightRepositoryProvider);
    var list =  await repo.getMonthWeights(year, month);

    // 🎯 3. 【就在这里】：无脑投喂给你的蓝牙单例
    // 只要这个 ViewModel 被 UI 唤醒，Repository 就会第一时间和蓝牙单例完成合体！
    BleManager.instance.initRepository(repo);

    //测试数据
    // if(list.isEmpty){
    //   final weight = CalendarWeight()..dateId = 20260601..weight = 78.00..isStable = true..impedance = 400;
    //   final weight1 = CalendarWeight()..dateId = 20260615..weight = 78.00..isStable = true..impedance = 400;
    //   final weight2 = CalendarWeight()..dateId = 20260618..weight = 78.00..isStable = true..impedance = 400;
    //   final weight3 = CalendarWeight()..dateId = 20260625..weight = 78.00..isStable = true..impedance = 400;
    //   final weight4 = CalendarWeight()..dateId = 20260625..weight = 78.32..isStable = true..impedance = 400;
    //   final weight5 = CalendarWeight()..dateId = 20260625..weight = 78.80..isStable = true..impedance = 400;
    //   list.add(weight);
    //   list.add(weight1);
    //   list.add(weight2);
    //   list.add(weight3);
    //   list.add(weight4);
    //   list.add(weight5);
    // }

    Map<int, List<CalendarWeight>> weightMap= {};
    Set<int> dateIdSet = list.map((weight) => weight.dateId).toSet();
    for(int dateId in dateIdSet){
      var weightList = list.where((weight) => weight.dateId == dateId).toList();
      weightMap[dateId]= weightList;
    }
    return weightMap;
  }

  Future<void> addWeight({
    required int dateId,
    required double weight,
    required int impedance,
    required bool isStable
}) async{
    CalendarWeight calendarWeight = CalendarWeight()
        ..dateId = dateId
        ..weight = weight
        ..isStable = isStable
        ..impedance = impedance;

    final repo = ref.read(weightRepositoryProvider);
    await repo.saveDayWeight(calendarWeight);
  }
}

@riverpod
Stream<List<CalendarWeight>> dayWeightsStream(DayWeightsStreamRef ref,DateTime data){
  final repo = ref.watch(weightRepositoryProvider);
  final int dateId = data.year * 10000 + data.month * 100 + data.day;
  return repo.getWeightsByDateId(dateId);
}

