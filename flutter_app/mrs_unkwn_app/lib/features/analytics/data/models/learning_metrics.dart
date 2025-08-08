import 'package:flutter/foundation.dart';

@immutable
class LearningMetrics {
  final Map<String, Duration> timePerSubject;
  final Map<String, int> questionsPerSession;
  final double learningVelocity;

  const LearningMetrics({
    required this.timePerSubject,
    required this.questionsPerSession,
    required this.learningVelocity,
  });

  factory LearningMetrics.empty() => const LearningMetrics(
        timePerSubject: {},
        questionsPerSession: {},
        learningVelocity: 0,
      );
}
