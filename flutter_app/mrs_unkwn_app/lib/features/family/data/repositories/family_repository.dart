import '../models/family.dart';
import '../models/create_family_request.dart';
import '../models/update_family_request.dart';
import '../models/invite_member_request.dart';

/// Abstract contract for family data operations.
abstract class FamilyRepository {
  /// Creates a new family using [request].
  Future<Family> createFamily(CreateFamilyRequest request);

  /// Retrieves a family by its identifier [familyId].
  Future<Family> getFamily(String familyId);

  /// Updates an existing family with [familyId] using [request].
  Future<Family> updateFamily(String familyId, UpdateFamilyRequest request);

  /// Deletes the family with [familyId].
  Future<void> deleteFamily(String familyId);

  /// Sends an invitation to join a family and returns the invitation token.
  Future<String> inviteMember(InviteMemberRequest request);

  /// Accepts an invitation token and returns the updated family.
  Future<Family> acceptInvitation(String token);
}
