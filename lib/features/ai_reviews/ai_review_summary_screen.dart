import 'package:flutter/material.dart';

import '../../core/widgets/vianexis_admin_scaffold.dart';
import '../../l10n/app_localizations.dart';

class AiReviewSummaryScreen extends StatelessWidget {
  const AiReviewSummaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AdminFeatureScaffold(
      title: l10n.aiReviewsTitle,
      body: l10n.aiReviewsPlaceholderBody,
    );
  }
}
