import 'package:flutter/foundation.dart';

/// Application-wide constant values.
class AppConstants {
  const AppConstants._();

  /// Display name of the application.
  static const String appName = 'Mrs-Unkwn';

  /// Current application version.
  static const String version = '0.1.0';

  /// Base URL for API requests.
  static const String apiBaseUrl = kDebugMode
      ? 'https://api-dev.mrsunkwn.com'
      : 'https://api.mrsunkwn.com';
}
