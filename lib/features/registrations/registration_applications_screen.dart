import 'package:flutter/material.dart';

import '../../core/widgets/vianexis_admin_scaffold.dart';
import '../../l10n/app_localizations.dart';

class RegistrationApplicationsScreen extends StatelessWidget {
  const RegistrationApplicationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AdminFeatureScaffold(
      title: l10n.registrationsTitle,
      body: l10n.registrationsPlaceholderBody,
    );
  }
}
