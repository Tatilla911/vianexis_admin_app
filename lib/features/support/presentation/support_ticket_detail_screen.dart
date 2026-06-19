import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/support_ticket.dart';
import '../domain/support_ticket_action_request.dart';
import 'support_providers.dart';
import 'widgets/support_access_grant_dialog.dart';
import 'widgets/support_action_dialog.dart';
import 'widgets/support_ticket_priority_badge.dart';
import 'widgets/support_ticket_status_badge.dart';

class SupportTicketDetailScreen extends ConsumerWidget {
  const SupportTicketDetailScreen({
    super.key,
    required this.ticketId,
  });

  final String ticketId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final ticketAsync = ref.watch(supportTicketDetailProvider(ticketId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportTicketDetailTitle)),
      body: ticketAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView(
          message: resolveSupportKey(context, 'supportLoadError'),
          onRetry: () => refreshSupportTicketDetail(ref, ticketId),
        ),
        data: (ticket) => _DetailBody(
          ticket: ticket,
          onAction: (type) => _handleAction(context, ref, type),
          onCreateGrant: () => _handleCreateGrant(context, ref, ticket),
        ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    SupportTicketActionType type,
  ) async {
    final request = await showSupportActionDialog(context: context, type: type);
    if (request == null || !context.mounted) return;

    try {
      await submitSupportTicketAction(
        ref: ref,
        ticketId: ticketId,
        request: request,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveSupportKey(context, 'supportActionSuccess'))),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveLocalizationKey(context, error.messageKey))),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveSupportKey(context, 'supportActionError'))),
      );
    }
  }

  Future<void> _handleCreateGrant(
    BuildContext context,
    WidgetRef ref,
    SupportTicket ticket,
  ) async {
    if (ticket.companyId == null) return;

    final request = await showSupportAccessGrantDialog(
      context: context,
      prefill: SupportAccessGrantDialogPrefill(
        companyId: ticket.companyId!,
        companyName: ticket.companyName,
        linkedTicketId: ticket.id,
        linkedSystemHealthEventId: ticket.linkedSystemHealthEventId,
      ),
    );
    if (request == null || !context.mounted) return;

    try {
      final grant = await createSupportAccessGrant(ref: ref, request: request);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveSupportKey(context, 'supportGrantCreateSuccess'))),
      );
      context.push(AdminRoutes.supportGrantDetail(grant.id));
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveSupportKey(context, error.messageKey))),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveSupportKey(context, 'supportActionError'))),
      );
    }
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.ticket,
    required this.onAction,
    required this.onCreateGrant,
  });

  final SupportTicket ticket;
  final ValueChanged<SupportTicketActionType> onAction;
  final VoidCallback onCreateGrant;

  String _formatDate(BuildContext context, DateTime? value) {
    if (value == null) return '—';
    return DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .add_Hm()
        .format(value.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final canAct = ticket.status.isOpenLike;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(ticket.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SupportTicketStatusBadge(status: ticket.status),
            SupportTicketPriorityBadge(priority: ticket.priority),
          ],
        ),
        const SizedBox(height: 16),
        _InfoRow(
          label: resolveSupportKey(context, 'supportTicketFieldCompany'),
          value: ticket.companyName ?? ticket.companyId ?? '—',
        ),
        _InfoRow(
          label: resolveSupportKey(context, 'supportTicketFieldRequester'),
          value: [
            if (ticket.requestedByName != null) ticket.requestedByName,
            if (ticket.requestedByEmail != null) ticket.requestedByEmail,
          ].whereType<String>().join(' · '),
        ),
        _InfoRow(
          label: resolveSupportKey(context, 'supportTicketFieldCategory'),
          value: resolveSupportKey(context, ticket.category.localizationKey()),
        ),
        _InfoRow(
          label: resolveSupportKey(context, 'supportTicketFieldSummary'),
          value: ticket.summary,
        ),
        _InfoRow(
          label: resolveSupportKey(context, 'supportTicketFieldCreatedAt'),
          value: _formatDate(context, ticket.createdAt),
        ),
        _InfoRow(
          label: resolveSupportKey(context, 'supportTicketFieldUpdatedAt'),
          value: _formatDate(context, ticket.updatedAt),
        ),
        _InfoRow(
          label: resolveSupportKey(context, 'supportTicketFieldLastActivity'),
          value: _formatDate(context, ticket.lastActivityAt),
        ),
        if (ticket.linkedSystemHealthEventId != null)
          _InfoRow(
            label: resolveSupportKey(context, 'supportTicketFieldLinkedHealthEvent'),
            value: ticket.linkedSystemHealthEventId!,
          ),
        if (ticket.hasSupportAccessGrant)
          _InfoRow(
            label: resolveSupportKey(context, 'supportTicketFieldSupportGrant'),
            value: ticket.supportAccessGrantId ?? '—',
          ),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.shield_outlined, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(resolveSupportKey(context, 'supportPrivacyNotice')),
                ),
              ],
            ),
          ),
        ),
        if (canAct) ...[
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => onAction(SupportTicketActionType.acknowledge),
            child: Text(resolveSupportKey(context, 'supportTicketActionAcknowledge')),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => onAction(SupportTicketActionType.close),
            child: Text(resolveSupportKey(context, 'supportTicketActionClose')),
          ),
        ],
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: ticket.companyId != null ? onCreateGrant : null,
          child: Text(resolveSupportKey(context, 'supportTicketActionCreateGrant')),
        ),
      ],
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 150,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
