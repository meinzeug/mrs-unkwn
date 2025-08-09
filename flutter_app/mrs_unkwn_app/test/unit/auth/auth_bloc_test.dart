import 'package:bloc_test/bloc_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:mrs_unkwn_app/features/auth/presentation/bloc/auth_bloc.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;

  setUp(() {
    repository = MockAuthRepository();
  });

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthSuccess] on successful login',
    build: () {
      when(() => repository.login(any(), any()))
          .thenAnswer((_) async => const User(id: '1'));
      return AuthBloc(repository);
    },
    act: (bloc) => bloc.add(LoginRequested('a@b.com', 'pass')),
    expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthFailure] on login failure',
    build: () {
      when(() => repository.login(any(), any()))
          .thenThrow(Exception('oops'));
      return AuthBloc(repository);
    },
    act: (bloc) => bloc.add(LoginRequested('a@b.com', 'pass')),
    expect: () => [isA<AuthLoading>(), isA<AuthFailure>()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthSuccess] on AppStartEvent with valid session',
    build: () {
      when(() => repository.getCurrentUser())
          .thenAnswer((_) async => const User(id: '1'));
      return AuthBloc(repository);
    },
    act: (bloc) => bloc.add(AppStartEvent()),
    expect: () => [isA<AuthLoading>(), isA<AuthSuccess>()],
  );

  blocTest<AuthBloc, AuthState>(
    'emits [AuthLoading, AuthInitial] on AppStartEvent without session',
    build: () {
      when(() => repository.getCurrentUser())
          .thenAnswer((_) async => null);
      return AuthBloc(repository);
    },
    act: (bloc) => bloc.add(AppStartEvent()),
    expect: () => [isA<AuthLoading>(), isA<AuthInitial>()],
  );
}
