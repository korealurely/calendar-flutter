import 'package:flutter/services.dart';

class CalendarChannelHelper {
  static const MethodChannel _channel = MethodChannel('com.joe.dream_calendar/calendar');

  //单条
  static Future<bool> syncShiftToSystem({
    required String title,
    required String description,
    required DateTime startTime,
    required DateTime endTime
}) async{
    try{
      final bool result = await _channel.invokeMethod("addCalendarEvent",{
        'title':title,
        'description':description,
        'startTime':startTime.millisecondsSinceEpoch,
        'endTime':endTime.millisecondsSinceEpoch
      });
      return result;
    } on PlatformException catch (e){
      print("❌ 同步日历失败: '${e.message}'");
      return false;
    }
  }

  //批量
  static Future<bool> syncShiftsToSystem(List<Map<String,dynamic>> shifts) async{
    if(shifts.isEmpty) return true;
    try{
      final bool result = await _channel.invokeMethod("addCalendarEventsBatch",{
        'shifts':shifts
      });
      return result;
    }on PlatformException catch (e){
      print("❌ 批量同步日历失败: '${e.message}'");
      return false;
    }
  }
}