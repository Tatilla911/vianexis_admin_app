import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/bulk_onboarding_type.dart';

class BulkOnboardingTemplateCard extends StatelessWidget {
  const BulkOnboardingTemplateCard({
    super.key,
    required this.type,
    required this.onDownload,
    this.isDownloading = false,
  });

  final BulkOnboardingJobType type;
  final VoidCallback onDownload;
  final bool isDownloading;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveBulkOnboardingKey(context, 'bulkOnboardingImportTemplate'),
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Text(resolveBulkOnboardingKey(context, type.localizationKey())),
            const SizedBox(height: 12),
            OutlinedButton.icon(
              onPressed: isDownloading ? null : onDownload,
              icon: isDownloading
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.download),
              label: Text(
                resolveBulkOnboardingKey(context, 'bulkOnboardingDownloadTemplate'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
