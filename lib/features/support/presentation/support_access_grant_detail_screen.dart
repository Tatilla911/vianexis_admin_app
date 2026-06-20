import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/support_access_grant.dart';
import '../domain/support_access_grant_status.dart';
import 'support_providers.dart';
import 'widgets/support_access_scope_badge.dart';
import 'widgets/support_access_warning_card.dart';
import 'widgets/support_action_dialog.dart';

class SupportAccessGrantDetailScreen extends ConsumerWidget {
  const SupportAccessGrantDetailScreen({
    super.key,
    required this.grantId,
  });

  final String grantId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final grantAsync = ref.watch(supportAccessGrantDetailProvider(grantId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.supportGrantDetailTitle)),
      body: grantAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveSupportKey(context, 'supportLoadError'),
          onRetry: () => refreshSupportAccessGrantDetail(ref, grantId),
        ),
        data: (grant) => _DetailBody(
          grant: grant,
          onRevoke: () => _handleRevoke(context, ref),
        ),
      ),
    );
  }

  Future<void> _handleRevoke(BuildContext context, WidgetRef ref) async {
    final request = await showSupportRevokeDialog(context: context);
    if (request == null || !context.mounted) return;

    try {
      await revokeSupportAccessGrant(
        ref: ref,
        grantId: grantId,
        request: request,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveSupportKey(context, 'supportGrantRevokeSuccess'))),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
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
    required this.grant,
    required this.onRevoke,
  });

  final SupportAccessGrant grant;
  final VoidCallback onRevoke;

  String _formatDate(BuildContext context, DateTime? value) {
    if (value == null) return '—';
    return DateFormat.yMMMd(Localizations.localeOf(context).toString())
        .add_Hm()
        .format(value.toLocal());
  }

  @override
  Widget build(BuildContext context) {
    final canRevoke = grant.status == SupportAccessGrantStatus.active ||
        grant.status == SupportAccessGrantStatus.pending;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        const SupportAccessWarningCard(),
        const SizedBox(height: 16),
        Text(
          grant.companyName ?? grant.companyId,
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            VianexisStatusBadge(
              label: resolveSupportKey(context, grant.status.localizationKey()),
              tone: grant.status == SupportAccessGrantStatus.active
                  ? VianexisStatusTone.healthy
                  : VianexisStatusTone.unknown,
            ),
            SupportAccessScopeBadge(scopeType: grant.scopeType),
          ],
        ),
        const SizedBox(height: 16),
        _InfoRow(
          label: resolveSupportKey(context, 'supportGrantFieldCompany'),
          value: grant.companyName ?? grant.companyId,
        ),
        if (grant.scopeId != null)
          _InfoRow(
            label: resolveSupportKey(context, 'supportGrantFieldScopeId'),
            value: grant.scopeId!,
          ),
        _InfoRow(
          label: resolveSupportKey(context, 'supportGrantFieldReason'),
          value: grant.reason,
        ),
        _InfoRow(
          label: resolveSupportKey(context, 'supportGrantFieldAllowedCategories'),
          value: grant.allowedDataCategories.join(', '),
        ),
        _InfoRow(
          label: resolveSupportKey(context, 'supportGrantFieldExcludesDocuments'),
          value: grant.excludesSensitiveDocuments
              ? resolveSupportKey(context, 'supportGrantYes')
              : resolveSupportKey(context, 'supportGrantNo'),
        ),
        _InfoRow(
          label: resolveSupportKey(context, 'supportGrantFieldCreatedAt'),
          value: _formatDate(context, grant.createdAt),
        ),
        _InfoRow(
          label: resolveSupportKey(context, 'supportGrantFieldExpiresAt'),
          value: _formatDate(context, grant.expiresAt),
        ),
        if (grant.revokedAt != null)
          _InfoRow(
            label: resolveSupportKey(context, 'supportGrantFieldRevokedAt'),
            value: _formatDate(context, grant.revokedAt),
          ),
        if (grant.approvedByName != null)
          _InfoRow(
            label: resolveSupportKey(context, 'supportGrantFieldApprovedBy'),
            value: grant.approvedByName!,
          ),
        if (grant.auditLogId != null)
          _InfoRow(
            label: resolveSupportKey(context, 'supportGrantFieldAuditLogId'),
            value: grant.auditLogId!,
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
        if (canRevoke) ...[
          const SizedBox(height: 16),
          OutlinedButton(
            onPressed: onRevoke,
            child: Text(resolveSupportKey(context, 'supportGrantActionRevoke')),
          ),
        ],
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
