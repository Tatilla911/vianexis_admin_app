import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/customer_communication_thread.dart';

class CustomerCommunicationsFilterBar extends StatelessWidget {
  const CustomerCommunicationsFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final CustomerCommunicationListFilter selected;
  final ValueChanged<CustomerCommunicationListFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: CustomerCommunicationListFilter.values.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              selected: selected == filter,
              label: Text(
                resolveCustomerCommunicationsKey(
                  context,
                  filter.localizationKey(),
                ),
              ),
              onSelected: (_) => onSelected(filter),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}

class CustomerCommunicationsSummaryCard extends StatelessWidget {
  const CustomerCommunicationsSummaryCard({
    super.key,
    required this.summary,
    this.compact = false,
  });

  final CustomerCommunicationSummary summary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationSummaryTitle',
              ),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Wrap(
              spacing: 12,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(
                    resolveCustomerCommunicationsKey(
                      context,
                      'customerCommunicationSummaryDisputed',
                      params: {'count': '${summary.disputedCount}'},
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    resolveCustomerCommunicationsKey(
                      context,
                      'customerCommunicationSummaryOpen',
                      params: {'count': '${summary.openCount}'},
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    resolveCustomerCommunicationsKey(
                      context,
                      'customerCommunicationSummaryTotal',
                      params: {'count': '${summary.totalCount}'},
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
