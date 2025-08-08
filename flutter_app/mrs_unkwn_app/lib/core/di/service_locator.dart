import 'package:get_it/get_it.dart';
import '../services/openai_service.dart';

final sl = GetIt.instance;

Future<void> configureDependencies() async {
  _registerCore();
  _registerFeatures();
  _registerExternal();
}

void _registerCore() {
  // Register core services here
}

void _registerFeatures() {
  // Register feature-specific services here
}

void _registerExternal() {
  // Register external packages and APIs here
  sl.registerLazySingleton<OpenAIService>(() => OpenAIService());
}
