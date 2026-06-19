import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_dashboard_summary.dart';

class BulkOnboardingSummaryCard extends StatelessWidget {
  const BulkOnboardingSummaryCard({
    super.key,
    required this.summary,
    this.compact = false,
  });

  final BulkOnboardingDashboardSummary summary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final padding = compact ? 16.0 : 20.0;
    return Card(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingDashboardTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _MetricChip(
                  label: resolveBulkOnboardingKey(
                    context,
                    'bulkOnboardingDashboardWaitingReview',
                  ),
                  value: '${summary.jobsWaitingForReview}',
                ),
                _MetricChip(
                  label: resolveBulkOnboardingKey(
                    context,
                    'bulkOnboardingDashboardHighRisk',
                  ),
                  value: '${summary.highRiskJobs}',
                ),
                _MetricChip(
                  label: resolveBulkOnboardingKey(
                    context,
                    'bulkOnboardingDashboardInvalidRows',
                  ),
                  value: '${summary.invalidRows}',
                ),
                _MetricChip(
                  label: resolveBulkOnboardingKey(
                    context,
                    'bulkOnboardingDashboardProcessing',
                  ),
                  value: '${summary.processingJobs}',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Chip(label: Text('$label: $value'));
  }
}
