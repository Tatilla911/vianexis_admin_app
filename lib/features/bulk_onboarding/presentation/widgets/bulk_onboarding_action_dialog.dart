import 'package:flutter/material.dart';

import '../../../../l10n/app_localizations.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_action_request.dart';

Future<BulkOnboardingActionRequest?> showBulkOnboardingActionDialog({
  required BuildContext context,
  required BulkOnboardingActionKind kind,
  required bool processingAvailable,
}) {
  return showDialog<BulkOnboardingActionRequest>(
    context: context,
    builder: (dialogContext) => _BulkOnboardingActionDialog(
      kind: kind,
      processingAvailable: processingAvailable,
    ),
  );
}

class _BulkOnboardingActionDialog extends StatefulWidget {
  const _BulkOnboardingActionDialog({
    required this.kind,
    required this.processingAvailable,
  });

  final BulkOnboardingActionKind kind;
  final bool processingAvailable;

  @override
  State<_BulkOnboardingActionDialog> createState() =>
      _BulkOnboardingActionDialogState();
}

class _BulkOnboardingActionDialogState extends State<_BulkOnboardingActionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();
  bool _confirm = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  bool get _requiresNote =>
      widget.kind == BulkOnboardingActionKind.reject ||
      widget.kind == BulkOnboardingActionKind.cancel;

  bool get _requiresConfirm => widget.kind == BulkOnboardingActionKind.process;

  String _titleKey() {
    return switch (widget.kind) {
      BulkOnboardingActionKind.validate => 'bulkOnboardingActionValidateTitle',
      BulkOnboardingActionKind.approve => 'bulkOnboardingActionApproveTitle',
      BulkOnboardingActionKind.reject => 'bulkOnboardingActionRejectTitle',
      BulkOnboardingActionKind.cancel => 'bulkOnboardingActionCancelTitle',
      BulkOnboardingActionKind.process => 'bulkOnboardingActionProcessTitle',
    };
  }

  String _confirmKey() {
    return switch (widget.kind) {
      BulkOnboardingActionKind.validate => 'bulkOnboardingActionValidateConfirm',
      BulkOnboardingActionKind.approve => 'bulkOnboardingActionApproveConfirm',
      BulkOnboardingActionKind.reject => 'bulkOnboardingActionRejectConfirm',
      BulkOnboardingActionKind.cancel => 'bulkOnboardingActionCancelConfirm',
      BulkOnboardingActionKind.process => 'bulkOnboardingActionProcessConfirm',
    };
  }

  void _submit() {
    if (widget.kind == BulkOnboardingActionKind.process &&
        !widget.processingAvailable) {
      return;
    }
    if (!_formKey.currentState!.validate()) return;
    if (_requiresConfirm && !_confirm) return;

    Navigator.of(context).pop(
      BulkOnboardingActionRequest(
        kind: widget.kind,
        note: _noteController.text.trim().isEmpty
            ? null
            : _noteController.text.trim(),
        confirm: _confirm,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final processDisabled =
        widget.kind == BulkOnboardingActionKind.process &&
        !widget.processingAvailable;

    return AlertDialog(
      title: Text(resolveBulkOnboardingKey(context, _titleKey())),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(resolveBulkOnboardingKey(context, 'bulkOnboardingActionAuditNotice')),
            if (processDisabled) ...[
              const SizedBox(height: 12),
              Text(
                resolveBulkOnboardingKey(
                  context,
                  'bulkOnboardingProcessUnavailable',
                ),
                style: const TextStyle(color: Colors.red),
              ),
            ],
            if (_requiresNote) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: resolveBulkOnboardingKey(
                    context,
                    'bulkOnboardingActionNoteLabel',
                  ),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return resolveBulkOnboardingKey(
                      context,
                      'bulkOnboardingActionNoteRequired',
                    );
                  }
                  return null;
                },
                maxLines: 3,
              ),
            ],
            if (!_requiresNote &&
                widget.kind == BulkOnboardingActionKind.approve) ...[
              const SizedBox(height: 12),
              TextFormField(
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: resolveBulkOnboardingKey(
                    context,
                    'bulkOnboardingActionOptionalNoteLabel',
                  ),
                ),
                maxLines: 3,
              ),
            ],
            if (_requiresConfirm) ...[
              const SizedBox(height: 12),
              CheckboxListTile(
                contentPadding: EdgeInsets.zero,
                value: _confirm,
                onChanged: processDisabled
                    ? null
                    : (value) => setState(() => _confirm = value ?? false),
                title: Text(
                  resolveBulkOnboardingKey(
                    context,
                    'bulkOnboardingActionExplicitConfirm',
                  ),
                ),
              ),
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
          style: widget.kind == BulkOnboardingActionKind.reject ||
                  widget.kind == BulkOnboardingActionKind.cancel
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                )
              : null,
          onPressed: processDisabled ? null : _submit,
          child: Text(resolveBulkOnboardingKey(context, _confirmKey())),
        ),
      ],
    );
  }
}
