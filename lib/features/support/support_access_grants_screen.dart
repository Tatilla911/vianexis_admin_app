import 'package:flutter/material.dart';

import '../../core/widgets/vianexis_admin_scaffold.dart';
import '../../l10n/app_localizations.dart';

class SupportAccessGrantsScreen extends StatelessWidget {
  const SupportAccessGrantsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AdminFeatureScaffold(
      title: l10n.supportGrantsTitle,
      body: l10n.supportGrantsPlaceholderBody,
    );
  }
}
