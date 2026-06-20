import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/ai_review_item.dart';

class AiReviewChecksCard extends StatelessWidget {
  const AiReviewChecksCard({super.key, required this.review});

  final AiReviewItem review;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveAiReviewKey(context, 'aiReviewSectionChecks'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (review.checksPerformed.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                resolveAiReviewKey(context, 'aiReviewFieldChecksPerformed'),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              ...review.checksPerformed.map(
                (check) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $check'),
                ),
              ),
            ],
            if (review.missingInformation.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                resolveAiReviewKey(context, 'aiReviewFieldMissingInformation'),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              ...review.missingInformation.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $item'),
                ),
              ),
            ],
            if (review.duplicateWarnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                resolveAiReviewKey(context, 'aiReviewFieldDuplicateWarnings'),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 8),
              ...review.duplicateWarnings.map(
                (item) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $item'),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
