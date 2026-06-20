import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/pricing_intake.dart';
import '../../domain/pricing_intake_status.dart';

class PricingIntakeCard extends StatelessWidget {
  const PricingIntakeCard({
    super.key,
    required this.intake,
    this.onTap,
  });

  final PricingIntake intake;
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      intake.companyName ??
                          resolveBillingKey(
                            context,
                            'billingFieldCompanyId',
                            params: {'id': intake.companyId},
                          ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  _StatusChip(status: intake.status),
                ],
              ),
              if (intake.contactEmail != null) ...[
                const SizedBox(height: 4),
                Text(intake.contactEmail!),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (intake.fleetSize != null)
                    Text(
                      resolveBillingKey(
                        context,
                        'billingMetricFleetSize',
                        params: {'count': '${intake.fleetSize}'},
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (intake.officeUsers != null)
                    Text(
                      resolveBillingKey(
                        context,
                        'billingMetricOfficeUsers',
                        params: {'count': '${intake.officeUsers}'},
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (intake.needsHumanReview)
                    Text(
                      resolveBillingKey(context, 'billingPricingIntakeNeedsReview'),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.status});

  final PricingIntakeStatus status;

  @override
  Widget build(BuildContext context) {
    final color = switch (status) {
      PricingIntakeStatus.newIntake => Colors.blue,
      PricingIntakeStatus.reviewing => Colors.orange,
      PricingIntakeStatus.quoted => Colors.deepPurple,
      PricingIntakeStatus.accepted => Colors.green,
      PricingIntakeStatus.rejected => Colors.red,
      PricingIntakeStatus.unknown => Colors.black54,
    };

    return Chip(
      label: Text(resolveBillingKey(context, status.localizationKey())),
      backgroundColor: color.withValues(alpha: 0.12),
      side: BorderSide(color: color.withValues(alpha: 0.4)),
    );
  }
}
