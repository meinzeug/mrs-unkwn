import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/network/dio_client.dart';
import '../../../../core/utils/logger.dart';
import '../../../../platform_channels/device_monitoring.dart';

/// Collects application usage statistics periodically and
/// stores them locally. Data can be aggregated and uploaded
/// to the backend in batches.
class ActivityMonitoringService {
  ActivityMonitoringService(this._deviceMonitoring, this._dio);

  final DeviceMonitoring _deviceMonitoring;
  final DioClient _dio;

  static const _boxName = 'app_usage_records';
  static bool _initialized = false;

  Box? _box;
  Timer? _timer;

  /// Initializes Hive storage for monitoring data.
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

  /// Starts periodic collection every 15 minutes.
  Future<void> start() async {
    await init();
    await collectOnce();
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(minutes: 15), (_) => collectOnce());
  }

  /// Stops periodic collection.
  Future<void> stop() async {
    _timer?.cancel();
  }

  /// Collects usage data once and stores it.
  Future<void> collectOnce() async {
    try {
      if (!await _deviceMonitoring.hasPermission()) return;
      final stats = await _deviceMonitoring.getAppUsageStats();
      final record = {
        'timestamp': DateTime.now().toIso8601String(),
        'stats': stats,
      };
      await _box?.add(record);
    } catch (e, stack) {
      Logger.error('collectOnce failed: $e', e, stack);
    }
  }

  /// Returns aggregated usage for the given day.
  Future<List<Map<String, dynamic>>> dailySummary(DateTime day) async {
    await init();
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final Map<String, int> totals = {};
    for (final value in _box!.values) {
      final map = Map<String, dynamic>.from(value as Map);
      final ts = DateTime.parse(map['timestamp'] as String);
      if (ts.isBefore(start) || ts.isAfter(end)) continue;
      for (final stat in map['stats'] as List) {
        final s = Map<String, dynamic>.from(stat as Map);
        final pkg = s['package'] as String? ?? 'unknown';
        final minutes = (s['minutes'] as num?)?.toInt() ?? 0;
        totals[pkg] = (totals[pkg] ?? 0) + minutes;
      }
    }
    return totals.entries
        .map((e) => {'package': e.key, 'minutes': e.value})
        .toList();
  }

  /// Returns aggregated usage for the week containing [day].
  Future<List<Map<String, dynamic>>> weeklySummary(DateTime day) async {
    await init();
    final start = DateTime(day.year, day.month, day.day)
        .subtract(Duration(days: day.weekday - 1));
    final end = start.add(const Duration(days: 7));
    final Map<String, int> totals = {};
    for (final value in _box!.values) {
      final map = Map<String, dynamic>.from(value as Map);
      final ts = DateTime.parse(map['timestamp'] as String);
      if (ts.isBefore(start) || ts.isAfter(end)) continue;
      for (final stat in map['stats'] as List) {
        final s = Map<String, dynamic>.from(stat as Map);
        final pkg = s['package'] as String? ?? 'unknown';
        final minutes = (s['minutes'] as num?)?.toInt() ?? 0;
        totals[pkg] = (totals[pkg] ?? 0) + minutes;
      }
    }
    return totals.entries
        .map((e) => {'package': e.key, 'minutes': e.value})
        .toList();
  }

  /// Uploads all collected usage data to the backend and clears the cache.
  Future<void> uploadBatch() async {
    await init();
    if (_box!.isEmpty) return;
    final data =
        _box!.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
    try {
      await _dio.post('/monitoring/usage', data: data);
      await _box!.clear();
    } catch (e, stack) {
      Logger.error('uploadBatch failed: $e', e, stack);
    }
  }
}
