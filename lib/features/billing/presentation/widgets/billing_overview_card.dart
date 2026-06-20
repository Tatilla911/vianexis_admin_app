import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/billing_overview.dart';

class BillingOverviewCard extends StatelessWidget {
  const BillingOverviewCard({
    super.key,
    required this.overview,
    this.compact = false,
  });

  final BillingOverview overview;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final updated = overview.lastUpdatedAt;
    final updatedLabel = updated != null
        ? DateFormat.yMMMd(locale).add_Hm().format(updated.toLocal())
        : '—';

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveBillingKey(context, 'billingOverviewTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                _chip(context, 'billingOverviewActive', overview.activeSubscriptions),
                _chip(context, 'billingOverviewTrial', overview.trialSubscriptions),
                _chip(context, 'billingOverviewPastDue', overview.pastDueSubscriptions),
                _chip(context, 'billingOverviewSuspended', overview.suspendedSubscriptions),
                _chip(context, 'billingOverviewPricingNew', overview.pricingIntakesNew),
                _chip(context, 'billingOverviewQuotesPending', overview.quoteRequestsPending),
              ],
            ),
            if (!compact) ...[
              const SizedBox(height: 12),
              Text(
                resolveBillingKey(
                  context,
                  'billingOverviewLastUpdated',
                  params: {'date': updatedLabel},
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _chip(BuildContext context, String key, int count) {
    return Chip(
      label: Text(
        resolveBillingKey(context, key, params: {'count': '$count'}),
      ),
    );
  }
}
