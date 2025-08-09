import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../../../monitoring/data/services/privacy_compliance_service.dart';

/// Allows parents to manage consent and privacy settings
/// for monitoring features.
class PrivacySettingsPage extends StatefulWidget {
  const PrivacySettingsPage({super.key});

  @override
  State<PrivacySettingsPage> createState() => _PrivacySettingsPageState();
}

class _PrivacySettingsPageState extends State<PrivacySettingsPage> {
  final _privacy = GetIt.instance<MonitoringPrivacyService>();
  bool _consent = false;
  final _retentionCtrl = TextEditingController(text: '30');

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final value = await _privacy.hasConsent();
    setState(() => _consent = value);
  }

  Future<void> _exportData() async {
    final json = await _privacy.exportData();
    if (!mounted) return;
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Exportierte Daten'),
        content: SingleChildScrollView(child: Text(json)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Schließen'),
          ),
        ],
      ),
    );
  }

  Future<void> _deleteData() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Alle Daten löschen?'),
        content: const Text('Dies entfernt sämtliche Monitoring-Daten.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Löschen'),
          ),
        ],
      ),
    );
    if (confirm == true) {
      await _privacy.deleteAllData();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Daten gelöscht')),
      );
    }
  }

  Future<void> _purgeOld() async {
    final days = int.tryParse(_retentionCtrl.text) ?? 30;
    await _privacy.purgeOldData(Duration(days: days));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Alte Daten bereinigt')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Privatsphäre')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile(
            value: _consent,
            title: const Text('Monitoring erlauben'),
            subtitle: const Text('Erfordert Zustimmung des Kindes/Elternteils'),
            onChanged: (val) async {
              await _privacy.setConsent(val);
              setState(() => _consent = val);
            },
          ),
          const SizedBox(height: 16),
          TextField(
            controller: _retentionCtrl,
            decoration: const InputDecoration(
              labelText: 'Aufbewahrungsdauer in Tagen',
              border: OutlineInputBorder(),
            ),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 8),
          ElevatedButton(
            onPressed: _purgeOld,
            child: const Text('Alte Daten löschen'),
          ),
          const Divider(height: 32),
          ElevatedButton.icon(
            onPressed: _exportData,
            icon: const Icon(Icons.download),
            label: const Text('Daten exportieren'),
          ),
          const SizedBox(height: 8),
          ElevatedButton.icon(
            onPressed: _deleteData,
            icon: const Icon(Icons.delete),
            label: const Text('Alle Daten löschen'),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _retentionCtrl.dispose();
    super.dispose();
  }
}
