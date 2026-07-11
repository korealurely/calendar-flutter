import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut:'lib/src/generated/live_activity_api.g.dart',
  dartOptions:DartOptions(),
  swiftOut:'ios/Runner/LiveActivityApi.g.swift',
  swiftOptions:SwiftOptions(),
))

class PigeonShiftIslandData{
  late String shiftName;
  late int startTimeMills;
  late int endTimeMills;
  late String colorHex;
}

@HostApi()
abstract class LiveActivityHostApi {
  void startOrUpdateIsland(PigeonShiftIslandData data);

  void stopIsland();
}