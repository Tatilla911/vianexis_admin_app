enum TranslationStatus {
  draft,
  machineTranslated,
  humanReviewed,
  approved,
  rejected,
  failed,
}

extension TranslationStatusParsing on TranslationStatus {
  static TranslationStatus? tryParse(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    switch (raw.trim().toLowerCase()) {
      case 'draft':
        return TranslationStatus.draft;
      case 'machine_translated':
        return TranslationStatus.machineTranslated;
      case 'human_reviewed':
        return TranslationStatus.humanReviewed;
      case 'approved':
        return TranslationStatus.approved;
      case 'rejected':
        return TranslationStatus.rejected;
      case 'failed':
        return TranslationStatus.failed;
      default:
        return null;
    }
  }

  String get apiValue {
    switch (this) {
      case TranslationStatus.draft:
        return 'draft';
      case TranslationStatus.machineTranslated:
        return 'machine_translated';
      case TranslationStatus.humanReviewed:
        return 'human_reviewed';
      case TranslationStatus.approved:
        return 'approved';
      case TranslationStatus.rejected:
        return 'rejected';
      case TranslationStatus.failed:
        return 'failed';
    }
  }

  bool get isApproved => this == TranslationStatus.approved;
}
