import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Simple logger utility based on [dart:developer].
class Logger {
  const Logger._();

  /// Logs debug messages only in debug builds.
  static void debug(String message) {
    if (!kReleaseMode) {
      developer.log(message, name: 'DEBUG', level: 500);
    }
  }

  /// Logs informational messages.
  static void info(String message) {
    if (!kReleaseMode) {
      developer.log(message, name: 'INFO', level: 800);
    }
  }

  /// Logs warnings.
  static void warning(String message) {
    developer.log(message, name: 'WARNING', level: 900);
  }

  /// Logs errors with optional [error] and [stackTrace].
  static void error(
    String message, [
    Object? error,
    StackTrace? stackTrace,
  ]) {
    developer.log(
      message,
      name: 'ERROR',
      level: 1000,
      error: error,
      stackTrace: stackTrace,
    );
  }
}
