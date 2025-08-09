import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../monitoring/data/services/activity_monitoring_service.dart';
import '../../../monitoring/data/services/monitoring_sync_service.dart';

/// Dashboard für Eltern mit Überblick über Monitoring-Daten.
///
/// Zeigt aktuelle App-Nutzungsstatistiken, reagiert auf Live-Updates
/// durch periodisches Polling und bietet Schnellaktionen sowie ein
/// einfaches Alert-Center.
class MonitoringDashboardPage extends StatefulWidget {
  const MonitoringDashboardPage({super.key});

  @override
  State<MonitoringDashboardPage> createState() => _MonitoringDashboardPageState();
}

class _MonitoringDashboardPageState extends State<MonitoringDashboardPage> {
  final _activity = GetIt.instance<ActivityMonitoringService>();
  final _sync = GetIt.instance<MonitoringSyncService>();

  List<Map<String, dynamic>> _usage = [];
  final ValueNotifier<List<String>> _alerts = ValueNotifier<List<String>>([]);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _loadData();
    // Poll every 10 seconds for new usage data
    _timer = Timer.periodic(const Duration(seconds: 10), (_) => _loadData());
    // listen to sync status for error alerts
    _sync.status.addListener(_handleSyncStatus);
  }

  void _handleSyncStatus() {
    if (_sync.status.value == SyncState.error) {
      _alerts.value = List.from(_alerts.value)..add('Synchronisation fehlgeschlagen');
    }
  }

  Future<void> _loadData() async {
    final data = await _activity.dailySummary(DateTime.now());
    setState(() => _usage = data);
  }

  @override
  void dispose() {
    _timer?.cancel();
    _sync.status.removeListener(_handleSyncStatus);
    super.dispose();
  }

  Future<void> _blockApp(String pkg) async {
    // Placeholder implementation
    _alerts.value = List.from(_alerts.value)..add('App blockiert: $pkg');
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('App $pkg blockiert')));
  }

  Future<void> _setTimeLimit(String pkg) async {
    final limit = await showDialog<Duration>(
      context: context,
      builder: (context) {
        Duration temp = const Duration(hours: 1);
        return AlertDialog(
          title: const Text('Zeitlimit setzen'),
          content: DropdownButton<Duration>(
            value: temp,
            items: const [
              DropdownMenuItem(value: Duration(minutes: 30), child: Text('30 Minuten')),
              DropdownMenuItem(value: Duration(hours: 1), child: Text('1 Stunde')),
              DropdownMenuItem(value: Duration(hours: 2), child: Text('2 Stunden')),
            ],
            onChanged: (val) => temp = val ?? temp,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, temp),
              child: const Text('Speichern'),
            )
          ],
        );
      },
    );
    if (limit != null) {
      _alerts.value = List.from(_alerts.value)
        ..add('Limit für $pkg: ${limit.inMinutes} min');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Limit gesetzt: ${limit.inMinutes} min')),);
    }
  }

  Future<void> _sendMessage() async {
    final msg = await showDialog<String>(
      context: context,
      builder: (context) {
        final controller = TextEditingController();
        return AlertDialog(
          title: const Text('Nachricht senden'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(hintText: 'Nachricht'),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Abbrechen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, controller.text),
              child: const Text('Senden'),
            )
          ],
        );
      },
    );
    if (msg != null && msg.isNotEmpty) {
      _alerts.value = List.from(_alerts.value)..add('Nachricht gesendet: $msg');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nachricht gesendet')),);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monitoring Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.message),
            onPressed: _sendMessage,
            tooltip: 'Nachricht senden',
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: _usage.isEmpty
                ? const Center(child: Text('Keine Nutzungsdaten'))
                : ListView.builder(
                    itemCount: _usage.length,
                    itemBuilder: (context, index) {
                      final item = _usage[index];
                      final pkg = item['package'] as String;
                      final minutes = item['minutes'] as int;
                      return ListTile(
                        title: Text(pkg),
                        subtitle: Text('$minutes Minuten heute'),
                        trailing: PopupMenuButton<String>(
                          onSelected: (value) {
                            if (value == 'block') {
                              _blockApp(pkg);
                            } else if (value == 'limit') {
                              _setTimeLimit(pkg);
                            }
                          },
                          itemBuilder: (context) => const [
                            PopupMenuItem(value: 'block', child: Text('Blockieren')),
                            PopupMenuItem(value: 'limit', child: Text('Zeitlimit')),
                          ],
                        ),
                      );
                    },
                  ),
          ),
          const Divider(),
          Expanded(
            child: ValueListenableBuilder<List<String>>(
              valueListenable: _alerts,
              builder: (context, alerts, _) {
                if (alerts.isEmpty) {
                  return const Center(child: Text('Keine Alerts'));
                }
                return ListView.builder(
                  itemCount: alerts.length,
                  itemBuilder: (context, index) => ListTile(
                    leading: const Icon(Icons.warning, color: Colors.orange),
                    title: Text(alerts[index]),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
