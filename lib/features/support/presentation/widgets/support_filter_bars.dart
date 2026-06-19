import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/support_access_grant.dart';
import '../../domain/support_ticket.dart';

class SupportTicketFilterBar extends StatelessWidget {
  const SupportTicketFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final SupportTicketListFilter selected;
  final ValueChanged<SupportTicketListFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: SupportTicketListFilter.values.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(resolveSupportKey(context, filter.localizationKey())),
              selected: selected == filter,
              onSelected: (_) => onSelected(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class SupportAccessGrantFilterBar extends StatelessWidget {
  const SupportAccessGrantFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final SupportAccessGrantListFilter selected;
  final ValueChanged<SupportAccessGrantListFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: SupportAccessGrantListFilter.values.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(resolveSupportKey(context, filter.localizationKey())),
              selected: selected == filter,
              onSelected: (_) => onSelected(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}
