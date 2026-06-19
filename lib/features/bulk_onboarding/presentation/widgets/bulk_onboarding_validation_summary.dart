import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_job.dart';

class BulkOnboardingValidationSummary extends StatelessWidget {
  const BulkOnboardingValidationSummary({super.key, required this.job});

  final BulkOnboardingJob job;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingValidationSummaryTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _countChip(context, 'bulkOnboardingMetricValidRows', job.validRows),
                _countChip(context, 'bulkOnboardingMetricWarningRows', job.warningRows),
                _countChip(context, 'bulkOnboardingMetricInvalidRows', job.invalidRows),
                _countChip(context, 'bulkOnboardingMetricDuplicateRows', job.duplicateRows),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _countChip(BuildContext context, String key, int count) {
    return Chip(
      label: Text(
        resolveBulkOnboardingKey(context, key, params: {'count': '$count'}),
      ),
    );
  }
}
