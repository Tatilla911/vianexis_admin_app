import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_row_action.dart';

Future<BulkOnboardingRowSkipRequest?> showBulkOnboardingRowSkipDialog({
  required BuildContext context,
}) {
  return showDialog<BulkOnboardingRowSkipRequest>(
    context: context,
    builder: (dialogContext) => const _BulkOnboardingRowSkipDialog(),
  );
}

class _BulkOnboardingRowSkipDialog extends StatefulWidget {
  const _BulkOnboardingRowSkipDialog();

  @override
  State<_BulkOnboardingRowSkipDialog> createState() =>
      _BulkOnboardingRowSkipDialogState();
}

class _BulkOnboardingRowSkipDialogState extends State<_BulkOnboardingRowSkipDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final request = BulkOnboardingRowSkipRequest(reason: _reasonController.text);
    final validationError = request.validate();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveBulkOnboardingKey(context, validationError))),
      );
      return;
    }
    Navigator.of(context).pop(request);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingRowSkipTitle')),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingRowSkipNotice'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: resolveBulkOnboardingKey(
                  context,
                  'bulkOnboardingRowSkipReasonLabel',
                ),
              ),
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return resolveBulkOnboardingKey(
                    context,
                    'bulkOnboardingRowSkipReasonRequired',
                  );
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingRowActionAuditNotice'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingActionDismiss')),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingRowSkipConfirm')),
        ),
      ],
    );
  }
}
