import '../core/config/environment.dart';

/// Development environment configuration values.
class DevConfig implements EnvConfig {
  @override
  String get apiBaseUrl => 'https://dev.api.mrs-unkwn.com';

  @override
  String get appName => 'Mrs-Unkwn Dev';
}
