import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class OfflineBanner extends StatelessWidget {
  const OfflineBanner({super.key, required this.isOnline});

  final bool isOnline;

  @override
  Widget build(BuildContext context) {
    if (isOnline) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context);
    final colors = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: colors.tertiaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        children: [
          Icon(Icons.wifi_off_outlined, color: colors.onTertiaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              l10n.offlineBannerMessage,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: colors.onTertiaryContainer,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
