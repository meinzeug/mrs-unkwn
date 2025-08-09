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

/// Error state with message.
class FamilyError extends FamilyState {
  const FamilyError(this.message);

  final String message;

  @override
  List<Object?> get props => [message];
}
