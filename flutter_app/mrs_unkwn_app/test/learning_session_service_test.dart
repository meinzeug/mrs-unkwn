import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mocktail/mocktail.dart';

import 'helpers/test_helpers.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/services/learning_session_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late MockSecureStorageService secureStorage;
  late LearningSessionService service;

  setUp(() async {
    await Hive.initFlutter();
    await Hive.deleteBoxFromDisk('learning_sessions');
    secureStorage = MockSecureStorageService();
    when(() => secureStorage.read(any())).thenAnswer((_) async => null);
    when(() => secureStorage.store(any(), any())).thenAnswer((_) async {});
    service = LearningSessionService(secureStorage);
  });

  test('startSession persists new session', () async {
    final session = await service.startSession();
    final fetched = await service.getSession(session.id);
    expect(fetched?.id, session.id);
    expect(fetched?.questionCount, 0);
  });

  test('unsyncedSessions filters sessions needing sync', () async {
    final session = await service.startSession();
    var unsynced = await service.unsyncedSessions();
    expect(unsynced.length, 1);
    await service.updateSession(session.markSynced());
    unsynced = await service.unsyncedSessions();
    expect(unsynced.isEmpty, true);
  });
}
