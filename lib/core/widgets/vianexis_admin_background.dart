import 'package:flutter/material.dart';

import '../../app/vianexis_brand.dart';
import 'vianexis_watermark_background.dart';

/// Branded deep-navy screen background with optional gradient and watermark.
class VianexisAdminBackground extends StatelessWidget {
  const VianexisAdminBackground({
    super.key,
    required this.child,
    this.showWatermark = true,
    this.showGradient = true,
  });

  final Widget child;
  final bool showWatermark;
  final bool showGradient;

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const ColoredBox(color: VianexisBrand.backgroundNavy),
        if (showGradient)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  VianexisBrand.backgroundNavy,
                  VianexisBrand.panelNavy,
                  VianexisBrand.backgroundNavy.withValues(alpha: 0.96),
                ],
              ),
              image: showWatermark
                  ? const DecorationImage(
                      image: AssetImage(VianexisBrand.backgroundAsset),
                      fit: BoxFit.cover,
                      opacity: 0.18,
                    )
                  : null,
            ),
          ),
        if (showWatermark) const VianexisWatermarkBackground(),
        child,
      ],
    );
  }
}
