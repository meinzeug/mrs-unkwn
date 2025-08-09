import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../../core/di/service_locator.dart';
import '../../data/models/family.dart';
import '../../data/models/invite_member_request.dart';
import '../../data/repositories/family_repository.dart';
import '../bloc/family_bloc.dart';
import 'qr_invitation_scanner_page.dart';

/// Page for inviting a new member to the family.
class InviteMemberPage extends StatefulWidget {
  const InviteMemberPage({super.key, required this.familyId});

  final String familyId;

  @override
  State<InviteMemberPage> createState() => _InviteMemberPageState();
}

class _InviteMemberPageState extends State<InviteMemberPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  FamilyRole _role = FamilyRole.child;

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    context.read<FamilyBloc>().add(
          InviteMemberRequested(
            InviteMemberRequest(
              familyId: widget.familyId,
              email: _emailCtrl.text,
              role: _role,
            ),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FamilyBloc(sl<FamilyRepository>()),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Mitglied einladen'),
          actions: [
            IconButton(
              icon: const Icon(Icons.qr_code_scanner),
              onPressed: () async {
                final token = await Navigator.of(context).push<String>(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<FamilyBloc>(),
                      child: const QrInvitationScannerPage(),
                    ),
                  ),
                );
                if (token != null) {
                  context
                      .read<FamilyBloc>()
                      .add(AcceptInvitationRequested(token));
                }
              },
            ),
          ],
        ),
        body: BlocConsumer<FamilyBloc, FamilyState>(
          listener: (context, state) {
            if (state is FamilyInvitationSent) {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text('QR-Code Einladung'),
                  content: QrImageView(
                    data: state.token,
                    size: 200,
                  ),
                ),
              );
            } else if (state is FamilyLoaded) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Einladung angenommen')),
              );
            } else if (state is FamilyError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            final loading = state is FamilyLoading;
            return Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailCtrl,
                      decoration: const InputDecoration(labelText: 'E-Mail'),
                      validator: (v) =>
                          v != null && v.contains('@') ? null : 'Ungültige E-Mail',
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<FamilyRole>(
                      value: _role,
                      decoration: const InputDecoration(labelText: 'Rolle'),
                      items: FamilyRole.values
                          .map(
                            (r) => DropdownMenuItem(
                              value: r,
                              child: Text(r.name),
                            ),
                          )
                          .toList(),
                      onChanged: loading ? null : (r) => setState(() => _role = r!),
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: loading ? null : _submit,
                      child: loading
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const Text('Einladen'),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
