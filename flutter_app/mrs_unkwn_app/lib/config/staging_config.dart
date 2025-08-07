import '../core/config/environment.dart';

/// Staging environment configuration values.
class StagingConfig implements EnvConfig {
  @override
  String get apiBaseUrl => 'https://staging.api.mrs-unkwn.com';

  @override
  String get appName => 'Mrs-Unkwn Staging';
}
