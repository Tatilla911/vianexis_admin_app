import 'package:flutter/material.dart';

import '../../core/widgets/vianexis_admin_scaffold.dart';
import '../../l10n/app_localizations.dart';

class SystemHealthScreen extends StatelessWidget {
  const SystemHealthScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AdminFeatureScaffold(
      title: l10n.systemHealthTitle,
      body: l10n.systemHealthPlaceholderBody,
    );
  }
}
