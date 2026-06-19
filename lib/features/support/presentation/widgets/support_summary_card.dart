import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/support_ticket.dart';

class SupportSummaryCard extends StatelessWidget {
  const SupportSummaryCard({
    super.key,
    required this.summary,
    this.compact = false,
  });

  final SupportSummary summary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final updated = summary.lastUpdatedAt;
    final updatedLabel = updated != null
        ? DateFormat.yMMMd(locale).add_Hm().format(updated.toLocal())
        : '—';

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveSupportKey(context, 'supportSummaryTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: [
                _MetricChip(
                  label: resolveSupportKey(context, 'supportSummaryOpenTickets'),
                  value: '${summary.openTicketsCount}',
                ),
                _MetricChip(
                  label: resolveSupportKey(context, 'supportSummaryUrgentCritical'),
                  value: '${summary.urgentCriticalTicketsCount}',
                ),
                _MetricChip(
                  label: resolveSupportKey(context, 'supportSummaryActiveGrants'),
                  value: '${summary.activeSupportAccessGrantsCount}',
                ),
              ],
            ),
            if (!compact) ...[
              const SizedBox(height: 12),
              Text(
                resolveSupportKey(
                  context,
                  'supportSummaryLastUpdated',
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
}

class _MetricChip extends StatelessWidget {
  const _MetricChip({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Theme.of(context).dividerColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.bodySmall),
          Text(value, style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}
