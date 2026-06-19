import 'bulk_onboarding_job.dart';

class BulkOnboardingUploadResult {
  const BulkOnboardingUploadResult({
    required this.job,
    required this.summary,
    this.processingAvailable = false,
    this.metadataOnly = true,
  });

  final BulkOnboardingJob job;
  final BulkOnboardingValidationCounts summary;
  final bool processingAvailable;
  final bool metadataOnly;

  factory BulkOnboardingUploadResult.fromJson(Map<String, dynamic> json) {
    final summaryRaw = json['summary'];
    return BulkOnboardingUploadResult(
      job: BulkOnboardingJob.fromDetailResponseJson(
        {'job': json['job'], 'metadataOnly': json['metadataOnly']},
      ),
      summary: summaryRaw is Map<String, dynamic>
          ? BulkOnboardingValidationCounts.fromJson(summaryRaw)
          : const BulkOnboardingValidationCounts(),
      processingAvailable: json['processingAvailable'] == true,
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class BulkOnboardingValidationCounts {
  const BulkOnboardingValidationCounts({
    this.totalRows = 0,
    this.validRows = 0,
    this.warningRows = 0,
    this.invalidRows = 0,
    this.duplicateRows = 0,
  });

  final int totalRows;
  final int validRows;
  final int warningRows;
  final int invalidRows;
  final int duplicateRows;

  factory BulkOnboardingValidationCounts.fromJson(Map<String, dynamic> json) {
    return BulkOnboardingValidationCounts(
      totalRows: _parseInt(json['totalRows']),
      validRows: _parseInt(json['validRows']),
      warningRows: _parseInt(json['warningRows']),
      invalidRows: _parseInt(json['invalidRows']),
      duplicateRows: _parseInt(json['duplicateRows']),
    );
  }
}

int _parseInt(Object? raw) {
  if (raw is int) return raw;
  return int.tryParse(raw?.toString() ?? '') ?? 0;
}
