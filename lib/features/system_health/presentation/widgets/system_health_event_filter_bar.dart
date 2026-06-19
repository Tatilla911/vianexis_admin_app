import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/system_health_event.dart';

class SystemHealthEventFilterBar extends StatelessWidget {
  const SystemHealthEventFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final SystemHealthEventFilter selected;
  final ValueChanged<SystemHealthEventFilter> onSelected;

  static const filters = [
    SystemHealthEventFilter.all,
    SystemHealthEventFilter.critical,
    SystemHealthEventFilter.warning,
    SystemHealthEventFilter.open,
    SystemHealthEventFilter.acknowledged,
    SystemHealthEventFilter.resolved,
    SystemHealthEventFilter.tenantImpacting,
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final filter in filters)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                label: Text(resolveSystemHealthKey(context, filter.localizationKey())),
                selected: selected == filter,
                onSelected: (_) => onSelected(filter),
              ),
            ),
        ],
      ),
    );
  }
}
