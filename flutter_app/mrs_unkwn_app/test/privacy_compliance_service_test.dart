import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'package:mrs_unkwn_app/features/monitoring/data/services/privacy_compliance_service.dart';

void main() {
  setUp(() async {
    TestWidgetsFlutterBinding.ensureInitialized();
    await Hive.initFlutter();
    GetIt.I.reset();
    GetIt.I.registerLazySingleton<MonitoringPrivacyService>(
      () => MonitoringPrivacyService(),
    );
  });

  tearDown(() async {
    await Hive.deleteFromDisk();
    GetIt.I.reset();
  });

  test('consent flag persists', () async {
    final service = GetIt.I<MonitoringPrivacyService>();
    await service.setConsent(true);
    expect(await service.hasConsent(), isTrue);
    await service.setConsent(false);
    expect(await service.hasConsent(), isFalse);
  });

  test('export returns json', () async {
    final service = GetIt.I<MonitoringPrivacyService>();
    final json = await service.exportData();
    expect(json, isA<String>());
  });
}
