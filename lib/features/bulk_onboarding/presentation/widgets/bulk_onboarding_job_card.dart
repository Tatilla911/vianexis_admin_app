import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_status.dart';
import 'bulk_onboarding_status_badge.dart';

class BulkOnboardingJobCard extends StatelessWidget {
  const BulkOnboardingJobCard({
    super.key,
    required this.companyName,
    required this.status,
    required this.sourceFileName,
    required this.totalRows,
    required this.invalidRows,
    required this.riskLevelKey,
    required this.onTap,
  });

  final String companyName;
  final BulkOnboardingJobStatus status;
  final String? sourceFileName;
  final int totalRows;
  final int invalidRows;
  final String riskLevelKey;
  final VoidCallback onTap;

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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      companyName,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  BulkOnboardingStatusBadge(status: status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                sourceFileName ??
                    resolveBulkOnboardingKey(context, 'bulkOnboardingNoSourceFile'),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 12,
                runSpacing: 8,
                children: [
                  Text(
                    resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingMetricTotalRows',
                      params: {'count': '$totalRows'},
                    ),
                  ),
                  Text(
                    resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingMetricInvalidRows',
                      params: {'count': '$invalidRows'},
                    ),
                  ),
                  Text(resolveBulkOnboardingKey(context, riskLevelKey)),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
