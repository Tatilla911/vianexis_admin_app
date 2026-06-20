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
import 'bulk_onboarding_providers.dart';
import 'widgets/bulk_onboarding_ai_review_card.dart';
import 'widgets/bulk_onboarding_action_dialog.dart';
import 'widgets/bulk_onboarding_status_badge.dart';
import 'widgets/bulk_onboarding_validation_summary.dart';

class BulkOnboardingJobDetailScreen extends ConsumerWidget {
  const BulkOnboardingJobDetailScreen({super.key, required this.jobId});

  final String jobId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final jobAsync = ref.watch(bulkOnboardingJobDetailProvider(jobId));
    final user = ref.watch(adminAuthProvider).user;
    final canDecide = user?.role.canDecideBulkOnboarding ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bulkOnboardingDetailTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.table_rows_outlined),
            tooltip: resolveBulkOnboardingKey(context, 'bulkOnboardingOpenRows'),
            onPressed: () => context.push(AdminRoutes.bulkOnboardingJobRows(jobId)),
          ),
        ],
      ),
      body: jobAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveBulkOnboardingKey(context, 'bulkOnboardingDetailError'),
          onRetry: () => ref.invalidate(bulkOnboardingJobDetailProvider(jobId)),
        ),
        data: (job) {
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
                  title: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingFieldSourceFile')),
                  subtitle: Text(job.sourceFileName ?? '—'),
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
                resolveBulkOnboardingKey(context, 'bulkOnboardingPrivacyNotice'),
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
                        resolveBulkOnboardingKey(context, 'bulkOnboardingActionValidate'),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => _revalidateJob(context, ref),
                      child: Text(
                        resolveBulkOnboardingKey(context, 'bulkOnboardingJobRevalidateAction'),
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
                        resolveBulkOnboardingKey(context, 'bulkOnboardingActionApprove'),
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
                        resolveBulkOnboardingKey(context, 'bulkOnboardingActionReject'),
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
                        resolveBulkOnboardingKey(context, 'bulkOnboardingActionCancel'),
                      ),
                    ),
                    FilledButton(
                      onPressed: job.processingAvailable
                          ? () => _runAction(
                              context,
                              ref,
                              BulkOnboardingActionKind.process,
                              job.processingAvailable,
                            )
                          : null,
                      child: Text(
                        job.processingAvailable
                            ? resolveBulkOnboardingKey(context, 'bulkOnboardingActionProcess')
                            : resolveBulkOnboardingKey(
                                context,
                                'bulkOnboardingProcessDisabled',
                              ),
                      ),
                    ),
                  ],
                ),
              ],
            ],
          );
        },
      ),
    );
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
        SnackBar(content: Text(resolveBulkOnboardingKey(context, validationError))),
      );
      return;
    }

    try {
      await submitBulkOnboardingAction(ref, jobId: jobId, request: request);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingActionSuccess')),
        ),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingActionUnavailable')),
        ),
      );
    }
  }

  Future<void> _downloadValidationReport(BuildContext context, WidgetRef ref) async {
    try {
      final csv = await ref
          .read(bulkOnboardingRepositoryProvider)
          .downloadValidationReport(jobId);
      await Clipboard.setData(ClipboardData(text: csv));
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(context, 'bulkOnboardingValidationReportCopied'),
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
            resolveBulkOnboardingKey(context, 'bulkOnboardingValidationReportFailed'),
          ),
        ),
      );
    }
  }

  Future<void> _revalidateJob(BuildContext context, WidgetRef ref) async {
    try {
      await submitBulkOnboardingJobRevalidate(ref, jobId: jobId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(context, 'bulkOnboardingJobRevalidateSuccess'),
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
            resolveBulkOnboardingKey(context, 'bulkOnboardingRowActionUnavailable'),
          ),
        ),
      );
    }
  }
}
