import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mocktail/mocktail.dart';
import 'package:go_router/go_router.dart';

import 'package:mrs_unkwn_app/features/auth/presentation/pages/login_page.dart';
import 'package:mrs_unkwn_app/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:mrs_unkwn_app/core/routing/route_constants.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late MockAuthRepository repository;
  late AuthBloc bloc;

  setUp(() {
    repository = MockAuthRepository();
    bloc = AuthBloc(repository);
  });

  testWidgets('shows validation errors when fields are empty', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const LoginPage(),
        ),
      ),
    );

    await tester.tap(find.text('Login'));
    await tester.pump();

    expect(find.text('Bitte Email eingeben'), findsOneWidget);
    expect(find.text('Bitte Passwort eingeben'), findsOneWidget);
  });

  testWidgets('navigates to home on successful login', (tester) async {
    when(() => repository.login(any(), any()))
        .thenAnswer((_) async => const User(id: '1'));

    final router = GoRouter(
      routes: [
        GoRoute(
          path: RouteConstants.login,
          builder: (_, __) => BlocProvider.value(
            value: bloc,
            child: const LoginPage(),
          ),
        ),
        GoRoute(
          path: RouteConstants.home,
          builder: (_, __) => const Text('Home'),
        ),
      ],
      initialLocation: RouteConstants.login,
    );

    await tester.pumpWidget(MaterialApp.router(routerConfig: router));

    await tester.enterText(
        find.byType(TextFormField).first, 'test@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'password');

    await tester.tap(find.text('Login'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(
      router.routerDelegate.currentConfiguration.uri.toString(),
      RouteConstants.home,
    );
  });

  testWidgets('adapts layout for small screens', (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider.value(
          value: bloc,
          child: const LoginPage(),
        ),
      ),
    );

    expect(find.byType(LoginPage), findsOneWidget);
  });
}
