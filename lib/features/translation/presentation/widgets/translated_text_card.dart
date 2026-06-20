import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/translation_record.dart';
import 'translation_status_badge.dart';

class TranslatedTextCard extends StatelessWidget {
  const TranslatedTextCard({
    super.key,
    required this.text,
    required this.record,
    this.languageCode,
  });

  final String? text;
  final TranslationRecord record;
  final String? languageCode;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final displayText = text ?? l10n.translationMetadataOnlyNotice;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              l10n.translationTranslatedTitle,
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
            TranslationStatusBadge(
              status: record.status,
              needsReview: record.needsReview,
              stale: record.stale,
            ),
            const SizedBox(height: 8),
            SelectableText(displayText),
          ],
        ),
      ),
    );
  }
}
