import 'package:equatable/equatable.dart';
import 'package:bloc/bloc.dart';

import '../../../../core/bloc/base_bloc.dart';
import '../../../../core/bloc/base_event.dart';
import '../../../../core/bloc/base_state.dart';
import '../../data/repositories/family_repository.dart';
import '../../data/models/family.dart';
import '../../data/models/create_family_request.dart';
import '../../data/models/update_family_request.dart';
import '../../data/models/invite_member_request.dart';

part 'family_event.dart';
part 'family_state.dart';

/// Bloc for handling family related actions and state.
class FamilyBloc extends BaseBloc<FamilyEvent, FamilyState> {
  FamilyBloc(this._repository) : super(const FamilyInitial()) {
    on<CreateFamilyRequested>(_onCreateFamilyRequested);
    on<LoadFamilyRequested>(_onLoadFamilyRequested);
    on<UpdateFamilyRequested>(_onUpdateFamilyRequested);
    on<DeleteFamilyRequested>(_onDeleteFamilyRequested);
    on<InviteMemberRequested>(_onInviteMemberRequested);
    on<AcceptInvitationRequested>(_onAcceptInvitationRequested);
  }

  final FamilyRepository _repository;

  Future<void> _onCreateFamilyRequested(
    CreateFamilyRequested event,
    Emitter<FamilyState> emit,
  ) async {
    emit(const FamilyLoading());
    try {
      final family = await _repository.createFamily(event.request);
      emit(FamilyCreated(family));
    } catch (e) {
      emit(FamilyError(e.toString()));
    }
  }

  Future<void> _onLoadFamilyRequested(
    LoadFamilyRequested event,
    Emitter<FamilyState> emit,
  ) async {
    emit(const FamilyLoading());
    try {
      final family = await _repository.getFamily(event.familyId);
      emit(FamilyLoaded(family));
    } catch (e) {
      emit(FamilyError(e.toString()));
    }
  }

  Future<void> _onUpdateFamilyRequested(
    UpdateFamilyRequested event,
    Emitter<FamilyState> emit,
  ) async {
    Family? previous;
    if (state is FamilyLoaded) {
      previous = (state as FamilyLoaded).family;
      final optimistic = Family(
        id: previous.id,
        name: event.request.name ?? previous.name,
        createdBy: previous.createdBy,
        subscriptionTier:
            event.request.subscriptionTier ?? previous.subscriptionTier,
        settings: event.request.settings ?? previous.settings,
        createdAt: previous.createdAt,
        updatedAt: DateTime.now(),
        members: previous.members,
      );
      emit(FamilyLoaded(optimistic));
    } else {
      emit(const FamilyLoading());
    }
    try {
      final family =
          await _repository.updateFamily(event.familyId, event.request);
      emit(FamilyLoaded(family));
    } catch (e) {
      if (previous != null) {
        emit(FamilyLoaded(previous));
      }
      emit(FamilyError(e.toString()));
    }
  }

  Future<void> _onDeleteFamilyRequested(
    DeleteFamilyRequested event,
    Emitter<FamilyState> emit,
  ) async {
    Family? previous;
    if (state is FamilyLoaded) {
      previous = (state as FamilyLoaded).family;
    }
    emit(const FamilyLoading());
    try {
      await _repository.deleteFamily(event.familyId);
      emit(const FamilyInitial());
    } catch (e) {
      if (previous != null) {
        emit(FamilyLoaded(previous));
      }
      emit(FamilyError(e.toString()));
    }
  }

  Future<void> _onInviteMemberRequested(
    InviteMemberRequested event,
    Emitter<FamilyState> emit,
  ) async {
    emit(const FamilyLoading());
    try {
      await _repository.inviteMember(event.request);
      emit(const FamilyInvitationSent());
    } catch (e) {
      emit(FamilyError(e.toString()));
    }
  }

  Future<void> _onAcceptInvitationRequested(
    AcceptInvitationRequested event,
    Emitter<FamilyState> emit,
  ) async {
    emit(const FamilyLoading());
    try {
      final family = await _repository.acceptInvitation(event.token);
      emit(FamilyLoaded(family));
    } catch (e) {
      emit(FamilyError(e.toString()));
    }
  }
}
