import 'package:flutter/material.dart';

import '../../core/widgets/vianexis_admin_scaffold.dart';
import '../../l10n/app_localizations.dart';

class RegistrationApplicationDetailScreen extends StatelessWidget {
  const RegistrationApplicationDetailScreen({
    super.key,
    required this.applicationId,
  });

  final String applicationId;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AdminFeatureScaffold(
      title: l10n.registrationDetailTitle,
      body: l10n.registrationDetailPlaceholderBody,
    );
  }
}
