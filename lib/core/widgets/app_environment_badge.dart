import 'package:flutter/material.dart';

import '../../app/app_config.dart';
import '../../app/vianexis_brand.dart';
import '../localization/localization_resolver.dart';
import 'vianexis_status_badge.dart';

/// Compact environment + API status badge for settings and release views.
class AppEnvironmentBadge extends StatelessWidget {
  const AppEnvironmentBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final config = AppConfig.instance;
    final envLabel = resolveAppConfigKey(context, config.displayLabelKey);
    final apiLabel = config.isApiConfigured
        ? (config.safeApiHostDisplay ??
            resolveAppConfigKey(context, 'appConfigApiConfigured'))
        : resolveAppConfigKey(context, 'appConfigApiNotConfigured');

    return Wrap(
      spacing: VianexisBrand.spaceSm,
      runSpacing: VianexisBrand.spaceSm,
      children: [
        VianexisStatusBadge(
          label: '${resolveAppConfigKey(context, 'appConfigEnvironmentLabel')}: $envLabel',
          tone: config.isProduction
              ? VianexisStatusTone.degraded
              : VianexisStatusTone.unknown,
        ),
        VianexisStatusBadge(
          label: '${resolveAppConfigKey(context, 'appConfigApiStatusLabel')}: $apiLabel',
          tone: config.isApiConfigured
              ? VianexisStatusTone.healthy
              : VianexisStatusTone.degraded,
        ),
        if (config.isMockFallbackActive)
          VianexisStatusBadge(
            label: resolveAppConfigKey(context, 'appConfigMockFallbackActive'),
            tone: VianexisStatusTone.unknown,
          ),
      ],
    );
  }
}
