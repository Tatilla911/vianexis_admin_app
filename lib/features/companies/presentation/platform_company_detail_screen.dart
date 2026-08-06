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
import '../data/platform_companies_repository.dart';
import '../domain/authorization_method_l10n.dart';
import '../domain/platform_company_status.dart';
import 'platform_companies_providers.dart';
import 'widgets/company_data_amendment_dialog.dart';
import 'widgets/company_members_section.dart';
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
    final role = ref.watch(adminAuthProvider).user?.role;
    final canAmend = role?.canInitiateCompanyDataAmendment ?? false;
    final canApproveAmend = role?.canApproveCompanyDataAmendment ?? false;
    final canApplyAmend = role?.canApplyCompanyDataAmendment ?? false;
    final registrationAsync = ref.watch(
      platformCompanyRegistrationSnapshotProvider(companyId),
    );
    final amendmentsAsync = ref.watch(
      platformCompanyAmendmentsProvider(companyId),
    );

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
              _sectionTitle(context, 'platformCompanySectionOverview'),
              Text(
                resolvePlatformCompanyKey(
                  context,
                  'platformCompanyOverviewHint',
                ),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (canAmend) ...[
                const SizedBox(height: 12),
                FilledButton.icon(
                  onPressed: () async {
                    final created = await showCompanyDataAmendmentDialog(
                      context: context,
                      ref: ref,
                      companyId: companyId,
                      expectedDataVersion:
                          registrationAsync.asData?.value.dataVersion,
                    );
                    if (created != null && context.mounted) {
                      final status = created.status.toLowerCase();
                      final successKey =
                          status == 'pending_approval' || status == 'pending'
                          ? 'platformCompanyAmendSubmitSuccessPending'
                          : status == 'applied'
                          ? 'platformCompanyAmendSubmitSuccessApplied'
                          : 'platformCompanyAmendSubmitSuccess';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            resolvePlatformCompanyKey(context, successKey),
                          ),
                        ),
                      );
                    }
                  },
                  icon: const Icon(Icons.edit_outlined),
                  label: Text(
                    resolvePlatformCompanyKey(
                      context,
                      'platformCompanyAmendAction',
                    ),
                  ),
                ),
              ],
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
                error: (_, _) => Text(
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
              _sectionTitle(context, 'platformCompanySectionRegistration'),
              registrationAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => Text(
                  resolvePlatformCompanyKey(
                    context,
                    'platformCompanyRegistrationLoadError',
                  ),
                ),
                data: (snap) {
                  final originalName =
                      snap.originalSubmitted?['companyName']?.toString();
                  final currentName =
                      snap.currentValid?['companyName']?.toString();
                  final hasDiff = snap.differences.isNotEmpty;
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resolvePlatformCompanyKey(
                          context,
                          'platformCompanyOriginalSubmitted',
                        ),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      _plainField(
                        context,
                        resolvePlatformCompanyKey(
                          context,
                          'platformCompanyAmendFieldLegalName',
                        ),
                        originalName ?? '—',
                      ),
                      if (snap.registration != null) ...[
                        _plainField(
                          context,
                          resolvePlatformCompanyKey(
                            context,
                            'platformCompanyRegistrationSubmittedAt',
                          ),
                          snap.registration!.createdAt == null
                              ? '—'
                              : _formatDate(
                                  context,
                                  snap.registration!.createdAt!,
                                ),
                        ),
                        _plainField(
                          context,
                          resolvePlatformCompanyKey(
                            context,
                            'platformCompanyRegistrationSubmitter',
                          ),
                          snap.registration!.contactName ??
                              snap.registration!.contactEmail ??
                              '—',
                        ),
                      ],
                      const SizedBox(height: 8),
                      Text(
                        resolvePlatformCompanyKey(
                          context,
                          'platformCompanyCurrentValid',
                        ),
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      _plainField(
                        context,
                        resolvePlatformCompanyKey(
                          context,
                          'platformCompanyAmendFieldLegalName',
                        ),
                        currentName ?? company.name,
                      ),
                      if (hasDiff) ...[
                        const SizedBox(height: 8),
                        Text(
                          resolvePlatformCompanyKey(
                            context,
                            'platformCompanyOriginalCurrentDiff',
                          ),
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.tertiary,
                              ),
                        ),
                        ...snap.differences.map(
                          (d) => Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Text(
                              '${d.field}: ${d.original} → ${d.current}',
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ),
                        ),
                      ],
                    ],
                  );
                },
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
                    error: (_, _) => const SizedBox.shrink(),
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
                loading: () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const LinearProgressIndicator(),
                    const SizedBox(height: 12),
                    CompanyMembersSection(companyId: companyId),
                  ],
                ),
                error: (error, stackTrace) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanySummaryError',
                      ),
                    ),
                    const SizedBox(height: 12),
                    CompanyMembersSection(companyId: companyId),
                  ],
                ),
                data: (summary) => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
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
                    const SizedBox(height: 12),
                    CompanyMembersSection(
                      companyId: companyId,
                      usersSummary: summary,
                    ),
                  ],
                ),
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
              _sectionTitle(context, 'platformCompanySectionAmendments'),
              amendmentsAsync.when(
                loading: () => const LinearProgressIndicator(),
                error: (_, _) => Text(
                  resolvePlatformCompanyKey(
                    context,
                    'platformCompanyAmendLoadError',
                  ),
                ),
                data: (items) {
                  if (items.isEmpty) {
                    return Text(
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanyAmendHistoryEmpty',
                      ),
                    );
                  }
                  return Column(
                    children: items.map((a) {
                      return Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                resolvePlatformCompanyKey(
                                  context,
                                  a.fieldLabelKey,
                                ),
                                style: Theme.of(context).textTheme.titleSmall,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${resolvePlatformCompanyKey(context, 'platformCompanyAmendOldValue')}: ${_stringify(a.oldValueJson)}',
                              ),
                              Text(
                                '${resolvePlatformCompanyKey(context, 'platformCompanyAmendNewValue')}: ${_stringify(a.newValueJson)}',
                              ),
                              Text(
                                '${resolvePlatformCompanyKey(context, 'platformCompanyAmendReason')}: ${a.reason}',
                              ),
                              Text(
                                '${resolvePlatformCompanyKey(context, 'platformCompanyAmendAuthorizedBy')}: ${a.authorizedByName}',
                              ),
                              Text(
                                '${resolvePlatformCompanyKey(context, 'platformCompanyAmendAuthMethod')}: ${resolvePlatformCompanyKey(context, authorizationMethodL10nKey(a.authorizationMethod))}',
                              ),
                              Text(
                                '${resolvePlatformCompanyKey(context, 'platformCompanyAmendStatus')}: ${resolvePlatformCompanyKey(context, _amendmentStatusKey(a.status))}',
                              ),
                              Text(_formatDate(context, a.requestedAt)),
                              if (a.status == 'conflict')
                                Text(
                                  resolvePlatformCompanyKey(
                                    context,
                                    'platformCompanyAmendConflict',
                                  ),
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.error,
                                  ),
                                ),
                              if (canApproveAmend &&
                                  a.status == 'pending_approval')
                                Row(
                                  children: [
                                    TextButton(
                                      onPressed: () async {
                                        await ref
                                            .read(
                                              platformCompaniesRepositoryProvider,
                                            )
                                            .approveAmendment(
                                              companyId: companyId,
                                              amendmentId: a.id,
                                            );
                                        ref.invalidate(
                                          platformCompanyAmendmentsProvider(
                                            companyId,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        resolvePlatformCompanyKey(
                                          context,
                                          'platformCompanyAmendApprove',
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () async {
                                        await ref
                                            .read(
                                              platformCompaniesRepositoryProvider,
                                            )
                                            .rejectAmendment(
                                              companyId: companyId,
                                              amendmentId: a.id,
                                              rejectionReason:
                                                  'Rejected from admin app',
                                            );
                                        ref.invalidate(
                                          platformCompanyAmendmentsProvider(
                                            companyId,
                                          ),
                                        );
                                      },
                                      child: Text(
                                        resolvePlatformCompanyKey(
                                          context,
                                          'platformCompanyAmendReject',
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              if (canApplyAmend && a.status == 'approved')
                                TextButton(
                                  onPressed: () async {
                                    try {
                                      await ref
                                          .read(
                                            platformCompaniesRepositoryProvider,
                                          )
                                          .applyAmendment(
                                            companyId: companyId,
                                            amendmentId: a.id,
                                            expectedDataVersion: a
                                                .expectedDataVersion,
                                          );
                                      ref.invalidate(
                                        platformCompanyAmendmentsProvider(
                                          companyId,
                                        ),
                                      );
                                      ref.invalidate(
                                        platformCompanyDetailProvider(
                                          companyId,
                                        ),
                                      );
                                      ref.invalidate(
                                        platformCompanyRegistrationSnapshotProvider(
                                          companyId,
                                        ),
                                      );
                                    } catch (_) {
                                      if (context.mounted) {
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            content: Text(
                                              resolvePlatformCompanyKey(
                                                context,
                                                'platformCompanyAmendConflict',
                                              ),
                                            ),
                                          ),
                                        );
                                      }
                                    }
                                  },
                                  child: Text(
                                    resolvePlatformCompanyKey(
                                      context,
                                      'platformCompanyAmendApply',
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),
                      );
                    }).toList(growable: false),
                  );
                },
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
                onPressed: () {
                  final entityId = int.tryParse(company.id) ?? 0;
                  if (entityId == 0) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          AppLocalizations.of(context).errorActionUnavailableBody,
                        ),
                      ),
                    );
                    return;
                  }
                  showQrCodesManagementDialog(
                    context,
                    entityType: QrEntityType.company.apiValue,
                    entityId: entityId,
                    displayName: company.companyName ?? company.name,
                    companyId: entityId,
                    titleKey: 'qrCodesCompanyTitle',
                    allowedPurposes: const [
                      QrPurpose.companyInvite,
                      QrPurpose.companyOnboarding,
                      QrPurpose.companyProfile,
                      QrPurpose.publicCompanyInfo,
                      QrPurpose.supportReference,
                    ],
                  );
                },
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

  Widget _plainField(BuildContext context, String label, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(label),
      subtitle: Text(value),
    );
  }

  String _stringify(Object? value) {
    if (value == null) return '—';
    final text = value.toString().trim();
    return text.isEmpty ? '—' : text;
  }

  String _amendmentStatusKey(String status) {
    return switch (status) {
      'draft' => 'platformCompanyAmendStatusDraft',
      'pending_approval' => 'platformCompanyAmendStatusPending',
      'approved' => 'platformCompanyAmendStatusApproved',
      'rejected' => 'platformCompanyAmendStatusRejected',
      'applied' => 'platformCompanyAmendStatusApplied',
      'reverted' => 'platformCompanyAmendStatusReverted',
      'cancelled' => 'platformCompanyAmendStatusCancelled',
      'conflict' => 'platformCompanyAmendStatusConflict',
      _ => 'platformCompanyAmendStatus',
    };
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
