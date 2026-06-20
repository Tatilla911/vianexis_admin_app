import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/auth/admin_auth_state.dart';
import '../core/auth/admin_user.dart';
import '../core/widgets/permission_denied_screen.dart';
import '../core/widgets/vianexis_admin_scaffold.dart';
import '../features/action_center/presentation/action_center_screen.dart';
import '../features/admin_users/presentation/admin_user_detail_screen.dart';
import '../features/admin_users/presentation/admin_users_screen.dart';
import '../features/ai_reviews/presentation/ai_review_summary_screen.dart';
import '../features/audit_logs/presentation/audit_log_detail_screen.dart';
import '../features/audit_logs/presentation/audit_logs_screen.dart';
import '../features/ai_reviews/presentation/ai_review_detail_screen.dart';
import '../features/release_center/presentation/release_center_screen.dart';
import '../features/security_center/presentation/security_event_detail_screen.dart';
import '../features/security_center/presentation/security_center_screen.dart';
import '../features/bulk_onboarding/presentation/bulk_onboarding_job_detail_screen.dart';
import '../features/bulk_onboarding/presentation/bulk_onboarding_jobs_screen.dart';
import '../features/bulk_onboarding/presentation/bulk_onboarding_row_detail_screen.dart';
import '../features/bulk_onboarding/presentation/bulk_onboarding_rows_screen.dart';
import '../features/bulk_onboarding/presentation/bulk_onboarding_upload_screen.dart';
import '../features/billing/presentation/billing_screen.dart';
import '../features/billing/presentation/pricing_intake_detail_screen.dart';
import '../features/billing/presentation/quote_request_detail_screen.dart';
import '../features/billing/presentation/subscription_detail_screen.dart';
import '../features/companies/presentation/platform_companies_screen.dart';
import '../features/companies/presentation/platform_company_detail_screen.dart';
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
          return AdminRoutes.accessDenied;
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
            path: AdminRoutes.actionCenter,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ActionCenterScreen(),
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
            path: AdminRoutes.companies,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: PlatformCompaniesScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => PlatformCompanyDetailScreen(
                  companyId: state.pathParameters['id'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: AdminRoutes.billing,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BillingScreen(),
            ),
            routes: [
              GoRoute(
                path: 'subscription/:id',
                builder: (context, state) => SubscriptionDetailScreen(
                  subscriptionId: state.pathParameters['id'] ?? '',
                ),
              ),
              GoRoute(
                path: 'pricing-intake/:id',
                builder: (context, state) => PricingIntakeDetailScreen(
                  intakeId: state.pathParameters['id'] ?? '',
                ),
              ),
              GoRoute(
                path: 'quote-request/:id',
                builder: (context, state) => QuoteRequestDetailScreen(
                  quoteRequestId: state.pathParameters['id'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: AdminRoutes.bulkOnboarding,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: BulkOnboardingJobsScreen(),
            ),
            routes: [
              GoRoute(
                path: 'upload',
                pageBuilder: (context, state) => const NoTransitionPage(
                  child: BulkOnboardingUploadScreen(),
                ),
              ),
              GoRoute(
                path: ':id',
                builder: (context, state) => BulkOnboardingJobDetailScreen(
                  jobId: state.pathParameters['id'] ?? '',
                ),
                routes: [
                  GoRoute(
                    path: 'rows',
                    builder: (context, state) => BulkOnboardingRowsScreen(
                      jobId: state.pathParameters['id'] ?? '',
                    ),
                    routes: [
                      GoRoute(
                        path: ':rowId',
                        builder: (context, state) => BulkOnboardingRowDetailScreen(
                          jobId: state.pathParameters['id'] ?? '',
                          rowId: state.pathParameters['rowId'] ?? '',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
          GoRoute(
            path: AdminRoutes.aiReviews,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AiReviewSummaryScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => AiReviewDetailScreen(
                  reviewId: Uri.decodeComponent(state.pathParameters['id'] ?? ''),
                ),
              ),
            ],
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
            path: AdminRoutes.securityCenter,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: SecurityCenterScreen(),
            ),
            routes: [
              GoRoute(
                path: 'events/:id',
                builder: (context, state) => SecurityEventDetailScreen(
                  eventId: Uri.decodeComponent(state.pathParameters['id'] ?? ''),
                ),
              ),
            ],
          ),
          GoRoute(
            path: AdminRoutes.adminUsers,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AdminUsersScreen(),
            ),
            routes: [
              GoRoute(
                path: ':id',
                builder: (context, state) => AdminUserDetailScreen(
                  userId: state.pathParameters['id'] ?? '',
                ),
              ),
            ],
          ),
          GoRoute(
            path: AdminRoutes.releaseCenter,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: ReleaseCenterScreen(),
            ),
          ),
          GoRoute(
            path: AdminRoutes.settings,
            pageBuilder: (context, state) => const NoTransitionPage(
              child: AdminSettingsScreen(),
            ),
          ),
          GoRoute(
            path: AdminRoutes.accessDenied,
            pageBuilder: (context, state) => NoTransitionPage(
              child: PermissionDeniedScreen(
                attemptedRoute: state.uri.queryParameters['attempted'],
              ),
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
  static const actionCenter = '/action-center';
  static const registrations = '/registrations';
  static const companies = '/companies';
  static const billing = '/billing';
  static const bulkOnboarding = '/bulk-onboarding';
  static const bulkOnboardingUpload = '/bulk-onboarding/upload';
  static const aiReviews = '/ai-reviews';
  static const supportTickets = '/support/tickets';
  static const supportGrants = '/support/grants';
  static const systemHealth = '/system-health';
  static const auditLogs = '/audit-logs';
  static const securityCenter = '/security';
  static const adminUsers = '/admin-users';
  static const releaseCenter = '/release-center';
  static const settings = '/settings';
  static const accessDenied = '/access-denied';

  static String systemHealthEventDetail(String id) => '$systemHealth/events/$id';

  static String registrationDetail(String id) => '$registrations/$id';

  static String platformCompanyDetail(String id) => '$companies/$id';

  static String billingSubscriptionDetail(String id) => '$billing/subscription/$id';

  static String billingPricingIntakeDetail(String id) => '$billing/pricing-intake/$id';

  static String billingQuoteRequestDetail(String id) => '$billing/quote-request/$id';

  static String bulkOnboardingJobDetail(String id) => '$bulkOnboarding/$id';

  static String bulkOnboardingJobRows(String id) => '$bulkOnboarding/$id/rows';

  static String bulkOnboardingJobRowDetail(String jobId, String rowId) =>
      '$bulkOnboarding/$jobId/rows/$rowId';

  static String supportTicketDetail(String id) => '$supportTickets/$id';

  static String supportGrantDetail(String id) => '$supportGrants/$id';

  static String auditLogDetail(String id) => '$auditLogs/$id';

  static String aiReviewDetail(String id) =>
      '$aiReviews/${Uri.encodeComponent(id)}';

  static String adminUserDetail(String id) => '$adminUsers/$id';

  static String securityEventDetail(String id) =>
      '$securityCenter/events/${Uri.encodeComponent(id)}';

  static AdminDestination? destinationForLocation(String location) {
    if (location.startsWith(actionCenter)) {
      return AdminDestination.actionCenter;
    }
    if (location.startsWith(registrations)) {
      return AdminDestination.registrations;
    }
    if (location.startsWith(companies)) {
      return AdminDestination.companies;
    }
    if (location.startsWith(billing)) {
      return AdminDestination.billing;
    }
    if (location.startsWith(bulkOnboarding)) {
      return AdminDestination.bulkOnboarding;
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
    if (location.startsWith(securityCenter)) {
      return AdminDestination.securityCenter;
    }
    if (location.startsWith(adminUsers)) {
      return AdminDestination.adminUsers;
    }
    if (location.startsWith(releaseCenter)) {
      return AdminDestination.releaseCenter;
    }
    return switch (location) {
      dashboard => AdminDestination.dashboard,
      actionCenter => AdminDestination.actionCenter,
      aiReviews => AdminDestination.aiReviews,
      supportTickets => AdminDestination.supportTickets,
      supportGrants => AdminDestination.supportGrants,
      systemHealth => AdminDestination.systemHealth,
      securityCenter => AdminDestination.securityCenter,
      adminUsers => AdminDestination.adminUsers,
      releaseCenter => AdminDestination.releaseCenter,
      auditLogs => AdminDestination.auditLogs,
      settings => AdminDestination.settings,
      _ => null,
    };
  }
}
