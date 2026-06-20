import 'package:flutter/material.dart';

import '../../app/vianexis_brand.dart';

/// Standard elevated card surface for admin modules.
class VianexisAdminCard extends StatelessWidget {
  const VianexisAdminCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(VianexisBrand.spaceXl),
    this.header,
    this.onTap,
  });

  final Widget child;
  final EdgeInsetsGeometry padding;
  final Widget? header;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final content = Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: VianexisBrand.surfaceElevated,
        borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
        border: Border.all(color: VianexisBrand.borderSubtle),
        boxShadow: [VianexisBrand.cardShadow(brightness)],
      ),
      child: Padding(
        padding: padding,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (header != null) ...[
              header!,
              const SizedBox(height: VianexisBrand.spaceMd),
            ],
            child,
          ],
        ),
      ),
    );

    if (onTap == null) {
      return content;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
        child: content,
      ),
    );
  }
}
