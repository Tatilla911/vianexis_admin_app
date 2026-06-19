import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

Future<bool?> showVianexisConfirmDialog({
  required BuildContext context,
  required String title,
  required String body,
  String? confirmLabel,
  String? cancelLabel,
  bool isDestructive = false,
}) {
  final l10n = AppLocalizations.of(context);
  return showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(title),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text(cancelLabel ?? l10n.confirmDialogCancel),
        ),
        FilledButton(
          style: isDestructive
              ? FilledButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.error,
                  foregroundColor: Theme.of(context).colorScheme.onError,
                )
              : null,
          onPressed: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel ?? l10n.confirmDialogProceed),
        ),
      ],
    ),
  );
}
