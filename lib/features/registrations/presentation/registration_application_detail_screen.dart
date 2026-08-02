import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/localization/localization_keys.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/registration_application.dart';
import '../domain/registration_approval_outcome.dart';
import '../domain/registration_decision_request.dart';
import '../data/registration_applications_repository.dart';
import 'registration_providers.dart';
import 'widgets/ai_risk_badge.dart';
import 'widgets/registration_decision_dialog.dart';
import '../../translation/presentation/widgets/translation_panel.dart';

class RegistrationApplicationDetailScreen extends ConsumerStatefulWidget {
  const RegistrationApplicationDetailScreen({
    super.key,
    required this.applicationId,
  });

  final String applicationId;

  @override
  ConsumerState<RegistrationApplicationDetailScreen> createState() =>
      _RegistrationApplicationDetailScreenState();
}

class _RegistrationApplicationDetailScreenState
    extends ConsumerState<RegistrationApplicationDetailScreen> {
  RegistrationApprovalOutcome? _approvalOutcome;
  bool _decisionLoading = false;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(
      registrationApplicationDetailProvider(widget.applicationId),
    );
    final user = ref.watch(adminAuthProvider).user;
    final canDecide = user?.role.canDecideCompanyRegistrations ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.registrationDetailTitle)),
      body: detailAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveRegistrationKey(
            context,
            'registrationDetailError',
          ),
          onRetry: () =>
              refreshRegistrationApplicationDetail(ref, widget.applicationId),
        ),
        data: (application) => _DetailBody(
          application: application,
          applicationId: widget.applicationId,
          canDecide: canDecide,
          decisionLoading: _decisionLoading,
          approvalOutcome: _approvalOutcome,
          onDecision: (type) => _handleDecision(context, type),
          onResendInvite: canDecide ? () => _handleResend(context) : null,
          onSendPasswordSetup:
              canDecide ? () => _handleSendPasswordSetup(context) : null,
          onRevokeInvite: canDecide ? () => _handleRevoke(context) : null,
        ),
      ),
    );
  }

  Future<void> _handleResend(BuildContext context) async {
    if (_decisionLoading) return;
    setState(() => _decisionLoading = true);
    try {
      final repo = ref.read(registrationApplicationsRepositoryProvider);
      if (repo.usesMockData) {
        throw const ApiException(
          messageKey: LocalizationKeys.authBackendNotConfigured,
          kind: ApiExceptionKind.notConfigured,
          errorCode: 'MOCK_INVITE_SEND_FORBIDDEN',
          backendMessage:
              'Mock repository is active — activation invite was not sent.',
        );
      }
      final outcome = await repo.resendInvite(widget.applicationId);
      if (!context.mounted) return;
      setState(() => _approvalOutcome = outcome);
      await refreshRegistrationApplicationDetail(ref, widget.applicationId);
      if (!context.mounted) return;
      final delivery = outcome.inviteDeliveryStatus;
      final message = switch (delivery) {
        'sent' || 'accepted_by_provider' || 'queued' =>
          resolveRegistrationKey(context, 'registrationInviteResendSuccess'),
        'provider_disabled' || 'skipped' => AppLocalizations.of(
          context,
        ).registrationInviteDeliveryProviderDisabled,
        'provider_not_configured' => AppLocalizations.of(
          context,
        ).registrationInviteDeliveryProviderNotConfigured,
        'blocked_by_staging_allowlist' || 'staging_allowlist_missing' =>
          AppLocalizations.of(
            context,
          ).registrationInviteDeliveryAllowlistBlocked,
        'failed' || 'pending_or_failed' => AppLocalizations.of(
          context,
        ).registrationInviteDeliveryFailed,
        _ => resolveRegistrationKey(context, 'registrationInviteResendSuccess'),
      };
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveRegistrationKey(context, 'registrationDecisionError'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _decisionLoading = false);
    }
  }

  Future<void> _handleSendPasswordSetup(BuildContext context) async {
    if (_decisionLoading) return;
    setState(() => _decisionLoading = true);
    try {
      final repo = ref.read(registrationApplicationsRepositoryProvider);
      if (repo.usesMockData) {
        throw const ApiException(
          messageKey: LocalizationKeys.authBackendNotConfigured,
          kind: ApiExceptionKind.notConfigured,
          errorCode: 'MOCK_INVITE_SEND_FORBIDDEN',
          backendMessage:
              'Mock repository is active — activation invite was not sent.',
        );
      }
      final result = await repo.sendPasswordSetup(widget.applicationId);
      if (!context.mounted) return;
      final delivery =
          result['emailDeliveryStatus']?.toString() ??
          result['emailInviteDeliveryStatus']?.toString() ??
          '';
      final sent = result['emailSent'] == true || delivery == 'sent';
      setState(() {
        _approvalOutcome = RegistrationApprovalOutcome.fromJson({
          ...result,
          'emailInviteSent': sent,
          'emailInviteDeliveryStatus': delivery.isEmpty
              ? (sent ? 'sent' : 'pending_or_failed')
              : delivery,
          'companyId':
              result['companyId']?.toString() ?? _approvalOutcome?.companyId,
          'adminEmail':
              result['adminEmail']?.toString() ?? _approvalOutcome?.adminEmail,
        });
      });
      await refreshRegistrationApplicationDetail(ref, widget.applicationId);
      if (!context.mounted) return;
      final message = switch (delivery) {
        'sent' || 'accepted_by_provider' || 'queued' =>
          resolveRegistrationKey(context, 'registrationPasswordSetupSent'),
        'provider_disabled' || 'skipped' => AppLocalizations.of(
          context,
        ).registrationInviteDeliveryProviderDisabled,
        'provider_not_configured' => AppLocalizations.of(
          context,
        ).registrationInviteDeliveryProviderNotConfigured,
        'blocked_by_staging_allowlist' || 'staging_allowlist_missing' =>
          AppLocalizations.of(
            context,
          ).registrationInviteDeliveryAllowlistBlocked,
        'failed' || 'pending_or_failed' => AppLocalizations.of(
          context,
        ).registrationInviteDeliveryFailed,
        _ when sent =>
          resolveRegistrationKey(context, 'registrationPasswordSetupSent'),
        _ => resolveRegistrationKey(context, 'registrationPasswordSetupQueued'),
      };
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveRegistrationKey(context, 'registrationDecisionError'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _decisionLoading = false);
    }
  }

  Future<void> _handleRevoke(BuildContext context) async {
    setState(() => _decisionLoading = true);
    try {
      await ref
          .read(registrationApplicationsRepositoryProvider)
          .revokeInvite(widget.applicationId);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveRegistrationKey(context, 'registrationInviteRevokeSuccess'),
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveRegistrationKey(context, 'registrationDecisionError'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _decisionLoading = false);
    }
  }

  Future<void> _handleDecision(
    BuildContext context,
    RegistrationDecisionType type,
  ) async {
    final request = await showRegistrationDecisionDialog(
      context: context,
      type: type,
    );
    if (request == null || !context.mounted) return;

    setState(() => _decisionLoading = true);
    try {
      final outcome = await submitRegistrationDecision(
        ref: ref,
        applicationId: widget.applicationId,
        request: request,
      );

      if (!context.mounted) return;
      if (type == RegistrationDecisionType.approve && outcome != null) {
        setState(() => _approvalOutcome = outcome);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resolveRegistrationKey(context, 'registrationApproveSuccess'),
            ),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resolveRegistrationKey(context, 'registrationDecisionSuccess'),
            ),
          ),
        );
      }
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveRegistrationKey(context, 'registrationDecisionError'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _decisionLoading = false);
    }
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.application,
    required this.applicationId,
    required this.canDecide,
    required this.decisionLoading,
    required this.approvalOutcome,
    required this.onDecision,
    this.onResendInvite,
    this.onSendPasswordSetup,
    this.onRevokeInvite,
  });

  final RegistrationApplication application;
  final String applicationId;
  final bool canDecide;
  final bool decisionLoading;
  final RegistrationApprovalOutcome? approvalOutcome;
  final ValueChanged<RegistrationDecisionType> onDecision;
  final VoidCallback? onResendInvite;
  final VoidCallback? onSendPasswordSetup;
  final VoidCallback? onRevokeInvite;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final submitted = application.submittedAt;
    final reviewed = application.reviewedAt;
    final showActions =
        canDecide && !application.status.isTerminal && approvalOutcome == null;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        if (!canDecide && !application.status.isTerminal)
          _SectionCard(
            title: resolveRegistrationKey(
              context,
              'registrationPermissionPolicyTitle',
            ),
            children: [
              Text(
                resolveRegistrationKey(
                  context,
                  'registrationPermissionSuperAdminOnly',
                ),
              ),
            ],
          ),
        if (approvalOutcome != null)
          _ApprovalOutcomeCard(
            outcome: approvalOutcome!,
            canManageInvite: canDecide,
            inviteBusy: decisionLoading,
            onResend: onResendInvite,
            onSendPasswordSetup: onSendPasswordSetup,
            onRevoke: onRevokeInvite,
          ),
        if (approvalOutcome == null &&
            application.status.isApproved &&
            canDecide)
          _SectionCard(
            title: resolveRegistrationKey(
              context,
              'registrationApproveOutcomeTitle',
            ),
            children: [
              Text(
                resolveRegistrationKey(
                  context,
                  'registrationInviteManageHint',
                ),
              ),
              if (onResendInvite != null) ...[
                const SizedBox(height: 8),
                OutlinedButton(
                  onPressed: decisionLoading
                      ? null
                      : () {
                          onResendInvite!();
                        },
                  child: Text(
                    resolveRegistrationKey(context, 'registrationInviteResend'),
                  ),
                ),
              ],
              if (onSendPasswordSetup != null) ...[
                const SizedBox(height: 8),
                FilledButton(
                  onPressed: decisionLoading
                      ? null
                      : () {
                          onSendPasswordSetup!();
                        },
                  child: Text(
                    resolveRegistrationKey(
                      context,
                      'registrationPasswordSetupSend',
                    ),
                  ),
                ),
              ],
            ],
          ),
        _SectionCard(
          title: resolveRegistrationKey(context, 'registrationSectionCompany'),
          children: [
            _InfoRow(
              label: resolveRegistrationKey(
                context,
                'registrationFieldApplicationReference',
              ),
              value: 'REG-$applicationId',
            ),
            _InfoRow(
              label: resolveRegistrationKey(
                context,
                'registrationFieldCompanyName',
              ),
              value: application.companyName,
            ),
            _InfoRow(
              label: resolveRegistrationKey(
                context,
                'registrationFieldCountry',
              ),
              value: application.country ?? '—',
            ),
            _InfoRow(
              label: resolveRegistrationKey(
                context,
                'registrationFieldVatNumber',
              ),
              value: application.vatNumber ?? '—',
            ),
            _InfoRow(
              label: resolveRegistrationKey(
                context,
                'registrationFieldRegistrationNumber',
              ),
              value: application.registrationNumber ?? '—',
            ),
          ],
        ),
        _SectionCard(
          title: resolveRegistrationKey(context, 'registrationSectionContact'),
          children: [
            _InfoRow(
              label: resolveRegistrationKey(
                context,
                'registrationFieldContactName',
              ),
              value: application.contactName ?? '—',
            ),
            _InfoRow(
              label: resolveRegistrationKey(
                context,
                'registrationFieldContactEmail',
              ),
              value: application.contactEmail,
            ),
          ],
        ),
        _SectionCard(
          title: resolveRegistrationKey(context, 'registrationSectionStatus'),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                VianexisStatusBadge(
                  label: resolveRegistrationKey(
                    context,
                    application.status.localizationKey(),
                  ),
                  tone: VianexisStatusTone.unknown,
                ),
                AiRiskBadge(riskLevel: application.riskLevel),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: resolveRegistrationKey(
                context,
                'registrationFieldSubmittedAt',
              ),
              value: submitted != null
                  ? DateFormat.yMMMd(locale).add_Hm().format(submitted)
                  : '—',
            ),
            if (reviewed != null)
              _InfoRow(
                label: resolveRegistrationKey(
                  context,
                  'registrationFieldReviewedAt',
                ),
                value: DateFormat.yMMMd(locale).add_Hm().format(reviewed),
              ),
            if (application.reviewedBy != null)
              _InfoRow(
                label: resolveRegistrationKey(
                  context,
                  'registrationFieldReviewedBy',
                ),
                value: application.reviewedBy!,
              ),
          ],
        ),
        if (application.status.isRejected ||
            (application.reviewNotes != null &&
                application.reviewNotes!.trim().isNotEmpty))
          _SectionCard(
            title: resolveRegistrationKey(
              context,
              application.status.isRejected
                  ? 'registrationRejectionReasonTitle'
                  : 'registrationSectionDecision',
            ),
            children: [
              if (reviewed != null)
                _InfoRow(
                  label: resolveRegistrationKey(
                    context,
                    'registrationFieldReviewedAt',
                  ),
                  value: DateFormat.yMMMd(locale).add_Hm().format(reviewed),
                ),
              _InfoRow(
                label: resolveRegistrationKey(
                  context,
                  'registrationFieldReviewNotes',
                ),
                value: (application.reviewNotes?.trim().isNotEmpty ?? false)
                    ? application.reviewNotes!.trim()
                    : '—',
              ),
            ],
          ),
        _SectionCard(
          title: resolveRegistrationKey(context, 'registrationSectionAiReview'),
          children: [
            _InfoRow(
              label: resolveRegistrationKey(
                context,
                'registrationFieldAiRecommendation',
              ),
              value: application.aiRecommendation ?? '—',
            ),
            _InfoRow(
              label: resolveRegistrationKey(
                context,
                'registrationFieldAiSummary',
              ),
              value: application.aiSummary ?? '—',
            ),
            if ((application.aiSummary ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              TranslationPanel(
                sourceType: 'registration_application',
                sourceId: applicationId,
                sourceField: 'aiSummary',
                originalText: application.aiSummary!.trim(),
              ),
            ],
            _BulletList(
              title: resolveRegistrationKey(
                context,
                'registrationFieldMissingInformation',
              ),
              items: application.missingInformation,
              emptyLabel: resolveRegistrationKey(
                context,
                'registrationNoneReported',
              ),
            ),
            _BulletList(
              title: resolveRegistrationKey(
                context,
                'registrationFieldDuplicateWarnings',
              ),
              items: application.duplicateWarnings,
              emptyLabel: resolveRegistrationKey(
                context,
                'registrationNoneReported',
              ),
            ),
            _BulletList(
              title: resolveRegistrationKey(
                context,
                'registrationFieldRiskFlags',
              ),
              items: application.riskFlags.entries
                  .map((entry) => '${entry.key}: ${entry.value}')
                  .toList(growable: false),
              emptyLabel: resolveRegistrationKey(
                context,
                'registrationNoneReported',
              ),
            ),
          ],
        ),
        _SectionCard(
          title: resolveRegistrationKey(
            context,
            'registrationSectionDocuments',
          ),
          children: [
            Text(
              resolveRegistrationKey(
                context,
                'registrationDocumentsMetadataOnly',
              ),
            ),
            const SizedBox(height: 12),
            if (application.documentMetadataOnly.isEmpty)
              Text(
                resolveRegistrationKey(context, 'registrationDocumentsEmpty'),
              )
            else
              for (final doc in application.documentMetadataOnly)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.description_outlined),
                  title: Text(doc.label),
                  subtitle: Text(
                    [
                      if (doc.documentType != null) doc.documentType,
                      if (doc.uploadedAt != null)
                        DateFormat.yMMMd(locale).format(doc.uploadedAt!),
                    ].whereType<String>().join(' · '),
                  ),
                ),
          ],
        ),
        if (showActions) ...[
          const SizedBox(height: 8),
          if (decisionLoading)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 16),
              child: Center(child: CircularProgressIndicator()),
            )
          else ...[
            FilledButton(
              onPressed: () => onDecision(RegistrationDecisionType.approve),
              child: Text(
                resolveRegistrationKey(context, 'registrationActionApprove'),
              ),
            ),
            const SizedBox(height: 8),
            OutlinedButton(
              onPressed: () => onDecision(RegistrationDecisionType.requestInfo),
              child: Text(
                resolveRegistrationKey(
                  context,
                  'registrationActionRequestInfo',
                ),
              ),
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () => onDecision(RegistrationDecisionType.reject),
              child: Text(
                resolveRegistrationKey(context, 'registrationActionReject'),
              ),
            ),
          ],
        ],
      ],
    );
  }
}

class _ApprovalOutcomeCard extends StatelessWidget {
  const _ApprovalOutcomeCard({
    required this.outcome,
    required this.canManageInvite,
    required this.inviteBusy,
    this.onResend,
    this.onSendPasswordSetup,
    this.onRevoke,
  });

  final RegistrationApprovalOutcome outcome;
  final bool canManageInvite;
  final bool inviteBusy;
  final VoidCallback? onResend;
  final VoidCallback? onSendPasswordSetup;
  final VoidCallback? onRevoke;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final deliveryLabel = switch (outcome.inviteDeliveryStatus) {
      'sent' => resolveRegistrationKey(
        context,
        'registrationInviteDeliverySent',
      ),
      'pending_or_failed' => resolveRegistrationKey(
        context,
        'registrationInviteDeliveryPending',
      ),
      'provider_disabled' || 'skipped' => AppLocalizations.of(
        context,
      ).registrationInviteDeliveryProviderDisabled,
      'provider_not_configured' => AppLocalizations.of(
        context,
      ).registrationInviteDeliveryProviderNotConfigured,
      'blocked_by_staging_allowlist' ||
      'staging_allowlist_missing' => AppLocalizations.of(
        context,
      ).registrationInviteDeliveryAllowlistBlocked,
      'failed' => AppLocalizations.of(
        context,
      ).registrationInviteDeliveryFailed,
      'accepted' => resolveRegistrationKey(
        context,
        'registrationInviteDeliveryAccepted',
      ),
      'expired' => resolveRegistrationKey(
        context,
        'registrationInviteDeliveryExpired',
      ),
      'revoked' => resolveRegistrationKey(
        context,
        'registrationInviteDeliveryRevoked',
      ),
      _ => outcome.inviteDeliveryStatus,
    };

    return _SectionCard(
      title: resolveRegistrationKey(context, 'registrationApproveOutcomeTitle'),
      children: [
        _InfoRow(
          label: resolveRegistrationKey(context, 'registrationFieldCompanyId'),
          value: outcome.companyId ?? '—',
        ),
        _InfoRow(
          label: resolveRegistrationKey(
            context,
            'registrationFieldCompanyName',
          ),
          value: outcome.companyName ?? '—',
        ),
        _InfoRow(
          label: resolveRegistrationKey(context, 'registrationFieldAdminEmail'),
          value: outcome.adminEmail ?? '—',
        ),
        _InfoRow(
          label: resolveRegistrationKey(
            context,
            'registrationFieldInviteStatus',
          ),
          value: deliveryLabel,
        ),
        if (outcome.inviteExpiresAt != null)
          _InfoRow(
            label: resolveRegistrationKey(
              context,
              'registrationFieldInviteExpiresAt',
            ),
            value: DateFormat.yMMMd(
              locale,
            ).add_Hm().format(outcome.inviteExpiresAt!.toLocal()),
          ),
        if (outcome.inviteTokenId != null)
          _InfoRow(
            label: resolveRegistrationKey(
              context,
              'registrationFieldInviteTokenId',
            ),
            value: outcome.inviteTokenId!,
          ),
        if (outcome.recipientEmailMasked != null)
          _InfoRow(
            label: AppLocalizations.of(context).applicationActivationRecipient,
            value: outcome.recipientEmailMasked!,
          ),
        if (outcome.activationUrlHost != null)
          _InfoRow(
            label: 'URL host',
            value: outcome.activationUrlHost!,
          ),
        if (outcome.activationUrl != null &&
            outcome.activationUrl!.isNotEmpty) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () async {
              await Clipboard.setData(
                ClipboardData(text: outcome.activationUrl!),
              );
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    AppLocalizations.of(context).registrationInviteLinkCopied,
                  ),
                ),
              );
            },
            child: Text(
              AppLocalizations.of(context).registrationInviteCopyLink,
            ),
          ),
        ],
        if (outcome.companyId != null) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () {
              context.push(
                AdminRoutes.platformCompanyDetail(outcome.companyId!),
              );
            },
            child: Text(
              resolveRegistrationKey(context, 'registrationOpenCompany'),
            ),
          ),
        ],
        if (canManageInvite && onResend != null) ...[
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: inviteBusy
                ? null
                : () {
                    onResend!();
                  },
            child: Text(
              resolveRegistrationKey(context, 'registrationInviteResend'),
            ),
          ),
        ],
        if (canManageInvite && onSendPasswordSetup != null) ...[
          const SizedBox(height: 8),
          FilledButton(
            onPressed: inviteBusy
                ? null
                : () {
                    onSendPasswordSetup!();
                  },
            child: Text(
              resolveRegistrationKey(
                context,
                'registrationPasswordSetupSend',
              ),
            ),
          ),
        ],
        if (canManageInvite && onRevoke != null) ...[
          const SizedBox(height: 8),
          TextButton(
            onPressed: inviteBusy
                ? null
                : () {
                    onRevoke!();
                  },
            child: Text(
              resolveRegistrationKey(context, 'registrationInviteRevoke'),
            ),
          ),
        ],
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
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
            width: 140,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({
    required this.title,
    required this.items,
    required this.emptyLabel,
  });

  final String title;
  final List<String> items;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          if (items.isEmpty)
            Text(emptyLabel)
          else
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
