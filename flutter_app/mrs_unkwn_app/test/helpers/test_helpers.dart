import 'package:mocktail/mocktail.dart';
import 'package:mrs_unkwn_app/core/di/service_locator.dart';
import 'package:mrs_unkwn_app/core/storage/secure_storage_service.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/models/chat_message.dart';
import 'package:mrs_unkwn_app/features/tutoring/data/models/learning_session.dart';

class MockSecureStorageService extends Mock implements SecureStorageService {}

void setUpTestLocator() {
  if (!sl.isRegistered<SecureStorageService>()) {
    sl.registerLazySingleton<SecureStorageService>(() => MockSecureStorageService());
  }
}

ChatMessage createTestChatMessage({
  String id = 'msg-1',
  ChatRole role = ChatRole.user,
  ChatMessageType type = ChatMessageType.text,
  String content = 'Hallo',
  DateTime? timestamp,
}) {
  return ChatMessage(
    id: id,
    role: role,
    type: type,
    content: content,
    timestamp: timestamp ?? DateTime.now(),
  );
}

LearningSession createTestLearningSession({
  String id = 'session-1',
  DateTime? startedAt,
}) {
  return LearningSession(
    id: id,
    startedAt: startedAt ?? DateTime.now(),
  );
}
