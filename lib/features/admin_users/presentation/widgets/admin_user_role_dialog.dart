import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/admin_user_role_update_request.dart';
import '../../domain/platform_admin_user_role.dart';

Future<AdminUserRoleUpdateRequest?> showAdminUserRoleDialog({
  required BuildContext context,
  required PlatformAdminUserRole currentRole,
}) {
  return showDialog<AdminUserRoleUpdateRequest>(
    context: context,
    builder: (dialogContext) => _AdminUserRoleDialog(currentRole: currentRole),
  );
}

class _AdminUserRoleDialog extends StatefulWidget {
  const _AdminUserRoleDialog({required this.currentRole});

  final PlatformAdminUserRole currentRole;

  @override
  State<_AdminUserRoleDialog> createState() => _AdminUserRoleDialogState();
}

class _AdminUserRoleDialogState extends State<_AdminUserRoleDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  late PlatformAdminUserRole _role;

  @override
  void initState() {
    super.initState();
    _role = widget.currentRole;
  }

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(resolveAdminUserKey(context, 'adminUserRoleDialogTitle')),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              resolveAdminUserKey(
                context,
                'adminUserActionCurrentRole',
                params: {
                  'role': roleLabel(context, widget.currentRole.localizationKey()),
                },
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<PlatformAdminUserRole>(
              initialValue: _role,
              decoration: InputDecoration(
                labelText: resolveAdminUserKey(context, 'adminUserFieldRole'),
              ),
              items: PlatformAdminUserRole.invitableRoles
                  .map(
                    (role) => DropdownMenuItem(
                      value: role,
                      child: Text(roleLabel(context, role.localizationKey())),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) setState(() => _role = value);
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
                if (value == null || value.trim().length < 3) {
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
              AdminUserRoleUpdateRequest(
                role: _role,
                reason: _reasonController.text,
              ),
            );
          },
          child: Text(resolveAdminUserKey(context, 'adminUserRoleConfirm')),
        ),
      ],
    );
  }
}
