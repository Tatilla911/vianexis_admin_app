import 'package:flutter/material.dart';

import '../../app/vianexis_brand.dart';

/// Section title with optional trailing action for module screens.
class VianexisSectionHeader extends StatelessWidget {
  const VianexisSectionHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.trailing,
  });

  final String title;
  final String? subtitle;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: VianexisBrand.sectionTitleStyle(context)),
              if (subtitle case final text?) ...[
                const SizedBox(height: VianexisBrand.spaceXs),
                Text(text, style: Theme.of(context).textTheme.bodySmall),
              ],
            ],
          ),
        ),
        ?trailing,
      ],
    );
  }
}
