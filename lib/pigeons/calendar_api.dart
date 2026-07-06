import 'package:pigeon/pigeon.dart';

@ConfigurePigeon(PigeonOptions(
  dartOut:'lib/src/generated/calendar_api.g.dart',
  dartOptions:DartOptions(),
  kotlinOut:'android/app/src/main/kotlin/com/joe/flutter_calendar/CalendarApi.g.kt',
  kotlinOptions: KotlinOptions(package: 'com.joe.flutter_calendar'),
  swiftOut:'ios/Runner/CalendarApi.g.swift',
  swiftOptions:SwiftOptions(),
))

class PigeonShift{
  late String title;
  late int startTimeMills;
  late int endTimeMills;
  late String description;
}

@HostApi()
abstract class CalendarHostApi{
  @async
  bool syncShiftsToSystem(List<PigeonShift> shifts);
}