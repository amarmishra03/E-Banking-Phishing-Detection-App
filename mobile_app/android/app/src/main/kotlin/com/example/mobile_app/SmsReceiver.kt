package com.example.mobile_app

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.provider.Telephony
import io.flutter.plugin.common.MethodChannel

class SmsReceiver : BroadcastReceiver() {

    companion object {
        var channel: MethodChannel? = null
    }

    override fun onReceive(context: Context?, intent: Intent?) {

        if (intent?.action == Telephony.Sms.Intents.SMS_RECEIVED_ACTION) {

            val messages = Telephony.Sms.Intents.getMessagesFromIntent(intent)

            for (sms in messages) {

                val messageBody = sms.messageBody

                channel?.invokeMethod("onSmsReceived", messageBody)

            }
        }
    }
}