import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_job.dart';

class BulkOnboardingFilterBar extends StatelessWidget {
  const BulkOnboardingFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final BulkOnboardingListFilter selected;
  final ValueChanged<BulkOnboardingListFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final filter in BulkOnboardingListFilter.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: selected == filter,
                label: Text(_label(context, filter)),
                onSelected: (_) => onSelected(filter),
              ),
            ),
        ],
      ),
    );
  }

  String _label(BuildContext context, BulkOnboardingListFilter filter) {
    return switch (filter) {
      BulkOnboardingListFilter.all => resolveBulkOnboardingKey(context, 'bulkOnboardingFilterAll'),
      BulkOnboardingListFilter.readyForReview =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingFilterReadyForReview'),
      BulkOnboardingListFilter.validationFailed =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingFilterValidationFailed'),
      BulkOnboardingListFilter.processing =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingFilterProcessing'),
      BulkOnboardingListFilter.completed =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingFilterCompleted'),
      BulkOnboardingListFilter.rejected =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingFilterRejected'),
      BulkOnboardingListFilter.highRisk =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingFilterHighRisk'),
    };
  }
}
