import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../storage/secure_storage_service.dart';
import 'route_constants.dart';
import '../di/service_locator.dart';
import '../../features/monitoring/presentation/pages/monitoring_dashboard_page.dart';
import '../../features/monitoring/presentation/pages/privacy_settings_page.dart';
import '../../features/analytics/presentation/pages/analytics_dashboard_page.dart';
import '../../features/auth/presentation/pages/home_page.dart';
import '../../features/auth/presentation/pages/login_page.dart';
import '../../features/auth/presentation/pages/register_page.dart';
import '../../features/auth/presentation/pages/forgot_password_page.dart';
import '../../features/auth/presentation/pages/reset_password_page.dart';
import '../../features/family/presentation/pages/create_family_page.dart';
import '../../features/family/presentation/pages/family_settings_page.dart';
import '../../features/family/presentation/pages/family_members_page.dart';
import '../../features/family/presentation/pages/family_dashboard_page.dart';
import '../../features/family/presentation/pages/subscription_page.dart';
import '../../features/family/presentation/bloc/family_bloc.dart';
import '../../features/family/data/models/family.dart';

/// Central application router using [GoRouter].
class AppRouter {
  AppRouter._();

  /// Global [GoRouter] instance.
  static final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const LoginPage(),
      ),
      GoRoute(
        path: RouteConstants.register,
        builder: (context, state) => const RegisterPage(),
      ),
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const HomePage(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteConstants.forgotPassword,
        builder: (context, state) => const ForgotPasswordPage(),
      ),
      GoRoute(
        path: RouteConstants.resetPassword,
        builder: (context, state) => ResetPasswordPage(
          token: state.uri.queryParameters['token'] ?? '',
        ),
      ),
      GoRoute(
        path: RouteConstants.familySetup,
        builder: (context, state) => const CreateFamilyPage(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteConstants.familyDashboard,
        builder: (context, state) => BlocProvider(
          create: (_) => FamilyBloc(sl(), sl()),
          child: FamilyDashboardPage(
            familyId: state.uri.queryParameters['id'] ?? '',
            currentUserRole: FamilyRole.values.byName(
              state.uri.queryParameters['role'] ?? 'parent',
            ),
          ),
        ),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteConstants.familySettings,
        builder: (context, state) => FamilySettingsPage(
          familyId: state.uri.queryParameters['id'] ?? '',
        ),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteConstants.familyMembers,
        builder: (context, state) => FamilyMembersPage(
          familyId: state.uri.queryParameters['id'] ?? '',
          currentUserRole: FamilyRole.values.byName(
            state.uri.queryParameters['role'] ?? 'parent',
          ),
        ),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteConstants.familySubscription,
        builder: (context, state) => BlocProvider(
          create: (_) => FamilyBloc(sl(), sl()),
          child: SubscriptionPage(
            familyId: state.uri.queryParameters['id'] ?? '',
          ),
        ),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteConstants.monitoring,
        builder: (context, state) => const MonitoringDashboardPage(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteConstants.monitoringPrivacy,
        builder: (context, state) => const PrivacySettingsPage(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteConstants.analytics,
        builder: (context, state) => const AnalyticsDashboardPage(),
        redirect: _authGuard,
      ),
    ],
    redirect: _rootRedirect,
  );

  static Future<String?> _authGuard(
    BuildContext context,
    GoRouterState state,
  ) async {
    final token = await SecureStorageService().read(
      SecureStorageService.tokenKey,
    );
    return token == null ? RouteConstants.login : null;
  }

  static Future<String?> _rootRedirect(
    BuildContext context,
    GoRouterState state,
  ) async {
    final token = await SecureStorageService().read(
      SecureStorageService.tokenKey,
    );
    final location = state.uri.toString();
    if (token == null &&
        location != RouteConstants.login &&
        location != RouteConstants.register) {
      return RouteConstants.login;
    }
    if (token != null && location == RouteConstants.login) {
      return RouteConstants.home;
    }
    return null;
  }
}
