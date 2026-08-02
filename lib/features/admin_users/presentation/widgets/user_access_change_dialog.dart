import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/api/api_exception_feedback.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/user_access_api.dart';

Future<bool> showUserAccessChangeDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String userId,
  required List<UserAccessCatalogEntry> baseline,
  required Map<String, bool> draftEnabled,
}) async {
  final result = await showDialog<bool>(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) => _UserAccessChangeDialog(
      userId: userId,
      baseline: baseline,
      draftEnabled: draftEnabled,
      parentRef: ref,
    ),
  );
  return result == true;
}

class _UserAccessChangeDialog extends ConsumerStatefulWidget {
  const _UserAccessChangeDialog({
    required this.userId,
    required this.baseline,
    required this.draftEnabled,
    required this.parentRef,
  });

  final String userId;
  final List<UserAccessCatalogEntry> baseline;
  final Map<String, bool> draftEnabled;
  final WidgetRef parentRef;

  @override
  ConsumerState<_UserAccessChangeDialog> createState() =>
      _UserAccessChangeDialogState();
}

class _UserAccessChangeDialogState extends ConsumerState<_UserAccessChangeDialog> {
  final _reason = TextEditingController();
  final _requestedBy = TextEditingController();
  final _authorizedBy = TextEditingController();
  final _authReference = TextEditingController();
  final _internalComment = TextEditingController();
  final _userComment = TextEditingController();
  String _authMethod = 'internal_approval';
  String _applyMode = 'require_approval';
  bool _submitting = false;
  String? _error;

  List<MapEntry<UserAccessCatalogEntry, bool>> get _deltas {
    final out = <MapEntry<UserAccessCatalogEntry, bool>>[];
    for (final entry in widget.baseline) {
      final key = '${entry.targetType}:${entry.targetKey}';
      final next = widget.draftEnabled[key] ?? entry.active;
      if (next != entry.active) {
        out.add(MapEntry(entry, next));
      }
    }
    return out;
  }

  @override
  void dispose() {
    _reason.dispose();
    _requestedBy.dispose();
    _authorizedBy.dispose();
    _authReference.dispose();
    _internalComment.dispose();
    _userComment.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final deltas = _deltas;
    if (deltas.isEmpty) {
      setState(() => _error = 'No changes selected.');
      return;
    }
    if (_reason.text.trim().length < 3 ||
        _requestedBy.text.trim().isEmpty ||
        _authorizedBy.text.trim().isEmpty) {
      setState(() => _error = 'Reason, requestedBy and authorizedBy are required.');
      return;
    }
    setState(() {
      _submitting = true;
      _error = null;
    });
    try {
      await widget.parentRef.read(userAccessApiProvider).createChangeRequest(
        userId: widget.userId,
        changes: deltas
            .map(
              (d) => {
                'targetType': d.key.targetType,
                'targetKey': d.key.targetKey,
                'enabled': d.value,
              },
            )
            .toList(),
        reason: _reason.text.trim(),
        requestedByName: _requestedBy.text.trim(),
        authorizedByName: _authorizedBy.text.trim(),
        authorizationMethod: _authMethod,
        authorizationReference: _authReference.text.trim().isEmpty
            ? null
            : _authReference.text.trim(),
        internalComment: _internalComment.text.trim().isEmpty
            ? null
            : _internalComment.text.trim(),
        userVisibleComment: _userComment.text.trim().isEmpty
            ? null
            : _userComment.text.trim(),
        applyMode: _applyMode,
      );
      if (!mounted) return;
      Navigator.of(context).pop(true);
    } on ApiException catch (error) {
      if (!mounted) return;
      setState(() {
        _error = apiExceptionMessage(context, error);
        _submitting = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _error = error.toString();
        _submitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final deltas = _deltas;
    return AlertDialog(
      title: Text(l10n.adminUserAccessChangeTitle),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(l10n.adminUserAccessChangeIntro),
              const SizedBox(height: 12),
              ...deltas.map((d) {
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(d.key.targetKey),
                  subtitle: Text(
                    '${d.key.active ? l10n.adminUserAccessActive : l10n.adminUserAccessInactive}'
                    ' → '
                    '${d.value ? l10n.adminUserAccessActive : l10n.adminUserAccessInactive}',
                  ),
                );
              }),
              const SizedBox(height: 8),
              TextField(
                controller: _reason,
                decoration: InputDecoration(
                  labelText: '${l10n.adminUserAccessReason} *',
                ),
                maxLines: 3,
              ),
              TextField(
                controller: _requestedBy,
                decoration: InputDecoration(
                  labelText: '${l10n.adminUserAccessRequestedBy} *',
                ),
              ),
              TextField(
                controller: _authorizedBy,
                decoration: InputDecoration(
                  labelText: '${l10n.adminUserAccessAuthorizedBy} *',
                ),
              ),
              DropdownButtonFormField<String>(
                initialValue: _authMethod,
                decoration: InputDecoration(
                  labelText: l10n.adminUserAccessAuthMethod,
                ),
                items: const [
                  DropdownMenuItem(
                    value: 'customer_email',
                    child: Text('Customer email'),
                  ),
                  DropdownMenuItem(
                    value: 'internal_approval',
                    child: Text('Internal approval'),
                  ),
                  DropdownMenuItem(
                    value: 'contract',
                    child: Text('Contract'),
                  ),
                  DropdownMenuItem(value: 'other', child: Text('Other')),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _authMethod = value);
                },
              ),
              TextField(
                controller: _authReference,
                decoration: InputDecoration(
                  labelText: l10n.adminUserAccessAuthReference,
                ),
              ),
              TextField(
                controller: _internalComment,
                decoration: InputDecoration(
                  labelText: l10n.adminUserAccessInternalComment,
                ),
              ),
              TextField(
                controller: _userComment,
                decoration: InputDecoration(
                  labelText: l10n.adminUserAccessUserComment,
                ),
              ),
              DropdownButtonFormField<String>(
                initialValue: _applyMode,
                decoration: InputDecoration(
                  labelText: l10n.adminUserAccessApplyMode,
                ),
                items: [
                  DropdownMenuItem(
                    value: 'require_approval',
                    child: Text(l10n.adminUserAccessRequireApproval),
                  ),
                  DropdownMenuItem(
                    value: 'immediate',
                    child: Text(l10n.adminUserAccessApplyImmediate),
                  ),
                ],
                onChanged: (value) {
                  if (value != null) setState(() => _applyMode = value);
                },
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting ? null : () => Navigator.of(context).pop(false),
          child: Text(l10n.confirmDialogCancel),
        ),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: Text(
            _submitting
                ? l10n.adminUserAccessSaving
                : l10n.adminUserAccessSaveChanges,
          ),
        ),
      ],
    );
  }
}
