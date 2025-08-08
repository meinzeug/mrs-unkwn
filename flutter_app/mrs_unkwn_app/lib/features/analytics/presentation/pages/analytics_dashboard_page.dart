import 'package:flutter/material.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/services/learning_analytics_service.dart';
import '../../data/services/analytics_export_service.dart';

/// Displays aggregated learning metrics with an export option.
class AnalyticsDashboardPage extends StatelessWidget {
  const AnalyticsDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final analytics = sl<LearningAnalyticsService>();
    final exportService = sl<AnalyticsExportService>();
    final report = analytics.generateReport();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: () {
              final csv = exportService.generateCsv(report);
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Exported CSV'),
                  content: SingleChildScrollView(child: Text(csv)),
                ),
              );
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Learning Velocity: '
              '${report.metrics.learningVelocity.toStringAsFixed(2)} questions/min',
            ),
            const SizedBox(height: 16),
            const Text('Time per Subject:'),
            Expanded(
              child: ListView(
                children: report.metrics.timePerSubject.entries
                    .map(
                      (e) => ListTile(
                        title: Text(e.key),
                        trailing: Text('${e.value.inMinutes} min'),
                      ),
                    )
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
