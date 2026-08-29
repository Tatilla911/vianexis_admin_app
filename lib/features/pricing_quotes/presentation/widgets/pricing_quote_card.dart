import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/pricing_quote.dart';
import '../../domain/pricing_quote_review_flag.dart';
import '../pricing_quote_l10n.dart';

class PricingQuoteCard extends StatelessWidget {
  const PricingQuoteCard({
    super.key,
    required this.quote,
    this.partyName,
    this.onTap,
  });

  final PricingQuoteListItem quote;
  final String? partyName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final created = quote.createdAt == null
        ? l10n.pricingQuoteValueUnavailable
        : DateFormat.yMMMd(locale).format(quote.createdAt!.toLocal());
    final theme = Theme.of(context);

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
                      quote.publicReference,
                      style: theme.textTheme.titleMedium,
                    ),
                  ),
                  _StatusChip(
                    label: pricingQuoteStatusLabel(l10n, quote.status),
                    backend: quote.statusRaw,
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                partyName ??
                    (quote.companyId != null
                        ? l10n.pricingQuoteCompanyId(quote.companyId.toString())
                        : quote.publicIntakeId != null
                        ? l10n.pricingQuoteIntakeId(
                            quote.publicIntakeId.toString(),
                          )
                        : l10n.pricingQuoteUnknownParty),
                style: theme.textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                created,
                style: theme.textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  Text(
                    '${l10n.pricingQuoteRecurringShort}: ${formatPricingQuoteMoney(context, quote.recurringTotalNet)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    '${l10n.pricingQuoteSetupShort}: ${formatPricingQuoteMoney(context, quote.oneTimeTotalNet)}',
                    style: theme.textTheme.bodySmall,
                  ),
                  Text(
                    '${l10n.pricingQuoteConfidenceShort}: ${pricingQuoteConfidenceLabel(l10n, quote.confidence)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
              if (quote.importantReviewFlags.isNotEmpty) ...[
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    for (final flag in quote.importantReviewFlags)
                      Chip(
                        visualDensity: VisualDensity.compact,
                        backgroundColor:
                            flag ==
                                PricingQuoteReviewFlag
                                    .providerValidationPending
                                    .backendValue
                            ? theme.colorScheme.errorContainer
                            : theme.colorScheme.surfaceContainerHighest,
                        label: Text(
                          pricingQuoteFlagLabel(l10n, flag),
                          style: theme.textTheme.labelSmall,
                        ),
                      ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  const _StatusChip({required this.label, required this.backend});

  final String label;
  final String backend;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: backend,
      child: Chip(
        visualDensity: VisualDensity.compact,
        label: Text(label),
      ),
    );
  }
}
