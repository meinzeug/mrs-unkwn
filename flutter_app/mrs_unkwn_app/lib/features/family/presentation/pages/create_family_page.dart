import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/repositories/family_repository.dart';
import '../../data/models/create_family_request.dart';

/// Multi-step wizard for creating a new family.
class CreateFamilyPage extends StatefulWidget {
  const CreateFamilyPage({super.key});

  @override
  State<CreateFamilyPage> createState() => _CreateFamilyPageState();
}

class _CreateFamilyPageState extends State<CreateFamilyPage> {
  final PageController _controller = PageController();
  final _nameKey = GlobalKey<FormState>();
  final TextEditingController _nameCtrl = TextEditingController();
  int _step = 0;
  bool _isSubmitting = false;

  void _next() {
    if (_step == 0 && !(_nameKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _step++);
    _controller.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _previous() {
    if (_step == 0) return;
    setState(() => _step--);
    _controller.previousPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _createFamily() async {
    setState(() => _isSubmitting = true);
    try {
      final repo = sl<FamilyRepository>();
      await repo.createFamily(
        CreateFamilyRequest(name: _nameCtrl.text),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Familie erfolgreich erstellt')),
      );
      context.go('/home');
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Fehler: $e')),
      );
    } finally {
      if (mounted) {
        setState(() => _isSubmitting = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Familie erstellen')),
      body: Column(
        children: [
          LinearProgressIndicator(value: (_step + 1) / 4),
          Expanded(
            child: PageView(
              controller: _controller,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                _buildNameStep(),
                _buildRulesStep(),
                _buildPlanStep(),
                _buildSummaryStep(),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (_step > 0)
                  OutlinedButton(
                    onPressed: _isSubmitting ? null : _previous,
                    child: const Text('Zurück'),
                  ),
                if (_step < 3)
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _next,
                    child: const Text('Weiter'),
                  )
                else
                  ElevatedButton(
                    onPressed: _isSubmitting ? null : _createFamily,
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Text('Erstellen'),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNameStep() {
    return Form(
      key: _nameKey,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Familienname'),
            TextFormField(
              controller: _nameCtrl,
              decoration: const InputDecoration(hintText: 'z.B. Familie Müller'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Name erforderlich';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRulesStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text('Regeln festlegen'),
          SizedBox(height: 8),
          Text('Einfache Platzhalter für Studienzeiten und Schlafenszeit.'),
        ],
      ),
    );
  }

  Widget _buildPlanStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Abonnement wählen'),
          const SizedBox(height: 8),
          RadioListTile<String>(
            title: const Text('Basic (kostenlos)'),
            value: 'basic',
            groupValue: 'basic',
            onChanged: (_) {},
          ),
          RadioListTile<String>(
            title: const Text('Family (€12.99)'),
            value: 'family',
            groupValue: 'basic',
            onChanged: (_) {},
          ),
          RadioListTile<String>(
            title: const Text('Premium (€19.99)'),
            value: 'premium',
            groupValue: 'basic',
            onChanged: (_) {},
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryStep() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Zusammenfassung'),
          const SizedBox(height: 8),
          Text('Name: ${_nameCtrl.text}'),
          const Text('Plan: Basic'),
          const SizedBox(height: 16),
          const Text('Überprüfe deine Eingaben, bevor du fortfährst.'),
        ],
      ),
    );
  }
}

