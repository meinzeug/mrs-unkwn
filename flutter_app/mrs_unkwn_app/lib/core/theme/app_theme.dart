import 'package:flutter/material.dart';

/// Provides application theme configurations.
class AppTheme {
  const AppTheme._();

  /// Default light theme for the app.
  static ThemeData get light => ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      );
}
