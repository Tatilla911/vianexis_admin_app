import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_router.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../domain/support_ticket.dart';
import 'support_ticket_priority_badge.dart';
import 'support_ticket_status_badge.dart';

class SupportTicketCard extends StatelessWidget {
  const SupportTicketCard({super.key, required this.ticket});

  final SupportTicket ticket;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final updated = ticket.lastActivityAt ?? ticket.updatedAt;
    final dateLabel = updated != null
        ? DateFormat.yMMMd(locale).add_Hm().format(updated.toLocal())
        : '—';

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AdminRoutes.supportTicketDetail(ticket.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      ticket.title,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  SupportTicketStatusBadge(status: ticket.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                [
                  if (ticket.companyName != null) ticket.companyName,
                  if (ticket.requestedByEmail != null) ticket.requestedByEmail,
                ].whereType<String>().join(' · '),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  SupportTicketPriorityBadge(priority: ticket.priority),
                  const Spacer(),
                  Text(
                    resolveSupportKey(
                      context,
                      'supportTicketLastActivity',
                      params: {'date': dateLabel},
                    ),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
