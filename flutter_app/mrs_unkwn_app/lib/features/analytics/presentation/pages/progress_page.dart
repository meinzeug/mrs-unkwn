import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/services/learning_analytics_service.dart';
import '../widgets/progress_chart.dart';

class ProgressPage extends StatelessWidget {
  const ProgressPage({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = sl<LearningAnalyticsService>();
    final report = analytics.generateReport();

    return Scaffold(
      appBar: AppBar(title: const Text('Learning Progress')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            ProgressChart(metrics: report.metrics),
            const SizedBox(height: 24),
            const Text('Achievements:'),
            ...report.achievements.map(
              (a) => ListTile(
                leading: const Icon(Icons.star, color: Colors.amber),
                title: Text(a.title),
                subtitle: Text(a.description),
              ),
            ),
            const SizedBox(height: 24),
            Text('Recommendations: ${report.recommendations}'),
          ],
        ),
      ),
    );
  }
}
