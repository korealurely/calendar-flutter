package com.joe.flutter_calendar

import android.content.ContentValues
import android.net.Uri
import android.provider.CalendarContract
import androidx.annotation.NonNull
import androidx.lifecycle.lifecycleScope
import com.joe.flutter_calendar.alarm.AlarmScheduler
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.util.TimeZone
import kotlinx.coroutines.CoroutineScope
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext

class MainActivity : FlutterActivity(), CalendarHostApi{
    private val CHANNEL = "com.joe.dream_calendar/calendar"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        //旧的方法
//        MethodChannel(flutterEngine.dartExecutor.binaryMessenger,CHANNEL).setMethodCallHandler { call, result ->
//            if(call.method == "addCalendarEvent"){
//                val title = call.argument<String>("title")
//                val description = call.argument<String>("description")
//                val startTime = call.argument<Long>("startTime")
//                val endTime = call.argument<Long>("endTime")
//
//                if(title != null && startTime != null && endTime != null){
//                    val success = insertToSystemCalendar(title,description ?:"" ,startTime,endTime)
//                    if(success){
//                        result.success(true)
//                    }else{
//                        result.error("CALENDAR_ERROR","写入系统日历失败",null)
//                    }
//                }else{
//                    result.notImplemented()
//                }
//            }else if(call.method == "addCalendarEventsBatch"){
//                val shifts = call.argument<List<Map<String, Any>>>("shifts")
//
//                if(shifts != null){
//
//                    CoroutineScope(Dispatchers.Main).launch {
//                        val allSuccess = withContext(Dispatchers.IO){
//                            var successFlag = true
//                            val cr = contentResolver
//                            //提前删除
//                            val deleteSelection = "${CalendarContract.Events.ORGANIZER} = ?"
//                            val selectionArgs = arrayOf("dream_calendar@joe.com")
//                            cr.delete(CalendarContract.Events.CONTENT_URI, deleteSelection, selectionArgs)
//
//                            for(shift in shifts){
//                                val title = shift["title"] as? String
//                                val description = shift["description"] as? String
//                                val startTime = shift["startTime"] as? Long
//                                val endTime = shift["endTime"] as? Long
//
//                                if(title != null && startTime != null && endTime != null){
//                                    val success = insertToSystemCalendar(title,description ?: "",startTime,endTime)
//                                    if(!success){ successFlag = false; }
//                                }
//                            }
//                            successFlag
//                        }
//                        result.success(allSuccess)
//                    }
//                }else{
//                    result.error("BAD_ARGUMENTS", "数据列表不能为空", null)
//                }
//            }
//        }
        CalendarHostApi.setUp(flutterEngine.dartExecutor.binaryMessenger,this)
    }

    /**
     * 🛠️ 原生核心：利用 CalendarContract 写入 Android 日历数据库
     */
    private fun insertToSystemCalendar(title: String, description: String, startTime: Long, endTime: Long): Boolean {
        return try {
            val cr = contentResolver

            val values = ContentValues().apply {
                // 安卓要求必须指定插入到哪一个日历账户下，这里我们默认拿 ID 为 1 的主日历账户
                put(CalendarContract.Events.CALENDAR_ID, 1)
                put(CalendarContract.Events.TITLE, title)
                put(CalendarContract.Events.DESCRIPTION, description)
                put(CalendarContract.Events.DTSTART, startTime)
                put(CalendarContract.Events.DTEND, endTime)
                put(CalendarContract.Events.EVENT_TIMEZONE, TimeZone.getDefault().id)
                put(CalendarContract.Events.ORGANIZER, "dream_calendar@joe.com")
            }

            // 执行物理插入
            val uri: Uri? = cr.insert(CalendarContract.Events.CONTENT_URI, values)
            uri != null
        } catch (e: Exception) {
            e.printStackTrace()
            false
        }
    }

    override fun syncShiftsToSystem(
        shifts: List<PigeonShift>,
        callback: (Result<Boolean>) -> Unit
    ) {
        CoroutineScope(Dispatchers.Main).launch {
            val allSuccess = withContext(Dispatchers.IO){
                var successFlag = true
                val cr = contentResolver
                try {
                    val deleteSelection = "${CalendarContract.Events.ORGANIZER} = ?"
                    val selectionArgs = arrayOf("dream_calendar@joe.com")
                    cr.delete(CalendarContract.Events.CONTENT_URI, deleteSelection, selectionArgs)

                    for(shift in shifts){
                        val title = shift.title
                        val description = shift.description
                        val startTime = shift.startTimeMills
                        val endTime = shift.endTimeMills
                        val success = insertToSystemCalendar(title, description, startTime, endTime)
                        if (!success) {
                            successFlag = false
                        }
                    }
                }catch (e: Exception){
                    e.printStackTrace()
                    successFlag = false
                }
                successFlag
            }
            callback(Result.success(allSuccess))
        }
    }

    //设置shift通知
    override fun setShiftsAlarmToSystem(shifts: List<PigeonShift>) {
        lifecycleScope.launch {
            AlarmScheduler.updateNextScheduler(context,shifts)
        }
    }

}
