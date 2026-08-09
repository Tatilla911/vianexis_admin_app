import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/admin_ops_feedback.dart';
import '../../../../core/api/api_exception.dart';
import '../../../../core/email/email_delivery_feedback.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../data/platform_companies_repository.dart';
import '../platform_companies_providers.dart';

class CompanyDossierOpsSection extends ConsumerStatefulWidget {
  const CompanyDossierOpsSection({
    super.key,
    required this.companyId,
    required this.canInviteOps,
    required this.canArchive,
  });

  final String companyId;
  final bool canInviteOps;
  final bool canArchive;

  @override
  ConsumerState<CompanyDossierOpsSection> createState() =>
      _CompanyDossierOpsSectionState();
}

class _CompanyDossierOpsSectionState
    extends ConsumerState<CompanyDossierOpsSection> {
  bool _busy = false;

  Future<void> _run(
    Future<Map<String, dynamic>> Function() action, {
    required String successKey,
    bool expectEmailDelivery = false,
  }) async {
    if (_busy) return;
    setState(() => _busy = true);
    try {
      final result = await action();
      if (!mounted) return;
      final successText = resolvePlatformCompanyKey(context, successKey);
      final message = expectEmailDelivery
          ? emailDeliveryUserMessage(
              context,
              result,
              successFallback: successText,
            )
          : successText;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      ref.invalidate(platformCompanyDetailProvider(widget.companyId));
    } catch (error) {
      if (!mounted) return;
      // Known business state: invite resend is only valid while admin is INVITED.
      if (error is ApiException &&
          error.errorCode == 'COMPANY_INVITE_RESEND_NOT_SUPPORTED') {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              resolvePlatformCompanyKey(
                context,
                'platformCompanyInviteResendAlreadyActive',
              ),
            ),
          ),
        );
        return;
      }
      showAdminOpsFailureSnackBar(
        context,
        error,
        resolveKey: resolvePlatformCompanyKey,
        fallbackKey: 'platformCompanyOpsFailed',
        endpointMissingKey: 'platformCompanyOpsEndpointMissing',
        permissionDeniedKey: 'platformCompanyOpsPermissionDenied',
        actionLabel: resolvePlatformCompanyKey(context, successKey),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _confirmDelete() async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            resolvePlatformCompanyKey(
              dialogContext,
              'platformCompanyDeleteConfirmTitle',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                resolvePlatformCompanyKey(
                  dialogContext,
                  'platformCompanyDeleteConfirmBody',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: resolvePlatformCompanyKey(
                    dialogContext,
                    'platformCompanyDeleteReasonLabel',
                  ),
                ),
                minLines: 2,
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                MaterialLocalizations.of(dialogContext).cancelButtonLabel,
              ),
            ),
            FilledButton(
              onPressed: () {
                if (reasonController.text.trim().length < 3) return;
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(
                resolvePlatformCompanyKey(
                  dialogContext,
                  'platformCompanyDeleteAction',
                ),
              ),
            ),
          ],
        );
      },
    );
    final reason = reasonController.text.trim();
    reasonController.dispose();
    if (confirmed != true || reason.length < 3) return;

    await _run(
      () => ref
          .read(platformCompaniesRepositoryProvider)
          .softDelete(id: widget.companyId, reason: reason),
      successKey: 'platformCompanyDeleteSuccess',
    );
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.canInviteOps && !widget.canArchive) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          resolvePlatformCompanyKey(context, 'platformCompanyOpsSection'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            if (widget.canInviteOps) ...[
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => _run(
                        () => ref
                            .read(platformCompaniesRepositoryProvider)
                            .resendInvite(widget.companyId),
                        successKey: 'platformCompanyInviteResendSuccess',
                        expectEmailDelivery: true,
                      ),
                icon: const Icon(Icons.mail_outline),
                label: Text(
                  resolvePlatformCompanyKey(
                    context,
                    'platformCompanyResendInviteAction',
                  ),
                ),
              ),
              OutlinedButton.icon(
                onPressed: _busy
                    ? null
                    : () => _run(
                        () => ref
                            .read(platformCompaniesRepositoryProvider)
                            .sendPasswordSetup(widget.companyId),
                        successKey: 'platformCompanyPasswordSetupSuccess',
                        expectEmailDelivery: true,
                      ),
                icon: const Icon(Icons.lock_reset_outlined),
                label: Text(
                  resolvePlatformCompanyKey(
                    context,
                    'platformCompanySendPasswordSetupAction',
                  ),
                ),
              ),
            ],
            if (widget.canArchive)
              OutlinedButton.icon(
                onPressed: _busy ? null : _confirmDelete,
                icon: const Icon(Icons.archive_outlined),
                label: Text(
                  resolvePlatformCompanyKey(
                    context,
                    'platformCompanyDeleteAction',
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
