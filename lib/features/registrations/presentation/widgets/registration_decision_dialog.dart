import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/registration_decision_request.dart';

Future<RegistrationDecisionRequest?> showRegistrationDecisionDialog({
  required BuildContext context,
  required RegistrationDecisionType type,
}) {
  return showDialog<RegistrationDecisionRequest>(
    context: context,
    builder: (dialogContext) => _RegistrationDecisionDialog(type: type),
  );
}

class _RegistrationDecisionDialog extends StatefulWidget {
  const _RegistrationDecisionDialog({required this.type});

  final RegistrationDecisionType type;

  @override
  State<_RegistrationDecisionDialog> createState() =>
      _RegistrationDecisionDialogState();
}

class _RegistrationDecisionDialogState extends State<_RegistrationDecisionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  bool get _requiresNotes =>
      widget.type == RegistrationDecisionType.reject ||
      widget.type == RegistrationDecisionType.requestInfo;

  String _titleKey() {
    return switch (widget.type) {
      RegistrationDecisionType.approve => 'registrationDecisionApproveTitle',
      RegistrationDecisionType.reject => 'registrationDecisionRejectTitle',
      RegistrationDecisionType.requestInfo => 'registrationDecisionRequestInfoTitle',
    };
  }

  String _confirmKey() {
    return switch (widget.type) {
      RegistrationDecisionType.approve => 'registrationDecisionApproveConfirm',
      RegistrationDecisionType.reject => 'registrationDecisionRejectConfirm',
      RegistrationDecisionType.requestInfo =>
        'registrationDecisionRequestInfoConfirm',
    };
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      RegistrationDecisionRequest(
        type: widget.type,
        reviewNotes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(resolveRegistrationKey(context, _titleKey())),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(resolveRegistrationKey(context, 'registrationDecisionAuditNotice')),
            if (_requiresNotes) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _notesController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: resolveRegistrationKey(
                    context,
                    'registrationDecisionNotesLabel',
                  ),
                ),
                validator: (value) {
                  if (!_requiresNotes) return null;
                  if (value == null || value.trim().length < 3) {
                    return resolveRegistrationKey(
                      context,
                      'registrationDecisionNotesRequired',
                    );
                  }
                  return null;
                },
              ),
            ] else ...[
              const SizedBox(height: 12),
              Text(resolveRegistrationKey(context, 'registrationDecisionApproveBody')),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(resolveRegistrationKey(context, 'registrationDecisionCancel')),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(resolveRegistrationKey(context, _confirmKey())),
        ),
      ],
    );
  }
}
