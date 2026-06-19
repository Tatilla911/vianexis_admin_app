import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/auth/admin_auth_state.dart';
import '../core/auth/admin_user.dart';
import '../core/widgets/vianexis_admin_scaffold.dart';
import '../features/ai_reviews/ai_review_summary_screen.dart';
import '../features/audit_logs/presentation/audit_log_detail_screen.dart';
import '../features/audit_logs/presentation/audit_logs_screen.dart';
import '../features/dashboard/admin_dashboard_screen.dart';
import '../features/login/login_screen.dart';
import '../features/registrations/presentation/registration_application_detail_screen.dart';
import '../features/registrations/presentation/registration_applications_screen.dart';
import '../features/settings/admin_settings_screen.dart';
import '../features/support/presentation/support_access_grant_detail_screen.dart';
import '../features/support/presentation/support_access_grants_screen.dart';
import '../features/support/presentation/support_ticket_detail_screen.dart';
import '../features/support/presentation/support_tickets_screen.dart';
import '../features/system_health/presentation/system_health_event_detail_screen.dart';
import '../features/system_health/presentation/system_health_screen.dart';

class RouterRefreshNotifier extends ChangeNotifier {
  RouterRefreshNotifier(this._ref) {
    _ref.listen<AdminAuthState>(adminAuthProvider, (previous, next) => notifyListeners());
  }

  final Ref _ref;
}

final routerRefreshNotifierProvider = Provider<RouterRefreshNotifier>((ref) {
  final notifier = RouterRefreshNotifier(ref);
  ref.onDispose(notifier.dispose);
  return notifier;
});

final appRouterProvider = Provider<GoRouter>((ref) {
  final refresh = ref.watch(routerRefreshNotifierProvider);

  return GoRouter(
    initialLocation: AdminRoutes.login,
    refreshListenable: refresh,
    redirect: (context, state) {
      final auth = ref.read(adminAuthProvider);
      final isLoggingIn = state.matchedLocation == AdminRoutes.login;

      if (auth.isRestoringSession) {
        return isLoggingIn ? null : AdminRoutes.login;
      }

      if (!auth.isAuthenticated) {
        return isLoggingIn ? null : AdminRoutes.login;
      }

      if (isLoggingIn) {
        return AdminRoutes.dashboard;
      }

      final user = auth.user;
      if (user != null) {
        final destination = AdminRoutes.destinationForLocation(state.matchedLocation);
        if (destination != null && !user.canAccess(destination)) {
          return AdminRoutes.dashboard;
        }
      }

      return null;
    },
    routes: [
      GoRoute(
        path: AdminRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) => VianexisAdminScaffold(child: child),
        routes: [
          GoRoute(
            path: AdminRoutes.dashboard,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AdminDashboardScreen(),
            ),
          ),
          GoRoute(
            path: AdminRoutes.registrations,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: RegistrationApplicationsScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => RegistrationApplicationDetailScreen(
                  applicationId: state.pathParameters['id'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: AdminRoutes.aiReviews,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AiReviewSummaryScreen(),
            ),
          ),
          GoRoute(
            path: AdminRoutes.supportTickets,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SupportTicketsScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => SupportTicketDetailScreen(
                  ticketId: state.pathParameters['id'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: AdminRoutes.supportGrants,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SupportAccessGrantsScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => SupportAccessGrantDetailScreen(
                  grantId: state.pathParameters['id'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: AdminRoutes.systemHealth,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SystemHealthScreen(),
            ),
            routes: [
              GoRoute(
                path: 'events/:id',
                builder: (context, state) => SystemHealthEventDetailScreen(
                  eventId: state.pathParameters['id'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: AdminRoutes.auditLogs,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AuditLogsScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => AuditLogDetailScreen(
                  logId: state.pathParameters['id'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: AdminRoutes.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AdminSettingsScreen(),
            ),
          ),
        ],
      ),
    ],
  );
});

abstract final class AdminRoutes {
  static const login = '/login';
  static const dashboard = '/dashboard';
  static const registrations = '/registrations';
  static const aiReviews = '/ai-reviews';
  static const supportTickets = '/support/tickets';
  static const supportGrants = '/support/grants';
  static const systemHealth = '/system-health';
  static const auditLogs = '/audit-logs';
  static const settings = '/settings';

  static String systemHealthEventDetail(String id) => '$systemHealth/events/$id';

  static String registrationDetail(String id) => '$registrations/$id';

  static String supportTicketDetail(String id) => '$supportTickets/$id';

  static String supportGrantDetail(String id) => '$supportGrants/$id';

  static String auditLogDetail(String id) => '$auditLogs/$id';

  static AdminDestination? destinationForLocation(String location) {
    if (location.startsWith(registrations)) {
      return AdminDestination.registrations;
    }
    if (location.startsWith(supportTickets)) {
      return AdminDestination.supportTickets;
    }
    if (location.startsWith(supportGrants)) {
      return AdminDestination.supportGrants;
    }
    if (location.startsWith(auditLogs)) {
      return AdminDestination.auditLogs;
    }
    return switch (location) {
      dashboard => AdminDestination.dashboard,
      aiReviews => AdminDestination.aiReviews,
      supportTickets => AdminDestination.supportTickets,
      supportGrants => AdminDestination.supportGrants,
      systemHealth => AdminDestination.systemHealth,
      auditLogs => AdminDestination.auditLogs,
      settings => AdminDestination.settings,
      _ => null,
    };
  }
}
