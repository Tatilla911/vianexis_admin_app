import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/api/api_exception.dart';
import '../../../../core/api/api_exception_feedback.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/platform_companies_repository.dart';
import '../../domain/authorization_method_l10n.dart';
import '../../domain/company_data_amendment.dart';
import '../platform_companies_providers.dart';

Future<CompanyDataAmendment?> showCompanyDataAmendmentDialog({
  required BuildContext context,
  required WidgetRef ref,
  required String companyId,
  int? expectedDataVersion,
}) async {
  final result = await showDialog<CompanyDataAmendment>(
    context: context,
    builder: (dialogContext) => _CompanyDataAmendmentDialog(
      companyId: companyId,
      expectedDataVersion: expectedDataVersion,
      parentRef: ref,
    ),
  );
  return result;
}

class _CompanyDataAmendmentDialog extends ConsumerStatefulWidget {
  const _CompanyDataAmendmentDialog({
    required this.companyId,
    required this.parentRef,
    this.expectedDataVersion,
  });

  final String companyId;
  final WidgetRef parentRef;
  final int? expectedDataVersion;

  @override
  ConsumerState<_CompanyDataAmendmentDialog> createState() =>
      _CompanyDataAmendmentDialogState();
}

class _CompanyDataAmendmentDialogState
    extends ConsumerState<_CompanyDataAmendmentDialog> {
  final _reasonController = TextEditingController();
  final _newValueController = TextEditingController();
  final _authSourceController = TextEditingController();
  final _authorizedByController = TextEditingController();
  final _authReferenceController = TextEditingController();
  final _internalCommentController = TextEditingController();
  final _customerCommentController = TextEditingController();

  CompanyAmendmentFieldOption? _field;
  String? _enumNewValue;
  String _authMethod = canonicalAuthorizationMethods.first;
  String? _errorText;
  bool _submitting = false;

  InputDecoration _denseDecoration(String label, {String? hint}) {
    return InputDecoration(
      labelText: label,
      hintText: hint,
      isDense: true,
    );
  }

  String _requiredLabel(BuildContext context, String key) {
    return '${resolvePlatformCompanyKey(context, key)} *';
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _newValueController.dispose();
    _authSourceController.dispose();
    _authorizedByController.dispose();
    _authReferenceController.dispose();
    _internalCommentController.dispose();
    _customerCommentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final fieldsAsync = ref.watch(
      platformCompanyAmendmentFieldsProvider(widget.companyId),
    );
    final registrationAsync = ref.watch(
      platformCompanyRegistrationSnapshotProvider(widget.companyId),
    );
    final maxHeight = MediaQuery.sizeOf(context).height * 0.7;

    return AlertDialog(
      title: Text(
        resolvePlatformCompanyKey(context, 'platformCompanyAmendAction'),
      ),
      content: SizedBox(
        width: 480,
        child: ConstrainedBox(
          constraints: BoxConstraints(maxHeight: maxHeight),
          child: fieldsAsync.when(
            loading: () => const SizedBox(
              height: 120,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, _) => Text(
              resolvePlatformCompanyKey(
                context,
                'platformCompanyAmendLoadError',
              ),
            ),
            data: (fields) {
              final currentMap =
                  registrationAsync.asData?.value.currentValid ?? const {};
              final currentValue = _field == null
                  ? null
                  : _currentValueForField(currentMap, _field!.fieldPath);
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonFormField<CompanyAmendmentFieldOption>(
                      initialValue: _field,
                      decoration: _denseDecoration(
                        _requiredLabel(
                          context,
                          'platformCompanyAmendFieldLabel',
                        ),
                      ),
                      items: fields
                          .map(
                            (f) => DropdownMenuItem(
                              value: f,
                              child: Text(
                                resolvePlatformCompanyKey(
                                  context,
                                  f.fieldLabelKey,
                                ),
                              ),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: _submitting
                          ? null
                          : (value) {
                              setState(() {
                                _field = value;
                                _enumNewValue = null;
                                _newValueController.text = _editableNewValue(
                                  value,
                                  currentMap,
                                );
                              });
                            },
                    ),
                    const SizedBox(height: 12),
                    Text(
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanyAmendCurrentValue',
                      ),
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    Text(_formatValue(currentValue)),
                    if (_field?.sensitive == true) ...[
                      const SizedBox(height: 8),
                      Text(
                        resolvePlatformCompanyKey(
                          context,
                          'platformCompanyAmendSensitiveNotice',
                        ),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Theme.of(context).colorScheme.tertiary,
                            ),
                      ),
                    ],
                    const SizedBox(height: 12),
                    _buildNewValueField(context),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _reasonController,
                      maxLines: 2,
                      enabled: !_submitting,
                      decoration: _denseDecoration(
                        _requiredLabel(context, 'platformCompanyAmendReason'),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _authSourceController,
                      enabled: !_submitting,
                      decoration: _denseDecoration(
                        _requiredLabel(
                          context,
                          'platformCompanyAmendAuthSource',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _authorizedByController,
                      enabled: !_submitting,
                      decoration: _denseDecoration(
                        _requiredLabel(
                          context,
                          'platformCompanyAmendAuthorizedBy',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      initialValue: _authMethod,
                      decoration: _denseDecoration(
                        _requiredLabel(
                          context,
                          'platformCompanyAmendAuthMethod',
                        ),
                      ),
                      items: canonicalAuthorizationMethods
                          .map(
                            (m) => DropdownMenuItem(
                              value: m,
                              child: Text(
                                resolvePlatformCompanyKey(
                                  context,
                                  authorizationMethodL10nKey(m),
                                ),
                              ),
                            ),
                          )
                          .toList(growable: false),
                      onChanged: _submitting
                          ? null
                          : (v) {
                              if (v != null) setState(() => _authMethod = v);
                            },
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _authReferenceController,
                      enabled: !_submitting,
                      decoration: _denseDecoration(
                        resolvePlatformCompanyKey(
                          context,
                          'platformCompanyAmendAuthReference',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _internalCommentController,
                      maxLines: 2,
                      enabled: !_submitting,
                      decoration: _denseDecoration(
                        _requiredLabel(
                          context,
                          'platformCompanyAmendInternalComment',
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextField(
                      controller: _customerCommentController,
                      maxLines: 2,
                      enabled: !_submitting,
                      decoration: _denseDecoration(
                        resolvePlatformCompanyKey(
                          context,
                          'platformCompanyAmendCustomerComment',
                        ),
                      ),
                    ),
                    if (_errorText != null) ...[
                      const SizedBox(height: 12),
                      Text(
                        _errorText!,
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: _submitting
              ? null
              : () => Navigator.of(context).pop(),
          child: Text(
            resolvePlatformCompanyKey(context, 'platformCompanyStatusDismiss'),
          ),
        ),
        FilledButton(
          onPressed: _submitting ? null : _submit,
          child: _submitting
              ? const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              : Text(
                  resolvePlatformCompanyKey(
                    context,
                    'platformCompanyAmendSubmit',
                  ),
                ),
        ),
      ],
    );
  }

  Widget _buildNewValueField(BuildContext context) {
    final field = _field;
    final label = _requiredLabel(context, 'platformCompanyAmendNewValue');
    final enumValues = field?.enumValues;
    final isEnum =
        field != null &&
        field.valueType.toLowerCase() == 'enum' &&
        enumValues != null &&
        enumValues.isNotEmpty;
    final isJson = field != null && field.valueType.toLowerCase() == 'json';

    if (isEnum) {
      return DropdownButtonFormField<String>(
        initialValue: _enumNewValue,
        decoration: _denseDecoration(label),
        items: enumValues
            .map(
              (v) => DropdownMenuItem(value: v, child: Text(v)),
            )
            .toList(growable: false),
        onChanged: _submitting
            ? null
            : (v) {
                setState(() {
                  _enumNewValue = v;
                  _newValueController.text = v ?? '';
                });
              },
      );
    }

    return TextField(
      controller: _newValueController,
      enabled: !_submitting,
      maxLines: isJson ? 4 : 1,
      decoration: _denseDecoration(
        label,
        hint: isJson
            ? resolvePlatformCompanyKey(
                context,
                'platformCompanyAmendNewValueJsonHint',
              )
            : null,
      ),
    );
  }

  Future<void> _submit() async {
    if (_submitting) return;

    final field = _field;
    if (field == null) {
      setState(
        () => _errorText = resolvePlatformCompanyKey(
          context,
          'platformCompanyAmendFieldRequired',
        ),
      );
      return;
    }
    if (_reasonController.text.trim().length < 3) {
      setState(
        () => _errorText = resolvePlatformCompanyKey(
          context,
          'platformCompanyAmendReasonRequired',
        ),
      );
      return;
    }
    if (_authorizedByController.text.trim().isEmpty ||
        _authSourceController.text.trim().isEmpty ||
        _internalCommentController.text.trim().isEmpty) {
      setState(
        () => _errorText = resolvePlatformCompanyKey(
          context,
          'platformCompanyAmendAuthRequired',
        ),
      );
      return;
    }

    final Object? newValue;
    try {
      newValue = _resolveNewValue(field);
    } on FormatException {
      setState(
        () => _errorText = resolvePlatformCompanyKey(
          context,
          field.valueType.toLowerCase() == 'json'
              ? 'platformCompanyAmendNewValueJsonHint'
              : 'platformCompanyAmendNewValue',
        ),
      );
      return;
    }

    setState(() {
      _submitting = true;
      _errorText = null;
    });

    try {
      debugPrint(
        'company amendment submit endpoint=/platform-admin/companies/${widget.companyId}/amendments '
        'companyId=${widget.companyId} fieldPath=${field.fieldPath} '
        'authorizationMethod=$_authMethod '
        'reasonPresent=${_reasonController.text.trim().isNotEmpty} '
        'expectedDataVersion=${widget.expectedDataVersion}',
      );
      final created = await widget.parentRef
          .read(platformCompaniesRepositoryProvider)
          .createAmendment(
            id: widget.companyId,
            request: CreateCompanyAmendmentRequest(
              fieldPath: field.fieldPath,
              newValue: newValue,
              reason: _reasonController.text.trim(),
              authorizationSource: _authSourceController.text.trim(),
              authorizedByName: _authorizedByController.text.trim(),
              authorizationMethod: _authMethod,
              authorizationReference:
                  _authReferenceController.text.trim().isEmpty
                      ? null
                      : _authReferenceController.text.trim(),
              internalComment: _internalCommentController.text.trim(),
              customerVisibleComment:
                  _customerCommentController.text.trim().isEmpty
                      ? null
                      : _customerCommentController.text.trim(),
              expectedDataVersion: widget.expectedDataVersion,
            ),
          );
      widget.parentRef.invalidate(
        platformCompanyAmendmentsProvider(widget.companyId),
      );
      widget.parentRef.invalidate(
        platformCompanyRegistrationSnapshotProvider(widget.companyId),
      );
      widget.parentRef.invalidate(
        platformCompanyDetailProvider(widget.companyId),
      );
      await widget.parentRef
          .read(platformCompaniesProvider.notifier)
          .refresh();
      if (mounted) Navigator.of(context).pop(created);
    } on ApiException catch (error) {
      debugPrint(
        'company amendment failed status=${error.statusCode} '
        'errorCode=${error.errorCode} requestId=${error.requestId} '
        'endpoint=${error.endpoint} messageKey=${error.messageKey}',
      );
      if (mounted) {
        setState(() {
          _submitting = false;
          _errorText = _formatAmendmentError(context, error);
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _submitting = false;
          _errorText = resolvePlatformCompanyKey(
            context,
            'platformCompanyAmendSubmitError',
          );
        });
      }
    }
  }

  String _formatAmendmentError(BuildContext context, ApiException error) {
    final l10n = AppLocalizations.of(context);
    final base = apiExceptionMessage(context, error);
    final parts = <String>[base];
    final requestId = error.requestId?.trim();
    if (requestId != null && requestId.isNotEmpty) {
      parts.add(l10n.platformCompanyAmendRequestId(requestId));
    }
    final details = [
      if (error.statusCode != null) 'HTTP ${error.statusCode}',
      if (error.errorCode != null && error.errorCode!.isNotEmpty)
        error.errorCode!,
      if (error.messageKeyFromApi != null &&
          error.messageKeyFromApi!.trim().isNotEmpty)
        error.messageKeyFromApi!,
      if (error.backendMessage != null &&
          error.backendMessage!.trim().isNotEmpty &&
          error.backendMessage != base)
        error.backendMessage!,
    ].join(' · ');
    if (details.isNotEmpty) {
      parts.add('${l10n.platformCompanyAmendDevDetails}: $details');
    }
    return parts.join('\n');
  }

  String _editableNewValue(
    CompanyAmendmentFieldOption? field,
    Map<String, dynamic> currentMap,
  ) {
    if (field == null) return '';
    final current = _currentValueForField(currentMap, field.fieldPath);
    if (current == null) return '';
    if (field.valueType.toLowerCase() == 'json') {
      if (current is Map) {
        return const JsonEncoder.withIndent('  ').convert(current);
      }
      if (current is String && current.trim().isNotEmpty) {
        try {
          final decoded = jsonDecode(current);
          if (decoded is Map) {
            return const JsonEncoder.withIndent('  ').convert(decoded);
          }
        } catch (_) {
          return current;
        }
      }
      return '';
    }
    return current.toString();
  }

  Object? _resolveNewValue(CompanyAmendmentFieldOption field) {
    final raw = _newValueController.text.trim();
    if (raw.isEmpty) {
      throw const FormatException('New value is required');
    }
    if (field.valueType.toLowerCase() != 'json') {
      return raw;
    }
    final decoded = jsonDecode(raw);
    if (decoded is! Map) {
      throw const FormatException('Contact JSON must be an object');
    }
    return Map<String, dynamic>.from(decoded);
  }

  Object? _currentValueForField(Map<String, dynamic> current, String path) {
    final key = path.split('.').last;
    return current[key] ?? current[path];
  }

  String _formatValue(Object? value) {
    if (value == null) return '—';
    if (value is Map || value is List) {
      try {
        return const JsonEncoder.withIndent('  ').convert(value);
      } catch (_) {
        return value.toString();
      }
    }
    final text = value.toString().trim();
    return text.isEmpty ? '—' : text;
  }
}
