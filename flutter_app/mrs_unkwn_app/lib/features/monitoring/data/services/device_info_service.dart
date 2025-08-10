import 'dart:io';

import 'package:battery_plus/battery_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:disk_space_plus/disk_space_plus.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/utils/logger.dart';

/// Collects hardware, OS, storage and battery information and
/// stores periodic snapshots for the parent dashboard.
class DeviceInfoService {
  DeviceInfoService({
    Future<Map<String, dynamic>> Function()? deviceInfo,
    Future<int> Function()? batteryLevel,
    Future<BatteryState> Function()? batteryState,
    Future<double?> Function()? freeDisk,
    Future<double?> Function()? totalDisk,
    Future<List<String>> Function()? readMemInfo,
  })  : _deviceInfo = deviceInfo ?? _defaultDeviceInfo,
        _batteryLevel = batteryLevel ?? _defaultBatteryLevel,
        _batteryState = batteryState ?? _defaultBatteryState,
        _freeDisk = freeDisk ?? (() => DiskSpace.getFreeDiskSpace),
        _totalDisk = totalDisk ?? (() => DiskSpace.getTotalDiskSpace),
        _readMemInfo = readMemInfo ?? _defaultReadMemInfo;

  final Future<Map<String, dynamic>> Function() _deviceInfo;
  final Future<int> Function() _batteryLevel;
  final Future<BatteryState> Function() _batteryState;
  final Future<double?> Function() _freeDisk;
  final Future<double?> Function() _totalDisk;
  final Future<List<String>> Function() _readMemInfo;

  static const _boxName = 'device_info_records';
  static bool _initialized = false;
  Box? _box;

  static Future<Map<String, dynamic>> _defaultDeviceInfo() async {
    final plugin = DeviceInfoPlugin();
    final info = await plugin.deviceInfo;
    return info.data;
  }

  static Future<int> _defaultBatteryLevel() => Battery().batteryLevel;
  static Future<BatteryState> _defaultBatteryState() => Battery().batteryState;

  static Future<List<String>> _defaultReadMemInfo() async {
    if (Platform.isAndroid || Platform.isLinux) {
      final file = File('/proc/meminfo');
      if (await file.exists()) {
        return file.readAsLines();
      }
    }
    return [];
  }

  /// Initializes Hive storage for device info records.
  Future<void> init() async {
    if (!_initialized) {
      await Hive.initFlutter();
      _initialized = true;
    }
    if (!Hive.isBoxOpen(_boxName)) {
      _box = await Hive.openBox(_boxName);
    } else {
      _box = Hive.box(_boxName);
    }
  }

  /// Collects device information snapshot.
  Future<Map<String, dynamic>> collect() async {
    final info = await _deviceInfo();
    final batteryLvl = await _batteryLevel();
    final state = await _batteryState();
    final diskFree = await _freeDisk() ?? 0;
    final diskTotal = await _totalDisk() ?? 0;

    int? totalRam;
    int? freeRam;
    for (final line in await _readMemInfo()) {
      if (line.startsWith('MemTotal')) {
        totalRam = int.tryParse(RegExp(r'\d+').firstMatch(line)?.group(0) ?? '');
      } else if (line.startsWith('MemAvailable')) {
        freeRam = int.tryParse(RegExp(r'\d+').firstMatch(line)?.group(0) ?? '');
      }
    }
    if (totalRam != null) totalRam = (totalRam / 1024).round();
    if (freeRam != null) freeRam = (freeRam / 1024).round();

    return {
      'timestamp': DateTime.now().toIso8601String(),
      'device': info,
      'batteryLevel': batteryLvl,
      'isCharging': state == BatteryState.charging,
      'storageFree': diskFree,
      'storageTotal': diskTotal,
      'ramTotal': totalRam,
      'ramAvailable': freeRam,
    };
  }

  /// Saves current device snapshot to Hive.
  Future<void> saveCurrent() async {
    try {
      await init();
      final data = await collect();
      await _box?.add(data);
    } catch (e, stack) {
      Logger.error('saveCurrent failed: $e', e, stack);
    }
  }

  /// Returns latest stored record if available.
  Future<Map<String, dynamic>?> latest() async {
    await init();
    if (_box == null || _box!.isEmpty) return null;
    return Map<String, dynamic>.from(
        _box!.getAt(_box!.length - 1) as Map<dynamic, dynamic>);
  }
}
