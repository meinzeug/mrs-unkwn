import 'package:flutter_bloc/flutter_bloc.dart';

/// Simple user placeholder. Replace with actual user model when available.
class User {
  const User({required this.id});
  final String id;
}

// Events
abstract class AuthEvent {}

class LoginRequested extends AuthEvent {
  LoginRequested(this.email, this.password);
  final String email;
  final String password;
}

class LogoutRequested extends AuthEvent {}

class AppStartEvent extends AuthEvent {}

class AuthStatusChanged extends AuthEvent {
  AuthStatusChanged(this.user);
  final User? user;
}

class RegisterRequested extends AuthEvent {
  RegisterRequested(
    this.firstName,
    this.lastName,
    this.email,
    this.password,
    this.role,
  );

  final String firstName;
  final String lastName;
  final String email;
  final String password;
  final String role;
}

// States
abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthLoading extends AuthState {}

class AuthSuccess extends AuthState {
  AuthSuccess(this.user);
  final User user;
}

class AuthFailure extends AuthState {
  AuthFailure(this.message);
  final String message;
}

class RegisterSuccess extends AuthState {
  RegisterSuccess(this.user);
  final User user;
}

class RegisterFailure extends AuthState {
  RegisterFailure(this.message);
  final String message;
}

// Repository interface
abstract class AuthRepository {
  Future<User> login(String email, String password);
  Future<void> refreshToken();
  Future<void> logout();
  Future<User?> getCurrentUser();
  Future<User> register(
    String firstName,
    String lastName,
    String email,
    String password,
    String role,
  );
}

// Bloc
class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc(this._repository) : super(AuthInitial()) {
    on<LoginRequested>(_onLoginRequested);
    on<LogoutRequested>(_onLogoutRequested);
    on<AuthStatusChanged>(_onAuthStatusChanged);
    on<AppStartEvent>(_onAppStarted);
    on<RegisterRequested>(_onRegisterRequested);
  }

  final AuthRepository _repository;

  Future<void> _onLoginRequested(
    LoginRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _repository.login(event.email, event.password);
      emit(AuthSuccess(user));
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  Future<void> _onAppStarted(
    AppStartEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _repository.getCurrentUser();
      if (user != null) {
        emit(AuthSuccess(user));
      } else {
        emit(AuthInitial());
      }
    } catch (_) {
      emit(AuthInitial());
    }
  }

  Future<void> _onLogoutRequested(
    LogoutRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      await _repository.logout();
      emit(AuthInitial());
    } catch (e) {
      emit(AuthFailure(e.toString()));
    }
  }

  void _onAuthStatusChanged(
    AuthStatusChanged event,
    Emitter<AuthState> emit,
  ) {
    final user = event.user;
    if (user != null) {
      emit(AuthSuccess(user));
    } else {
      emit(AuthInitial());
    }
  }

  Future<void> _onRegisterRequested(
    RegisterRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());
    try {
      final user = await _repository.register(
        event.firstName,
        event.lastName,
        event.email,
        event.password,
        event.role,
      );
      emit(RegisterSuccess(user));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
