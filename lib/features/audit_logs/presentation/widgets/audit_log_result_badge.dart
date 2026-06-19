import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_status_badge.dart';
import '../../domain/platform_audit_result.dart';

class AuditLogResultBadge extends StatelessWidget {
  const AuditLogResultBadge({super.key, required this.result});

  final PlatformAuditResult result;

  @override
  Widget build(BuildContext context) {
    return VianexisStatusBadge(
      label: resolveAuditLogKey(context, result.localizationKey()),
      tone: _tone(result),
    );
  }

  VianexisStatusTone _tone(PlatformAuditResult result) {
    return switch (result) {
      PlatformAuditResult.success => VianexisStatusTone.healthy,
      PlatformAuditResult.partial => VianexisStatusTone.degraded,
      PlatformAuditResult.failure || PlatformAuditResult.denied =>
        VianexisStatusTone.degraded,
      PlatformAuditResult.unknown => VianexisStatusTone.unknown,
    };
  }
}
