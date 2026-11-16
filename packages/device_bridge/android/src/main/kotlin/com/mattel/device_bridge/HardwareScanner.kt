package com.mattel.device_bridge

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import androidx.core.content.ContextCompat
import io.flutter.plugin.common.EventChannel

/**
 * Results of the built-in barcode engine of Newland devices (WD1 II), sent as
 * broadcasts when the scanner is set to "broadcast output" (the default on
 * MDM-managed units). No camera library is involved.
 *
 * Two known broadcast formats are handled; others are ignored.
 */
internal class HardwareScanner(private val context: Context) : EventChannel.StreamHandler {
    private var receiver: BroadcastReceiver? = null

    override fun onListen(arguments: Any?, events: EventChannel.EventSink) {
        val r = object : BroadcastReceiver() {
            override fun onReceive(ctx: Context, intent: Intent) {
                val value = when (intent.action) {
                    ACTION_NLSCAN -> {
                        // SCAN_STATE is "ok" for a successful read on Newland firmware.
                        val state = intent.getStringExtra("SCAN_STATE")
                        if (state != null && state != "ok") null
                        else intent.getStringExtra("SCAN_BARCODE1")
                    }
                    ACTION_SCANNER_SERVICE -> intent.getStringExtra("scannerdata")
                    else -> null
                }
                if (!value.isNullOrEmpty()) events.success(value.trim())
            }
        }
        val filter = IntentFilter().apply {
            addAction(ACTION_NLSCAN)
            addAction(ACTION_SCANNER_SERVICE)
        }
        // Sent by the system scanner service, so the receiver must be exported.
        ContextCompat.registerReceiver(context, r, filter, ContextCompat.RECEIVER_EXPORTED)
        receiver = r
    }

    override fun onCancel(arguments: Any?) {
        receiver?.let {
            try {
                context.unregisterReceiver(it)
            } catch (_: IllegalArgumentException) {
                // Already unregistered.
            }
        }
        receiver = null
    }

    companion object {
        private const val ACTION_NLSCAN = "nlscan.action.SCANNER_RESULT"
        private const val ACTION_SCANNER_SERVICE = "com.android.server.scannerservice.broadcast"
    }
}
