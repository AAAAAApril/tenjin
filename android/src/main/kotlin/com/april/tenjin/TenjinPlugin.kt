package com.april.tenjin

import android.content.Context
import android.util.Log
import androidx.annotation.NonNull
import com.tenjin.android.BuildConfig
import com.tenjin.android.TenjinSDK

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/** TenjinPlugin */
class TenjinPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context
    private var sdk: TenjinSDK? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "tenjin")
        context = flutterPluginBinding.applicationContext
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        if (call.method != "init") {
            if (sdk == null) {
                result.error("call init() first to init TenjinSDK", null, null)
                return
            }
        }
        when (call.method) {
            "init" -> {
                val apiKey = call.argument("apiKey") as? String
                if (apiKey.isNullOrEmpty()) {
                    result.success(false)
                } else {
                    sdk = TenjinSDK.getInstance(context, apiKey)
                    result.success(true)
                }
            }
            "optInParams" -> {
                sdk!!.optInParams(
                    (call.argument("params") as? List<String>)?.toTypedArray()
                        ?: emptyArray<String>()
                )
                result.success(true)
            }
            "optOutParams" -> {
                sdk!!.optOutParams(
                    (call.argument("params") as? List<String>)?.toTypedArray()
                        ?: emptyArray<String>()
                )
                result.success(true)
            }
            "connect" -> {
                sdk!!.connect()
                result.success(true)
            }
            "transaction" -> {
                sdk!!.transaction(
                    (call.argument("productId") as? String) ?: "",
                    (call.argument("currencyCode") as? String) ?: "",
                    (call.argument("quantity") as? Int) ?: 0,
                    (call.argument("unitPrice") as? Double) ?: 0.0,
                    (call.argument("purchaseData") as? String) ?: "",
                    (call.argument("dataSignature") as? String ?: "")
                )
                result.success(true)
            }
            "event" -> {
                val name = call.argument("name") as? String
                if (name.isNullOrEmpty()) {
                    result.success(false)
                } else {
                    val value = call.argument("value") as? String
                    if (value == null) {
                        sdk!!.eventWithName(name)
                    } else {
                        sdk!!.eventWithNameAndValue(name, value)
                    }
                    result.success(true)
                }
            }
            "appendAppSubversion" -> {
                val value = call.argument("value") as? Int
                if (value == null) {
                    result.success(false)
                } else {
                    sdk!!.appendAppSubversion(value)
                    result.success(true)
                }
            }
            else -> {
                result.notImplemented()
            }
        }
    }

}