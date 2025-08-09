import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/family_settings.dart';
import '../bloc/family_bloc.dart';

class FamilySettingsPage extends StatefulWidget {
  const FamilySettingsPage({super.key, required this.familyId});

  final String familyId;

  @override
  State<FamilySettingsPage> createState() => _FamilySettingsPageState();
}

class _FamilySettingsPageState extends State<FamilySettingsPage> {
  bool _studyRules = false;
  double _screenTime = 0;
  TimeOfDay _bedtime = const TimeOfDay(hour: 21, minute: 0);
  final TextEditingController _appController = TextEditingController();
  List<String> _restrictedApps = [];

  @override
  void initState() {
    super.initState();
    context
        .read<FamilyBloc>()
        .add(LoadFamilySettingsRequested(widget.familyId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Family Settings')),
      body: BlocConsumer<FamilyBloc, FamilyState>(
        listener: (context, state) {
          if (state is FamilySettingsLoaded) {
            final s = state.settings;
            _studyRules = s.studyRulesEnabled;
            _screenTime = s.screenTimeLimitMinutes.toDouble();
            _bedtime = TimeOfDay(hour: s.bedtimeHour, minute: s.bedtimeMinute);
            _restrictedApps = List.from(s.restrictedApps);
          }
        },
        builder: (context, state) {
          if (state is FamilyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FamilySettingsLoaded) {
            return _buildForm();
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildForm() {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SwitchListTile(
          title: const Text('Enable Study Rules'),
          value: _studyRules,
          onChanged: (v) => setState(() => _studyRules = v),
        ),
        ListTile(
          title: const Text('Screen Time Limit (min)'),
          subtitle: Slider(
            value: _screenTime,
            min: 0,
            max: 600,
            divisions: 60,
            label: _screenTime.round().toString(),
            onChanged: (v) => setState(() => _screenTime = v),
          ),
        ),
        ListTile(
          title: const Text('Bedtime'),
          subtitle: Text(_bedtime.format(context)),
          onTap: () async {
            final picked = await showTimePicker(
              context: context,
              initialTime: _bedtime,
            );
            if (picked != null) {
              setState(() => _bedtime = picked);
            }
          },
        ),
        TextField(
          controller: _appController,
          decoration: const InputDecoration(
            labelText: 'Restricted App',
            suffixIcon: Icon(Icons.add),
          ),
          onSubmitted: (val) {
            if (val.isEmpty) return;
            setState(() {
              _restrictedApps.add(val);
              _appController.clear();
            });
          },
        ),
        Wrap(
          spacing: 8,
          children: _restrictedApps
              .map((app) => Chip(
                    label: Text(app),
                    onDeleted: () => setState(() => _restrictedApps.remove(app)),
                  ))
              .toList(),
        ),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: _save,
          child: const Text('Save'),
        )
      ],
    );
  }

  void _save() {
    final settings = FamilySettings(
      studyRulesEnabled: _studyRules,
      screenTimeLimitMinutes: _screenTime.round(),
      bedtimeHour: _bedtime.hour,
      bedtimeMinute: _bedtime.minute,
      restrictedApps: _restrictedApps,
    );
    context
        .read<FamilyBloc>()
        .add(UpdateFamilySettingsRequested(widget.familyId, settings));
  }
}
