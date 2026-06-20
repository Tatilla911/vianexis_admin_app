import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/customer_evidence_package.dart';
import '../../domain/evidence_package_request.dart';

class GenerateEvidencePackageDialog extends StatefulWidget {
  const GenerateEvidencePackageDialog({super.key});

  @override
  State<GenerateEvidencePackageDialog> createState() =>
      _GenerateEvidencePackageDialogState();
}

class _GenerateEvidencePackageDialogState
    extends State<GenerateEvidencePackageDialog> {
  final _reasonController = TextEditingController();
  CustomerEvidencePackageType _packageType =
      CustomerEvidencePackageType.communicationEvidence;
  String? _reasonError;

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  void _submit() {
    final reason = _reasonController.text.trim();
    if (reason.length < 5) {
      setState(() {
        _reasonError = resolveCustomerCommunicationsKey(
          context,
          'customerCommunicationReasonRequired',
        );
      });
      return;
    }

    Navigator.of(context).pop(
      EvidencePackageRequest(
        packageType: _packageType,
        reason: reason,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        resolveCustomerCommunicationsKey(
          context,
          'customerCommunicationGeneratePackageTitle',
        ),
      ),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationExportAuditWarning',
              ),
            ),
            const SizedBox(height: 16),
            DropdownButtonFormField<CustomerEvidencePackageType>(
              initialValue: _packageType,
              decoration: InputDecoration(
                labelText: resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationPackageTypeLabel',
                ),
              ),
              items: [
                CustomerEvidencePackageType.communicationEvidence,
                CustomerEvidencePackageType.subscriptionDispute,
                CustomerEvidencePackageType.registrationEvidence,
                CustomerEvidencePackageType.pricingEvidence,
              ].map((type) {
                return DropdownMenuItem(
                  value: type,
                  child: Text(
                    resolveCustomerCommunicationsKey(
                      context,
                      type.localizationKey(),
                    ),
                  ),
                );
              }).toList(growable: false),
              onChanged: (value) {
                if (value == null) return;
                setState(() => _packageType = value);
              },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _reasonController,
              maxLines: 4,
              decoration: InputDecoration(
                labelText: resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationReasonLabel',
                ),
                errorText: _reasonError,
              ),
              onChanged: (_) {
                if (_reasonError != null) {
                  setState(() => _reasonError = null);
                }
              },
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(
            resolveCustomerCommunicationsKey(
              context,
              'customerCommunicationCancel',
            ),
          ),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(
            resolveCustomerCommunicationsKey(
              context,
              'customerCommunicationGeneratePackageAction',
            ),
          ),
        ),
      ],
    );
  }
}
