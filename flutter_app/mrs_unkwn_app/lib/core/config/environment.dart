import '../../config/dev_config.dart';
import '../../config/staging_config.dart';
import '../../config/prod_config.dart';

/// Provides access to environment specific configuration values.
abstract class EnvConfig {
  String get apiBaseUrl;
  String get appName;
}

class Environment {
  Environment._();

  static const String dev = 'dev';
  static const String staging = 'staging';
  static const String prod = 'prod';

  static final String _env = const String.fromEnvironment('ENV', defaultValue: dev);

  static EnvConfig get _config {
    switch (_env) {
      case staging:
        return StagingConfig();
      case prod:
        return ProdConfig();
      case dev:
      default:
        return DevConfig();
    }
  }

  /// Base URL for API requests.
  static String get apiBaseUrl => _config.apiBaseUrl;

  /// Whether current environment is production.
  static bool get isProduction => _env == prod;

  /// Name of the application.
  static String get appName => _config.appName;
}
