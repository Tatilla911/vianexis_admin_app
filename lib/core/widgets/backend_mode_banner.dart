import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';
import '../api/api_config.dart';

class BackendModeBanner extends StatelessWidget {
  const BackendModeBanner({super.key});

  @override
  Widget build(BuildContext context) {
    if (ApiConfig.isConfigured) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: colors.errorContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.cloud_off_outlined, color: colors.onErrorContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.backendNotConfiguredBanner,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onErrorContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
