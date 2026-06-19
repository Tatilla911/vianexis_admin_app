import 'registration_application_status.dart';
import 'registration_risk_level.dart';

enum RegistrationApplicationType {
  company('company'),
  user('user'),
  bulkOnboarding('bulk_onboarding');

  const RegistrationApplicationType(this.backendValue);

  final String backendValue;

  static RegistrationApplicationType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return company;
    for (final type in RegistrationApplicationType.values) {
      if (type.backendValue == raw) return type;
    }
    return company;
  }

  String localizationKey() {
    return switch (this) {
      RegistrationApplicationType.company => 'registrationTypeCompany',
      RegistrationApplicationType.user => 'registrationTypeUser',
      RegistrationApplicationType.bulkOnboarding => 'registrationTypeBulkOnboarding',
    };
  }
}

class RegistrationDocumentMetadata {
  const RegistrationDocumentMetadata({
    required this.label,
    this.fileName,
    this.documentType,
    this.uploadedAt,
  });

  final String label;
  final String? fileName;
  final String? documentType;
  final DateTime? uploadedAt;

  factory RegistrationDocumentMetadata.fromJson(Map<String, dynamic> json) {
    return RegistrationDocumentMetadata(
      label: json['label']?.toString() ?? json['name']?.toString() ?? '—',
      fileName: json['fileName']?.toString(),
      documentType: json['documentType']?.toString() ?? json['type']?.toString(),
      uploadedAt: RegistrationApplication.parseDate(json['uploadedAt']),
    );
  }
}

class RegistrationApplication {
  const RegistrationApplication({
    required this.id,
    required this.type,
    required this.companyName,
    this.country,
    this.vatNumber,
    this.registrationNumber,
    this.contactName,
    required this.contactEmail,
    required this.status,
    required this.riskLevel,
    this.aiRecommendation,
    this.aiSummary,
    this.missingInformation = const [],
    this.duplicateWarnings = const [],
    this.submittedAt,
    this.reviewedAt,
    this.reviewedBy,
    this.documentMetadataOnly = const [],
    this.needsHumanReview = true,
    this.completenessScore,
    this.riskFlags = const {},
  });

  final String id;
  final RegistrationApplicationType type;
  final String companyName;
  final String? country;
  final String? vatNumber;
  final String? registrationNumber;
  final String? contactName;
  final String contactEmail;
  final RegistrationApplicationStatus status;
  final RegistrationRiskLevel riskLevel;
  final String? aiRecommendation;
  final String? aiSummary;
  final List<String> missingInformation;
  final List<String> duplicateWarnings;
  final DateTime? submittedAt;
  final DateTime? reviewedAt;
  final String? reviewedBy;
  final List<RegistrationDocumentMetadata> documentMetadataOnly;
  final bool needsHumanReview;
  final double? completenessScore;
  final Map<String, dynamic> riskFlags;

  bool get hasAiReview =>
      (aiRecommendation != null && aiRecommendation!.isNotEmpty) ||
      (aiSummary != null && aiSummary!.isNotEmpty);

  bool get isHighRisk => riskLevel == RegistrationRiskLevel.high;

  bool matchesSearch(String query) {
    if (query.trim().isEmpty) return true;
    final normalized = query.trim().toLowerCase();
    final haystack = [
      companyName,
      country,
      vatNumber,
      registrationNumber,
      contactEmail,
      contactName,
    ].whereType<String>().join(' ').toLowerCase();
    return haystack.contains(normalized);
  }

  bool matchesFilter(RegistrationListFilter filter) {
    return switch (filter) {
      RegistrationListFilter.all => true,
      RegistrationListFilter.pending => status.isPending,
      RegistrationListFilter.needsInfo => status.isNeedsInfo,
      RegistrationListFilter.aiReviewed => hasAiReview && !status.isTerminal,
      RegistrationListFilter.approved => status.isApproved,
      RegistrationListFilter.rejected => status.isRejected,
      RegistrationListFilter.highRisk => isHighRisk,
    };
  }

  factory RegistrationApplication.fromListItemJson(Map<String, dynamic> json) {
    return RegistrationApplication.fromJson(json);
  }

  factory RegistrationApplication.fromJson(
    Map<String, dynamic> json, {
    List<dynamic>? aiReviews,
  }) {
    final latestAi = _latestAiReview(aiReviews);
    final riskFlags = _asStringKeyedMap(json['riskFlags']);
    final riskScore = _asDouble(latestAi?['riskScore']);
    final riskLevel = riskScore != null
        ? RegistrationRiskLevel.fromRiskScore(riskScore)
        : RegistrationRiskLevel.fromBackendFlags(riskFlags);

    return RegistrationApplication(
      id: json['id']?.toString() ?? '',
      type: RegistrationApplicationType.fromBackendValue(json['type']?.toString()),
      companyName: json['companyName']?.toString() ?? '—',
      country: json['country']?.toString(),
      vatNumber: json['vatNumber']?.toString(),
      registrationNumber: json['registrationNumber']?.toString(),
      contactName: json['contactName']?.toString(),
      contactEmail:
          json['contactEmail']?.toString() ??
          json['requestedAdminEmail']?.toString() ??
          '—',
      status: RegistrationApplicationStatus.fromBackendValue(
        json['status']?.toString(),
      ),
      riskLevel: riskLevel,
      aiRecommendation: latestAi?['suggestedAction']?.toString(),
      aiSummary: latestAi?['summary']?.toString(),
      missingInformation: _parseMissingInformation(json, latestAi),
      duplicateWarnings: _parseDuplicateWarnings(json, latestAi),
      submittedAt: parseDate(json['createdAt'] ?? json['submittedAt']),
      reviewedAt: parseDate(json['reviewedAt']),
      reviewedBy: json['reviewedByUserId']?.toString(),
      documentMetadataOnly: _parseDocumentMetadata(json),
      needsHumanReview: json['needsHumanReview'] == true,
      completenessScore: _asDouble(json['completenessScore']),
      riskFlags: riskFlags,
    );
  }

  factory RegistrationApplication.fromDetailResponseJson(
    Map<String, dynamic> json,
  ) {
    final application = json['application'];
    final aiReviews = json['aiReviews'];
    if (application is Map<String, dynamic>) {
      return RegistrationApplication.fromJson(
        application,
        aiReviews: aiReviews is List ? aiReviews : null,
      );
    }
    if (application is Map) {
      return RegistrationApplication.fromJson(
        Map<String, dynamic>.from(application),
        aiReviews: aiReviews is List ? aiReviews : null,
      );
    }
    return RegistrationApplication.fromJson(json);
  }

  static Map<String, dynamic>? _latestAiReview(List<dynamic>? aiReviews) {
    if (aiReviews == null || aiReviews.isEmpty) return null;
    final first = aiReviews.first;
    if (first is Map<String, dynamic>) return first;
    if (first is Map) return Map<String, dynamic>.from(first);
    return null;
  }

  static List<String> _parseMissingInformation(
    Map<String, dynamic> json,
    Map<String, dynamic>? latestAi,
  ) {
    final items = <String>[];
    final score = _asDouble(json['completenessScore']);
    if (score != null && score < 0.8) {
      items.add('completeness_below_threshold');
    }

    final findings = latestAi?['findings'];
    if (findings is Map) {
      for (final entry in findings.entries) {
        if (entry.value == true || entry.value?.toString() == 'missing') {
          items.add(entry.key.toString());
        }
      }
    } else if (findings is List) {
      for (final item in findings) {
        if (item != null) items.add(item.toString());
      }
    }

    return items;
  }

  static List<String> _parseDuplicateWarnings(
    Map<String, dynamic> json,
    Map<String, dynamic>? latestAi,
  ) {
    final warnings = <String>[];
    final duplicateStatus = json['duplicateCheckStatus']?.toString();
    if (duplicateStatus != null &&
        duplicateStatus.isNotEmpty &&
        duplicateStatus.toLowerCase() != 'clear' &&
        duplicateStatus.toLowerCase() != 'none') {
      warnings.add(duplicateStatus);
    }

    final findings = latestAi?['findings'];
    if (findings is Map) {
      for (final entry in findings.entries) {
        final key = entry.key.toString().toLowerCase();
        if (key.contains('duplicate') && entry.value != false) {
          warnings.add(entry.key.toString());
        }
      }
    }

    return warnings;
  }

  static List<RegistrationDocumentMetadata> _parseDocumentMetadata(
    Map<String, dynamic> json,
  ) {
    final raw = json['documentMetadataOnly'] ?? json['documents'];
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => RegistrationDocumentMetadata.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);
  }

  static Map<String, dynamic> _asStringKeyedMap(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return const {};
  }

  static double? _asDouble(Object? raw) {
    if (raw is num) return raw.toDouble();
    if (raw is String && raw.trim().isNotEmpty) {
      return double.tryParse(raw);
    }
    return null;
  }

  static DateTime? parseDate(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}

class RegistrationApplicationsPage {
  const RegistrationApplicationsPage({
    required this.items,
    required this.total,
    this.privacyNoteKey,
  });

  final List<RegistrationApplication> items;
  final int total;
  final String? privacyNoteKey;

  factory RegistrationApplicationsPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map>()
            .map(
              (item) => RegistrationApplication.fromListItemJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList(growable: false)
        : <RegistrationApplication>[];

    return RegistrationApplicationsPage(
      items: items,
      total: _asInt(json['total']) ?? items.length,
      privacyNoteKey: json['privacyNoteKey']?.toString(),
    );
  }

  static int? _asInt(Object? raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw);
    return null;
  }
}
