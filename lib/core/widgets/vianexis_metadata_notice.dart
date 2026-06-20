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
  });

  final String message;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final badge = badgeLabel ?? l10n.privacyMetadataOnlyBadge;

    return VianexisAdminCard(
      padding: const EdgeInsets.all(VianexisBrand.spaceLg),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.shield_outlined, size: 20, color: VianexisBrand.goldAccent),
          const SizedBox(width: VianexisBrand.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: VianexisBrand.spaceSm,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: VianexisBrand.goldAccent.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(VianexisBrand.radiusSm),
                    border: Border.all(
                      color: VianexisBrand.goldAccent.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Text(
                    badge,
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      color: VianexisBrand.goldAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(height: VianexisBrand.spaceSm),
                Text(message, style: Theme.of(context).textTheme.bodyMedium),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
