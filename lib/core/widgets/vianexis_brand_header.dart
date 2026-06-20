import 'package:flutter/material.dart';

import '../../app/app_environment.dart';
import '../../app/vianexis_brand.dart';
import '../../core/api/api_config.dart';
import '../../l10n/app_localizations.dart';
import 'vianexis_admin_card.dart';
import 'vianexis_logo_mark.dart';

/// Branded header for dashboard and module landing areas.
class VianexisBrandHeader extends StatelessWidget {
  const VianexisBrandHeader({
    super.key,
    this.showEnvironment = true,
  });

  final bool showEnvironment;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final environment = AppEnvironment.fromDefine(
      const String.fromEnvironment(AppEnvironment.dartDefineKey),
    ).value;
    final apiStatus = ApiConfig.isConfigured
        ? l10n.brandApiConnected
        : l10n.brandApiNotConfigured;

    return VianexisAdminCard(
      padding: const EdgeInsets.all(VianexisBrand.spaceXl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const VianexisLogoMark(compact: true, size: 56),
          const SizedBox(height: VianexisBrand.spaceLg),
          Text(
            l10n.brandOperationalControlCenter,
            style: VianexisBrand.sectionTitleStyle(context),
          ),
          const SizedBox(height: VianexisBrand.spaceSm),
          Text(
            l10n.brandPlatformControlCenterBody,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (showEnvironment) ...[
            const SizedBox(height: VianexisBrand.spaceMd),
            Wrap(
              spacing: VianexisBrand.spaceSm,
              runSpacing: VianexisBrand.spaceSm,
              children: [
                _EnvChip(
                  icon: Icons.hub_outlined,
                  label: '${l10n.brandEnvironmentLabel}: $environment',
                ),
                _EnvChip(
                  icon: ApiConfig.isConfigured
                      ? Icons.link_outlined
                      : Icons.link_off_outlined,
                  label: apiStatus,
                  tone: ApiConfig.isConfigured
                      ? VianexisBrand.success
                      : VianexisBrand.warning,
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _EnvChip extends StatelessWidget {
  const _EnvChip({
    required this.icon,
    required this.label,
    this.tone,
  });

  final IconData icon;
  final String label;
  final Color? tone;

  @override
  Widget build(BuildContext context) {
    final color = tone ?? VianexisBrand.accentMuted;
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: VianexisBrand.spaceMd,
        vertical: VianexisBrand.spaceSm,
      ),
      decoration: BoxDecoration(
        color: VianexisBrand.surfaceMuted.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(VianexisBrand.radiusSm),
        border: Border.all(color: VianexisBrand.borderSubtle),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: VianexisBrand.spaceSm),
          Text(
            label,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(color: color),
          ),
        ],
      ),
    );
  }
}
