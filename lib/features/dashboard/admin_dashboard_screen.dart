import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_router.dart';
import '../../core/auth/admin_auth_state.dart';
import '../../core/auth/admin_user.dart';
import '../../core/localization/localization_resolver.dart';
import '../../features/ai_reviews/presentation/ai_review_providers.dart';
import '../../features/ai_reviews/presentation/widgets/ai_review_card.dart';
import '../../features/audit_logs/presentation/audit_log_providers.dart';
import '../../features/audit_logs/presentation/widgets/audit_log_card.dart';
import '../../features/action_center/presentation/action_center_providers.dart';
import '../../features/action_center/presentation/widgets/action_center_item_card.dart';
import '../../features/billing/presentation/billing_providers.dart';
import '../../features/billing/presentation/widgets/billing_overview_card.dart';
import '../../features/companies/presentation/platform_companies_providers.dart';
import '../../features/companies/presentation/widgets/platform_company_summary_card.dart';
import '../../features/bulk_onboarding/presentation/bulk_onboarding_providers.dart';
import '../../features/bulk_onboarding/presentation/widgets/bulk_onboarding_summary_card.dart';
import '../../features/registrations/domain/registration_application_status.dart';
import '../../features/registrations/presentation/registration_providers.dart';
import '../../features/security_center/presentation/security_center_providers.dart';
import '../../features/security_center/presentation/widgets/security_overview_card.dart';
import '../../features/support/presentation/support_providers.dart';
import '../../features/support/presentation/widgets/support_summary_card.dart';
import '../../features/system_health/presentation/system_health_providers.dart';
import '../../features/system_health/presentation/widgets/system_health_overview_card.dart';
import '../../l10n/app_localizations.dart';
import 'widgets/dashboard_operational_overview.dart';
import 'widgets/dashboard_summary_error_card.dart';
import '../../core/widgets/vianexis_brand_header.dart';
import '../../core/widgets/vianexis_metadata_notice.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final healthAsync = ref.watch(systemHealthSnapshotProvider);
    final supportAsync = ref.watch(supportSummaryProvider);
    final auditAsync = ref.watch(platformAuditLogSummaryProvider);
    final bulkAsync = ref.watch(bulkOnboardingSummaryProvider);
    final companiesAsync = ref.watch(platformCompanyDashboardSummaryProvider);
    final billingAsync = ref.watch(billingOverviewProvider);
    final securityAsync = ref.watch(securityOverviewProvider);
    final actionCenterAsync = ref.watch(actionCenterProvider);
    final aiReviewsAsync = ref.watch(aiReviewSummaryProvider);
    final registrationsAsync = ref.watch(registrationApplicationsProvider);
    final user = ref.watch(adminAuthProvider).user;
    final showBulkOnboarding =
        user?.canAccess(AdminDestination.bulkOnboarding) ?? false;
    final showCompanies = user?.canAccess(AdminDestination.companies) ?? false;
    final showBilling = user?.canAccess(AdminDestination.billing) ?? false;
    final showAiReviews = user?.canAccess(AdminDestination.aiReviews) ?? false;
    final showRegistrations =
        user?.canAccess(AdminDestination.registrations) ?? false;
    final showSecurityCenter =
        user?.canAccess(AdminDestination.securityCenter) ?? false;
    final showActionCenter =
        user?.canAccess(AdminDestination.actionCenter) ?? false;

    final pendingRegistrations = showRegistrations
        ? registrationsAsync.maybeWhen(
            data: (items) => items
                .where(
                  (item) =>
                      item.status == RegistrationApplicationStatus.pending ||
                      item.status == RegistrationApplicationStatus.needsMoreInfo,
                )
                .length,
            orElse: () => null,
          )
        : null;

    final companiesNeedingAttention = showCompanies
        ? companiesAsync.maybeWhen(
            data: (summary) =>
                summary.pendingReviewCompanies +
                summary.companiesWithOpenSupportIssues +
                summary.companiesWithPendingOnboarding,
            orElse: () => null,
          )
        : null;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const VianexisBrandHeader(),
          const SizedBox(height: 20),
          DashboardOperationalOverview(
            systemOverview: healthAsync.asData?.value.overview,
            pendingRegistrations: pendingRegistrations,
            companiesNeedingAttention: companiesNeedingAttention,
            bulkOnboardingWaiting: showBulkOnboarding
                ? bulkAsync.asData?.value.jobsWaitingForReview
                : null,
            aiHighRiskReviews:
                showAiReviews ? aiReviewsAsync.asData?.value.highRiskCount : null,
            supportOpenIssues: supportAsync.asData?.value.openTicketsCount,
            auditFailedDenied: auditAsync.asData?.value.failedDeniedCount,
          ),
          const SizedBox(height: 16),
          if (showActionCenter)
            actionCenterAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => DashboardSummaryErrorCard(
                error: error,
                fallbackMessage:
                    resolveActionCenterKey(context, 'actionCenterLoadError'),
                onRetry: () => ref.read(actionCenterProvider.notifier).refresh(),
              ),
              data: (snapshot) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ActionCenterNeedsAttentionCard(snapshot: snapshot, compact: true),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.go(AdminRoutes.actionCenter),
                    child: Text(resolveActionCenterKey(context, 'actionCenterOpenModule')),
                  ),
                ],
              ),
            ),
          if (showActionCenter) const SizedBox(height: 16),
          healthAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => DashboardSummaryErrorCard(
              error: error,
              fallbackMessage:
                  resolveSystemHealthKey(context, 'systemHealthLoadError'),
              onRetry: () =>
                  ref.read(systemHealthSnapshotProvider.notifier).refresh(),
            ),
            data: (snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SystemHealthOverviewCard(
                  overview: snapshot.overview,
                  compact: true,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.go(AdminRoutes.systemHealth),
                  child: Text(resolveSystemHealthKey(context, 'systemHealthOpenModule')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          supportAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => DashboardSummaryErrorCard(
              error: error,
              fallbackMessage: resolveSupportKey(context, 'supportLoadError'),
              onRetry: () => ref.read(supportSummaryProvider.notifier).refresh(),
            ),
            data: (summary) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SupportSummaryCard(summary: summary, compact: true),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.go(AdminRoutes.supportTickets),
                  child: Text(resolveSupportKey(context, 'supportOpenModule')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          if (showCompanies)
            companiesAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => DashboardSummaryErrorCard(
                error: error,
                fallbackMessage:
                    resolvePlatformCompanyKey(context, 'platformCompanyListError'),
                onRetry: () => ref
                    .read(platformCompanyDashboardSummaryProvider.notifier)
                    .refresh(),
              ),
              data: (summary) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  PlatformCompanySummaryCard(summary: summary, compact: true),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.go(AdminRoutes.companies),
                    child: Text(
                      resolvePlatformCompanyKey(context, 'platformCompanyOpenModule'),
                    ),
                  ),
                ],
              ),
            ),
          if (showCompanies) const SizedBox(height: 16),
          if (showBilling)
            billingAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => DashboardSummaryErrorCard(
                error: error,
                fallbackMessage: resolveBillingKey(context, 'billingLoadError'),
                onRetry: () => ref.read(billingOverviewProvider.notifier).refresh(),
              ),
              data: (overview) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BillingOverviewCard(overview: overview, compact: true),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.go(AdminRoutes.billing),
                    child: Text(resolveBillingKey(context, 'billingOpenModule')),
                  ),
                ],
              ),
            ),
          if (showBilling) const SizedBox(height: 16),
          if (showSecurityCenter)
            securityAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => DashboardSummaryErrorCard(
                error: error,
                fallbackMessage: resolveSecurityKey(context, 'securityLoadError'),
                onRetry: () =>
                    ref.read(securityOverviewProvider.notifier).refresh(),
              ),
              data: (overview) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SecurityOverviewCard(overview: overview, compact: true),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.go(AdminRoutes.securityCenter),
                    child: Text(resolveSecurityKey(context, 'securityOpenModule')),
                  ),
                ],
              ),
            ),
          if (showSecurityCenter) const SizedBox(height: 16),
          if (showBulkOnboarding)
            bulkAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => DashboardSummaryErrorCard(
                error: error,
                fallbackMessage:
                    resolveBulkOnboardingKey(context, 'bulkOnboardingListError'),
                onRetry: () =>
                    ref.read(bulkOnboardingSummaryProvider.notifier).refresh(),
              ),
              data: (summary) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BulkOnboardingSummaryCard(summary: summary, compact: true),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.go(AdminRoutes.bulkOnboarding),
                    child: Text(
                      resolveBulkOnboardingKey(context, 'bulkOnboardingOpenModule'),
                    ),
                  ),
                ],
              ),
            ),
          if (showBulkOnboarding) const SizedBox(height: 16),
          if (showAiReviews)
            aiReviewsAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => DashboardSummaryErrorCard(
                error: error,
                fallbackMessage: resolveAiReviewKey(context, 'aiReviewLoadError'),
                onRetry: () => ref.read(aiReviewsProvider.notifier).refresh(),
              ),
              data: (summary) => Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  AiReviewSummaryCard(summary: summary, compact: true),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () => context.go(AdminRoutes.aiReviews),
                    child: Text(resolveAiReviewKey(context, 'aiReviewOpenModule')),
                  ),
                ],
              ),
            ),
          if (showAiReviews) const SizedBox(height: 16),
          auditAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => DashboardSummaryErrorCard(
              error: error,
              fallbackMessage: resolveAuditLogKey(context, 'auditLogLoadError'),
              onRetry: () =>
                  ref.read(platformAuditLogSummaryProvider.notifier).refresh(),
            ),
            data: (summary) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                AuditLogSummaryCard(summary: summary, compact: true),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.go(AdminRoutes.auditLogs),
                  child: Text(resolveAuditLogKey(context, 'auditLogOpenModule')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          VianexisMetadataNotice(message: l10n.privacyNoOperationalContent),
        ],
      ),
    );
  }
}
