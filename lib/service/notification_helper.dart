import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest_all.dart' as tz;
import 'package:flutter_calendar/src/generated/calendar_api.g.dart';


class iOSNotificationHelper{
  static final _notifications = FlutterLocalNotificationsPlugin();

  //需要初始化的时候调佣
  static Future<void> init() async{
    tz.initializeTimeZones();//初始化时区

    const initializationSettings = InitializationSettings(
      iOS: DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      )
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (response){
        _refreshNext7DaysAlarm();
      }
    );
  }

  static Future<void> schedule7DaysShifts(List<PigeonShift> shifts) async{
    //取消所有旧的通知
    await _notifications.cancelAll();

    for(int i = 0 ; i < shifts.length && i < 7;i++){
      final shift = shifts[i];

      final startDateTime = DateTime.fromMillisecondsSinceEpoch(shift.startTimeMills);
      //提前5分钟通知
      //final alarmDateTime = startDateTime.subtract(const Duration(minutes: 5));

      //过滤掉过去时间，因为ios系统限制
      if(startDateTime.isBefore(DateTime.now())) continue;

      await _notifications.zonedSchedule(
          i,
          shift.title,
          shift.description,
          tz.TZDateTime.from(startDateTime, tz.local),
          const NotificationDetails(
            iOS: DarwinNotificationDetails(
              presentAlert: true,
              presentSound: true,
              presentBadge: true,
              //sound:'alarm.caf'
            )
          ),
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime
      );
    }
  }

  //手动点击通知打开的时候做一些操作
  static Future<void> _refreshNext7DaysAlarm() async{
    // 从你 Flutter 侧的本地数据库（如 SQLite 或 Hive）中读取最近的 7 条数据
    // List<PigeonShift> shifts = await getShiftsFromDb();
    // await schedule7DaysShifts(shifts);
  }
}

