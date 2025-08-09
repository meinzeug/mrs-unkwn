import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrs_unkwn_app/features/monitoring/data/services/network_activity_service.dart';
import 'package:mrs_unkwn_app/platform_channels/device_monitoring.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/services/content_moderation_service.dart';

class _FakeDeviceMonitoring implements DeviceMonitoring {
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
  Future<List<Map<String, dynamic>>> getNetworkUsageStats() async => [
        {
          'packageName': 'app',
          'mobileRx': 60 * 1024 * 1024,
          'mobileTx': 0,
          'wifiRx': 0,
          'wifiTx': 0,
        }
      ];

  @override
  Stream<AppChangeEvent> get onAppChange => const Stream.empty();
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

  test('collect stores data and triggers alert', () async {
    await Hive.initFlutter();
    await Hive.deleteBoxFromDisk('network_activity');
    final notifier = _FakeNotifier();
    final service = NetworkActivityService(_FakeDeviceMonitoring(), notifier);
    await service.init();
    await service.collect();
    final summary = await service.dailySummary(DateTime.now());
    expect(summary.isNotEmpty, true);
    expect(notifier.messages.length, 1);
  });
}
