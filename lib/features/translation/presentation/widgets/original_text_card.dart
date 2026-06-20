import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';

class OriginalTextCard extends StatelessWidget {
  const OriginalTextCard({
    super.key,
    required this.text,
    this.languageCode,
  });

  final String text;
  final String? languageCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translationOriginalTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            if (languageCode != null) ...[
              const SizedBox(height: 4),
              Text(
                l10n.translationLanguageLabel(languageCode!),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: 8),
            SelectableText(text),
          ],
        ),
      ),
    );
  }
}
