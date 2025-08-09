import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/models/family.dart';
import '../../data/models/update_family_request.dart';
import '../bloc/family_bloc.dart';

/// Page to manage family subscription plans and usage limits.
class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({super.key, required this.familyId});

  final String familyId;

  @override
  State<SubscriptionPage> createState() => _SubscriptionPageState();
}

class _SubscriptionPageState extends State<SubscriptionPage> {
  @override
  void initState() {
    super.initState();
    context.read<FamilyBloc>().add(LoadFamilyRequested(widget.familyId));
  }

  void _changePlan(SubscriptionTier tier) {
    context.read<FamilyBloc>().add(
          UpdateFamilyRequested(
            widget.familyId,
            UpdateFamilyRequest(subscriptionTier: tier),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Abonnement')),
      body: BlocConsumer<FamilyBloc, FamilyState>(
        listener: (context, state) {
          if (state is FamilyError) {
            ScaffoldMessenger.of(context)
                .showSnackBar(SnackBar(content: Text(state.message)));
          }
        },
        builder: (context, state) {
          if (state is FamilyLoading || state is FamilyInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FamilyLoaded) {
            final family = state.family;
            final members = family.members ?? [];
            final childCount =
                members.where((m) => m.role == FamilyRole.child).length;
            final limits = {
              SubscriptionTier.basic: 1,
              SubscriptionTier.family: 4,
              SubscriptionTier.premium: null,
            };

            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Aktueller Plan: ${family.subscriptionTier.name}'),
                const SizedBox(height: 16),
                _buildPlanCard(
                  tier: SubscriptionTier.basic,
                  price: '0€',
                  selected: family.subscriptionTier == SubscriptionTier.basic,
                  childLimit: limits[SubscriptionTier.basic],
                  currentChildren: childCount,
                ),
                const SizedBox(height: 8),
                _buildPlanCard(
                  tier: SubscriptionTier.family,
                  price: '12.99€',
                  selected: family.subscriptionTier == SubscriptionTier.family,
                  childLimit: limits[SubscriptionTier.family],
                  currentChildren: childCount,
                ),
                const SizedBox(height: 8),
                _buildPlanCard(
                  tier: SubscriptionTier.premium,
                  price: '19.99€',
                  selected: family.subscriptionTier == SubscriptionTier.premium,
                  childLimit: limits[SubscriptionTier.premium],
                  currentChildren: childCount,
                ),
                const SizedBox(height: 24),
                const Text('Feature Vergleich'),
                const SizedBox(height: 8),
                _buildComparisonTable(),
                const SizedBox(height: 24),
                const Text(
                  'Zahlungsintegration folgt demnächst.',
                  textAlign: TextAlign.center,
                ),
              ],
            );
          }
          if (state is FamilyError) {
            return Center(child: Text('Fehler: ${state.message}'));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildPlanCard({
    required SubscriptionTier tier,
    required String price,
    required bool selected,
    int? childLimit,
    required int currentChildren,
  }) {
    final overLimit = childLimit != null && currentChildren > childLimit;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(tier.name.toUpperCase(),
                style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Preis: $price'),
            if (childLimit != null)
              Text('Kinderlimit: $childLimit'),
            if (overLimit)
              const Text(
                'Aktuelle Kinderzahl über Limit!',
                style: TextStyle(color: Colors.red),
              ),
            const SizedBox(height: 8),
            ElevatedButton(
              onPressed: selected || overLimit
                  ? null
                  : () => _changePlan(tier),
              child: Text(selected ? 'Aktiv' : 'Plan wählen'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComparisonTable() {
    return Table(
      border: TableBorder.all(color: Colors.grey.shade300),
      columnWidths: const {
        0: FlexColumnWidth(2),
        1: FlexColumnWidth(),
        2: FlexColumnWidth(),
        3: FlexColumnWidth(),
      },
      children: [
        const TableRow(
          decoration: BoxDecoration(color: Color(0xFFE0E0E0)),
          children: [
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Feature', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Basic', textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Family', textAlign: TextAlign.center),
            ),
            Padding(
              padding: EdgeInsets.all(8),
              child: Text('Premium', textAlign: TextAlign.center),
            ),
          ],
        ),
        _featureRow('Mitgliederlimit', '1', '4', 'Unbegrenzt'),
        _featureRow('Screen Time', '✓', '✓', '✓'),
        _featureRow('Analytics', '-', '✓', '✓'),
      ],
    );
  }

  TableRow _featureRow(String feature, String basic, String family, String premium) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.all(8),
          child: Text(feature),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Center(child: Text(basic)),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Center(child: Text(family)),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Center(child: Text(premium)),
        ),
      ],
    );
  }
}

