package com.mattel.device_bridge

import android.app.Notification
import android.app.NotificationChannel
import android.app.NotificationManager
import android.app.PendingIntent
import android.app.Service
import android.content.Context
import android.content.Intent
import android.content.pm.ServiceInfo
import android.os.Build
import android.os.IBinder
import androidx.core.app.NotificationCompat

/**
 * Keeps the app process alive while a technician is signed in, so the
 * Socket.IO connection that delivers work orders survives the screen turning
 * off (the backend sends no push notifications).
 *
 * The socket itself runs in the Flutter engine of the activity; this service
 * only holds a foreground priority with a quiet ongoing notification. It stops
 * with the task (`stopWithTask`): when the user swipes the app away the engine
 * is gone, so a lingering notification would be misleading.
 */
class KeepAliveService : Service() {
    override fun onBind(intent: Intent?): IBinder? = null

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {
        val title = intent?.getStringExtra(EXTRA_TITLE) ?: "Mattel Task"
        val body = intent?.getStringExtra(EXTRA_BODY) ?: ""
        val notification = buildNotification(this, title, body)
        if (Build.VERSION.SDK_INT >= 34) {
            startForeground(
                NOTIFICATION_ID,
                notification,
                ServiceInfo.FOREGROUND_SERVICE_TYPE_SPECIAL_USE,
            )
        } else {
            startForeground(NOTIFICATION_ID, notification)
        }
        // Never restarted without the app: the engine would not be running.
        return START_NOT_STICKY
    }

    companion object {
        const val EXTRA_TITLE = "title"
        const val EXTRA_BODY = "body"
        private const val CHANNEL_ID = "keep_alive_v1"
        private const val NOTIFICATION_ID = 1002

        fun start(context: Context, title: String, body: String) {
            val intent = Intent(context, KeepAliveService::class.java)
                .putExtra(EXTRA_TITLE, title)
                .putExtra(EXTRA_BODY, body)
            if (Build.VERSION.SDK_INT >= 26) {
                context.startForegroundService(intent)
            } else {
                context.startService(intent)
            }
        }

        fun stop(context: Context) {
            context.stopService(Intent(context, KeepAliveService::class.java))
        }

        private fun buildNotification(context: Context, title: String, body: String): Notification {
            if (Build.VERSION.SDK_INT >= 26) {
                val nm = context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager
                if (nm.getNotificationChannel(CHANNEL_ID) == null) {
                    nm.createNotificationChannel(
                        NotificationChannel(
                            CHANNEL_ID,
                            "Koneksi penugasan",
                            NotificationManager.IMPORTANCE_LOW,
                        ).apply {
                            description = "Menjaga koneksi agar penugasan tetap diterima"
                            setShowBadge(false)
                        },
                    )
                }
            }
            val launch = context.packageManager.getLaunchIntentForPackage(context.packageName)
            val content = launch?.let {
                PendingIntent.getActivity(
                    context,
                    0,
                    it,
                    PendingIntent.FLAG_IMMUTABLE or PendingIntent.FLAG_UPDATE_CURRENT,
                )
            }
            // The app's monochrome status icon (ic_stat_task), else the launcher icon.
            val icon = context.resources
                .getIdentifier("ic_stat_task", "drawable", context.packageName)
                .takeIf { it != 0 } ?: context.applicationInfo.icon
            return NotificationCompat.Builder(context, CHANNEL_ID)
                .setSmallIcon(icon)
                .setContentTitle(title)
                .setContentText(body)
                .setOngoing(true)
                .setSilent(true)
                .setCategory(NotificationCompat.CATEGORY_SERVICE)
                .setPriority(NotificationCompat.PRIORITY_LOW)
                .setContentIntent(content)
                .build()
        }
    }
}
