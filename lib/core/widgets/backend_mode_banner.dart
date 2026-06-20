import 'package:flutter/material.dart';

import '../../app/app_config.dart';
import '../localization/localization_resolver.dart';
import '../api/api_config.dart';

class BackendModeBanner extends StatelessWidget {
  const BackendModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (ApiConfig.isConfigured) {
      return const SizedBox.shrink();
    }

    final config = AppConfig.instance;
    final colors = Theme.of(context).colorScheme;
    final message = config.isProductionMisconfigured
        ? resolveAppConfigKey(context, 'appConfigProductionMisconfigured')
        : resolveAppConfigKey(context, 'backendMockFallbackBanner');

    return Container(
      width: double.infinity,
      color: config.isProductionMisconfigured
          ? colors.errorContainer
          : colors.tertiaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(
            config.isProductionMisconfigured
                ? Icons.error_outline
                : Icons.cloud_off_outlined,
            color: config.isProductionMisconfigured
                ? colors.onErrorContainer
                : colors.onTertiaryContainer,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: config.isProductionMisconfigured
                    ? colors.onErrorContainer
                    : colors.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
