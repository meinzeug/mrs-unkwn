package com.mrsunkwn.mrs_unkwn_app

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
import android.app.usage.NetworkStats
import android.app.usage.NetworkStatsManager
import android.net.ConnectivityManager
import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.EventChannel.EventSink
import io.flutter.plugin.common.EventChannel.StreamHandler
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Handles method channel calls for device monitoring features on Android.
 * Provides app usage statistics using [UsageStatsManager].
 */
class DeviceMonitoringPlugin : FlutterPlugin, MethodCallHandler, StreamHandler {
    private lateinit var channel: MethodChannel
    private lateinit var eventChannel: EventChannel
    private var events: EventSink? = null
    private lateinit var context: Context
    private val installReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context, intent: Intent) {
            val pkg = intent.data?.schemeSpecificPart ?: return
            val replacing = intent.getBooleanExtra(Intent.EXTRA_REPLACING, false)
            val type = when (intent.action) {
                Intent.ACTION_PACKAGE_ADDED -> "added"
                Intent.ACTION_PACKAGE_REMOVED -> "removed"
                else -> return
            }
            events?.success(mapOf(
                "packageName" to pkg,
                "type" to type,
                "replacing" to replacing
            ))
        }
    }

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.mrsunkwn/device_monitoring")
        channel.setMethodCallHandler(this)
        eventChannel = EventChannel(binding.binaryMessenger, "com.mrsunkwn/device_monitoring/events")
        eventChannel.setStreamHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        eventChannel.setStreamHandler(null)
        try {
            context.unregisterReceiver(installReceiver)
        } catch (_: Exception) {
        }
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "hasPermission" -> result.success(hasUsagePermission())
            "requestPermission", "openPermissionSettings" -> {
                requestUsagePermission()
                result.success(null)
            }
            "getAppUsageStats" -> result.success(getAppUsageStats())
            "getNetworkUsageStats" -> result.success(getNetworkUsageStats())
            "startMonitoring", "stopMonitoring", "getInstalledApps" -> result.success(null)
            else -> result.notImplemented()
        }
    }

    override fun onListen(arguments: Any?, events: EventSink) {
        this.events = events
        val filter = IntentFilter().apply {
            addAction(Intent.ACTION_PACKAGE_ADDED)
            addAction(Intent.ACTION_PACKAGE_REMOVED)
            addDataScheme("package")
        }
        context.registerReceiver(installReceiver, filter)
    }

    override fun onCancel(arguments: Any?) {
        events = null
        try {
            context.unregisterReceiver(installReceiver)
        } catch (_: Exception) {
        }
    }

    private fun hasUsagePermission(): Boolean {
        val appOps = context.getSystemService(Context.APP_OPS_SERVICE) as AppOpsManager
        val mode = if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.Q) {
            appOps.unsafeCheckOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(), context.packageName)
        } else {
            appOps.checkOpNoThrow(AppOpsManager.OPSTR_GET_USAGE_STATS,
                android.os.Process.myUid(), context.packageName)
        }
        return mode == AppOpsManager.MODE_ALLOWED
    }

    private fun requestUsagePermission() {
        val intent = Intent(Settings.ACTION_USAGE_ACCESS_SETTINGS).apply {
            addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
        }
        context.startActivity(intent)
    }

    private fun getAppUsageStats(): List<Map<String, Any>> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.LOLLIPOP) {
            return emptyList()
        }
        if (!hasUsagePermission()) {
            requestUsagePermission()
            return emptyList()
        }
        val manager = context.getSystemService(Context.USAGE_STATS_SERVICE) as UsageStatsManager
        val end = System.currentTimeMillis()
        val start = end - 24L * 60 * 60 * 1000 // last 24 hours
        val stats = manager.queryUsageStats(UsageStatsManager.INTERVAL_DAILY, start, end)
        return stats?.map {
            mapOf(
                "packageName" to it.packageName,
                "totalTimeForeground" to it.totalTimeInForeground
            )
        } ?: emptyList()
    }

    private fun getNetworkUsageStats(): List<Map<String, Any>> {
        if (Build.VERSION.SDK_INT < Build.VERSION_CODES.M) {
            return emptyList()
        }
        if (!hasUsagePermission()) {
            requestUsagePermission()
            return emptyList()
        }
        val manager =
            context.getSystemService(Context.NETWORK_STATS_SERVICE) as NetworkStatsManager
        val pm = context.packageManager
        val apps = pm.getInstalledApplications(0)
        val end = System.currentTimeMillis()
        val start = end - 24L * 60 * 60 * 1000 // last 24 hours
        val results = mutableListOf<Map<String, Any>>()
        val bucket = NetworkStats.Bucket()
        for (app in apps) {
            val uid = app.uid
            var mobileRx = 0L
            var mobileTx = 0L
            var wifiRx = 0L
            var wifiTx = 0L
            try {
                val mobile = manager.queryDetailsForUid(
                    ConnectivityManager.TYPE_MOBILE,
                    null,
                    start,
                    end,
                    uid
                )
                while (mobile.hasNextBucket()) {
                    mobile.getNextBucket(bucket)
                    mobileRx += bucket.rxBytes
                    mobileTx += bucket.txBytes
                }
                mobile.close()
            } catch (_: Exception) {
            }
            try {
                val wifi = manager.queryDetailsForUid(
                    ConnectivityManager.TYPE_WIFI,
                    null,
                    start,
                    end,
                    uid
                )
                while (wifi.hasNextBucket()) {
                    wifi.getNextBucket(bucket)
                    wifiRx += bucket.rxBytes
                    wifiTx += bucket.txBytes
                }
                wifi.close()
            } catch (_: Exception) {
            }
            results.add(
                mapOf(
                    "packageName" to app.packageName,
                    "mobileRx" to mobileRx,
                    "mobileTx" to mobileTx,
                    "wifiRx" to wifiRx,
                    "wifiTx" to wifiTx
                )
            )
        }
        return results
    }
}
