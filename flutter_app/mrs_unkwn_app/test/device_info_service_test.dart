import 'package:battery_plus/battery_plus.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mrs_unkwn_app/features/monitoring/data/services/device_info_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('saveCurrent stores device snapshot', () async {
    await Hive.initFlutter();
    await Hive.deleteBoxFromDisk('device_info_records');
    final service = DeviceInfoService(
      deviceInfo: () async => {'model': 't', 'os': '1'},
      batteryLevel: () async => 80,
      batteryState: () async => BatteryState.charging,
      freeDisk: () async => 10,
      totalDisk: () async => 100,
      readMemInfo: () async => ['MemTotal: 2048 kB', 'MemAvailable: 1024 kB'],
    );
    await service.saveCurrent();
    final latest = await service.latest();
    expect(latest?['batteryLevel'], 80);
    expect(latest?['ramTotal'], 2);
  });
}
