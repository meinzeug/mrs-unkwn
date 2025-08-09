import 'package:flutter/material.dart';

import '../../../../platform_channels/device_monitoring.dart';

/// Page that guides the user through granting the necessary device
/// monitoring permissions.
class DevicePermissionsPage extends StatefulWidget {
  const DevicePermissionsPage({super.key, DeviceMonitoring? monitoring})
      : _monitoring = monitoring ?? const MethodChannelDeviceMonitoring();

  final DeviceMonitoring _monitoring;

  @override
  State<DevicePermissionsPage> createState() => _DevicePermissionsPageState();
}

class _DevicePermissionsPageState extends State<DevicePermissionsPage> {
  bool _checking = true;
  bool _granted = false;

  @override
  void initState() {
    super.initState();
    _checkStatus();
  }

  Future<void> _checkStatus() async {
    final granted = await widget._monitoring.hasPermission();
    if (mounted) {
      setState(() {
        _granted = granted;
        _checking = false;
      });
    }
  }

  Future<void> _request() async {
    await widget._monitoring.requestPermission();
    await _checkStatus();
  }

  Future<void> _openSettings() async {
    await widget._monitoring.openPermissionSettings();
  }

  @override
  Widget build(BuildContext context) {
    if (_checking) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Device Monitoring Permission')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: _granted ? _buildGranted() : _buildRequest(),
      ),
    );
  }

  Widget _buildRequest() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Mrs-Unkwn benötigt Zugriff auf Nutzungsdaten, um das Lernverhalten '
          'deines Kindes zu analysieren. Bitte gewähre die Berechtigung in den '
          'Systemeinstellungen.',
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _request,
          child: const Text('Berechtigung anfordern'),
        ),
        const SizedBox(height: 12),
        TextButton(
          onPressed: _openSettings,
          child: const Text('Einstellungen öffnen'),
        ),
      ],
    );
  }

  Widget _buildGranted() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Berechtigung erteilt. Gerät wird überwacht.'),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Weiter'),
        ),
      ],
    );
  }
}
