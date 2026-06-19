import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_type.dart';
import 'bulk_onboarding_file_picker_field.dart';
import 'bulk_onboarding_template_card.dart';
import 'bulk_onboarding_upload_progress.dart';

class BulkOnboardingUploadCard extends StatelessWidget {
  const BulkOnboardingUploadCard({
    super.key,
    required this.selectedType,
    required this.companyIdController,
    required this.companyNameController,
    required this.noteController,
    required this.fileName,
    required this.fileSizeBytes,
    required this.fileError,
    required this.isUploading,
    required this.uploadProgress,
    required this.isDownloadingTemplate,
    required this.onTypeChanged,
    required this.onPickFile,
    required this.onDownloadTemplate,
    required this.onSubmit,
  });

  final BulkOnboardingJobType selectedType;
  final TextEditingController companyIdController;
  final TextEditingController companyNameController;
  final TextEditingController noteController;
  final String? fileName;
  final int? fileSizeBytes;
  final String? fileError;
  final bool isUploading;
  final double? uploadProgress;
  final bool isDownloadingTemplate;
  final ValueChanged<BulkOnboardingJobType> onTypeChanged;
  final VoidCallback onPickFile;
  final VoidCallback onDownloadTemplate;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingUploadPreviewTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<BulkOnboardingJobType>(
              key: ValueKey(selectedType),
              initialValue: selectedType,
              decoration: InputDecoration(
                labelText: resolveBulkOnboardingKey(context, 'bulkOnboardingUploadTypeLabel'),
              ),
              items: BulkOnboardingJobType.values
                  .where((type) => type != BulkOnboardingJobType.unknown)
                  .map(
                    (type) => DropdownMenuItem(
                      value: type,
                      child: Text(
                        resolveBulkOnboardingKey(context, type.localizationKey()),
                      ),
                    ),
                  )
                  .toList(growable: false),
              onChanged: isUploading
                  ? null
                  : (value) {
                      if (value != null) onTypeChanged(value);
                    },
            ),
            const SizedBox(height: 12),
            TextField(
              controller: companyIdController,
              enabled: !isUploading,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: resolveBulkOnboardingKey(
                  context,
                  'bulkOnboardingUploadCompanyIdLabel',
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: companyNameController,
              enabled: !isUploading,
              decoration: InputDecoration(
                labelText: resolveBulkOnboardingKey(
                  context,
                  'bulkOnboardingUploadCompanyNameLabel',
                ),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: noteController,
              enabled: !isUploading,
              maxLines: 2,
              decoration: InputDecoration(
                labelText: resolveBulkOnboardingKey(context, 'bulkOnboardingUploadNoteLabel'),
              ),
            ),
            const SizedBox(height: 16),
            BulkOnboardingFilePickerField(
              fileName: fileName,
              fileSizeBytes: fileSizeBytes,
              onPick: onPickFile,
              errorText: fileError,
            ),
            const SizedBox(height: 12),
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingCsvOnlyNotice'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingNoRealProvisioningNotice'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingHumanApprovalNotice'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingAiAdvisoryNotice'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 16),
            BulkOnboardingTemplateCard(
              type: selectedType,
              isDownloading: isDownloadingTemplate,
              onDownload: onDownloadTemplate,
            ),
            if (isUploading) ...[
              const SizedBox(height: 16),
              BulkOnboardingUploadProgress(progress: uploadProgress),
            ],
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: isUploading ? null : onSubmit,
              icon: const Icon(Icons.cloud_upload),
              label: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingUploadCsv')),
            ),
          ],
        ),
      ),
    );
  }
}
