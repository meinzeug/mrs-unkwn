import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrs_unkwn_app/features/monitoring/data/services/screen_time_tracker.dart';
import 'package:mrs_unkwn_app/platform_channels/device_monitoring.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/services/content_moderation_service.dart';

class _FakeDeviceMonitoring implements DeviceMonitoring {
  int _minutes = 0;

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
  Future<List<Map<String, dynamic>>> getAppUsageStats() async {
    _minutes += 5;
    return [
      {'package': 'app', 'minutes': _minutes},
    ];
  }

  @override
  Future<List<Map<String, dynamic>>> getInstalledApps() async => [];
}

class _FakeNotifier extends ParentNotificationService {
  final List<String> messages = [];

  @override
  Future<void> notify({
    required String message,
    required List<ModerationCategory> categories,
  }) async {
    messages.add(message);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('tracks usage and triggers limit notification', () async {
    await Hive.initFlutter();
    await Hive.deleteBoxFromDisk('screen_time');
    final notifier = _FakeNotifier();
    final tracker = ScreenTimeTracker(_FakeDeviceMonitoring(), notifier);
    tracker.setLimits(total: 8);
    await tracker.init();
    await tracker.collect();
    await tracker.collect();
    final report = await tracker.dailyReport(DateTime.now());
    expect(report['total'], 10);
    expect(notifier.messages.length, 1);
  });
}
