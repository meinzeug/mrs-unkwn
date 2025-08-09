import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrs_unkwn_app/features/monitoring/data/services/install_monitoring_service.dart';
import 'package:mrs_unkwn_app/platform_channels/device_monitoring.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/services/content_moderation_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('records app installation events', () async {
    await Hive.initFlutter();
    await Hive.deleteBoxFromDisk('app_install_history');
    final monitoring = MockDeviceMonitoring();
    final service =
        InstallMonitoringService(monitoring, ParentNotificationService());
    await service.start();
    monitoring.emitAppChange(
        AppChangeEvent(packageName: 'com.example.app', type: 'added'));
    await Future.delayed(const Duration(milliseconds: 10));
    expect(service.history.first['package'], 'com.example.app');
    await service.stop();
  });
}
