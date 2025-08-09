package com.mrsunkwn.mrs_unkwn_app

import android.app.AppOpsManager
import android.app.usage.UsageStatsManager
import android.content.Context
import android.content.Intent
import android.os.Build
import android.provider.Settings
import androidx.annotation.NonNull
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result

/**
 * Handles method channel calls for device monitoring features on Android.
 * Provides app usage statistics using [UsageStatsManager].
 */
class DeviceMonitoringPlugin : FlutterPlugin, MethodCallHandler {
    private lateinit var channel: MethodChannel
    private lateinit var context: Context

    override fun onAttachedToEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        context = binding.applicationContext
        channel = MethodChannel(binding.binaryMessenger, "com.mrsunkwn/device_monitoring")
        channel.setMethodCallHandler(this)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onMethodCall(call: MethodCall, result: Result) {
        when (call.method) {
            "hasPermission" -> result.success(hasUsagePermission())
            "requestPermission", "openPermissionSettings" -> {
                requestUsagePermission()
                result.success(null)
            }
            "getAppUsageStats" -> result.success(getAppUsageStats())
            "startMonitoring", "stopMonitoring", "getInstalledApps" -> result.success(null)
            else -> result.notImplemented()
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
}
