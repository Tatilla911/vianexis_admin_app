import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/public_intake_status.dart';

class PublicIntakeStatusDialogResult {
  const PublicIntakeStatusDialogResult({
    required this.status,
    this.reason,
  });

  final PublicIntakeStatus status;
  final String? reason;
}

Future<PublicIntakeStatusDialogResult?> showPublicIntakeStatusDialog({
  required BuildContext context,
  required PublicIntakeStatus initialStatus,
}) {
  return showDialog<PublicIntakeStatusDialogResult>(
    context: context,
    builder: (context) => _PublicIntakeStatusDialog(initialStatus: initialStatus),
  );
}

class _PublicIntakeStatusDialog extends StatefulWidget {
  const _PublicIntakeStatusDialog({required this.initialStatus});

  final PublicIntakeStatus initialStatus;

  @override
  State<_PublicIntakeStatusDialog> createState() =>
      _PublicIntakeStatusDialogState();
}

class _PublicIntakeStatusDialogState extends State<_PublicIntakeStatusDialog> {
  late PublicIntakeStatus _status = widget.initialStatus;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final statuses = [
      PublicIntakeStatus.reviewing,
      PublicIntakeStatus.contacted,
      PublicIntakeStatus.quoted,
      PublicIntakeStatus.converted,
      PublicIntakeStatus.rejected,
      PublicIntakeStatus.closed,
    ];

    return AlertDialog(
      title: Text(resolvePublicIntakeKey(context, 'publicIntakeStatusDialogTitle')),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            DropdownButtonFormField<PublicIntakeStatus>(
              initialValue: _status,
              decoration: InputDecoration(
                labelText: resolvePublicIntakeKey(context, 'publicIntakeFieldStatus'),
              ),
              items: statuses
                  .map(
                    (status) => DropdownMenuItem(
                      value: status,
                      child: Text(
                        resolvePublicIntakeKey(context, status.localizationKey()),
                      ),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (value) {
                if (value != null) setState(() => _status = value);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(
                labelText: resolvePublicIntakeKey(context, 'publicIntakeReasonLabel'),
                helperText: _status.requiresReasonOnClose
                    ? resolvePublicIntakeKey(context, 'publicIntakeReasonRequired')
                    : null,
              ),
              minLines: 2,
              maxLines: 4,
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(resolvePublicIntakeKey(context, 'publicIntakeCancel')),
        ),
        FilledButton(
          onPressed: () {
            final reason = _reasonController.text.trim();
            if (_status.requiresReasonOnClose && reason.length < 3) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    resolvePublicIntakeKey(context, 'publicIntakeReasonRequired'),
                  ),
                ),
              );
              return;
            }
            Navigator.of(context).pop(
              PublicIntakeStatusDialogResult(status: _status, reason: reason),
            );
          },
          child: Text(resolvePublicIntakeKey(context, 'publicIntakeStatusConfirm')),
        ),
      ],
    );
  }
}
