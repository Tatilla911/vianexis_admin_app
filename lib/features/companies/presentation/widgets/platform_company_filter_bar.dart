import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_company.dart';

class PlatformCompanyFilterBar extends StatelessWidget {
  const PlatformCompanyFilterBar({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final PlatformCompanyListFilter selected;
  final ValueChanged<PlatformCompanyListFilter> onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          for (final filter in PlatformCompanyListFilter.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: FilterChip(
                selected: selected == filter,
                label: Text(_label(context, filter)),
                onSelected: (_) => onSelected(filter),
              ),
            ),
        ],
      ),
    );
  }

  String _label(BuildContext context, PlatformCompanyListFilter filter) {
    return switch (filter) {
      PlatformCompanyListFilter.all =>
        resolvePlatformCompanyKey(context, 'platformCompanyFilterAll'),
      PlatformCompanyListFilter.active =>
        resolvePlatformCompanyKey(context, 'platformCompanyFilterActive'),
      PlatformCompanyListFilter.pendingReview =>
        resolvePlatformCompanyKey(context, 'platformCompanyFilterPendingReview'),
      PlatformCompanyListFilter.suspended =>
        resolvePlatformCompanyKey(context, 'platformCompanyFilterSuspended'),
      PlatformCompanyListFilter.disabled =>
        resolvePlatformCompanyKey(context, 'platformCompanyFilterDisabled'),
    };
  }
}
