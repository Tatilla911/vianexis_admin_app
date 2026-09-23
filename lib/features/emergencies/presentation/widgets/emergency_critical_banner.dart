import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class EmergencyCriticalBanner extends StatelessWidget {
  const EmergencyCriticalBanner({
    super.key,
    required this.count,
    this.onTap,
  });

  final int count;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Material(
      color: Theme.of(context).colorScheme.errorContainer,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Row(
            children: [
              Icon(
                Icons.emergency_outlined,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      l10n.emergenciesCriticalBannerTitle,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(l10n.emergenciesCriticalBannerBody(count)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
