import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/public_intake_status.dart';

class PublicIntakeFilterBar extends StatelessWidget {
  const PublicIntakeFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final PublicIntakeListFilter selected;
  final ValueChanged<PublicIntakeListFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: PublicIntakeListFilter.values.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(resolvePublicIntakeKey(context, filter.localizationKey())),
              selected: selected == filter,
              onSelected: (_) => onSelected(filter),
            ),
          );
        }).toList(growable: false),
      ),
    );
  }
}
