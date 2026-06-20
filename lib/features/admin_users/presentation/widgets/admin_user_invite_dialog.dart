import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/admin_user_invite_request.dart';
import '../../domain/platform_admin_user_role.dart';

Future<AdminUserInviteRequest?> showAdminUserInviteDialog({
  required BuildContext context,
}) {
  return showDialog<AdminUserInviteRequest>(
    context: context,
    builder: (dialogContext) => const _AdminUserInviteDialog(),
  );
}

class _AdminUserInviteDialog extends StatefulWidget {
  const _AdminUserInviteDialog();

  @override
  State<_AdminUserInviteDialog> createState() => _AdminUserInviteDialogState();
}

class _AdminUserInviteDialogState extends State<_AdminUserInviteDialog> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _nameController = TextEditingController();
  final _noteController = TextEditingController();
  PlatformAdminUserRole _role = PlatformAdminUserRole.supportAdmin;

  @override
  void dispose() {
    _emailController.dispose();
    _nameController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return AlertDialog(
      title: Text(resolveAdminUserKey(context, 'adminUserInviteTitle')),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(resolveAdminUserKey(context, 'adminUserInviteNotice')),
              const SizedBox(height: 16),
              TextFormField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: l10n.authEmail,
                ),
                keyboardType: TextInputType.emailAddress,
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return l10n.authRequiredField;
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: resolveAdminUserKey(context, 'adminUserFieldName'),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 2) {
                    return resolveAdminUserKey(context, 'adminUserNameRequired');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
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
                controller: _noteController,
                decoration: InputDecoration(
                  labelText: resolveAdminUserKey(context, 'adminUserInviteNoteLabel'),
                ),
                maxLines: 2,
              ),
              const SizedBox(height: 12),
              Text(
                resolveAdminUserKey(context, 'adminUserActionAuditNotice'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
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
              AdminUserInviteRequest(
                email: _emailController.text,
                name: _nameController.text,
                role: _role,
                note: _noteController.text,
              ),
            );
          },
          child: Text(resolveAdminUserKey(context, 'adminUserInviteConfirm')),
        ),
      ],
    );
  }
}
