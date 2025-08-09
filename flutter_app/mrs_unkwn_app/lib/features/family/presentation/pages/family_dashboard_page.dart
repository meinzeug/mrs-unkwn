import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/routing/route_constants.dart';
import '../../data/models/family.dart';
import '../bloc/family_bloc.dart';
import 'family_members_page.dart';
import 'family_settings_page.dart';
import 'invite_member_page.dart';

/// Main overview screen for a family with statistics and quick actions.
class FamilyDashboardPage extends StatefulWidget {
  const FamilyDashboardPage({super.key, required this.familyId});

  final String familyId;

  @override
  State<FamilyDashboardPage> createState() => _FamilyDashboardPageState();
}

class _FamilyDashboardPageState extends State<FamilyDashboardPage> {
  @override
  void initState() {
    super.initState();
    context.read<FamilyBloc>().add(LoadFamilyRequested(widget.familyId));
  }

  Future<void> _refresh() async {
    context.read<FamilyBloc>().add(LoadFamilyRequested(widget.familyId));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Family Dashboard')),
      body: BlocBuilder<FamilyBloc, FamilyState>(
        builder: (context, state) {
          if (state is FamilyLoading || state is FamilyInitial) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FamilyLoaded) {
            final family = state.family;
            final members = family.members ?? [];
            final activeMembers = members.length; // Placeholder

            return RefreshIndicator(
              onRefresh: _refresh,
              child: SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildStatsCard(members.length, activeMembers),
                    const SizedBox(height: 16),
                    _buildQuickActions(family.id),
                    const SizedBox(height: 16),
                    _buildProgressCharts(),
                    const SizedBox(height: 16),
                    _buildActivityFeed(),
                  ],
                ),
              ),
            );
          }
          if (state is FamilyError) {
            return Center(child: Text('Fehler: \'${state.message}\''));
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }

  Widget _buildStatsCard(int totalMembers, int activeMembers) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStatItem('Mitglieder', '$totalMembers'),
            _buildStatItem('Aktiv', '$activeMembers'),
            _buildStatItem('Lernzeit', '0h'),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Column(
      children: [
        Text(value, style: Theme.of(context).textTheme.headlineSmall),
        Text(label),
      ],
    );
  }

  Widget _buildQuickActions(String familyId) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<FamilyBloc>(),
                  child: InviteMemberPage(familyId: familyId),
                ),
              ),
            );
          },
          child: const Text('Einladen'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<FamilyBloc>(),
                  child: FamilyMembersPage(
                    familyId: familyId,
                    currentUserRole: FamilyRole.parent,
                  ),
                ),
              ),
            );
          },
          child: const Text('Mitglieder'),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => BlocProvider.value(
                  value: context.read<FamilyBloc>(),
                  child: FamilySettingsPage(familyId: familyId),
                ),
              ),
            );
          },
          child: const Text('Einstellungen'),
        ),
      ],
    );
  }

  Widget _buildProgressCharts() {
    return Card(
      child: SizedBox(
        height: 150,
        child: Center(
          child: Text(
            'Progress Charts',
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
      ),
    );
  }

  Widget _buildActivityFeed() {
    return Card(
      child: SizedBox(
        height: 200,
        child: ListView(
          physics: const NeverScrollableScrollPhysics(),
          children: const [
            ListTile(title: Text('Keine Aktivitäten')), // Placeholder
          ],
        ),
      ),
    );
  }
}
