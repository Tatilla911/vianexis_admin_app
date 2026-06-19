import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_job.dart';

class BulkOnboardingAiReviewCard extends StatelessWidget {
  const BulkOnboardingAiReviewCard({super.key, required this.job});

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
              resolveBulkOnboardingKey(context, 'bulkOnboardingAiReviewTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingAiAdvisoryNotice'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            if (job.aiSummary != null) Text(job.aiSummary!),
            if (job.recommendedAction != null) ...[
              const SizedBox(height: 8),
              Text(
                resolveBulkOnboardingKey(
                  context,
                  'bulkOnboardingRecommendedAction',
                  params: {'action': job.recommendedAction ?? ''},
                ),
              ),
            ],
            const SizedBox(height: 8),
            Text(
              resolveBulkOnboardingKey(
                context,
                job.riskLevel.localizationKey(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
