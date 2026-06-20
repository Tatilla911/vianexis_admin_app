import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../domain/translation_status.dart';

class TranslationStatusBadge extends StatelessWidget {
  const TranslationStatusBadge({
    super.key,
    required this.status,
    this.needsReview = false,
    this.stale = false,
  });

  final TranslationStatus status;
  final bool needsReview;
  final bool stale;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final chips = <Widget>[
      if (status == TranslationStatus.machineTranslated)
        Chip(
          label: Text(l10n.translationBadgeMachine),
          visualDensity: VisualDensity.compact,
        ),
      if (needsReview || status != TranslationStatus.approved)
        Chip(
          label: Text(l10n.translationBadgeNeedsReview),
          visualDensity: VisualDensity.compact,
        ),
      if (stale)
        Chip(
          label: Text(l10n.translationBadgeStale),
          visualDensity: VisualDensity.compact,
        ),
      if (status == TranslationStatus.approved)
        Chip(
          label: Text(l10n.translationBadgeApproved),
          visualDensity: VisualDensity.compact,
        ),
    ];

    if (chips.isEmpty) {
      return const SizedBox.shrink();
    }

    return Wrap(spacing: 8, runSpacing: 8, children: chips);
  }
}
