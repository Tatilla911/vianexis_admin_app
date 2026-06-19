import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/support_access_grant_request.dart';
import '../../domain/support_access_scope_type.dart';

class SupportAccessGrantDialogPrefill {
  const SupportAccessGrantDialogPrefill({
    required this.companyId,
    this.companyName,
    this.linkedTicketId,
    this.linkedSystemHealthEventId,
    this.defaultScopeType = SupportAccessScopeType.companyMetadata,
    this.defaultScopeId,
  });

  final String companyId;
  final String? companyName;
  final String? linkedTicketId;
  final String? linkedSystemHealthEventId;
  final SupportAccessScopeType defaultScopeType;
  final String? defaultScopeId;
}

Future<SupportAccessGrantRequest?> showSupportAccessGrantDialog({
  required BuildContext context,
  required SupportAccessGrantDialogPrefill prefill,
}) {
  return showDialog<SupportAccessGrantRequest>(
    context: context,
    builder: (dialogContext) => _SupportAccessGrantDialog(prefill: prefill),
  );
}

class _SupportAccessGrantDialog extends StatefulWidget {
  const _SupportAccessGrantDialog({required this.prefill});

  final SupportAccessGrantDialogPrefill prefill;

  @override
  State<_SupportAccessGrantDialog> createState() =>
      _SupportAccessGrantDialogState();
}

class _SupportAccessGrantDialogState extends State<_SupportAccessGrantDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _scopeIdController = TextEditingController();

  late SupportAccessScopeType _scopeType = widget.prefill.defaultScopeType;
  late _ExpiryPreset _expiryPreset = _ExpiryPreset.twoHours;

  @override
  void initState() {
    super.initState();
    if (widget.prefill.defaultScopeId != null) {
      _scopeIdController.text = widget.prefill.defaultScopeId!;
    }
  }

  DateTime _expiresAt() {
    final now = DateTime.now().toUtc();
    return switch (_expiryPreset) {
      _ExpiryPreset.twoHours => now.add(SupportAccessGrantRequest.defaultShortExpiry),
      _ExpiryPreset.twentyFourHours => now.add(const Duration(hours: 24)),
    };
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final request = SupportAccessGrantRequest(
      companyId: widget.prefill.companyId,
      scopeType: _scopeType,
      scopeId: _scopeIdController.text.trim().isEmpty
          ? null
          : _scopeIdController.text.trim(),
      reason: _reasonController.text.trim(),
      expiresAt: _expiresAt(),
      linkedTicketId: widget.prefill.linkedTicketId,
      linkedSystemHealthEventId: widget.prefill.linkedSystemHealthEventId,
    );

    final validationKey = request.validationErrorKey();
    if (validationKey != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveSupportKey(context, validationKey))),
      );
      return;
    }

    Navigator.of(context).pop(request);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _scopeIdController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final requiresScopeId = _scopeType.requiresScopeId;

    return AlertDialog(
      title: Text(resolveSupportKey(context, 'supportGrantCreateTitle')),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(resolveSupportKey(context, 'supportGrantCreateWarning')),
              const SizedBox(height: 8),
              Text(
                resolveSupportKey(context, 'supportGrantAuditNotice'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              if (widget.prefill.companyName != null)
                Text(
                  resolveSupportKey(
                    context,
                    'supportGrantCompanyLabel',
                    params: {'name': widget.prefill.companyName!},
                  ),
                ),
              const SizedBox(height: 12),
              DropdownButtonFormField<SupportAccessScopeType>(
                initialValue: _scopeType,
                decoration: InputDecoration(
                  labelText: resolveSupportKey(context, 'supportGrantScopeTypeLabel'),
                ),
                items: SupportAccessScopeType.values
                    .where((type) => type != SupportAccessScopeType.unknown)
                    .map(
                      (type) => DropdownMenuItem(
                        value: type,
                        child: Text(resolveSupportKey(context, type.localizationKey())),
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _scopeType = value);
                },
              ),
              if (requiresScopeId) ...[
                const SizedBox(height: 12),
                TextFormField(
                  controller: _scopeIdController,
                  decoration: InputDecoration(
                    labelText: resolveSupportKey(context, 'supportGrantScopeIdFieldLabel'),
                  ),
                  validator: (value) {
                    if (!requiresScopeId) return null;
                    if (value == null || value.trim().isEmpty) {
                      return resolveSupportKey(context, 'supportGrantScopeIdRequired');
                    }
                    return null;
                  },
                ),
              ],
              const SizedBox(height: 12),
              TextFormField(
                controller: _reasonController,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: resolveSupportKey(context, 'supportGrantReasonLabel'),
                ),
                validator: (value) {
                  if (value == null || value.trim().length < 3) {
                    return resolveSupportKey(context, 'supportGrantReasonRequired');
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<_ExpiryPreset>(
                initialValue: _expiryPreset,
                decoration: InputDecoration(
                  labelText: resolveSupportKey(context, 'supportGrantExpiryLabel'),
                ),
                items: [
                  DropdownMenuItem(
                    value: _ExpiryPreset.twoHours,
                    child: Text(resolveSupportKey(context, 'supportGrantExpiryTwoHours')),
                  ),
                  DropdownMenuItem(
                    value: _ExpiryPreset.twentyFourHours,
                    child: Text(resolveSupportKey(context, 'supportGrantExpiryTwentyFourHours')),
                  ),
                ],
                onChanged: (value) {
                  if (value == null) return;
                  setState(() => _expiryPreset = value);
                },
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(resolveSupportKey(context, 'supportActionCancel')),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(resolveSupportKey(context, 'supportGrantCreateConfirm')),
        ),
      ],
    );
  }
}

enum _ExpiryPreset {
  twoHours,
  twentyFourHours,
}
