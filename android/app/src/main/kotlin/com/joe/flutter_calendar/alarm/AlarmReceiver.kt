package com.joe.flutter_calendar.alarm

import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.media.RingtoneManager
import android.os.Build
import android.util.Log
import androidx.core.app.NotificationCompat
import com.joe.flutter_calendar.MainActivity
import com.joe.flutter_calendar.R


class AlarmReceiver : BroadcastReceiver(){

    override fun onReceive(context: Context, intent: Intent) {
        Log.e(TAG,"AlarmReceiver AlarmReceiver")
        //todo 展示通知
        showNotification(context,intent)
    }

    private fun showNotification(
        context: Context,
        intent:Intent
    ) {
        val title = intent.getStringExtra("TITLE")
        val desc = intent.getStringExtra("DESCRIPTION")
        //val time = intent.getStringExtra("TIME")
        Log.e(TAG,"AlarmReceiver AlarmReceiver : $title $desc")
        val channelId = "alarm_channel"
        val notificationManager =
            context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O) {
            val channel = NotificationChannel(
                channelId,
                title,
                NotificationManager.IMPORTANCE_HIGH
            ).apply {
                description = title
                enableLights(true)
                enableVibration(true)
                setSound(RingtoneManager.getDefaultUri(RingtoneManager.TYPE_NOTIFICATION), null)
            }
            notificationManager.createNotificationChannel(channel)
        }
        val detailIntent = Intent(context, MainActivity::class.java)
        val pendingIntent = PendingIntent.getActivity(context,0,detailIntent,PendingIntent.FLAG_IMMUTABLE)
        val notification = NotificationCompat.Builder(context,channelId)
            .setSmallIcon(R.drawable.ic_ai_spark)
            .setContentTitle(title)
            .setContentText(desc)
            .setPriority(NotificationCompat.PRIORITY_HIGH)
            .setCategory(NotificationCompat.CATEGORY_ALARM)
            .setAutoCancel(true)
            .setContentIntent(pendingIntent)
            .build()

        notificationManager.notify(1,notification)
    }

    companion object{
        const val TAG = "AlarmReceiver"
    }
}