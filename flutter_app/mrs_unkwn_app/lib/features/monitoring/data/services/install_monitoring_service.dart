import 'dart:async';

import 'package:hive_flutter/hive_flutter.dart';

import '../../../../platform_channels/device_monitoring.dart';
import '../../../../core/utils/logger.dart';
import '../../../tutoring/data/services/content_moderation_service.dart';

/// Listens to native app installation events and stores a history.
class InstallMonitoringService {
  InstallMonitoringService(this._deviceMonitoring, this._notifier);

  final DeviceMonitoring _deviceMonitoring;
  final ParentNotificationService _notifier;

  static const _boxName = 'app_install_history';
  static bool _initialized = false;
  Box? _box;
  StreamSubscription<AppChangeEvent>? _sub;

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

  /// Starts listening to installation/uninstallation events.
  Future<void> start() async {
    await init();
    _sub = _deviceMonitoring.onAppChange.listen(
      _handleEvent,
      onError: (e, stack) => Logger.error('onAppChange error: $e', e, stack),
    );
  }

  /// Stops listening to native events.
  Future<void> stop() async {
    await _sub?.cancel();
  }

  Future<void> _handleEvent(AppChangeEvent event) async {
    final record = {
      'package': event.packageName,
      'type': event.type,
      'replacing': event.replacing,
      'timestamp': DateTime.now().toIso8601String(),
    };
    await _box?.add(record);
    if (event.type == 'added') {
      await _notifier.notify(
        message: 'Neue App installiert: ${event.packageName}',
        categories: const [],
      );
      // Placeholder for approval workflow for restricted accounts.
    }
  }

  /// Returns the stored installation history.
  List<Map<String, dynamic>> get history =>
      _box?.values.map((e) => Map<String, dynamic>.from(e as Map)).toList() ?? [];
}

