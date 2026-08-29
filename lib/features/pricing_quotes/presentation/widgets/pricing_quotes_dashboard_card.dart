import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../l10n/app_localizations.dart';
import '../pricing_quotes_providers.dart';

class PricingQuotesDashboardCard extends StatelessWidget {
  const PricingQuotesDashboardCard({super.key, required this.summary});

  final PricingQuotesDashboardSummary summary;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: InkWell(
        onTap: () => context.push(AdminRoutes.pricingQuotes),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(
                    Icons.request_quote_outlined,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.navPricingQuotes,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                l10n.pricingQuotesDashboardReviewRequired(
                  summary.reviewRequiredCount.toString(),
                ),
              ),
              Text(
                l10n.pricingQuotesDashboardNew(summary.newCount.toString()),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
