import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

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
  int _intervalMinutes = 15;
  int _lastUsageMinutes = 0;
  final Map<String, List<Map<String, dynamic>>> _dailyCache = {};
  final Map<String, List<Map<String, dynamic>>> _weeklyCache = {};

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

  /// Starts periodic collection with adaptive intervals.
  Future<void> start() async {
    await init();
    await collectOnce();
    _intervalMinutes = _calculateInterval();
    _scheduleNextRun();
  }

  void _scheduleNextRun() {
    _timer?.cancel();
    _timer = Timer(Duration(minutes: _intervalMinutes), () async {
      await collectOnce();
      _intervalMinutes = _calculateInterval();
      _scheduleNextRun();
    });
  }

  int _calculateInterval() {
    if (_lastUsageMinutes > 60) return 15;
    if (_lastUsageMinutes > 30) return 30;
    return 60;
  }

  int get currentInterval => _intervalMinutes;

  /// Stops periodic collection.
  Future<void> stop() async {
    _timer?.cancel();
  }

  void _invalidateCaches() {
    _dailyCache.clear();
    _weeklyCache.clear();
  }

  /// Collects usage data once and stores it.
  Future<void> collectOnce() async {
    try {
      if (!await _deviceMonitoring.hasPermission()) return;
      final stats = await _deviceMonitoring.getAppUsageStats();
      _lastUsageMinutes = stats.fold<int>(
          0, (sum, s) => sum + ((s['minutes'] as num?)?.toInt() ?? 0));
      final jsonStats = jsonEncode(stats);
      final compressed = base64Encode(gzip.encode(utf8.encode(jsonStats)));
      final record = {
        'timestamp': DateTime.now().toIso8601String(),
        'stats': compressed,
      };
      await _box?.add(record);
      if ((_box?.length ?? 0) > 1000) {
        await _box?.deleteAt(0);
      }
      _invalidateCaches();
    } catch (e, stack) {
      Logger.error('collectOnce failed: $e', e, stack);
    }
  }

  /// Returns aggregated usage for the given day.
  Future<List<Map<String, dynamic>>> dailySummary(DateTime day) async {
    await init();
    final start = DateTime(day.year, day.month, day.day);
    final key = start.toIso8601String().substring(0, 10);
    if (_dailyCache.containsKey(key)) return _dailyCache[key]!;
    final end = start.add(const Duration(days: 1));
    final Map<String, int> totals = {};
    for (final value in _box!.values) {
      final map = Map<String, dynamic>.from(value as Map);
      final ts = DateTime.parse(map['timestamp'] as String);
      if (ts.isBefore(start) || ts.isAfter(end)) continue;
      final encoded = map['stats'] as String;
      final decoded = utf8.decode(gzip.decode(base64Decode(encoded)));
      final stats =
          List<Map<String, dynamic>>.from(jsonDecode(decoded) as List);
      for (final stat in stats) {
        final pkg = stat['package'] as String? ?? 'unknown';
        final minutes = (stat['minutes'] as num?)?.toInt() ?? 0;
        totals[pkg] = (totals[pkg] ?? 0) + minutes;
      }
    }
    final result = totals.entries
        .map((e) => {'package': e.key, 'minutes': e.value})
        .toList();
    _dailyCache[key] = result;
    return result;
  }

  /// Returns aggregated usage for the week containing [day].
  Future<List<Map<String, dynamic>>> weeklySummary(DateTime day) async {
    await init();
    final start = DateTime(day.year, day.month, day.day)
        .subtract(Duration(days: day.weekday - 1));
    final key = '${start.toIso8601String().substring(0, 10)}-${day.weekday}';
    if (_weeklyCache.containsKey(key)) return _weeklyCache[key]!;
    final end = start.add(const Duration(days: 7));
    final Map<String, int> totals = {};
    for (final value in _box!.values) {
      final map = Map<String, dynamic>.from(value as Map);
      final ts = DateTime.parse(map['timestamp'] as String);
      if (ts.isBefore(start) || ts.isAfter(end)) continue;
      final encoded = map['stats'] as String;
      final decoded = utf8.decode(gzip.decode(base64Decode(encoded)));
      final stats =
          List<Map<String, dynamic>>.from(jsonDecode(decoded) as List);
      for (final stat in stats) {
        final pkg = stat['package'] as String? ?? 'unknown';
        final minutes = (stat['minutes'] as num?)?.toInt() ?? 0;
        totals[pkg] = (totals[pkg] ?? 0) + minutes;
      }
    }
    final result = totals.entries
        .map((e) => {'package': e.key, 'minutes': e.value})
        .toList();
    _weeklyCache[key] = result;
    return result;
  }

  /// Uploads all collected usage data to the backend and clears the cache.
  Future<void> uploadBatch() async {
    await init();
    if (_box!.isEmpty) return;
    final data = _box!.values.map((e) {
      final map = Map<String, dynamic>.from(e as Map);
      final encoded = map['stats'] as String;
      final decoded = utf8.decode(gzip.decode(base64Decode(encoded)));
      map['stats'] = jsonDecode(decoded);
      return map;
    }).toList();
    try {
      await _dio.post('/monitoring/usage', data: data);
      await _box!.clear();
      _invalidateCaches();
    } catch (e, stack) {
      Logger.error('uploadBatch failed: $e', e, stack);
    }
  }
}
