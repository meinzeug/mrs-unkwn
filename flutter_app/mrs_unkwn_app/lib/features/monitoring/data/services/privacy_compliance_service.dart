import 'dart:convert';

import 'package:hive_flutter/hive_flutter.dart';

/// Manages privacy features for monitoring data to ensure DSGVO compliance.
class MonitoringPrivacyService {
  static const _boxName = 'monitoring_privacy';
  static bool _initialized = false;

  Box? _box;

  /// Initialize Hive box for privacy settings.
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

  /// Returns whether the user has granted monitoring consent.
  Future<bool> hasConsent() async {
    await init();
    return (_box?.get('consent') ?? false) as bool;
  }

  /// Stores the consent flag.
  Future<void> setConsent(bool value) async {
    await init();
    await _box?.put('consent', value);
  }

  /// Removes monitoring data older than [retention] duration.
  Future<void> purgeOldData(Duration retention) async {
    await init();
    final cutoff = DateTime.now().subtract(retention);
    final boxes = <String>[
      'app_usage_records',
      'screen_time_records',
      'install_history',
      'network_usage_records',
      'location_records',
    ];
    for (final name in boxes) {
      if (Hive.isBoxOpen(name)) {
        final box = Hive.box(name);
        final keysToDelete = <dynamic>[];
        for (final key in box.keys) {
          final value = box.get(key);
          if (value is Map && value['timestamp'] is String) {
            final ts = DateTime.tryParse(value['timestamp'] as String);
            if (ts == null || ts.isBefore(cutoff)) {
              keysToDelete.add(key);
            }
          }
        }
        await box.deleteAll(keysToDelete);
      }
    }
  }

  /// Exports all monitoring data as JSON string.
  Future<String> exportData() async {
    await init();
    final boxes = <String>[
      'app_usage_records',
      'screen_time_records',
      'install_history',
      'network_usage_records',
      'location_records',
    ];
    final export = <String, List<Map<String, dynamic>>>{};
    for (final name in boxes) {
      if (Hive.isBoxOpen(name)) {
        final box = Hive.box(name);
        export[name] =
            box.values.map((e) => Map<String, dynamic>.from(e as Map)).toList();
      }
    }
    return jsonEncode(export);
  }

  /// Deletes all stored monitoring data immediately.
  Future<void> deleteAllData() async {
    await init();
    final boxes = <String>[
      'app_usage_records',
      'screen_time_records',
      'install_history',
      'network_usage_records',
      'location_records',
    ];
    for (final name in boxes) {
      if (Hive.isBoxOpen(name)) {
        await Hive.box(name).clear();
      }
    }
  }
}
