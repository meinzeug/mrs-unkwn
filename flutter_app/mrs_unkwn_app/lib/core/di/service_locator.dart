import 'package:get_it/get_it.dart';
import '../services/openai_service.dart';
import '../../features/tutoring/data/services/ai_response_service.dart';
import '../../features/tutoring/data/services/subject_classification_service.dart';
import '../../features/tutoring/data/services/content_moderation_service.dart';
import '../../features/analytics/data/services/learning_analytics_service.dart';
import '../storage/secure_storage_service.dart';
import '../../features/tutoring/data/services/chat_history_service.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  _registerCore();
  _registerFeatures();
  _registerExternal();
}

void _registerCore() {
  // Register core services here
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
}

void _registerFeatures() {
  // Register feature-specific services here
  sl.registerLazySingleton<AIResponseService>(
    () => AIResponseService(openAI: sl()),
  );
  sl.registerLazySingleton<SubjectClassificationService>(
    () => SubjectClassificationService(),
  );
  sl.registerLazySingleton<ContentModerationService>(
    () => ContentModerationService(),
  );
  sl.registerLazySingleton<ModerationLogService>(
    () => ModerationLogService(),
  );
  sl.registerLazySingleton<ParentNotificationService>(
    () => ParentNotificationService(),
  );
  sl.registerLazySingleton<LearningAnalyticsService>(
    () => LearningAnalyticsService(),
  );
  sl.registerLazySingleton<ChatHistoryService>(
    () => ChatHistoryService(sl()),
  );
}

void _registerExternal() {
  // Register external packages and APIs here
  sl.registerLazySingleton<OpenAIService>(() => OpenAIService());
}
