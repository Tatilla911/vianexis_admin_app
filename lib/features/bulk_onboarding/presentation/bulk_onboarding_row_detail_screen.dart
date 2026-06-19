import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/auth/admin_auth_state.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/bulk_onboarding_row.dart';
import '../domain/bulk_onboarding_row_status.dart';
import 'bulk_onboarding_providers.dart';
import 'widgets/bulk_onboarding_row_correction_dialog.dart';
import 'widgets/bulk_onboarding_row_skip_dialog.dart';

class BulkOnboardingRowDetailScreen extends ConsumerWidget {
  const BulkOnboardingRowDetailScreen({
    super.key,
    required this.jobId,
    required this.rowId,
  });

  final String jobId;
  final String rowId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final rowAsync = ref.watch(
      bulkOnboardingRowDetailProvider((jobId: jobId, rowId: rowId)),
    );
    final canDecide = ref.watch(adminAuthProvider).user?.role.canDecideBulkOnboarding ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bulkOnboardingRowDetailTitle)),
      body: rowAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView(
          message: resolveBulkOnboardingKey(context, 'bulkOnboardingRowDetailError'),
          onRetry: () => ref.invalidate(
            bulkOnboardingRowDetailProvider((jobId: jobId, rowId: rowId)),
          ),
        ),
        data: (row) {
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                row.displayLabel ??
                    row.name ??
                    row.email ??
                    '#${row.rowIndex}',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 8),
              Text(
                resolveBulkOnboardingKey(context, row.status.localizationKey()),
              ),
              if (row.lastValidatedAt != null) ...[
                const SizedBox(height: 8),
                Text(
                  resolveBulkOnboardingKey(
                    context,
                    'bulkOnboardingRowLastValidatedAt',
                    params: {'date': _formatDate(context, row.lastValidatedAt!)},
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 16),
              _ValuesCard(
                titleKey: 'bulkOnboardingRowOriginalValuesTitle',
                values: row.originalValues ?? _currentValuesMap(row),
              ),
              if (row.correctedValues != null && row.correctedValues!.isNotEmpty) ...[
                const SizedBox(height: 12),
                _ValuesCard(
                  titleKey: 'bulkOnboardingRowCorrectedValuesTitle',
                  values: row.correctedValues!,
                ),
              ],
              if (row.correctionNote != null && row.correctionNote!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    title: Text(
                      resolveBulkOnboardingKey(context, 'bulkOnboardingRowCorrectionNoteLabel'),
                    ),
                    subtitle: Text(row.correctionNote!),
                  ),
                ),
              ],
              if (row.skipReason != null && row.skipReason!.isNotEmpty) ...[
                const SizedBox(height: 12),
                Card(
                  child: ListTile(
                    title: Text(
                      resolveBulkOnboardingKey(context, 'bulkOnboardingRowSkipReasonLabel'),
                    ),
                    subtitle: Text(row.skipReason!),
                  ),
                ),
              ],
              if (row.validationErrors.isNotEmpty) ...[
                const SizedBox(height: 12),
                _IssueList(
                  titleKey: 'bulkOnboardingValidationErrors',
                  items: row.validationErrors,
                  color: Colors.red,
                ),
              ],
              if (row.validationWarnings.isNotEmpty) ...[
                const SizedBox(height: 12),
                _IssueList(
                  titleKey: 'bulkOnboardingValidationWarnings',
                  items: row.validationWarnings,
                  color: Colors.orange,
                ),
              ],
              const SizedBox(height: 12),
              Text(
                resolveBulkOnboardingKey(context, 'bulkOnboardingPrivacyNotice'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              if (canDecide && row.status != BulkOnboardingRowStatus.skipped) ...[
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    OutlinedButton(
                      onPressed: () => _correctRow(context, ref, row),
                      child: Text(
                        resolveBulkOnboardingKey(context, 'bulkOnboardingRowCorrectionAction'),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => _skipRow(context, ref),
                      child: Text(
                        resolveBulkOnboardingKey(context, 'bulkOnboardingRowSkipAction'),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: () => _revalidateRow(context, ref),
                      child: Text(
                        resolveBulkOnboardingKey(context, 'bulkOnboardingRowRevalidateAction'),
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

  Map<String, dynamic> _currentValuesMap(BulkOnboardingRow row) {
    return {
      if (row.name != null) 'name': row.name,
      if (row.email != null) 'email': row.email,
      if (row.phone != null) 'phone': row.phone,
      if (row.country != null) 'country': row.country,
      if (row.role != null) 'role': row.role,
      if (row.vehiclePlate != null) 'vehiclePlate': row.vehiclePlate,
      if (row.trailerPlate != null) 'trailerPlate': row.trailerPlate,
    };
  }

  String _formatDate(BuildContext context, DateTime value) {
    return DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .add_Hm()
        .format(value.toLocal());
  }

  Future<void> _correctRow(
    BuildContext context,
    WidgetRef ref,
    BulkOnboardingRow row,
  ) async {
    final request = await showBulkOnboardingRowCorrectionDialog(
      context: context,
      row: row,
    );
    if (request == null) return;

    try {
      await submitBulkOnboardingRowCorrection(
        ref,
        jobId: jobId,
        rowId: rowId,
        request: request,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(context, 'bulkOnboardingRowActionSuccess'),
          ),
        ),
      );
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

  Future<void> _skipRow(BuildContext context, WidgetRef ref) async {
    final request = await showBulkOnboardingRowSkipDialog(context: context);
    if (request == null) return;

    try {
      await submitBulkOnboardingRowSkip(
        ref,
        jobId: jobId,
        rowId: rowId,
        request: request,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(context, 'bulkOnboardingRowActionSuccess'),
          ),
        ),
      );
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

  Future<void> _revalidateRow(BuildContext context, WidgetRef ref) async {
    try {
      await submitBulkOnboardingRowRevalidate(
        ref,
        jobId: jobId,
        rowId: rowId,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveBulkOnboardingKey(context, 'bulkOnboardingRowActionSuccess'),
          ),
        ),
      );
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

class _ValuesCard extends StatelessWidget {
  const _ValuesCard({required this.titleKey, required this.values});

  final String titleKey;
  final Map<String, dynamic> values;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveBulkOnboardingKey(context, titleKey),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final entry in values.entries)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Text('${entry.key}: ${entry.value}'),
              ),
          ],
        ),
      ),
    );
  }
}

class _IssueList extends StatelessWidget {
  const _IssueList({
    required this.titleKey,
    required this.items,
    required this.color,
  });

  final String titleKey;
  final List<String> items;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveBulkOnboardingKey(context, titleKey),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final item in items)
              Text('• $item', style: TextStyle(color: color)),
          ],
        ),
      ),
    );
  }
}
