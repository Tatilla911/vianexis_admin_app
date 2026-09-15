import 'package:flutter/material.dart';

import '../../app/vianexis_brand.dart';

enum VianexisMetricTone { neutral, success, warning, danger, info }

/// Compact metric tile for dashboard operational counts.
class VianexisMetricTile extends StatelessWidget {
  const VianexisMetricTile({
    super.key,
    required this.label,
    required this.value,
    this.tone = VianexisMetricTone.neutral,
    this.icon,
  });

  final String label;
  final String value;
  final VianexisMetricTone tone;
  final IconData? icon;

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;
    final accent = switch (tone) {
      VianexisMetricTone.success => VianexisBrand.success,
      VianexisMetricTone.warning => VianexisBrand.warning,
      VianexisMetricTone.danger => VianexisBrand.danger,
      VianexisMetricTone.info => VianexisBrand.info,
      VianexisMetricTone.neutral =>
        isDark ? VianexisBrand.goldAccent : VianexisBrand.accentBlue,
    };
    final panel = isDark
        ? VianexisBrand.panelNavy.withValues(alpha: 0.72)
        : VianexisBrand.panelLight;
    final labelColor = VianexisBrand.textSecondaryOf(brightness);
    final valueColor = VianexisBrand.textPrimaryOf(brightness);

    return Container(
      constraints: const BoxConstraints(minWidth: 148),
      padding: const EdgeInsets.symmetric(
        horizontal: VianexisBrand.spaceMd,
        vertical: VianexisBrand.spaceMd,
      ),
      decoration: BoxDecoration(
        color: panel,
        borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
        border: Border.all(color: accent.withValues(alpha: 0.35)),
        boxShadow: isDark
            ? null
            : [VianexisBrand.cardShadow(brightness)],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: accent),
                const SizedBox(width: VianexisBrand.spaceSm),
              ],
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.labelMedium?.copyWith(
                    color: labelColor,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: VianexisBrand.spaceSm),
          Text(
            value,
            style: VianexisBrand.displayStyle(
              fontSize:
                  Theme.of(context).textTheme.titleLarge?.fontSize ?? 22,
              fontWeight: FontWeight.w700,
              color: valueColor,
            ),
          ),
        ],
      ),
    );
  }
}
