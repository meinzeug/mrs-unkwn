import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../core/utils/logger.dart';
import '../../../../platform_channels/device_monitoring.dart';
import 'monitoring_alert_service.dart';

/// Tracks daily screen time per app and notifies parents when limits are exceeded.
class ScreenTimeTracker {
  ScreenTimeTracker(this._deviceMonitoring, this._alerts);

  final DeviceMonitoring _deviceMonitoring;
  final MonitoringAlertService _alerts;

  static const _boxName = 'screen_time';
  static bool _initialized = false;

  Box? _box;
  Timer? _timer;
  final Map<String, int> _todayUsage = {};
  Map<String, int> _lastSnapshot = {};
  DateTime _currentDay = DateTime.now();

  int? _totalLimit;
  final Map<String, int> _appLimits = {};
  bool _totalLimitNotified = false;
  final Set<String> _appLimitNotified = {};

  /// Initialize Hive storage.
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

  /// Start periodic screen time tracking.
  Future<void> start({Duration interval = const Duration(minutes: 1)}) async {
    await init();
    await collect();
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => collect());
  }

  /// Stop periodic tracking.
  Future<void> stop() async {
    _timer?.cancel();
  }

  /// Manually trigger a collection cycle.
  Future<void> collect() async {
    try {
      if (!await _deviceMonitoring.hasPermission()) return;
      final stats = await _deviceMonitoring.getAppUsageStats();
      final now = DateTime.now();
      if (_currentDay.day != now.day ||
          _currentDay.month != now.month ||
          _currentDay.year != now.year) {
        _todayUsage.clear();
        _lastSnapshot = {};
        _currentDay = now;
        _totalLimitNotified = false;
        _appLimitNotified.clear();
      }
      final current = <String, int>{};
      for (final stat in stats) {
        final pkg = stat['package'] as String? ?? 'unknown';
        final minutes = (stat['minutes'] as num?)?.toInt() ?? 0;
        current[pkg] = minutes;
        final last = _lastSnapshot[pkg] ?? 0;
        final diff = minutes - last;
        if (diff > 0) {
          _todayUsage[pkg] = (_todayUsage[pkg] ?? 0) + diff;
        }
      }
      _lastSnapshot = current;
      final total = _todayUsage.values.fold<int>(0, (a, b) => a + b);
      final record = {
        'total': total,
        'apps': Map<String, int>.from(_todayUsage),
        'timestamp': now.toIso8601String(),
      };
      final key = _dayKey(now);
      await _box?.put(key, record);
      _checkLimits(total);
    } catch (e, stack) {
      Logger.error('collect failed: $e', e, stack);
    }
  }

  /// Set screen time limits in minutes. [total] for daily total, [perApp] for per-app limits.
  void setLimits({int? total, Map<String, int>? perApp}) {
    _totalLimit = total;
    if (perApp != null) {
      _appLimits
        ..clear()
        ..addAll(perApp);
    }
    _totalLimitNotified = false;
    _appLimitNotified.clear();
  }

  void _checkLimits(int total) {
    if (_totalLimit != null && total > _totalLimit! && !_totalLimitNotified) {
      _totalLimitNotified = true;
      _alerts.trigger(
        MonitoringAlertType.screenTimeLimitExceeded,
        message: 'Tägliches Bildschirmzeitlimit überschritten',
      );
    }
    _todayUsage.forEach((pkg, minutes) {
      final limit = _appLimits[pkg];
      if (limit != null &&
          minutes > limit &&
          !_appLimitNotified.contains(pkg)) {
        _appLimitNotified.add(pkg);
        _alerts.trigger(
          MonitoringAlertType.screenTimeLimitExceeded,
          message: 'Bildschirmzeitlimit für $pkg überschritten',
        );
      }
    });
  }

  /// Returns stored usage for [day].
  Future<Map<String, dynamic>> dailyReport(DateTime day) async {
    await init();
    final data = _box?.get(_dayKey(day));
    if (data is Map) {
      return Map<String, dynamic>.from(data.cast<String, dynamic>());
    }
    return {'total': 0, 'apps': <String, int>{}};
  }

  String _dayKey(DateTime day) =>
      '${day.year.toString().padLeft(4, '0')}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';
}
