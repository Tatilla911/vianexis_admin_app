import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/system_health_action_request.dart';

Future<SystemHealthActionRequest?> showSystemHealthActionDialog({
  required BuildContext context,
  required SystemHealthActionType type,
}) {
  return showDialog<SystemHealthActionRequest>(
    context: context,
    builder: (dialogContext) => _SystemHealthActionDialog(type: type),
  );
}

class _SystemHealthActionDialog extends StatefulWidget {
  const _SystemHealthActionDialog({required this.type});

  final SystemHealthActionType type;

  @override
  State<_SystemHealthActionDialog> createState() =>
      _SystemHealthActionDialogState();
}

class _SystemHealthActionDialogState extends State<_SystemHealthActionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _noteController = TextEditingController();

  bool get _requiresNote => widget.type == SystemHealthActionType.escalate;

  String _titleKey() {
    return switch (widget.type) {
      SystemHealthActionType.acknowledge => 'systemHealthActionAcknowledgeTitle',
      SystemHealthActionType.escalate => 'systemHealthActionEscalateTitle',
    };
  }

  String _confirmKey() {
    return switch (widget.type) {
      SystemHealthActionType.acknowledge => 'systemHealthActionAcknowledgeConfirm',
      SystemHealthActionType.escalate => 'systemHealthActionEscalateConfirm',
    };
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).pop(
      SystemHealthActionRequest(
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
      title: Text(resolveSystemHealthKey(context, _titleKey())),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(resolveSystemHealthKey(context, 'systemHealthActionAuditNotice')),
            Text(
              resolveSystemHealthKey(context, 'systemHealthActionNoAutoRepair'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (_requiresNote) ...[
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: resolveSystemHealthKey(
                    context,
                    'systemHealthActionNoteLabel',
                  ),
                ),
                validator: (value) {
                  if (!_requiresNote) return null;
                  if (value == null || value.trim().length < 3) {
                    return resolveSystemHealthKey(
                      context,
                      'systemHealthActionNoteRequired',
                    );
                  }
                  return null;
                },
              ),
            ] else ...[
              const SizedBox(height: 12),
              Text(resolveSystemHealthKey(context, 'systemHealthActionAcknowledgeBody')),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(resolveSystemHealthKey(context, 'systemHealthActionCancel')),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(resolveSystemHealthKey(context, _confirmKey())),
        ),
      ],
    );
  }
}
