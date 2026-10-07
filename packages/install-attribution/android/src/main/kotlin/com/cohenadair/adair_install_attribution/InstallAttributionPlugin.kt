package com.cohenadair.adair_install_attribution

import android.app.Activity
import android.app.Application
import com.facebook.FacebookSdk
import com.facebook.appevents.AppEventsLogger
import com.facebook.appevents.internal.ActivityLifecycleTracker
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

class InstallAttributionPlugin : FlutterPlugin, ActivityAware, MethodCallHandler {
    companion object {
        private const val CHANNEL_INSTALL_ATTRIBUTION =
            "adair_install_attribution"
        private const val METHOD_REGISTER = "register"
    }

    private lateinit var installAttributionChannel: MethodChannel
    private lateinit var application: Application
    private var activity: Activity? = null

    override fun onAttachedToEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        application = binding.applicationContext as Application
        installAttributionChannel =
            MethodChannel(binding.binaryMessenger, CHANNEL_INSTALL_ATTRIBUTION)
        installAttributionChannel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(binding: FlutterPlugin.FlutterPluginBinding) {
        installAttributionChannel.setMethodCallHandler(null)
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        activity = binding.activity
    }

    override fun onDetachedFromActivityForConfigChanges() {
        activity = null
    }

    override fun onDetachedFromActivity() {
        activity = null
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            METHOD_REGISTER -> registerInstallAttribution(result)
            else -> result.notImplemented()
        }
    }

    /**
     * Enables the Meta SDK (disabled by default in this plugin's manifest)
     * and logs the install/activate-app event. The app ID and client token
     * are read by the SDK from the host app's manifest meta-data. Completes
     * with a description of the API that was called.
     */
    private fun registerInstallAttribution(result: Result) {
        try {
            FacebookSdk.setAutoInitEnabled(true)
            FacebookSdk.fullyInitialize()
            FacebookSdk.setAutoLogAppEventsEnabled(true)
            AppEventsLogger.activateApp(application)

            // The SDK logs fb_mobile_activate_app when an activity resumes,
            // but this runs after Flutter starts, so the launch activity has
            // already resumed and the SDK missed it. Replay the resume, as
            // Meta's Unity SDK does (this method is public for that reason).
            activity?.let { ActivityLifecycleTracker.onActivityResumed(it) }

            // Returned to Dart so the code path taken can be logged.
            result.success("Meta SDK AppEventsLogger.activateApp")
        } catch (e: Exception) {
            result.error("register_failed", e.message, e.toString())
        }
    }
}
