package com.lovisgod.mypayble

import android.app.Activity
import android.content.Context
import androidx.annotation.NonNull
import com.isw.upstreamsdk.ApplicationHandler
import com.isw.upstreamsdk.UpstreamSdkApplication
import com.isw.upstreamsdk.core.data.utilsData.AccountType
//import com.isw.upstreamsdk.ApplicationHandler

import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.runBlocking
import kotlinx.coroutines.withContext
import java.lang.ref.WeakReference

/** MypayblePlugin */
class MypayblePlugin: FlutterPlugin, MethodCallHandler, ActivityAware {
  /// The MethodChannel that will the communication between Flutter and native Android
  ///
  /// This local reference serves to register the plugin with the Flutter Engine and unregister it
  /// when the Flutter Engine is detached from the Activity
  private lateinit var channel : MethodChannel
  private lateinit var context: Context
  private  var activity = WeakReference<Activity>(null)

  override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
    println("on attached to engine is called" )
    channel = MethodChannel(flutterPluginBinding.binaryMessenger, "mypayble")
    channel.setMethodCallHandler(this)
    context = flutterPluginBinding.applicationContext
  }

  override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
    if (call.method == "getPlatformVersion") {
      result.success("Android ${android.os.Build.VERSION.RELEASE}")
    } else if (call.method == "initiateSdk") {
        println("initiate sdk called")
//        UpstreamSdkApplication.onCreate(context)
       UpstreamSdkApplication.setEnv(false)
       ApplicationHandler.initialize(context)
       result.success("successful")
    } else if (call.method == "initiateKeyAndDetailsDownload") {
       runBlocking {
         withContext(Dispatchers.IO) {
           val terminalId = call.argument<String>("terminalId")
           println("terminal ID is :::: $terminalId")
           val response  = ApplicationHandler.perFormKeyDownload(terminalId.toString())
           println(
             "sessionKey:${response.sessionKey}|masterKey:${response.masterKey}" +
                     "|pinkey:${response.pinKey}|terminalId:${response.terminalInfo?.terminalCode}"
           )
           val serializedData = mapOf(
             "sessionKey" to response.sessionKey,
             "pinKey" to response.pinKey,
             "masterKey" to response.masterKey,
             "terminalId" to response.terminalInfo?.terminalCode.toString(),
             "merchantId" to response.terminalInfo?.merchantId.toString(),
             "merhantCategoryCode" to response.terminalInfo?.merchantCategoryCode.toString(),
             "merhantNameAndLocation" to response.terminalInfo?.cardAcceptorNameLocation.toString()
           )
           result.success(serializedData)
         }
       }
    } else if (call.method == "initiatePurchase") {
       runBlocking {
         withContext(Dispatchers.IO) {
           val iccData = call.argument<String>("iccData")
           val terminalInfo = call.argument<Map<String, String>>("terminalInfoMap")
           println("terminalId is :::: ${terminalInfo?.get("terminalCode")}")
           val transactionInfo = call.argument<Map<String, Any>>("transactionInfo")
           val accountType = call.argument<String>("accountType")
           val accountTypeKt = when (accountType) {
             "Default" -> AccountType.Default
             "Savings" -> AccountType.Savings
             "Current" -> AccountType.Current
             else -> AccountType.Default
           }
           var terminalInfoMap = HashMap<String, String>()
           terminalInfoMap["merchantCategoryCode"] =
             terminalInfo?.get("merchantCategoryCode").toString()
           terminalInfoMap["terminalCode"] = terminalInfo?.get("terminalCode").toString()
           terminalInfoMap["merchantId"] = terminalInfo?.get("merchantId").toString()
           terminalInfoMap["merchantName"] = terminalInfo?.get("merchantName").toString()


           var transactionInfoMap = HashMap<String, Any>()
           transactionInfo?.get("haspin")?.let {
             transactionInfoMap.put("haspin", it) }
           transactionInfoMap.put("track2Data", transactionInfo?.get("track2Data").toString())
           transactionInfoMap.put(
             "panSequenceNumber",
             transactionInfo?.get("panSequenceNumber").toString()
           )
           transactionInfoMap.put("amount", transactionInfo?.get("amount").toString())
           transactionInfoMap.put("pinBlock", transactionInfo?.get("pinBlock").toString())
           transactionInfoMap.put("posDataCode", transactionInfo?.get("posDataCode").toString())

           val response = ApplicationHandler.performPurchase(transactionInfoMap,
             terminalInfoMap, iccData.toString(), accountTypeKt)

           println(
             "responseCode:${response.responseCode}|description:${response.description}"
           )

           val serializedData = mapOf(
             "responseCode" to response.responseCode,
             "description" to response.description
           )
           result.success(serializedData)
         }
       }
    }else {
      result.notImplemented()
    }
  }

  override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
    channel.setMethodCallHandler(null)
  }

  override fun onAttachedToActivity(binding: ActivityPluginBinding) {
     println("this is called :::: for activity attached")
      activity = WeakReference(binding.activity)
      UpstreamSdkApplication.onCreate(binding.activity.applicationContext)
  }

  override fun onDetachedFromActivityForConfigChanges() {
    activity.clear()
  }

  override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
    activity = WeakReference(binding.activity)
  }

  override fun onDetachedFromActivity() {
    activity.clear()
  }
}
