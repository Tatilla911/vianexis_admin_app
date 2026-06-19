import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_status.dart';

class BulkOnboardingStatusBadge extends StatelessWidget {
  const BulkOnboardingStatusBadge({super.key, required this.status});

  final BulkOnboardingJobStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      BulkOnboardingJobStatus.readyForReview => Colors.orange,
      BulkOnboardingJobStatus.validationFailed ||
      BulkOnboardingJobStatus.rejected => Colors.red,
      BulkOnboardingJobStatus.completed ||
      BulkOnboardingJobStatus.partiallyCompleted => Colors.green,
      BulkOnboardingJobStatus.processing ||
      BulkOnboardingJobStatus.approvedForProcessing => Colors.blue,
      BulkOnboardingJobStatus.cancelled => Colors.grey,
      _ => Colors.blueGrey,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        resolveBulkOnboardingKey(context, status.localizationKey()),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
      ),
    );
  }
}
