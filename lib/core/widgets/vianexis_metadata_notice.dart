import 'package:flutter/material.dart';

import '../../app/vianexis_brand.dart';
import '../../l10n/app_localizations.dart';
import 'vianexis_admin_card.dart';

/// Shared metadata-only / privacy notice styling across modules.
class VianexisMetadataNotice extends StatelessWidget {
  const VianexisMetadataNotice({
    super.key,
    required this.message,
    this.badgeLabel,
    this.forceHighContrastOnDark = false,
  });

  final String message;
  final String? badgeLabel;

  /// When true (login chrome), force high-contrast ink on dark navy cards.
  final bool forceHighContrastOnDark;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final badge = badgeLabel ?? l10n.privacyMetadataOnlyBadge;
    final brightness = Theme.of(context).brightness;
    final useDarkInk = forceHighContrastOnDark || brightness == Brightness.dark;
    final messageColor = useDarkInk
        ? VianexisBrand.textPrimary
        : VianexisBrand.textPrimaryOf(brightness);
    final badgeColor = useDarkInk
        ? VianexisBrand.goldAccent
        : (brightness == Brightness.light
            ? VianexisBrand.brandInkOnGold
            : VianexisBrand.goldAccent);

    return VianexisAdminCard(
      padding: const EdgeInsets.all(VianexisBrand.spaceLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.shield_outlined,
            size: 22,
            color: VianexisBrand.goldAccent,
          ),
          const SizedBox(width: VianexisBrand.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: VianexisBrand.spaceSm,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: VianexisBrand.goldAccent.withValues(alpha: 0.18),
                    borderRadius: BorderRadius.circular(VianexisBrand.radiusSm),
                    border: Border.all(
                      color: VianexisBrand.goldAccent.withValues(alpha: 0.55),
                    ),
                  ),
                  child: Text(
                    badge,
                    style: Theme.of(context).textTheme.labelMedium?.copyWith(
                          color: badgeColor,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                  ),
                ),
                const SizedBox(height: VianexisBrand.spaceSm),
                Text(
                  message,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: messageColor,
                        fontSize: 14,
                        height: 1.4,
                        fontWeight: FontWeight.w500,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
