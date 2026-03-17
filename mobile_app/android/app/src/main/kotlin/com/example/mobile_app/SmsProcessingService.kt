package com.example.mobile_app

import android.app.Service
import android.content.Intent
import android.os.IBinder
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class SmsProcessingService : Service() {

    override fun onStartCommand(intent: Intent?, flags: Int, startId: Int): Int {

        val smsText = intent?.getStringExtra("sms_text")

        val flutterEngine = FlutterEngine(this)

        val channel = MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "sms_channel"
        )

        channel.invokeMethod("processSms", smsText)

        return START_NOT_STICKY
    }

    override fun onBind(intent: Intent?): IBinder? {
        return null
    }
}