import 'package:flutter/material.dart';

import '../../app/vianexis_brand.dart';
import 'vianexis_watermark_background.dart';

/// Branded screen background — navy (night) or light day mode.
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
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final base = VianexisBrand.scaffoldOf(brightness);
    final panel = VianexisBrand.panelOf(brightness);

    return Stack(
      fit: StackFit.expand,
      children: [
        ColoredBox(color: base),
        if (showGradient)
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [
                        base,
                        panel,
                        base.withValues(alpha: 0.96),
                      ]
                    : [
                        const Color(0xFFF7F9FC),
                        base,
                        const Color(0xFFEAF0F7),
                      ],
              ),
              image: showWatermark
                  ? DecorationImage(
                      image: const AssetImage(VianexisBrand.backgroundAsset),
                      fit: BoxFit.cover,
                      opacity: isDark ? 0.14 : 0.06,
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
