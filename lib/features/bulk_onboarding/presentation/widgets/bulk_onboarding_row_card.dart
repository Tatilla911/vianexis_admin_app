import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_row.dart';

class BulkOnboardingRowCard extends StatelessWidget {
  const BulkOnboardingRowCard({
    super.key,
    required this.row,
    this.onTap,
  });

  final BulkOnboardingRow row;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              row.displayLabel ??
                  row.name ??
                  row.email ??
                  '#${row.rowIndex}',
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 4),
            Text(
              resolveBulkOnboardingKey(
                context,
                row.status.localizationKey(),
              ),
            ),
            if (row.email != null) ...[
              const SizedBox(height: 4),
              Text(row.email!),
            ],
            if (row.duplicateReason != null) ...[
              const SizedBox(height: 4),
              Text(
                resolveBulkOnboardingKey(
                  context,
                  'bulkOnboardingDuplicateReason',
                  params: {'reason': row.duplicateReason!},
                ),
              ),
            ],
            if (row.validationErrors.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(resolveBulkOnboardingKey(context, 'bulkOnboardingValidationErrors')),
              for (final error in row.validationErrors)
                Text('• $error', style: const TextStyle(color: Colors.red)),
            ],
          ],
        ),
      ),
      ),
    );
  }
}
