import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/auth/admin_auth_state.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/platform_company_status.dart';
import 'platform_companies_providers.dart';
import 'widgets/platform_company_status_badge.dart';
import 'widgets/platform_company_status_dialog.dart';

class PlatformCompanyDetailScreen extends ConsumerWidget {
  const PlatformCompanyDetailScreen({super.key, required this.companyId});

  final String companyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final companyAsync = ref.watch(platformCompanyDetailProvider(companyId));
    final usersAsync = ref.watch(platformCompanyUsersSummaryProvider(companyId));
    final systemAsync = ref.watch(platformCompanySystemSummaryProvider(companyId));
    final onboardingAsync = ref.watch(platformCompanyOnboardingSummaryProvider(companyId));
    final canChangeStatus =
        ref.watch(adminAuthProvider).user?.role.canChangePlatformCompanyStatus ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.platformCompanyDetailTitle)),
      body: companyAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView(
          message: resolvePlatformCompanyKey(context, 'platformCompanyDetailError'),
          onRetry: () => ref.invalidate(platformCompanyDetailProvider(companyId)),
        ),
        data: (company) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(company.name, style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 8),
              PlatformCompanyStatusBadge(status: company.status),
              const SizedBox(height: 16),
              _sectionTitle(context, 'platformCompanySectionMetadata'),
              _field(context, 'platformCompanyFieldCountry', company.country ?? '—'),
              _field(context, 'platformCompanyFieldVat', company.vatNumber ?? '—'),
              _field(
                context,
                'platformCompanyFieldRegistrationNumber',
                company.registrationNumber ?? '—',
              ),
              _field(
                context,
                'platformCompanyFieldPlan',
                company.planName ?? '—',
              ),
              _field(
                context,
                'platformCompanyFieldSubscriptionStatus',
                company.subscriptionStatus ?? '—',
              ),
              if (company.lastAdminActivityAt != null)
                _field(
                  context,
                  'platformCompanyFieldLastAdminActivity',
                  _formatDate(context, company.lastAdminActivityAt!),
                ),
              const SizedBox(height: 12),
              usersAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(
                  resolvePlatformCompanyKey(context, 'platformCompanySummaryError'),
                ),
                data: (summary) => _summaryCard(
                  context,
                  'platformCompanySectionUsers',
                  [
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyMetricActiveUsers',
                      params: {'count': '${summary.activeUsersCount}'},
                    ),
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyMetricDrivers',
                      params: {'count': '${summary.driversCount}'},
                    ),
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyMetricTotalUsers',
                      params: {'count': '${summary.totalUsersCount}'},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              systemAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(
                  resolvePlatformCompanyKey(context, 'platformCompanySummaryError'),
                ),
                data: (summary) => _summaryCard(
                  context,
                  'platformCompanySectionSupport',
                  [
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyMetricOpenSupport',
                      params: {'count': '${summary.openSupportTicketsCount}'},
                    ),
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyMetricActiveGrants',
                      params: {'count': '${summary.activeSupportAccessGrantsCount}'},
                    ),
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyMetricVehicles',
                      params: {'count': '${summary.vehiclesCount}'},
                    ),
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyMetricTrailers',
                      params: {'count': '${summary.trailersCount}'},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              onboardingAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(
                  resolvePlatformCompanyKey(context, 'platformCompanySummaryError'),
                ),
                data: (summary) => _summaryCard(
                  context,
                  'platformCompanySectionOnboarding',
                  [
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyMetricPendingRegistrations',
                      params: {
                        'count': '${summary.pendingRegistrationApplicationsCount}',
                      },
                    ),
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyMetricPendingBulkJobs',
                      params: {'count': '${summary.pendingBulkOnboardingJobsCount}'},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              Text(
                resolvePlatformCompanyKey(context, 'platformCompanyPrivacyNotice'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (canChangeStatus) ...[
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => _changeStatus(context, ref, company.status),
                  child: Text(
                    resolvePlatformCompanyKey(context, 'platformCompanyChangeStatusAction'),
                  ),
                ),
              ],
            ],
          );
        },
      ),
    );
  }

  Widget _sectionTitle(BuildContext context, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        resolvePlatformCompanyKey(context, key),
        style: Theme.of(context).textTheme.titleMedium,
      ),
    );
  }

  Widget _field(BuildContext context, String labelKey, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(resolvePlatformCompanyKey(context, labelKey)),
      subtitle: Text(value),
    );
  }

  Widget _summaryCard(BuildContext context, String titleKey, List<String> lines) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolvePlatformCompanyKey(context, titleKey),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            for (final line in lines) Text(line),
          ],
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime value) {
    return DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .add_Hm()
        .format(value.toLocal());
  }

  Future<void> _changeStatus(
    BuildContext context,
    WidgetRef ref,
    PlatformCompanyStatus currentStatus,
  ) async {
    final request = await showPlatformCompanyStatusDialog(
      context: context,
      currentStatus: currentStatus,
    );
    if (request == null) return;

    try {
      await submitPlatformCompanyStatusChange(
        ref,
        companyId: companyId,
        request: request,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolvePlatformCompanyKey(context, 'platformCompanyStatusSuccess'),
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolvePlatformCompanyKey(context, 'platformCompanyStatusUnavailable'),
          ),
        ),
      );
    }
  }
}
