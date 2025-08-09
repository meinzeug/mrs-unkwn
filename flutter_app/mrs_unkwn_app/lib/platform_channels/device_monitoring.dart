import 'dart:async';

import 'package:flutter/services.dart';

import '../core/utils/logger.dart';

/// Describes an app installation or removal event.
class AppChangeEvent {
  AppChangeEvent({
    required this.packageName,
    required this.type,
    this.replacing = false,
  });

  final String packageName;
  final String type; // 'added' or 'removed'
  final bool replacing;

  factory AppChangeEvent.fromMap(Map<dynamic, dynamic> map) => AppChangeEvent(
        packageName: map['packageName'] as String? ?? '',
        type: map['type'] as String? ?? '',
        replacing: map['replacing'] as bool? ?? false,
      );
}

/// Provides an interface to native device monitoring features via
/// a [MethodChannel].
abstract class DeviceMonitoring {
  /// Checks if the required permission for device monitoring is granted.
  Future<bool> hasPermission();

  /// Requests the necessary permission for device monitoring.
  Future<void> requestPermission();

  /// Opens the system settings so the user can grant the permission manually.
  Future<void> openPermissionSettings();

  /// Starts background monitoring on the native platform.
  Future<void> startMonitoring();

  /// Stops background monitoring on the native platform.
  Future<void> stopMonitoring();

  /// Returns application usage statistics from the native platform.
  Future<List<Map<String, dynamic>>> getAppUsageStats();

  /// Returns a list of installed applications from the native platform.
  Future<List<Map<String, dynamic>>> getInstalledApps();

  /// Returns network usage statistics per application from the native platform.
  /// Each entry contains package name and byte counts split by
  /// mobile/wifi and upload/download.
  Future<List<Map<String, dynamic>>> getNetworkUsageStats();

  /// Stream of app installation and removal events.
  Stream<AppChangeEvent> get onAppChange;
}

/// Default implementation of [DeviceMonitoring] using a
/// `MethodChannel` with name `com.mrsunkwn/device_monitoring`.
class MethodChannelDeviceMonitoring implements DeviceMonitoring {
  const MethodChannelDeviceMonitoring();

  static const MethodChannel _channel =
      MethodChannel('com.mrsunkwn/device_monitoring');
  static const EventChannel _eventChannel =
      EventChannel('com.mrsunkwn/device_monitoring/events');

  @override
  Future<bool> hasPermission() async {
    try {
      final result = await _channel.invokeMethod<bool>('hasPermission');
      return result ?? false;
    } on PlatformException catch (e, stack) {
      Logger.error('hasPermission failed: ${e.message}', e, stack);
      return false;
    } on MissingPluginException {
      Logger.warning('hasPermission not implemented on this platform');
      return false;
    }
  }

  @override
  Future<void> requestPermission() async {
    try {
      await _channel.invokeMethod('requestPermission');
    } on PlatformException catch (e, stack) {
      Logger.error('requestPermission failed: ${e.message}', e, stack);
    } on MissingPluginException {
      Logger.warning('requestPermission not implemented on this platform');
    }
  }

  @override
  Future<void> openPermissionSettings() async {
    try {
      await _channel.invokeMethod('openPermissionSettings');
    } on PlatformException catch (e, stack) {
      Logger.error('openPermissionSettings failed: ${e.message}', e, stack);
    } on MissingPluginException {
      Logger.warning('openPermissionSettings not implemented on this platform');
    }
  }

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

  @override
  Future<List<Map<String, dynamic>>> getNetworkUsageStats() async {
    try {
      final result =
          await _channel.invokeMethod<List<dynamic>>('getNetworkUsageStats');
      return (result ?? <dynamic>[])
          .cast<Map<dynamic, dynamic>>()
          .map((e) => e.cast<String, dynamic>())
          .toList();
    } on PlatformException catch (e, stack) {
      Logger.error('getNetworkUsageStats failed: ${e.message}', e, stack);
      return [];
    } on MissingPluginException {
      Logger.warning('getNetworkUsageStats not implemented on this platform');
      return [];
    }
  }

  @override
  Stream<AppChangeEvent> get onAppChange => _eventChannel
          .receiveBroadcastStream()
          .where((event) => event is Map)
          .map((event) =>
              AppChangeEvent.fromMap(event as Map<dynamic, dynamic>))
      // ignore: unnecessary_lambdas
      ;
}

/// Mock implementation used for development and tests without native code.
class MockDeviceMonitoring implements DeviceMonitoring {
  final _controller = StreamController<AppChangeEvent>.broadcast();

  @override
  Future<bool> hasPermission() async => true;

  @override
  Future<void> requestPermission() async {}

  @override
  Future<void> openPermissionSettings() async {}

  @override
  Future<void> startMonitoring() async {}

  @override
  Future<void> stopMonitoring() async {}

  @override
  Future<List<Map<String, dynamic>>> getAppUsageStats() async => [];

  @override
  Future<List<Map<String, dynamic>>> getInstalledApps() async => [];

  @override
  Future<List<Map<String, dynamic>>> getNetworkUsageStats() async => [];

  @override
  Stream<AppChangeEvent> get onAppChange => _controller.stream;

  /// Helper to emit fake events in tests.
  void emitAppChange(AppChangeEvent event) => _controller.add(event);
}

