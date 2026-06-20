import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_subscription.dart';
import 'subscription_status_badge.dart';

class SubscriptionCard extends StatelessWidget {
  const SubscriptionCard({
    super.key,
    required this.subscription,
    this.onTap,
  });

  final PlatformSubscription subscription;
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
                      subscription.companyName ??
                          resolveBillingKey(
                            context,
                            'billingFieldCompanyId',
                            params: {'id': subscription.companyId},
                          ),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SubscriptionStatusBadge(status: subscription.status),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                [
                  if (subscription.planName != null) subscription.planName,
                  if (subscription.billingCycle != null) subscription.billingCycle,
                ].join(' · '),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  if (subscription.seatsUsed != null && subscription.seatsIncluded != null)
                    Text(
                      resolveBillingKey(
                        context,
                        'billingMetricSeats',
                        params: {
                          'used': '${subscription.seatsUsed}',
                          'included': '${subscription.seatsIncluded}',
                        },
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                  if (subscription.driverAppsUsed != null &&
                      subscription.driverAppsIncluded != null)
                    Text(
                      resolveBillingKey(
                        context,
                        'billingMetricDriverApps',
                        params: {
                          'used': '${subscription.driverAppsUsed}',
                          'included': '${subscription.driverAppsIncluded}',
                        },
                      ),
                      style: Theme.of(context).textTheme.bodySmall,
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
