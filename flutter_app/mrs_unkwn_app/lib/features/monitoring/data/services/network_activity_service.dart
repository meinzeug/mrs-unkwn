import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../platform_channels/device_monitoring.dart';
import '../../../../core/utils/logger.dart';
import '../../../tutoring/data/services/content_moderation_service.dart';

/// Collects network usage statistics per app and notifies parents
/// when unusual data consumption occurs.
class NetworkActivityService {
  NetworkActivityService(this._deviceMonitoring, this._notifier);

  final DeviceMonitoring _deviceMonitoring;
  final ParentNotificationService _notifier;

  static const _boxName = 'network_activity';
  static bool _initialized = false;

  Box? _box;
  Timer? _timer;

  /// Initializes Hive box for storing network activity.
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

  /// Starts periodic network collection.
  Future<void> start({Duration interval = const Duration(hours: 1)}) async {
    await init();
    await collect();
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) => collect());
  }

  /// Stops periodic collection.
  Future<void> stop() async {
    _timer?.cancel();
  }

  /// Collects network stats once and stores them.
  Future<void> collect() async {
    try {
      if (!await _deviceMonitoring.hasPermission()) return;
      final stats = await _deviceMonitoring.getNetworkUsageStats();
      final record = {
        'timestamp': DateTime.now().toIso8601String(),
        'stats': stats,
      };
      await _box?.add(record);
      _checkUnusualUsage(stats);
    } catch (e, stack) {
      Logger.error('collect network usage failed: $e', e, stack);
    }
  }

  void _checkUnusualUsage(List<Map<String, dynamic>> stats) {
    for (final s in stats) {
      final total = ((s['mobileRx'] ?? 0) as num) +
          ((s['mobileTx'] ?? 0) as num) +
          ((s['wifiRx'] ?? 0) as num) +
          ((s['wifiTx'] ?? 0) as num);
      // alert if usage exceeds 50MB in one interval
      if (total > 50 * 1024 * 1024) {
        _notifier.notify(
          message: 'Ungewöhnliche Datennutzung: ${s['packageName']}',
          categories: const [],
        );
      }
    }
  }

  /// Aggregates usage for the given day.
  Future<List<Map<String, dynamic>>> dailySummary(DateTime day) async {
    await init();
    final start = DateTime(day.year, day.month, day.day);
    final end = start.add(const Duration(days: 1));
    final Map<String, Map<String, int>> totals = {};
    for (final value in _box!.values) {
      final map = Map<String, dynamic>.from(value as Map);
      final ts = DateTime.parse(map['timestamp'] as String);
      if (ts.isBefore(start) || ts.isAfter(end)) continue;
      for (final stat in map['stats'] as List) {
        final s = Map<String, dynamic>.from(stat as Map);
        final pkg = s['packageName'] as String? ?? 'unknown';
        final data = totals.putIfAbsent(pkg, () => {
          'mobileRx': 0,
          'mobileTx': 0,
          'wifiRx': 0,
          'wifiTx': 0,
        });
        data['mobileRx'] = data['mobileRx']! + (s['mobileRx'] as num? ?? 0).toInt();
        data['mobileTx'] = data['mobileTx']! + (s['mobileTx'] as num? ?? 0).toInt();
        data['wifiRx'] = data['wifiRx']! + (s['wifiRx'] as num? ?? 0).toInt();
        data['wifiTx'] = data['wifiTx']! + (s['wifiTx'] as num? ?? 0).toInt();
      }
    }
    return totals.entries
        .map((e) => {
              'packageName': e.key,
              ...e.value,
            })
        .toList();
  }
}
