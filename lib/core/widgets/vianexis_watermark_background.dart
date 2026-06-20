import 'package:flutter/material.dart';

import '../../app/vianexis_brand.dart';

/// Subtle centered watermark — asset when available, painted fallback otherwise.
class VianexisWatermarkBackground extends StatelessWidget {
  const VianexisWatermarkBackground({super.key, this.opacity = 0.06});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Opacity(
          opacity: opacity,
          child: Image.asset(
            VianexisBrand.watermarkAsset,
            width: 320,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) => _FallbackWatermark(opacity: opacity),
          ),
        ),
      ),
    );
  }
}

class _FallbackWatermark extends StatelessWidget {
  const _FallbackWatermark({required this.opacity});

  final double opacity;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity * 8,
      child: Container(
        width: 220,
        height: 220,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: VianexisBrand.viaNexisBlue.withValues(alpha: 0.25)),
        ),
        alignment: Alignment.center,
        child: Text(
          'VN',
          style: TextStyle(
            fontSize: 96,
            fontWeight: FontWeight.w700,
            color: VianexisBrand.textPrimary.withValues(alpha: 0.12),
            letterSpacing: 4,
          ),
        ),
      ),
    );
  }
}
