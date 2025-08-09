import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';
import 'package:mrs_unkwn_app/core/network/dio_client.dart';
import 'package:mrs_unkwn_app/features/monitoring/data/services/monitoring_sync_service.dart';

class _MockDioClient extends Mock implements DioClient {}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('sync uploads queued records and clears box', () async {
    await Hive.initFlutter();
    await Hive.deleteBoxFromDisk('monitoring_sync_queue');
    final dio = _MockDioClient();
    when(() => dio.post(any(), data: any(named: 'data')))
        .thenAnswer((_) async => {});

    final service = MonitoringSyncService(dio);
    await service.enqueue({'event': 'test'});
    await service.sync();

    final box = await Hive.openBox('monitoring_sync_queue');
    expect(box.isEmpty, isTrue);
    expect(service.status.value, SyncState.success);
  });
}
