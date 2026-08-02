import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/auth/admin_auth_state.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../qr_codes/domain/platform_qr_code.dart';
import '../../qr_codes/presentation/widgets/qr_codes_management_dialog.dart';
import '../data/company_assessments_api.dart';
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
    final usersAsync = ref.watch(
      platformCompanyUsersSummaryProvider(companyId),
    );
    final systemAsync = ref.watch(
      platformCompanySystemSummaryProvider(companyId),
    );
    final onboardingAsync = ref.watch(
      platformCompanyOnboardingSummaryProvider(companyId),
    );
    final canChangeStatus =
        ref
            .watch(adminAuthProvider)
            .user
            ?.role
            .canChangePlatformCompanyStatus ??
        false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.platformCompanyDetailTitle)),
      body: companyAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolvePlatformCompanyKey(
            context,
            'platformCompanyDetailError',
          ),
          onRetry: () =>
              ref.invalidate(platformCompanyDetailProvider(companyId)),
        ),
        data: (company) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                company.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              PlatformCompanyStatusBadge(status: company.status),
              const SizedBox(height: 16),
              _sectionTitle(context, 'platformCompanySectionBasics'),
              _field(
                context,
                'platformCompanyFieldCountry',
                company.country ?? '—',
              ),
              _field(
                context,
                'platformCompanyFieldVat',
                company.vatNumber ?? '—',
              ),
              _field(
                context,
                'platformCompanyFieldRegistrationNumber',
                company.registrationNumber ?? '—',
              ),
              const SizedBox(height: 12),
              _sectionTitle(context, 'platformCompanySectionContacts'),
              systemAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, __) => Text(
                  resolvePlatformCompanyKey(
                    context,
                    'platformCompanySummaryError',
                  ),
                ),
                data: (summary) => _summaryCard(
                  context,
                  'platformCompanySectionContacts',
                  [
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyMetricContacts',
                      params: {'count': '${summary.contactCardsCount}'},
                    ),
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyMetricDepartments',
                      params: {'count': '${summary.departmentsCount}'},
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              _sectionTitle(context, 'platformCompanySectionAssessment'),
              ref.watch(companyAssessmentsForCompanyProvider(companyId)).when(
                    loading: () => const LinearProgressIndicator(),
                    error: (_, _) => Text(
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanyAssessmentEmpty',
                      ),
                    ),
                    data: (items) {
                      if (items.isEmpty) {
                        return Text(
                          resolvePlatformCompanyKey(
                            context,
                            'platformCompanyAssessmentEmpty',
                          ),
                        );
                      }
                      final a = items.first;
                      final size =
                          (a.submittedSnapshot?['companySize']
                              as Map?)?['driversCount'];
                      final trips =
                          (a.submittedSnapshot?['operations']
                              as Map?)?['monthlyTrips'];
                      final modules =
                          (a.submittedSnapshot?['modules'] as List?)
                              ?.join(', ');
                      return _summaryCard(
                        context,
                        'platformCompanySectionAssessment',
                        [
                          resolvePlatformCompanyKey(
                            context,
                            'platformCompanyAssessmentStatus',
                            params: {'status': a.status},
                          ),
                          resolvePlatformCompanyKey(
                            context,
                            'platformCompanyAssessmentVersion',
                            params: {'version': '${a.version}'},
                          ),
                          if (a.lastSavedAt != null)
                            resolvePlatformCompanyKey(
                              context,
                              'platformCompanyAssessmentLastSaved',
                              params: {'value': a.lastSavedAt!},
                            ),
                          if (a.submittedAt != null)
                            resolvePlatformCompanyKey(
                              context,
                              'platformCompanyAssessmentSubmittedAt',
                              params: {'value': a.submittedAt!},
                            ),
                          if (size != null)
                            resolvePlatformCompanyKey(
                              context,
                              'platformCompanyAssessmentDrivers',
                              params: {'count': '$size'},
                            ),
                          if (trips != null)
                            resolvePlatformCompanyKey(
                              context,
                              'platformCompanyAssessmentMonthlyTrips',
                              params: {'count': '$trips'},
                            ),
                          if (modules != null && modules.isNotEmpty)
                            resolvePlatformCompanyKey(
                              context,
                              'platformCompanyAssessmentModules',
                              params: {'value': modules},
                            ),
                        ],
                      );
                    },
                  ),
              const SizedBox(height: 12),
              _sectionTitle(context, 'platformCompanySectionPricing'),
              ref.watch(companyAssessmentsForCompanyProvider(companyId)).when(
                    loading: () => const SizedBox.shrink(),
                    error: (_, __) => const SizedBox.shrink(),
                    data: (items) {
                      if (items.isEmpty) {
                        return Text(
                          resolvePlatformCompanyKey(
                            context,
                            'platformCompanyPricingEmpty',
                          ),
                        );
                      }
                      final a = items.first;
                      final suggestion = a.pricingSuggestion;
                      final monthly =
                          (suggestion?['monthly'] as Map?)?['net'];
                      final oneTime =
                          (suggestion?['oneTime'] as Map?)?['net'];
                      final pack = suggestion?['suggestedPackage'];
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _summaryCard(
                            context,
                            'platformCompanySectionPricing',
                            [
                              resolvePlatformCompanyKey(
                                context,
                                'platformCompanyPricingSuggestedPackage',
                                params: {'value': '${pack ?? '—'}'},
                              ),
                              resolvePlatformCompanyKey(
                                context,
                                'platformCompanyPricingMonthlyNet',
                                params: {'value': '${monthly ?? '—'}'},
                              ),
                              resolvePlatformCompanyKey(
                                context,
                                'platformCompanyPricingOneTimeNet',
                                params: {'value': '${oneTime ?? '—'}'},
                              ),
                              resolvePlatformCompanyKey(
                                context,
                                'platformCompanyPricingNotFinal',
                              ),
                              if (a.adminOverride != null)
                                resolvePlatformCompanyKey(
                                  context,
                                  'platformCompanyPricingHasOverride',
                                ),
                            ],
                          ),
                        ],
                      );
                    },
                  ),
              const SizedBox(height: 12),
              _sectionTitle(context, 'platformCompanySectionSubscription'),
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
                error: (error, stackTrace) => Text(
                  resolvePlatformCompanyKey(
                    context,
                    'platformCompanySummaryError',
                  ),
                ),
                data: (summary) =>
                    _summaryCard(context, 'platformCompanySectionUsers', [
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
                    ]),
              ),
              const SizedBox(height: 12),
              systemAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stackTrace) => Text(
                  resolvePlatformCompanyKey(
                    context,
                    'platformCompanySummaryError',
                  ),
                ),
                data: (summary) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _summaryCard(context, 'platformCompanySectionDocuments', [
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanyMetricDocuments',
                        params: {'count': '${summary.documentsCount}'},
                      ),
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanyMetricPackages',
                        params: {'count': '${summary.packagesCount}'},
                      ),
                    ]),
                    const SizedBox(height: 12),
                    _summaryCard(context, 'platformCompanySectionSupport', [
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanyMetricOpenSupport',
                        params: {
                          'count': '${summary.openSupportTicketsCount}',
                        },
                      ),
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanyMetricActiveGrants',
                        params: {
                          'count':
                              '${summary.activeSupportAccessGrantsCount}',
                        },
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
                    ]),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              onboardingAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (error, stackTrace) => Text(
                  resolvePlatformCompanyKey(
                    context,
                    'platformCompanySummaryError',
                  ),
                ),
                data: (summary) =>
                    _summaryCard(context, 'platformCompanySectionAudit', [
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanyMetricPendingRegistrations',
                        params: {
                          'count':
                              '${summary.pendingRegistrationApplicationsCount}',
                        },
                      ),
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanyMetricPendingBulkJobs',
                        params: {
                          'count': '${summary.pendingBulkOnboardingJobsCount}',
                        },
                      ),
                      if (summary.latestPricingIntakeStatus != null)
                        resolvePlatformCompanyKey(
                          context,
                          'platformCompanyAssessmentStatus',
                          params: {
                            'status': summary.latestPricingIntakeStatus!,
                          },
                        ),
                    ]),
              ),
              const SizedBox(height: 12),
              Text(
                resolvePlatformCompanyKey(
                  context,
                  'platformCompanyPrivacyNotice',
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => showQrCodesManagementDialog(
                  context,
                  entityType: QrEntityType.company.apiValue,
                  entityId: int.tryParse(company.id) ?? 0,
                  displayName: company.name,
                  companyId: int.tryParse(company.id),
                  titleKey: 'qrCodesCompanyTitle',
                  allowedPurposes: const [
                    QrPurpose.companyInvite,
                    QrPurpose.companyOnboarding,
                    QrPurpose.companyProfile,
                    QrPurpose.publicCompanyInfo,
                    QrPurpose.supportReference,
                  ],
                ),
                icon: const Icon(Icons.qr_code_2),
                label: Text(resolveQrCodesKey(context, 'qrCodesGenerateAction')),
              ),
              if (canChangeStatus) ...[
                const SizedBox(height: 20),
                OutlinedButton(
                  onPressed: () => _changeStatus(context, ref, company.status),
                  child: Text(
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyChangeStatusAction',
                    ),
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

  Widget _summaryCard(
    BuildContext context,
    String titleKey,
    List<String> lines,
  ) {
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
    return DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    ).add_Hm().format(value.toLocal());
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
            resolvePlatformCompanyKey(
              context,
              'platformCompanyStatusUnavailable',
            ),
          ),
        ),
      );
    }
  }
}
