import 'package:flutter/material.dart';

import '../../core/widgets/vianexis_admin_scaffold.dart';
import '../../l10n/app_localizations.dart';

class AuditLogsScreen extends StatelessWidget {
  const AuditLogsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AdminFeatureScaffold(
      title: l10n.auditLogsTitle,
      body: l10n.auditLogsPlaceholderBody,
    );
  }
}
