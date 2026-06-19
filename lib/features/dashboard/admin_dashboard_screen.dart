import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_router.dart';
import '../../core/auth/admin_auth_state.dart';
import '../../core/auth/admin_user.dart';
import '../../core/localization/localization_resolver.dart';
import '../../features/audit_logs/presentation/audit_log_providers.dart';
import '../../features/audit_logs/presentation/widgets/audit_log_card.dart';
import '../../features/companies/presentation/platform_companies_providers.dart';
import '../../features/companies/presentation/widgets/platform_company_summary_card.dart';
import '../../features/bulk_onboarding/presentation/bulk_onboarding_providers.dart';
import '../../features/bulk_onboarding/presentation/widgets/bulk_onboarding_summary_card.dart';
import '../../features/support/presentation/support_providers.dart';
import '../../features/support/presentation/widgets/support_summary_card.dart';
import '../../features/system_health/presentation/system_health_providers.dart';
import '../../features/system_health/presentation/widgets/system_health_overview_card.dart';
import '../../l10n/app_localizations.dart';

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
    final user = ref.watch(adminAuthProvider).user;
    final showBulkOnboarding =
        user?.canAccess(AdminDestination.bulkOnboarding) ?? false;
    final showCompanies = user?.canAccess(AdminDestination.companies) ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.dashboardPlaceholderBody,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          healthAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Card(
              child: ListTile(
                title: Text(resolveSystemHealthKey(context, 'systemHealthLoadError')),
                trailing: TextButton(
                  onPressed: () =>
                      ref.read(systemHealthSnapshotProvider.notifier).refresh(),
                  child: Text(l10n.errorRetryButton),
                ),
              ),
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
            error: (error, _) => Card(
              child: ListTile(
                title: Text(resolveSupportKey(context, 'supportLoadError')),
                trailing: TextButton(
                  onPressed: () =>
                      ref.read(supportSummaryProvider.notifier).refresh(),
                  child: Text(l10n.errorRetryButton),
                ),
              ),
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
              error: (error, _) => Card(
                child: ListTile(
                  title: Text(
                    resolvePlatformCompanyKey(context, 'platformCompanyListError'),
                  ),
                  trailing: TextButton(
                    onPressed: () => ref
                        .read(platformCompanyDashboardSummaryProvider.notifier)
                        .refresh(),
                    child: Text(l10n.errorRetryButton),
                  ),
                ),
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
          if (showBulkOnboarding)
            bulkAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Card(
                child: ListTile(
                  title: Text(
                    resolveBulkOnboardingKey(context, 'bulkOnboardingListError'),
                  ),
                  trailing: TextButton(
                    onPressed: () =>
                        ref.read(bulkOnboardingSummaryProvider.notifier).refresh(),
                    child: Text(l10n.errorRetryButton),
                  ),
                ),
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
          auditAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Card(
              child: ListTile(
                title: Text(resolveAuditLogKey(context, 'auditLogLoadError')),
                trailing: TextButton(
                  onPressed: () =>
                      ref.read(platformAuditLogSummaryProvider.notifier).refresh(),
                  child: Text(l10n.errorRetryButton),
                ),
              ),
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
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.shield_outlined, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(l10n.privacyNoOperationalContent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
