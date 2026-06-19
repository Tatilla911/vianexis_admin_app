import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/registration_application_status.dart';

class RegistrationStatusFilterBar extends StatelessWidget {
  const RegistrationStatusFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final RegistrationListFilter selected;
  final ValueChanged<RegistrationListFilter> onSelected;

  static const filters = [
    RegistrationListFilter.all,
    RegistrationListFilter.pending,
    RegistrationListFilter.needsInfo,
    RegistrationListFilter.aiReviewed,
    RegistrationListFilter.approved,
    RegistrationListFilter.rejected,
    RegistrationListFilter.highRisk,
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
                label: Text(resolveRegistrationKey(context, filter.localizationKey())),
                selected: selected == filter,
                onSelected: (_) => onSelected(filter),
              ),
            ),
        ],
      ),
    );
  }
}
