import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_status_badge.dart';
import '../../domain/platform_audit_severity.dart';

class AuditLogSeverityBadge extends StatelessWidget {
  const AuditLogSeverityBadge({super.key, required this.severity});

  final PlatformAuditSeverity severity;

  @override
  Widget build(BuildContext context) {
    return VianexisStatusBadge(
      label: resolveAuditLogKey(context, severity.localizationKey()),
      tone: _tone(severity),
    );
  }

  VianexisStatusTone _tone(PlatformAuditSeverity severity) {
    return switch (severity) {
      PlatformAuditSeverity.info => VianexisStatusTone.healthy,
      PlatformAuditSeverity.warning => VianexisStatusTone.degraded,
      PlatformAuditSeverity.critical => VianexisStatusTone.degraded,
      PlatformAuditSeverity.unknown => VianexisStatusTone.unknown,
    };
  }
}
