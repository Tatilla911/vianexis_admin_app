import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_upload_result.dart';
import 'bulk_onboarding_validation_summary.dart';

class BulkOnboardingUploadResultCard extends StatelessWidget {
  const BulkOnboardingUploadResultCard({
    super.key,
    required this.result,
  });

  final BulkOnboardingUploadResult result;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingUploadSuccessful'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingValidationCompleted'),
            ),
            const SizedBox(height: 12),
            BulkOnboardingValidationSummary(job: result.job),
          ],
        ),
      ),
    );
  }
}
