import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_metadata_notice.dart';

class AuditMetadataCard extends StatelessWidget {
  const AuditMetadataCard({super.key});

  @override
  Widget build(BuildContext context) {
    return VianexisMetadataNotice(
      message: resolveAuditLogKey(context, 'auditLogPrivacyNotice'),
    );
  }
}
