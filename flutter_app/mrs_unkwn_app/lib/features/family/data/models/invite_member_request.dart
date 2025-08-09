import 'family.dart';

/// Request model for inviting a family member.
class InviteMemberRequest {
  InviteMemberRequest({
    required this.familyId,
    required this.email,
    required this.role,
  });

  final String familyId;
  final String email;
  final FamilyRole role;

  Map<String, dynamic> toJson() => {
        'familyId': familyId,
        'email': email,
        'role': role.name,
      };
}
