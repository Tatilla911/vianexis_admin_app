import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/bulk_onboarding_repository.dart';
import '../domain/bulk_onboarding_action_request.dart';
import '../domain/bulk_onboarding_execution.dart';
import '../domain/bulk_onboarding_row_status.dart';
import '../domain/bulk_onboarding_status.dart';
import 'bulk_onboarding_providers.dart';
import 'widgets/bulk_onboarding_ai_review_card.dart';
import 'widgets/bulk_onboarding_action_dialog.dart';
import 'widgets/bulk_onboarding_status_badge.dart';
import 'widgets/bulk_onboarding_validation_summary.dart';

class BulkOnboardingJobDetailScreen extends ConsumerStatefulWidget {
  const BulkOnboardingJobDetailScreen({super.key, required this.jobId});

  final String jobId;

  @override
  ConsumerState<BulkOnboardingJobDetailScreen> createState() =>
      _BulkOnboardingJobDetailScreenState();
}

class _BulkOnboardingJobDetailScreenState
    extends ConsumerState<BulkOnboardingJobDetailScreen> {
  BulkOnboardingExecutionResult? _lastExecutionResult;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final jobAsync = ref.watch(bulkOnboardingJobDetailProvider(widget.jobId));
    final user = ref.watch(adminAuthProvider).user;
    final canDecide = user?.role.canDecideBulkOnboarding ?? false;
    final canExecuteRole = user?.role.canExecuteBulkOnboarding ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bulkOnboardingDetailTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.table_rows_outlined),
            tooltip: resolveBulkOnboardingKey(
              context,
              'bulkOnboardingOpenRows',
            ),
            onPressed: () =>
                context.push(AdminRoutes.bulkOnboardingJobRows(widget.jobId)),
          ),
        ],
      ),
      body: jobAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveBulkOnboardingKey(
            context,
            'bulkOnboardingDetailError',
          ),
          onRetry: () =>
              ref.invalidate(bulkOnboardingJobDetailProvider(widget.jobId)),
        ),
        data: (job) {
          final summary = _lastExecutionResult?.summary;
          final policy = _lastExecutionResult?.policy ?? job.executionPolicy;
          final rowCount = policy.rowCount ?? job.totalRows;
          final maxRows = policy.maxRows;
          final canShowExecute =
              canExecuteRole &&
              canShowExecuteButton(role: user!.role, status: job.status);
          final executeEnabled = !isExecuteDisabledByPolicy(
            provisioningAvailable: job.provisioningAvailable,
            policyEnabled: policy.enabled,
            rowCount: rowCount,
            maxRows: maxRows,
          );
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                job.companyName,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              BulkOnboardingStatusBadge(status: job.status),
              const SizedBox(height: 16),
              BulkOnboardingValidationSummary(job: job),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  _summaryBadge(
                    context,
                    resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingSummaryDryRunOk',
                    ),
                    (summary?.dryRunOk ?? 0).toString(),
                  ),
                  _summaryBadge(
                    context,
                    resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingSummaryBlocked',
                    ),
                    (summary?.blocked ?? 0).toString(),
                  ),
                  _summaryBadge(
                    context,
                    resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingSummaryDuplicates',
                    ),
                    (summary?.duplicates ?? 0).toString(),
                  ),
                  _summaryBadge(
                    context,
                    resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingSummaryFailed',
                    ),
                    (summary?.failed ?? 0).toString(),
                  ),
                  _summaryBadge(
                    context,
                    resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingSummaryProvisioned',
                    ),
                    (summary?.provisioned ?? 0).toString(),
                  ),
                ],
              ),
              if (job.lastValidatedAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  resolveBulkOnboardingKey(
                    context,
                    'bulkOnboardingJobLastValidatedAt',
                    params: {
                      'date': DateFormat.yMMMd(
                        Localizations.localeOf(context).toString(),
                      ).add_Hm().format(job.lastValidatedAt!.toLocal()),
                    },
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 12),
              BulkOnboardingAiReviewCard(job: job),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  title: Text(
                    resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingFieldSourceFile',
                    ),
                  ),
                  subtitle: Text(job.sourceFileName ?? '—'),
                ),
              ),
              const SizedBox(height: 12),
              Card(
                child: ListTile(
                  title: Text(
                    resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingProvisioningTitle',
                    ),
                  ),
                  subtitle: Text(
                    resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingProvisioningStatus',
                      params: {
                        'status':
                            job.provisioningStatus ??
                            (job.provisioningAvailable
                                ? 'available'
                                : 'unavailable'),
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => _downloadValidationReport(context, ref),
                icon: const Icon(Icons.download_outlined),
                label: Text(
                  resolveBulkOnboardingKey(
                    context,
                    'bulkOnboardingDownloadValidationReport',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                resolveBulkOnboardingKey(
                  context,
                  'bulkOnboardingPrivacyNotice',
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (canDecide) ...[
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: () => _runAction(
                        context,
                        ref,
                        BulkOnboardingActionKind.validate,
                        job.processingAvailable,
                      ),
                      child: Text(
                        resolveBulkOnboardingKey(
                          context,
                          'bulkOnboardingActionValidate',
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => _revalidateJob(context, ref),
                      child: Text(
                        resolveBulkOnboardingKey(
                          context,
                          'bulkOnboardingJobRevalidateAction',
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => _runAction(
                        context,
                        ref,
                        BulkOnboardingActionKind.approve,
                        job.processingAvailable,
                      ),
                      child: Text(
                        resolveBulkOnboardingKey(
                          context,
                          'bulkOnboardingActionApprove',
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => _runAction(
                        context,
                        ref,
                        BulkOnboardingActionKind.reject,
                        job.processingAvailable,
                      ),
                      child: Text(
                        resolveBulkOnboardingKey(
                          context,
                          'bulkOnboardingActionReject',
                        ),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => _runAction(
                        context,
                        ref,
                        BulkOnboardingActionKind.cancel,
                        job.processingAvailable,
                      ),
                      child: Text(
                        resolveBulkOnboardingKey(
                          context,
                          'bulkOnboardingActionCancel',
                        ),
                      ),
                    ),
                    FilledButton(
                      onPressed: canDecide ? _dryRun : null,
                      child: Text(
                        resolveBulkOnboardingKey(
                          context,
                          'bulkOnboardingDryRunAction',
                        ),
                      ),
                    ),
                    if (canShowExecute)
                      FilledButton(
                        onPressed: executeEnabled
                            ? () => _execute(rowCount, maxRows)
                            : null,
                        child: Text(
                          executeEnabled
                              ? resolveBulkOnboardingKey(
                                  context,
                                  'bulkOnboardingExecuteAction',
                                )
                              : resolveBulkOnboardingKey(
                                  context,
                                  'bulkOnboardingExecuteDisabled',
                                ),
                        ),
                      ),
                  ],
                ),
                if (canShowExecute && !policy.enabled) ...[
                  const SizedBox(height: 8),
                  Text(
                    resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingExecutePolicyDisabled',
                      params: {'reason': policy.reason ?? 'policy_restricted'},
                    ),
                    style: Theme.of(
                      context,
                    ).textTheme.bodySmall?.copyWith(color: Colors.orange),
                  ),
                ],
                if (_lastExecutionResult?.rows.isNotEmpty ?? false) ...[
                  const SizedBox(height: 16),
                  Text(
                    resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingRowExecutionStatusesTitle',
                    ),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  ..._lastExecutionResult!.rows
                      .take(8)
                      .map(
                        (row) => ListTile(
                          dense: true,
                          contentPadding: EdgeInsets.zero,
                          title: Text('Row #${row.rowIndex}'),
                          subtitle: row.reason == null
                              ? null
                              : Text(row.reason!),
                          trailing: BulkOnboardingStatusBadge(
                            status: _statusFromRow(row.status),
                          ),
                        ),
                      ),
                ],
              ],
            ],
          );
        },
      ),
    );
  }

  BulkOnboardingJobStatus _statusFromRow(BulkOnboardingRowStatus status) {
    return switch (status) {
      BulkOnboardingRowStatus.processed => BulkOnboardingJobStatus.completed,
      BulkOnboardingRowStatus.failed =>
        BulkOnboardingJobStatus.validationFailed,
      _ => BulkOnboardingJobStatus.readyForReview,
    };
  }

  Widget _summaryBadge(BuildContext context, String label, String value) {
    return Chip(label: Text('$label: $value'));
  }

  Future<void> _runAction(
    BuildContext context,
    WidgetRef ref,
    BulkOnboardingActionKind kind,
    bool processingAvailable,
  ) async {
    final request = await showBulkOnboardingActionDialog(
      context: context,
      kind: kind,
      processingAvailable: processingAvailable,
    );
    if (request == null) return;

    final validationError = request.validate();
    if (validationError != null) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolveBulkOnboardingKey(context, validationError)),
        ),
      );
      return;
    }

    try {
      await submitBulkOnboardingAction(
        ref,
        jobId: widget.jobId,
        request: request,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(context, 'bulkOnboardingActionSuccess'),
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(
              context,
              'bulkOnboardingActionUnavailable',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _downloadValidationReport(
    BuildContext context,
    WidgetRef ref,
  ) async {
    try {
      final csv = await ref
          .read(bulkOnboardingRepositoryProvider)
          .downloadValidationReport(widget.jobId);
      await Clipboard.setData(ClipboardData(text: csv));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(
              context,
              'bulkOnboardingValidationReportCopied',
            ),
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(
              context,
              'bulkOnboardingValidationReportFailed',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _revalidateJob(BuildContext context, WidgetRef ref) async {
    try {
      await submitBulkOnboardingJobRevalidate(ref, jobId: widget.jobId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(
              context,
              'bulkOnboardingJobRevalidateSuccess',
            ),
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(
              context,
              'bulkOnboardingRowActionUnavailable',
            ),
          ),
        ),
      );
    }
  }

  Future<void> _dryRun() async {
    try {
      final result = await submitBulkOnboardingDryRun(ref, jobId: widget.jobId);
      if (!mounted) return;
      setState(() => _lastExecutionResult = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(context, 'bulkOnboardingDryRunSuccess'),
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      showApiExceptionSnackBar(context, error);
    }
  }

  Future<void> _execute(int rowCount, int? maxRows) async {
    final request = await showBulkOnboardingExecuteDialog(
      context: context,
      rowCount: rowCount,
      maxRows: maxRows,
    );
    if (request == null) return;
    final validationError = request.validate();
    if (validationError != null) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolveBulkOnboardingKey(context, validationError)),
        ),
      );
      return;
    }
    try {
      final result = await submitBulkOnboardingExecute(
        ref,
        jobId: widget.jobId,
        request: request,
      );
      if (!mounted) return;
      setState(() => _lastExecutionResult = result);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(context, 'bulkOnboardingExecuteSuccess'),
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      showApiExceptionSnackBar(context, error);
    }
  }
}
