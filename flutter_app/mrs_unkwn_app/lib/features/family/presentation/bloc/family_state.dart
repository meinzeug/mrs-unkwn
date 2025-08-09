part of 'family_bloc.dart';

/// Base state for [FamilyBloc].
abstract class FamilyState extends BaseState with EquatableMixin {
  const FamilyState();

  @override
  List<Object?> get props => [];
}

/// Initial state before any action.
class FamilyInitial extends FamilyState {
  const FamilyInitial();
}

/// Loading state for async operations.
class FamilyLoading extends FamilyState {
  const FamilyLoading();
}

/// State emitted when family data is loaded.
class FamilyLoaded extends FamilyState {
  const FamilyLoaded(this.family);

  final Family family;

  @override
  List<Object?> get props => [family];
}

/// State emitted after a family is created.
class FamilyCreated extends FamilyState {
  const FamilyCreated(this.family);

  final Family family;

  @override
  List<Object?> get props => [family];
}

/// State emitted after an invitation was sent.
class FamilyInvitationSent extends FamilyState {
  const FamilyInvitationSent(this.token);

  /// Invitation token to be shared, e.g., via QR code.
  final String token;

  @override
  List<Object?> get props => [token];
}

/// State emitted when family settings are loaded or updated.
class FamilySettingsLoaded extends FamilyState {
  const FamilySettingsLoaded(this.settings);

  final FamilySettings settings;

  @override
  List<Object?> get props => [settings];
}

/// Error state with message.
class FamilyError extends FamilyState {
  const FamilyError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
