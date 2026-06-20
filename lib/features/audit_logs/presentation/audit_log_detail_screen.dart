import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/platform_audit_log.dart';
import 'audit_log_providers.dart';
import 'widgets/audit_log_action_badge.dart';
import 'widgets/audit_log_result_badge.dart';
import 'widgets/audit_log_severity_badge.dart';
import 'widgets/audit_metadata_card.dart';

class AuditLogDetailScreen extends ConsumerWidget {
  const AuditLogDetailScreen({
    super.key,
    required this.logId,
  });

  final String logId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final logAsync = ref.watch(platformAuditLogDetailProvider(logId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.auditLogDetailTitle)),
      body: logAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveAuditLogKey(context, 'auditLogLoadError'),
          onRetry: () => refreshPlatformAuditLogDetail(ref, logId),
        ),
        data: (log) => _DetailBody(log: log),
      ),
    );
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({required this.log});

  final PlatformAuditLog log;

  String _formatDate(BuildContext context, DateTime value) {
    return DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .add_Hm()
        .format(value.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(
          log.targetLabel ?? resolveAuditLogKey(context, log.actionType.localizationKey()),
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            AuditLogActionBadge(actionType: log.actionType),
            AuditLogResultBadge(result: log.result),
            AuditLogSeverityBadge(severity: log.severity),
          ],
        ),
        const SizedBox(height: 16),
        _InfoRow(
          label: resolveAuditLogKey(context, 'auditLogFieldTimestamp'),
          value: _formatDate(context, log.timestamp),
        ),
        _InfoRow(
          label: resolveAuditLogKey(context, 'auditLogFieldActor'),
          value: [
            if (log.actorName != null) log.actorName,
            if (log.actorEmail != null) log.actorEmail,
          ].whereType<String>().join(' · '),
        ),
        if (log.actorRole != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldActorRole'),
            value: roleLabel(context, log.actorRole!),
          ),
        if (log.targetType != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldTargetType'),
            value: log.targetType!,
          ),
        if (log.targetId != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldTargetId'),
            value: log.targetId!,
          ),
        if (log.companyName != null || log.companyId != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldCompany'),
            value: log.companyName ?? log.companyId ?? '—',
          ),
        if (log.tenantId != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldTenantId'),
            value: log.tenantId!,
          ),
        if (log.reason != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldReason'),
            value: log.reason!,
          ),
        if (log.note != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldNote'),
            value: log.note!,
          ),
        if (log.ipAddress != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldIpAddress'),
            value: log.ipAddress!,
          ),
        if (log.deviceLabel != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldDeviceLabel'),
            value: log.deviceLabel!,
          ),
        if (log.correlationId != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldCorrelationId'),
            value: log.correlationId!,
          ),
        if (log.registrationApplicationId != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldRegistrationApplicationId'),
            value: log.registrationApplicationId!,
          ),
        if (log.supportAccessGrantId != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldSupportAccessGrantId'),
            value: log.supportAccessGrantId!,
          ),
        if (log.systemHealthEventId != null)
          _InfoRow(
            label: resolveAuditLogKey(context, 'auditLogFieldSystemHealthEventId'),
            value: log.systemHealthEventId!,
          ),
        const SizedBox(height: 16),
        const AuditMetadataCard(),
        const SizedBox(height: 16),
        OutlinedButton(
          onPressed: null,
          child: Text(resolveAuditLogKey(context, 'auditLogExportDisabled')),
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
            width: 170,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
