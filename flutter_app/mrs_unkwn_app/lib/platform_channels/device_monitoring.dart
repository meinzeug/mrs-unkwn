import 'package:flutter/services.dart';

import '../core/utils/logger.dart';

/// Provides an interface to native device monitoring features via
/// a [MethodChannel].
abstract class DeviceMonitoring {
  /// Starts background monitoring on the native platform.
  Future<void> startMonitoring();

  /// Stops background monitoring on the native platform.
  Future<void> stopMonitoring();

  /// Returns application usage statistics from the native platform.
  Future<List<Map<String, dynamic>>> getAppUsageStats();

  /// Returns a list of installed applications from the native platform.
  Future<List<Map<String, dynamic>>> getInstalledApps();
}

/// Default implementation of [DeviceMonitoring] using a
/// `MethodChannel` with name `com.mrsunkwn/device_monitoring`.
class MethodChannelDeviceMonitoring implements DeviceMonitoring {
  const MethodChannelDeviceMonitoring();

  static const MethodChannel _channel =
      MethodChannel('com.mrsunkwn/device_monitoring');

  @override
  Future<void> startMonitoring() async {
    try {
      await _channel.invokeMethod('startMonitoring');
    } on PlatformException catch (e, stack) {
      Logger.error('startMonitoring failed: ${e.message}', e, stack);
    } on MissingPluginException {
      Logger.warning('startMonitoring not implemented on this platform');
    }
  }

  @override
  Future<void> stopMonitoring() async {
    try {
      await _channel.invokeMethod('stopMonitoring');
    } on PlatformException catch (e, stack) {
      Logger.error('stopMonitoring failed: ${e.message}', e, stack);
    } on MissingPluginException {
      Logger.warning('stopMonitoring not implemented on this platform');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getAppUsageStats() async {
    try {
      final result =
          await _channel.invokeMethod<List<dynamic>>('getAppUsageStats');
      return (result ?? <dynamic>[])
          .cast<Map<dynamic, dynamic>>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
    } on PlatformException catch (e, stack) {
      Logger.error('getAppUsageStats failed: ${e.message}', e, stack);
      return [];
    } on MissingPluginException {
      Logger.warning('getAppUsageStats not implemented on this platform');
      return [];
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getInstalledApps() async {
    try {
      final result =
          await _channel.invokeMethod<List<dynamic>>('getInstalledApps');
      return (result ?? <dynamic>[])
          .cast<Map<dynamic, dynamic>>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
    } on PlatformException catch (e, stack) {
      Logger.error('getInstalledApps failed: ${e.message}', e, stack);
      return [];
    } on MissingPluginException {
      Logger.warning('getInstalledApps not implemented on this platform');
      return [];
    }
  }
}

/// Mock implementation used for development and tests without native code.
class MockDeviceMonitoring implements DeviceMonitoring {
  @override
  Future<void> startMonitoring() async {}

  @override
  Future<void> stopMonitoring() async {}

  @override
  Future<List<Map<String, dynamic>>> getAppUsageStats() async => [];

  @override
  Future<List<Map<String, dynamic>>> getInstalledApps() async => [];
}

