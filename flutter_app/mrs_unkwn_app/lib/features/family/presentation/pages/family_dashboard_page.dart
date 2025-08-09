import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/permissions/family_permissions.dart';
import '../../../../core/routing/route_constants.dart';
import '../../data/models/family.dart';
import '../bloc/family_bloc.dart';
import 'family_members_page.dart';
import 'family_settings_page.dart';
import 'invite_member_page.dart';
import 'subscription_page.dart';

/// Main overview screen for a family with statistics and quick actions.
class FamilyDashboardPage extends StatefulWidget {
  const FamilyDashboardPage({super.key, required this.familyId, required this.currentUserRole});

  final FamilyRole currentUserRole;


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

  Widget _buildQuickActions(String familyId) {
    final role = widget.currentUserRole;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (FamilyPermissions.hasPermission(
          role,
          FamilyPermission.manageMembers,
        ))
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
        if (FamilyPermissions.hasPermission(
              role,
              FamilyPermission.manageMembers,
            ) ||
            FamilyPermissions.hasPermission(
              role,
              FamilyPermission.viewActivity,
            ))
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<FamilyBloc>(),
                    child: FamilyMembersPage(
                      familyId: familyId,
                      currentUserRole: role,
                    ),
                  ),
                ),
              );
            },
            child: const Text('Mitglieder'),
          ),
        if (FamilyPermissions.hasPermission(
          role,
          FamilyPermission.editSettings,
        ))
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
        if (FamilyPermissions.hasPermission(
          role,
          FamilyPermission.editSettings,
        ))
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (_) => BlocProvider.value(
                    value: context.read<FamilyBloc>(),
                    child: SubscriptionPage(familyId: familyId),
                  ),
                ),
              );
            },
            child: const Text('Abonnement'),
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
