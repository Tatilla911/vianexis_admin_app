import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/admin_user_status_update_request.dart';
import '../../domain/platform_admin_user_status.dart';

Future<AdminUserStatusUpdateRequest?> showAdminUserStatusDialog({
  required BuildContext context,
  required PlatformAdminUserStatus currentStatus,
}) {
  return showDialog<AdminUserStatusUpdateRequest>(
    context: context,
    builder: (dialogContext) => _AdminUserStatusDialog(currentStatus: currentStatus),
  );
}

class _AdminUserStatusDialog extends StatefulWidget {
  const _AdminUserStatusDialog({required this.currentStatus});

  final PlatformAdminUserStatus currentStatus;

  @override
  State<_AdminUserStatusDialog> createState() => _AdminUserStatusDialogState();
}

class _AdminUserStatusDialogState extends State<_AdminUserStatusDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  PlatformAdminUserStatus _status = PlatformAdminUserStatus.active;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(resolveAdminUserKey(context, 'adminUserStatusDialogTitle')),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              resolveAdminUserKey(
                context,
                'adminUserActionCurrentStatus',
                params: {
                  'status': resolveAdminUserKey(
                    context,
                    widget.currentStatus.localizationKey(),
                  ),
                },
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PlatformAdminUserStatus>(
              value: _status,
              decoration: InputDecoration(
                labelText: resolveAdminUserKey(context, 'adminUserFieldStatus'),
              ),
              items: [
                PlatformAdminUserStatus.active,
                PlatformAdminUserStatus.invited,
                PlatformAdminUserStatus.suspended,
                PlatformAdminUserStatus.disabled,
              ]
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(resolveAdminUserKey(context, status.localizationKey())),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: resolveAdminUserKey(context, 'adminUserReasonLabel'),
              ),
              maxLines: 3,
              validator: (value) {
                if (_status.requiresReason &&
                    (value == null || value.trim().length < 3)) {
                  return resolveAdminUserKey(context, 'adminUserReasonRequired');
                }
                return null;
              },
            ),
            const SizedBox(height: 12),
            Text(
              resolveAdminUserKey(context, 'adminUserActionAuditNotice'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(resolveAdminUserKey(context, 'adminUserActionCancel')),
        ),
        FilledButton(
          onPressed: () {
            if (!_formKey.currentState!.validate()) return;
            Navigator.of(context).pop(
              AdminUserStatusUpdateRequest(
                status: _status,
                reason: _reasonController.text.trim().isEmpty
                    ? null
                    : _reasonController.text,
              ),
            );
          },
          child: Text(resolveAdminUserKey(context, 'adminUserStatusConfirm')),
        ),
      ],
    );
  }
}
