import 'package:get_it/get_it.dart';
import '../services/openai_service.dart';
import '../services/monitoring_service.dart';
import '../services/biometric_service.dart';
import '../network/dio_client.dart';
import '../../platform_channels/device_monitoring.dart';
import '../../features/monitoring/data/services/activity_monitoring_service.dart';
import '../../features/monitoring/data/services/install_monitoring_service.dart';
import '../../features/tutoring/data/services/ai_response_service.dart';
import '../../features/tutoring/data/services/subject_classification_service.dart';
import '../../features/tutoring/data/services/content_moderation_service.dart';
import '../../features/analytics/data/services/learning_analytics_service.dart';
import '../../features/analytics/data/services/analytics_export_service.dart';
import '../storage/secure_storage_service.dart';
import '../../features/tutoring/data/services/chat_history_service.dart';
import '../../features/organization/data/organization_service.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/family/data/repositories/family_repository_impl.dart';
import '../../features/family/data/repositories/family_repository.dart';
import '../../features/family/presentation/bloc/family_bloc.dart';
import '../../features/family/data/services/family_service.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  _registerCore();
  _registerFeatures();
  _registerExternal();
}

void _registerCore() {
  // Register core services here
  sl.registerLazySingleton<SecureStorageService>(() => SecureStorageService());
  sl.registerLazySingleton<MonitoringService>(() => MonitoringService());
  sl.registerLazySingleton<BiometricService>(() => BiometricService());
  sl.registerLazySingleton<DeviceMonitoring>(
      () => const MethodChannelDeviceMonitoring());
  sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
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
  sl.registerLazySingleton<AnalyticsExportService>(
    () => AnalyticsExportService(),
  );
  sl.registerLazySingleton<ChatHistoryService>(
    () => ChatHistoryService(sl()),
  );
  sl.registerLazySingleton<OrganizationService>(
    () => OrganizationService(DioClient()),
  );
  sl.registerLazySingleton<FamilyRepository>(() => FamilyRepositoryImpl());
  sl.registerLazySingleton<FamilyService>(() => FamilyService());
  sl.registerLazySingleton<ActivityMonitoringService>(
    () => ActivityMonitoringService(sl(), DioClient()),
  );
  sl.registerLazySingleton<InstallMonitoringService>(
    () => InstallMonitoringService(sl(), sl()),
  );
  sl.registerFactory<FamilyBloc>(() => FamilyBloc(sl(), sl()));
}

void _registerExternal() {
  // Register external packages and APIs here
  sl.registerLazySingleton<OpenAIService>(() => OpenAIService());
}
