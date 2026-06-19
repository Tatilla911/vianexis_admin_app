import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_status_badge.dart';
import '../../domain/support_ticket_status.dart';

class SupportTicketStatusBadge extends StatelessWidget {
  const SupportTicketStatusBadge({super.key, required this.status});

  final SupportTicketStatus status;

  @override
  Widget build(BuildContext context) {
    return VianexisStatusBadge(
      label: resolveSupportKey(context, status.localizationKey()),
      tone: _tone(status),
    );
  }

  VianexisStatusTone _tone(SupportTicketStatus status) {
    return switch (status) {
      SupportTicketStatus.open => VianexisStatusTone.degraded,
      SupportTicketStatus.acknowledged || SupportTicketStatus.investigating =>
        VianexisStatusTone.unknown,
      SupportTicketStatus.waitingForCustomer => VianexisStatusTone.unknown,
      SupportTicketStatus.resolved || SupportTicketStatus.closed =>
        VianexisStatusTone.healthy,
      SupportTicketStatus.unknown => VianexisStatusTone.unknown,
    };
  }
}
