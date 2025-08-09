import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/permissions/family_permissions.dart';

import '../../data/models/family.dart';
import '../bloc/family_bloc.dart';

/// Displays and manages family members.
class FamilyMembersPage extends StatelessWidget {
  const FamilyMembersPage({
    super.key,
    required this.familyId,
    required this.currentUserRole,
  });

  final String familyId;
  final FamilyRole currentUserRole;

  bool get _canManage => FamilyPermissions.hasPermission(currentUserRole, FamilyPermission.manageMembers);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Familienmitglieder')),
      body: BlocBuilder<FamilyBloc, FamilyState>(
        builder: (context, state) {
          if (state is FamilyInitial) {
            context.read<FamilyBloc>().add(LoadFamilyRequested(familyId));
          }
          if (state is FamilyLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is FamilyLoaded) {
            final members = state.family.members ?? [];
            if (members.isEmpty) {
              return const Center(child: Text('Keine Mitglieder'));
            }
            return RefreshIndicator(
              onRefresh: () async {
                context
                    .read<FamilyBloc>()
                    .add(LoadFamilyRequested(familyId));
              },
              child: ListView.builder(
                itemCount: members.length,
                itemBuilder: (context, index) {
                  final member = members[index];
                  return ListTile(
                    title: Text(member.userId),
                    subtitle: Text(member.role.name),
                    trailing: _buildActions(context, member),
                  );
                },
              ),
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

  Widget _buildActions(BuildContext context, FamilyMember member) {
    if (!_canManage) return const SizedBox.shrink();
    return PopupMenuButton<String>(
      onSelected: (value) {
        switch (value) {
          case 'role':
            _changeRole(context, member);
            break;
          case 'permissions':
            _editPermissions(context, member);
            break;
          case 'remove':
            _removeMember(context, member);
            break;
        }
      },
      itemBuilder: (context) => const [
        PopupMenuItem(value: 'role', child: Text('Rolle ändern')),
        PopupMenuItem(value: 'permissions', child: Text('Rechte bearbeiten')),
        PopupMenuItem(value: 'remove', child: Text('Entfernen')),
      ],
    );
  }

  Future<void> _changeRole(BuildContext context, FamilyMember member) async {
    final role = await showDialog<FamilyRole>(
      context: context,
      builder: (context) => SimpleDialog(
        title: const Text('Rolle auswählen'),
        children: FamilyRole.values.map((r) {
          return RadioListTile<FamilyRole>(
            title: Text(r.name),
            value: r,
            groupValue: member.role,
            onChanged: (value) => Navigator.pop(context, value),
          );
        }).toList(),
      ),
    );
    if (role != null && role != member.role) {
      context.read<FamilyBloc>().add(
            ChangeMemberRoleRequested(familyId, member.userId, role),
          );
    }
  }

  Future<void> _editPermissions(
    BuildContext context,
    FamilyMember member,
  ) async {
    final controller = TextEditingController(
      text: (member.permissions ?? []).join(','),
    );
    final result = await showDialog<List<String>>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Rechte bearbeiten'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'comma,separated,permissions',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(
              context,
              controller.text
                  .split(',')
                  .map((e) => e.trim())
                  .where((e) => e.isNotEmpty)
                  .toList(),
            ),
            child: const Text('Speichern'),
          ),
        ],
      ),
    );
    if (result != null) {
      context.read<FamilyBloc>().add(
            UpdateMemberPermissionsRequested(
              familyId,
              member.userId,
              result,
            ),
          );
    }
  }

  Future<void> _removeMember(
    BuildContext context,
    FamilyMember member,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Mitglied entfernen?'),
        content: Text('Soll ${member.userId} wirklich entfernt werden?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Abbrechen'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Entfernen'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      context.read<FamilyBloc>().add(
            RemoveMemberRequested(familyId, member.userId),
          );
    }
  }
}
