import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

import '../storage/secure_storage_service.dart';
import 'route_constants.dart';
import '../../features/monitoring/presentation/pages/monitoring_dashboard_page.dart';
import '../../features/analytics/presentation/pages/analytics_dashboard_page.dart';
import '../../features/auth/presentation/pages/home_page.dart';

/// Central application router using [GoRouter].
class AppRouter {
  AppRouter._();

  /// Global [GoRouter] instance.
  static final GoRouter router = GoRouter(
    routes: <GoRoute>[
      GoRoute(
        path: RouteConstants.login,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: RouteConstants.register,
        builder: (context, state) => const Placeholder(),
      ),
      GoRoute(
        path: RouteConstants.home,
        builder: (context, state) => const HomePage(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteConstants.familySetup,
        builder: (context, state) => const Placeholder(),
        redirect: _authGuard,
      ),
      GoRoute(
        path: RouteConstants.monitoring,
        builder: (context, state) => const MonitoringDashboardPage(),
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
    final location = state.location;
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
