import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';

class BulkOnboardingFilePickerField extends StatelessWidget {
  const BulkOnboardingFilePickerField({
    super.key,
    required this.fileName,
    required this.fileSizeBytes,
    required this.onPick,
    this.errorText,
  });

  final String? fileName;
  final int? fileSizeBytes;
  final VoidCallback onPick;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        OutlinedButton.icon(
          onPressed: onPick,
          icon: const Icon(Icons.upload_file),
          label: Text(resolveBulkOnboardingKey(context, 'bulkOnboardingChooseFile')),
        ),
        if (fileName != null) ...[
          const SizedBox(height: 8),
          Text(
            resolveBulkOnboardingKey(context, 'bulkOnboardingSelectedFile', params: {
              'name': fileName!,
            }),
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          if (fileSizeBytes != null)
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingFileSize', params: {
                'size': _formatBytes(fileSizeBytes!),
              }),
              style: Theme.of(context).textTheme.bodySmall,
            ),
        ],
        if (errorText != null) ...[
          const SizedBox(height: 8),
          Text(
            errorText!,
            style: TextStyle(color: Theme.of(context).colorScheme.error),
          ),
        ],
      ],
    );
  }

  String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}

Future<PlatformFile?> pickBulkOnboardingCsvFile() {
  return FilePicker.platform
      .pickFiles(
        type: FileType.custom,
        allowedExtensions: const ['csv'],
        withData: true,
      )
      .then((result) => result?.files.single);
}

bool isExcelBulkOnboardingFileName(String? name) {
  if (name == null) return false;
  final lower = name.toLowerCase();
  return lower.endsWith('.xlsx') ||
      lower.endsWith('.xls') ||
      lower.endsWith('.xlsm');
}
