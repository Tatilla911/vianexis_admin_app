import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/ai_review_item.dart';

class AiReviewFilterBar extends StatelessWidget {
  const AiReviewFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final AiReviewFilter selected;
  final ValueChanged<AiReviewFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: AiReviewFilter.values.map((filter) {
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(resolveAiReviewKey(context, filter.localizationKey())),
              selected: selected == filter,
              onSelected: (_) => onSelected(filter),
            ),
          );
        }).toList(),
      ),
    );
  }
}
