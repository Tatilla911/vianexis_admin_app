import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_status_badge.dart';
import '../../domain/support_ticket_priority.dart';

class SupportTicketPriorityBadge extends StatelessWidget {
  const SupportTicketPriorityBadge({super.key, required this.priority});

  final SupportTicketPriority priority;

  @override
  Widget build(BuildContext context) {
    return VianexisStatusBadge(
      label: resolveSupportKey(context, priority.localizationKey()),
      tone: _tone(priority),
    );
  }

  VianexisStatusTone _tone(SupportTicketPriority priority) {
    return switch (priority) {
      SupportTicketPriority.low || SupportTicketPriority.normal => VianexisStatusTone.healthy,
      SupportTicketPriority.high => VianexisStatusTone.degraded,
      SupportTicketPriority.urgent || SupportTicketPriority.critical =>
        VianexisStatusTone.degraded,
      SupportTicketPriority.unknown => VianexisStatusTone.unknown,
    };
  }
}
