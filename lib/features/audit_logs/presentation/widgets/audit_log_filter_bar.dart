import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_audit_filter.dart';

class AuditLogFilterBar extends StatelessWidget {
  const AuditLogFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final PlatformAuditLogFilter selected;
  final ValueChanged<PlatformAuditLogFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: PlatformAuditLogFilter.values.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(resolveAuditLogKey(context, filter.localizationKey())),
              selected: selected == filter,
              onSelected: (_) => onSelected(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}
