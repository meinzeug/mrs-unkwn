import 'package:flutter/material.dart';

import '../../data/models/learning_metrics.dart';

/// Simple textual visualization of learning metrics.
class ProgressChart extends StatelessWidget {
  const ProgressChart({super.key, required this.metrics});

  final LearningMetrics metrics;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Time per subject:'),
        ...metrics.timePerSubject.entries.map(
          (e) => Text('${e.key}: ${e.value.inMinutes} min'),
        ),
        const SizedBox(height: 16),
        const Text('Questions per session:'),
        ...metrics.questionsPerSession.entries.map(
          (e) => Text('${e.key}: ${e.value}'),
        ),
        const SizedBox(height: 16),
        Text(
          'Learning velocity: '
          '${metrics.learningVelocity.toStringAsFixed(2)} questions/min',
        ),
      ],
    );
  }
}
