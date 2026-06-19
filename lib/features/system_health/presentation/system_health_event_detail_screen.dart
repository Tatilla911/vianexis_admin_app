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
import '../../support/data/support_tickets_repository.dart';
import '../../support/presentation/support_providers.dart';
import '../domain/system_health_action_request.dart';
import '../domain/system_health_event.dart';
import 'system_health_providers.dart';
import 'widgets/ai_diagnostic_summary_card.dart';
import 'widgets/system_health_action_dialog.dart';
import 'widgets/system_health_severity_badge.dart';

class SystemHealthEventDetailScreen extends ConsumerWidget {
  const SystemHealthEventDetailScreen({
    super.key,
    required this.eventId,
  });

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final eventAsync = ref.watch(systemHealthEventDetailProvider(eventId));

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.systemHealthEventDetailTitle),
      ),
      body: eventAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView(
          message: resolveSystemHealthKey(context, 'systemHealthLoadError'),
          onRetry: () => refreshSystemHealthEventDetail(ref, eventId),
        ),
        data: (event) => _DetailBody(
          event: event,
          eventId: eventId,
          onAction: (type) => _handleAction(context, ref, type),
          onCreateTicket: () => _handleCreateTicket(context, ref, event),
          canCreateTicket: ref.watch(supportTicketsRepositoryProvider).canCreateTicketFromSystemHealth,
        ),
      ),
    );
  }

  Future<void> _handleAction(
    BuildContext context,
    WidgetRef ref,
    SystemHealthActionType type,
  ) async {
    final request = await showSystemHealthActionDialog(context: context, type: type);
    if (request == null || !context.mounted) return;

    try {
      await submitSystemHealthAction(
        ref: ref,
        eventId: eventId,
        request: request,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolveSystemHealthKey(context, 'systemHealthActionSuccess')),
        ),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolveLocalizationKey(context, error.messageKey)),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolveSystemHealthKey(context, 'systemHealthActionError')),
        ),
      );
    }
  }

  Future<void> _handleCreateTicket(
    BuildContext context,
    WidgetRef ref,
    SystemHealthEvent event,
  ) async {
    final ticket = await createSupportTicketFromSystemHealth(
      ref: ref,
      eventId: eventId,
      title: event.title,
      summary: event.summary,
      companyId: event.affectedCompanyId,
      companyName: event.affectedCompanyName,
    );
    if (!context.mounted) return;
    if (ticket == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolveSystemHealthKey(context, 'systemHealthCreateTicketDisabled')),
        ),
      );
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(resolveSupportKey(context, 'supportTicketCreateSuccess'))),
    );
    context.push(AdminRoutes.supportTicketDetail(ticket.id));
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.event,
    required this.eventId,
    required this.onAction,
    required this.onCreateTicket,
    required this.canCreateTicket,
  });

  final SystemHealthEvent event;
  final String eventId;
  final ValueChanged<SystemHealthActionType> onAction;
  final VoidCallback onCreateTicket;
  final bool canCreateTicket;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    String formatDate(DateTime? value) =>
        value == null ? '—' : DateFormat.yMMMd(locale).add_Hm().format(value.toLocal());

    final canAct = event.status != SystemHealthEventStatus.resolved;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(event.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            SystemHealthSeverityBadge(severity: event.severity),
            Chip(
              label: Text(resolveSystemHealthKey(context, event.status.localizationKey())),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _InfoRow(
          label: resolveSystemHealthKey(context, 'systemHealthFieldServiceName'),
          value: event.serviceName,
        ),
        _InfoRow(
          label: resolveSystemHealthKey(context, 'systemHealthFieldTenantImpact'),
          value: resolveSystemHealthKey(context, event.tenantImpactLevel.localizationKey()),
        ),
        if (event.affectedCompanyName != null)
          _InfoRow(
            label: resolveSystemHealthKey(context, 'systemHealthFieldAffectedCompany'),
            value: event.affectedCompanyName!,
          ),
        _InfoRow(
          label: resolveSystemHealthKey(context, 'systemHealthFieldStartedAt'),
          value: formatDate(event.startedAt),
        ),
        _InfoRow(
          label: resolveSystemHealthKey(context, 'systemHealthFieldLastSeenAt'),
          value: formatDate(event.lastSeenAt),
        ),
        if (event.resolvedAt != null)
          _InfoRow(
            label: resolveSystemHealthKey(context, 'systemHealthFieldResolvedAt'),
            value: formatDate(event.resolvedAt),
          ),
        _InfoRow(
          label: resolveSystemHealthKey(context, 'systemHealthFieldFailedJobs'),
          value: event.failedJobsCount.toString(),
        ),
        if (event.correlationId != null)
          _InfoRow(
            label: resolveSystemHealthKey(context, 'systemHealthFieldCorrelationId'),
            value: event.correlationId!,
          ),
        const SizedBox(height: 8),
        Text(event.summary),
        if (event.aiDiagnosticSummary != null && event.aiDiagnosticSummary!.isNotEmpty) ...[
          const SizedBox(height: 16),
          AiDiagnosticSummaryCard(
            summary: event.aiDiagnosticSummary!,
            recommendedAction: event.recommendedAction,
          ),
        ],
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
                  child: Text(resolveSystemHealthKey(context, 'systemHealthPrivacyNotice')),
                ),
              ],
            ),
          ),
        ),
        if (canAct) ...[
          const SizedBox(height: 16),
          FilledButton(
            onPressed: () => onAction(SystemHealthActionType.acknowledge),
            child: Text(resolveSystemHealthKey(context, 'systemHealthActionAcknowledge')),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => onAction(SystemHealthActionType.escalate),
            child: Text(resolveSystemHealthKey(context, 'systemHealthActionEscalate')),
          ),
        ],
        const SizedBox(height: 8),
        OutlinedButton(
          onPressed: canCreateTicket ? onCreateTicket : null,
          child: Text(
            resolveSystemHealthKey(
              context,
              canCreateTicket
                  ? 'systemHealthCreateTicket'
                  : 'systemHealthCreateTicketDisabled',
            ),
          ),
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
