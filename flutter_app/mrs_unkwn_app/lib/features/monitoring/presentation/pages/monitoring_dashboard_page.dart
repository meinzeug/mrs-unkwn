import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../../core/services/monitoring_service.dart';

/// Simple dashboard that lists critical errors and allows user feedback.
class MonitoringDashboardPage extends StatelessWidget {
  const MonitoringDashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    final monitoring = GetIt.instance<MonitoringService>();
    return Scaffold(
      appBar: AppBar(title: const Text('Monitoring Dashboard')),
      body: StreamBuilder<String>(
        stream: monitoring.criticalErrors,
        builder: (context, snapshot) {
          final errors = <String>[];
          if (snapshot.hasData) errors.add(snapshot.data!);
          if (errors.isEmpty) {
            return const Center(child: Text('No critical errors reported'));
          }
          return ListView.builder(
            itemCount: errors.length,
            itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.error, color: Colors.red),
              title: Text(errors[index]),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final feedback = await showDialog<String>(
            context: context,
            builder: (_) => const _FeedbackDialog(),
          );
          if (feedback != null && feedback.isNotEmpty) {
            monitoring.submitUserFeedback(feedback);
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Feedback gesendet')),
            );
          }
        },
        child: const Icon(Icons.feedback),
      ),
    );
  }
}

class _FeedbackDialog extends StatefulWidget {
  const _FeedbackDialog();

  @override
  State<_FeedbackDialog> createState() => _FeedbackDialogState();
}

class _FeedbackDialogState extends State<_FeedbackDialog> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Feedback'),
      content: TextField(
        controller: controller,
        maxLines: 3,
        decoration: const InputDecoration(hintText: 'Dein Feedback'),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Abbrechen'),
        ),
        ElevatedButton(
          onPressed: () => Navigator.pop(context, controller.text),
          child: const Text('Senden'),
        ),
      ],
    );
  }
}
