import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_performance/firebase_performance.dart';
import 'package:flutter/foundation.dart';

/// Handles crash reporting, performance monitoring and user feedback.
class MonitoringService {
  final _criticalErrorController = StreamController<String>.broadcast();

  /// Stream of fatal error messages.
  Stream<String> get criticalErrors => _criticalErrorController.stream;

  /// Initialize Firebase and monitoring tools.
  Future<void> init() async {
    await Firebase.initializeApp();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
    FirebasePerformance.instance;
  }

  /// Record an error and optionally flag as fatal.
  Future<void> recordError(
    dynamic error,
    StackTrace stack, {
    bool fatal = false,
  }) async {
    await FirebaseCrashlytics.instance.recordError(
      error,
      stack,
      fatal: fatal,
    );
    if (fatal) {
      _criticalErrorController.add(error.toString());
    }
  }

  /// Log a custom message to Crashlytics.
  void log(String message) {
    FirebaseCrashlytics.instance.log(message);
  }

  /// Associate a user identifier with crash reports.
  Future<void> setUserIdentifier(String id) {
    return FirebaseCrashlytics.instance.setUserIdentifier(id);
  }

  /// Submit user feedback for analysis.
  Future<void> submitUserFeedback(String feedback) async {
    FirebaseCrashlytics.instance.log('USER_FEEDBACK: $feedback');
  }

  /// Clean up resources.
  void dispose() {
    _criticalErrorController.close();
  }
}
