import 'package:flutter/foundation.dart';

import 'achievement.dart';
import 'learning_metrics.dart';

@immutable
class LearningReport {
  final LearningMetrics metrics;
  final List<Achievement> achievements;
  final String recommendations;

  const LearningReport({
    required this.metrics,
    required this.achievements,
    this.recommendations = '',
  });
}
