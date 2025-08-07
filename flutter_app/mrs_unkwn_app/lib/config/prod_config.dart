import '../core/config/environment.dart';

/// Production environment configuration values.
class ProdConfig implements EnvConfig {
  @override
  String get apiBaseUrl => 'https://api.mrs-unkwn.com';

  @override
  String get appName => 'Mrs-Unkwn';
}
