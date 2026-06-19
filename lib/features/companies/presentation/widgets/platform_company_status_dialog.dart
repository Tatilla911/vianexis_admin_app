import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_company_status.dart';
import '../../domain/platform_company_status_request.dart';

Future<PlatformCompanyStatusRequest?> showPlatformCompanyStatusDialog({
  required BuildContext context,
  required PlatformCompanyStatus currentStatus,
}) {
  return showDialog<PlatformCompanyStatusRequest>(
    context: context,
    builder: (dialogContext) => _PlatformCompanyStatusDialog(
      currentStatus: currentStatus,
    ),
  );
}

class _PlatformCompanyStatusDialog extends StatefulWidget {
  const _PlatformCompanyStatusDialog({required this.currentStatus});

  final PlatformCompanyStatus currentStatus;

  @override
  State<_PlatformCompanyStatusDialog> createState() =>
      _PlatformCompanyStatusDialogState();
}

class _PlatformCompanyStatusDialogState extends State<_PlatformCompanyStatusDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  late PlatformCompanyStatus _selectedStatus;

  @override
  void initState() {
    super.initState();
    _selectedStatus = widget.currentStatus;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final request = PlatformCompanyStatusRequest(
      status: _selectedStatus,
      reason: _reasonController.text,
    );
    final validationError = request.validate();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolvePlatformCompanyKey(context, validationError))),
      );
      return;
    }
    Navigator.of(context).pop(request);
  }

  @override
  Widget build(BuildContext context) {
    final selectableStatuses = [
      PlatformCompanyStatus.active,
      PlatformCompanyStatus.pendingReview,
      PlatformCompanyStatus.suspended,
      PlatformCompanyStatus.disabled,
      PlatformCompanyStatus.archived,
    ];

    return AlertDialog(
      title: Text(resolvePlatformCompanyKey(context, 'platformCompanyStatusDialogTitle')),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              resolvePlatformCompanyKey(context, 'platformCompanyStatusDialogNotice'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<PlatformCompanyStatus>(
              initialValue: _selectedStatus,
              decoration: InputDecoration(
                labelText: resolvePlatformCompanyKey(
                  context,
                  'platformCompanyStatusFieldLabel',
                ),
              ),
              items: [
                for (final status in selectableStatuses)
                  DropdownMenuItem(
                    value: status,
                    child: Text(
                      resolvePlatformCompanyKey(context, status.localizationKey()),
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _selectedStatus = value);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _reasonController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: resolvePlatformCompanyKey(
                  context,
                  'platformCompanyStatusReasonLabel',
                ),
              ),
              validator: (value) {
                if (_selectedStatus.isRestrictive &&
                    (value == null || value.trim().isEmpty)) {
                  return resolvePlatformCompanyKey(
                    context,
                    'platformCompanyStatusReasonRequired',
                  );
                }
                return null;
              },
            ),
            const SizedBox(height: 8),
            Text(
              resolvePlatformCompanyKey(context, 'platformCompanyStatusAuditNotice'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(resolvePlatformCompanyKey(context, 'platformCompanyStatusDismiss')),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(resolvePlatformCompanyKey(context, 'platformCompanyStatusConfirm')),
        ),
      ],
    );
  }
}
