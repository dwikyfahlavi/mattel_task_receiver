package com.mattel.device_bridge

import android.app.NotificationManager
import android.content.Context
import android.content.Intent
import android.net.Uri
import android.os.Build
import android.provider.Settings
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File

/**
 * Android-only checks and actions that the regular Flutter plugins do not expose.
 *
 * Every method is safe to call on any API level: unsupported checks return the
 * value that means "nothing to fix" so the readiness check does not block a
 * device that simply does not have the restriction.
 */
class DeviceBridgePlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var scannerChannel: EventChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, CHANNEL)
        channel.setMethodCallHandler(this)
        scannerChannel = EventChannel(binding.binaryMessenger, SCANNER_CHANNEL)
        scannerChannel.setStreamHandler(HardwareScanner(context))
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        scannerChannel.setStreamHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        try {
            when (call.method) {
                "canUseFullScreenIntent" -> result.success(canUseFullScreenIntent())
                "openFullScreenIntentSettings" -> result.success(openFullScreenIntentSettings())
                "isNotificationChannelEnabled" -> {
                    val id = call.argument<String>("channelId")
                    if (id == null) {
                        result.error("ARGUMENT", "channelId is required", null)
                    } else {
                        result.success(isNotificationChannelEnabled(id))
                    }
                }
                "canRequestPackageInstalls" -> result.success(canRequestPackageInstalls())
                "openInstallUnknownAppsSettings" -> result.success(openInstallUnknownAppsSettings())
                "installApk" -> {
                    val path = call.argument<String>("path")
                    if (path == null) {
                        result.error("ARGUMENT", "path is required", null)
                    } else {
                        installApk(path)
                        result.success(true)
                    }
                }
                "restartApp" -> {
                    result.success(true)
                    restartApp()
                }
                "deviceKeyEnsure" -> result.success(DeviceKeys.ensure())
                "deviceKeyDescribe" -> result.success(DeviceKeys.describe())
                "deviceKeySign" -> {
                    val text = call.argument<String>("text")
                    if (text == null) {
                        result.error("ARGUMENT", "text is required", null)
                    } else {
                        result.success(DeviceKeys.sign(text))
                    }
                }
                "deviceKeyDelete" -> {
                    DeviceKeys.delete()
                    result.success(true)
                }
                "keepAliveStart" -> {
                    KeepAliveService.start(
                        context,
                        call.argument<String>("title") ?: "",
                        call.argument<String>("body") ?: "",
                    )
                    result.success(true)
                }
                "keepAliveStop" -> {
                    KeepAliveService.stop(context)
                    result.success(true)
                }
                else -> result.notImplemented()
            }
        } catch (e: Exception) {
            result.error("DEVICE_BRIDGE", e.message, null)
        }
    }

    private fun notificationManager() =
        context.getSystemService(Context.NOTIFICATION_SERVICE) as NotificationManager

    private fun canUseFullScreenIntent(): Boolean {
        // Restricted for non-calling apps only from Android 14 (API 34).
        if (Build.VERSION.SDK_INT < 34) return true
        return notificationManager().canUseFullScreenIntent()
    }

    private fun openFullScreenIntentSettings(): Boolean {
        if (Build.VERSION.SDK_INT < 34) return false
        val intent = Intent(Settings.ACTION_MANAGE_APP_USE_FULL_SCREEN_INTENT)
            .setData(Uri.parse("package:${context.packageName}"))
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
        return true
    }

    private fun isNotificationChannelEnabled(channelId: String): Boolean {
        val nm = notificationManager()
        if (!nm.areNotificationsEnabled()) return false
        if (Build.VERSION.SDK_INT < 26) return true
        val channel = nm.getNotificationChannel(channelId) ?: return false
        return channel.importance != NotificationManager.IMPORTANCE_NONE
    }

    private fun canRequestPackageInstalls(): Boolean {
        if (Build.VERSION.SDK_INT < 26) return true
        return context.packageManager.canRequestPackageInstalls()
    }

    private fun openInstallUnknownAppsSettings(): Boolean {
        if (Build.VERSION.SDK_INT < 26) return false
        val intent = Intent(Settings.ACTION_MANAGE_UNKNOWN_APP_SOURCES)
            .setData(Uri.parse("package:${context.packageName}"))
            .addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
        return true
    }

    private fun installApk(path: String) {
        val file = File(path)
        require(file.exists()) { "APK not found" }
        val uri = FileProvider.getUriForFile(
            context,
            "${context.packageName}.device_bridge.fileprovider",
            file,
        )
        val intent = Intent(Intent.ACTION_VIEW)
            .setDataAndType(uri, "application/vnd.android.package-archive")
            .addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION or Intent.FLAG_ACTIVITY_NEW_TASK)
        context.startActivity(intent)
    }

    /** Relaunches the app in a fresh process so a downloaded Shorebird patch is applied. */
    private fun restartApp() {
        val launch = context.packageManager.getLaunchIntentForPackage(context.packageName) ?: return
        launch.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK or Intent.FLAG_ACTIVITY_CLEAR_TASK)
        context.startActivity(launch)
        Runtime.getRuntime().exit(0)
    }

    companion object {
        private const val CHANNEL = "com.mattel/device_bridge"
        private const val SCANNER_CHANNEL = "com.mattel/device_bridge/scanner"
    }
}
