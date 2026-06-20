import 'package:flutter/material.dart';

import '../../app/app_config.dart';
import '../../app/vianexis_brand.dart';
import '../../core/localization/localization_resolver.dart';
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
    final config = AppConfig.instance;
    final envLabel = resolveAppConfigKey(context, config.displayLabelKey);
    final apiLabel = config.isApiConfigured
        ? (config.safeApiHostDisplay ??
            resolveAppConfigKey(context, 'appConfigApiConfigured'))
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
                  label:
                      '${resolveAppConfigKey(context, 'appConfigEnvironmentLabel')}: $envLabel',
                  tone: config.isProduction
                      ? VianexisBrand.warning
                      : VianexisBrand.accentMuted,
                ),
                _EnvChip(
                  icon: config.isApiConfigured
                      ? Icons.link_outlined
                      : Icons.link_off_outlined,
                  label: apiLabel,
                  tone: config.isApiConfigured
                      ? VianexisBrand.success
                      : VianexisBrand.warning,
                ),
                if (config.isMockFallbackActive)
                  _EnvChip(
                    icon: Icons.science_outlined,
                    label: resolveAppConfigKey(
                      context,
                      'appConfigMockFallbackActive',
                    ),
                    tone: VianexisBrand.accentMuted,
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
