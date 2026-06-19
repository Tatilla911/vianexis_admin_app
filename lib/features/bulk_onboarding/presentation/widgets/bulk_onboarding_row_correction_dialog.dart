import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_row.dart';
import '../../domain/bulk_onboarding_row_action.dart';

Future<BulkOnboardingRowCorrectionRequest?> showBulkOnboardingRowCorrectionDialog({
  required BuildContext context,
  required BulkOnboardingRow row,
}) {
  return showDialog<BulkOnboardingRowCorrectionRequest>(
    context: context,
    builder: (dialogContext) => _BulkOnboardingRowCorrectionDialog(row: row),
  );
}

class _BulkOnboardingRowCorrectionDialog extends StatefulWidget {
  const _BulkOnboardingRowCorrectionDialog({required this.row});

  final BulkOnboardingRow row;

  @override
  State<_BulkOnboardingRowCorrectionDialog> createState() =>
      _BulkOnboardingRowCorrectionDialogState();
}

class _BulkOnboardingRowCorrectionDialogState
    extends State<_BulkOnboardingRowCorrectionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _countryController;
  late final TextEditingController _roleController;
  late final TextEditingController _vehiclePlateController;
  late final TextEditingController _trailerPlateController;
  late final TextEditingController _noteController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.row.name ?? '');
    _emailController = TextEditingController(text: widget.row.email ?? '');
    _phoneController = TextEditingController(text: widget.row.phone ?? '');
    _countryController = TextEditingController(text: widget.row.country ?? '');
    _roleController = TextEditingController(text: widget.row.role ?? '');
    _vehiclePlateController =
        TextEditingController(text: widget.row.vehiclePlate ?? '');
    _trailerPlateController =
        TextEditingController(text: widget.row.trailerPlate ?? '');
    _noteController = TextEditingController(text: widget.row.correctionNote ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _countryController.dispose();
    _roleController.dispose();
    _vehiclePlateController.dispose();
    _trailerPlateController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final request = BulkOnboardingRowCorrectionRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      country: _countryController.text.trim(),
      role: _roleController.text.trim(),
      vehiclePlate: _vehiclePlateController.text.trim(),
      trailerPlate: _trailerPlateController.text.trim(),
      note: _noteController.text.trim(),
    );
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
      title: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingRowCorrectionTitle')),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                resolveBulkOnboardingKey(context, 'bulkOnboardingRowCorrectionNotice'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 12),
              _field(_nameController, 'bulkOnboardingRowFieldName'),
              _field(_emailController, 'bulkOnboardingRowFieldEmail'),
              _field(_phoneController, 'bulkOnboardingRowFieldPhone'),
              _field(_countryController, 'bulkOnboardingRowFieldCountry'),
              _field(_roleController, 'bulkOnboardingRowFieldRole'),
              _field(_vehiclePlateController, 'bulkOnboardingRowFieldVehiclePlate'),
              _field(_trailerPlateController, 'bulkOnboardingRowFieldTrailerPlate'),
              _field(
                _noteController,
                'bulkOnboardingRowCorrectionNoteLabel',
                maxLines: 2,
              ),
              const SizedBox(height: 8),
              Text(
                resolveBulkOnboardingKey(context, 'bulkOnboardingRowActionAuditNotice'),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingActionDismiss')),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingRowCorrectionConfirm')),
        ),
      ],
    );
  }

  Widget _field(
    TextEditingController controller,
    String labelKey, {
    int maxLines = 1,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: TextFormField(
        controller: controller,
        maxLines: maxLines,
        decoration: InputDecoration(
          labelText: resolveBulkOnboardingKey(context, labelKey),
        ),
      ),
    );
  }
}
