package com.example.watchman

import io.flutter.embedding.android.FlutterActivity
import android.os.Bundle
import android.telephony.SmsManager
import android.util.Log
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugins.GeneratedPluginRegistrant

class MainActivity: FlutterActivity() {

    private val CHANNEL = "sendSms"

    private val callResult: MethodChannel.Result? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        provideFlutterEngine(this)?.let { GeneratedPluginRegistrant.registerWith(it) }
        MethodChannel(flutterEngine?.dartExecutor, CHANNEL).setMethodCallHandler{ call, result ->
            if (call.method.equals("send")) {
                val num: String = call.argument("phoneNumber")!!
                val msg: String = call.argument("message")!!
                sendSMS(num, msg, result)
            } else {
                result.notImplemented()
            }
        }


    }

    private fun sendSMS(num: String, msg: String, result: MethodChannel.Result) {
        try {
            val smsManager: SmsManager = SmsManager.getDefault()
            smsManager.sendTextMessage(num, null, msg, null, null)
            result.success("SMS Sent")
        } catch (ex: Exception) {
            ex.printStackTrace()
            result.error("Err", "Sms Not Sent", "")
        }
    }

}
