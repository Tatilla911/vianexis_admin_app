import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_status_badge.dart';
import '../../domain/platform_audit_action_type.dart';

class AuditLogActionBadge extends StatelessWidget {
  const AuditLogActionBadge({super.key, required this.actionType});

  final PlatformAuditActionType actionType;

  @override
  Widget build(BuildContext context) {
    return VianexisStatusBadge(
      label: resolveAuditLogKey(context, actionType.localizationKey()),
      tone: VianexisStatusTone.unknown,
    );
  }
}
