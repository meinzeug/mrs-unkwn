import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrs_unkwn_app/core/network/dio_client.dart';
import 'package:mrs_unkwn_app/features/monitoring/data/services/activity_monitoring_service.dart';
import 'package:mrs_unkwn_app/platform_channels/device_monitoring.dart';

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
  Future<List<Map<String, dynamic>>> getAppUsageStats() async => [
        {'package': 'app', 'minutes': 10},
      ];

  @override
  Future<List<Map<String, dynamic>>> getInstalledApps() async => [];

  @override
  Future<List<Map<String, dynamic>>> getNetworkUsageStats() async => [];

  @override
  Stream<AppChangeEvent> get onAppChange => const Stream.empty();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('collectOnce stores data and aggregates daily summary', () async {
    await Hive.initFlutter();
    await Hive.deleteBoxFromDisk('app_usage_records');
    final service =
        ActivityMonitoringService(_FakeDeviceMonitoring(), DioClient());
    await service.init();
    await service.collectOnce();
    final summary = await service.dailySummary(DateTime.now());
    expect(summary.first['minutes'], 10);
  });

  test('data is stored compressed', () async {
    await Hive.initFlutter();
    await Hive.deleteBoxFromDisk('app_usage_records');
    final service =
        ActivityMonitoringService(_FakeDeviceMonitoring(), DioClient());
    await service.init();
    await service.collectOnce();
    final box = Hive.box('app_usage_records');
    final record = Map<String, dynamic>.from(box.getAt(0) as Map);
    final encoded = record['stats'] as String;
    final decoded =
        jsonDecode(utf8.decode(gzip.decode(base64Decode(encoded)))) as List;
    expect(decoded.first['minutes'], 10);
  });
}
