import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../domain/support_access_grant_request.dart';
import '../../domain/support_access_scope_type.dart';
import '../../domain/support_ticket_action_request.dart';

Future<SupportTicketActionRequest?> showSupportActionDialog({
  required BuildContext context,
  required SupportTicketActionType type,
}) {
  return showDialog<SupportTicketActionRequest>(
    context: context,
    builder: (dialogContext) => _SupportActionDialog(type: type),
  );
}

class _SupportActionDialog extends StatefulWidget {
  const _SupportActionDialog({required this.type});

  final SupportTicketActionType type;

  @override
  State<_SupportActionDialog> createState() => _SupportActionDialogState();
}

class _SupportActionDialogState extends State<_SupportActionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  bool get _requiresNote => widget.type == SupportTicketActionType.close;

  String _titleKey() {
    return switch (widget.type) {
      SupportTicketActionType.acknowledge => 'supportTicketActionAcknowledgeTitle',
      SupportTicketActionType.close => 'supportTicketActionCloseTitle',
    };
  }

  String _confirmKey() {
    return switch (widget.type) {
      SupportTicketActionType.acknowledge => 'supportTicketActionAcknowledgeConfirm',
      SupportTicketActionType.close => 'supportTicketActionCloseConfirm',
    };
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      SupportTicketActionRequest(
        type: widget.type,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(resolveSupportKey(context, _titleKey())),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(resolveSupportKey(context, 'supportActionAuditNotice')),
            if (_requiresNote) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: resolveSupportKey(context, 'supportActionNoteLabel'),
                ),
                validator: (value) {
                  if (!_requiresNote) return null;
                  if (value == null || value.trim().length < 3) {
                    return resolveSupportKey(context, 'supportActionNoteRequired');
                  }
                  return null;
                },
              ),
            ] else ...[
              const SizedBox(height: 12),
              Text(resolveSupportKey(context, 'supportTicketActionAcknowledgeBody')),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).confirmDialogCancel),
        ),
        FilledButton(
          style: widget.type == SupportTicketActionType.close
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                )
              : null,
          onPressed: _submit,
          child: Text(resolveSupportKey(context, _confirmKey())),
        ),
      ],
    );
  }
}

Future<SupportAccessGrantRequest?> showSupportRevokeDialog({
  required BuildContext context,
}) {
  return showDialog<SupportAccessGrantRequest>(
    context: context,
    builder: (dialogContext) => const _SupportRevokeDialog(),
  );
}

class _SupportRevokeDialog extends StatefulWidget {
  const _SupportRevokeDialog();

  @override
  State<_SupportRevokeDialog> createState() => _SupportRevokeDialogState();
}

class _SupportRevokeDialogState extends State<_SupportRevokeDialog> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      SupportAccessGrantRequest(
        companyId: '0',
        scopeType: SupportAccessScopeType.companyMetadata,
        reason: _noteController.text.trim(),
        expiresAt: DateTime.now().toUtc().add(const Duration(hours: 1)),
        type: SupportAccessGrantActionType.revoke,
      ),
    );
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(resolveSupportKey(context, 'supportGrantRevokeTitle')),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(resolveSupportKey(context, 'supportGrantAuditNotice')),
            const SizedBox(height: 16),
            TextFormField(
              controller: _noteController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: resolveSupportKey(context, 'supportGrantRevokeNoteLabel'),
              ),
              validator: (value) {
                if (value == null || value.trim().length < 3) {
                  return resolveSupportKey(context, 'supportGrantReasonRequired');
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).confirmDialogCancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.error,
            foregroundColor: Theme.of(context).colorScheme.onError,
          ),
          onPressed: _submit,
          child: Text(resolveSupportKey(context, 'supportGrantRevokeConfirm')),
        ),
      ],
    );
  }
}
