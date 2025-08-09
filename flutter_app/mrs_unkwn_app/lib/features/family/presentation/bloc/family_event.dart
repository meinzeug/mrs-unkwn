part of 'family_bloc.dart';

/// Base event for [FamilyBloc].
abstract class FamilyEvent extends BaseEvent {
  const FamilyEvent();
}

/// Event to create a new family.
class CreateFamilyRequested extends FamilyEvent {
  const CreateFamilyRequested(this.request);

  final CreateFamilyRequest request;
}

/// Event to load family details by [familyId].
class LoadFamilyRequested extends FamilyEvent {
  const LoadFamilyRequested(this.familyId);

  final String familyId;
}

/// Event to update a family.
class UpdateFamilyRequested extends FamilyEvent {
  const UpdateFamilyRequested(this.familyId, this.request);

  final String familyId;
  final UpdateFamilyRequest request;
}

/// Event to delete a family.
class DeleteFamilyRequested extends FamilyEvent {
  const DeleteFamilyRequested(this.familyId);

  final String familyId;
}

/// Event to invite a new member to a family.
class InviteMemberRequested extends FamilyEvent {
  const InviteMemberRequested(this.request);

  final InviteMemberRequest request;
}

/// Event to accept an invitation token.
class AcceptInvitationRequested extends FamilyEvent {
  const AcceptInvitationRequested(this.token);

  final String token;
}

/// Event to load settings for a family.
class LoadFamilySettingsRequested extends FamilyEvent {
  const LoadFamilySettingsRequested(this.familyId);

  final String familyId;
}

/// Event to update settings for a family.
class UpdateFamilySettingsRequested extends FamilyEvent {
  const UpdateFamilySettingsRequested(this.familyId, this.settings);

  final String familyId;
  final FamilySettings settings;
}
