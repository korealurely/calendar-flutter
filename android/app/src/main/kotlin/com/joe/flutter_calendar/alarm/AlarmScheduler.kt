package com.joe.flutter_calendar.alarm

import android.app.AlarmManager
import android.app.PendingIntent
import android.content.Context
import android.content.Intent
import android.os.Build
import com.joe.flutter_calendar.PigeonShift
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.withContext

object AlarmScheduler {

    // 固定的 7 天闹钟身份证，极其安全的沙箱隔离
    private val ALARM_REQUEST_CODE_LIST = listOf(1001, 1002, 1003, 1004, 1005, 1006, 1007)

    suspend fun updateNextScheduler(context: Context, shifts: List<PigeonShift>) {
        withContext(Dispatchers.IO) {
            val alarmManager = context.getSystemService(Context.ALARM_SERVICE) as AlarmManager

            for (i in 0 until 7) {
                print("设置shift$i")
                val requestCode = ALARM_REQUEST_CODE_LIST[i]
                val shift = shifts.getOrNull(i)

                if (shift != null) {
                    // --- 1. 设定或更新闹钟 ---
                    val intent = Intent(context, AlarmReceiver::class.java).apply {
                        // 统一设置 Action 也是一种好习惯，能确保 PendingIntent 的唯一性匹配
                        action = "com.joe.flutter_calendar.ALARM_ACTION"
                        putExtra("TITLE", shift.title)
                        putExtra("DESCRIPTION", shift.description)
                    }

                    val pendingIntent = PendingIntent.getBroadcast(
                        context,
                        requestCode,
                        intent,
                        PendingIntent.FLAG_UPDATE_CURRENT or PendingIntent.FLAG_IMMUTABLE
                    )

                    val triggerTime = shift.startTimeMills

                    // Android 12 (API 31) 及以上的精准闹钟权限动态处理
                    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
                        if (!alarmManager.canScheduleExactAlarms()) {
                            // 权限缺失：降级为普通闹钟，虽有延迟但保证不崩溃、能响铃
                            alarmManager.setAndAllowWhileIdle(
                                AlarmManager.RTC_WAKEUP,
                                triggerTime,
                                pendingIntent
                            )
                            continue
                        }
                    }

                    // 执行设定（带上最终安全防线）
                    try {
                        alarmManager.setExactAndAllowWhileIdle(
                            AlarmManager.RTC_WAKEUP,
                            triggerTime,
                            pendingIntent
                        )
                    } catch (e: SecurityException) {
                        // 极极端情况下（如用户在设定瞬间手动撤销权限），降级处理
                        alarmManager.setAndAllowWhileIdle(
                            AlarmManager.RTC_WAKEUP,
                            triggerTime,
                            pendingIntent
                        )
                    }

                } else {
                    // --- 2. 取消多余的预埋闹钟 ---
                    // 核心：这里的 Intent 结构（Class 和 Action）必须与上面创建时【完全一致】
                    val intent = Intent(context, AlarmReceiver::class.java).apply {
                        action = "com.joe.flutter_calendar.ALARM_ACTION"
                    }

                    val pendingIntent = PendingIntent.getBroadcast(
                        context,
                        requestCode,  // 对应当天的 requestCode
                        intent,
                        PendingIntent.FLAG_NO_CREATE or PendingIntent.FLAG_IMMUTABLE
                    )

                    if (pendingIntent != null) {
                        alarmManager.cancel(pendingIntent) // 告诉系统大总管取消闹钟
                        pendingIntent.cancel() // 释放本地内存中的 PendingIntent 资源
                    }
                }
            }
        }
    }
}