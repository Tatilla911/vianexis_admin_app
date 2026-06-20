import 'ai_review_recommendation.dart';
import 'ai_review_risk_level.dart';
import 'ai_review_source_type.dart';

enum AiReviewFilter {
  all,
  highRisk,
  registration,
  bulkOnboarding,
  systemHealth,
  needsHumanReview,
}

extension AiReviewFilterLabels on AiReviewFilter {
  String localizationKey() => switch (this) {
    AiReviewFilter.all => 'aiReviewFilterAll',
    AiReviewFilter.highRisk => 'aiReviewFilterHighRisk',
    AiReviewFilter.registration => 'aiReviewFilterRegistration',
    AiReviewFilter.bulkOnboarding => 'aiReviewFilterBulkOnboarding',
    AiReviewFilter.systemHealth => 'aiReviewFilterSystemHealth',
    AiReviewFilter.needsHumanReview => 'aiReviewFilterNeedsHumanReview',
  };
}

class AiReviewSummary {
  const AiReviewSummary({
    required this.totalCount,
    required this.highRiskCount,
    required this.needsHumanReviewCount,
    required this.registrationCount,
    required this.bulkOnboardingCount,
    required this.systemHealthCount,
  });

  final int totalCount;
  final int highRiskCount;
  final int needsHumanReviewCount;
  final int registrationCount;
  final int bulkOnboardingCount;
  final int systemHealthCount;

  factory AiReviewSummary.fromItems(List<AiReviewItem> items) {
    return AiReviewSummary(
      totalCount: items.length,
      highRiskCount: items.where((item) => item.riskLevel == AiReviewRiskLevel.high).length,
      needsHumanReviewCount: items.where((item) => item.needsHumanReview).length,
      registrationCount: items
          .where((item) => item.sourceType == AiReviewSourceType.registrationApplication)
          .length,
      bulkOnboardingCount: items
          .where((item) => item.sourceType == AiReviewSourceType.bulkOnboardingJob)
          .length,
      systemHealthCount: items
          .where((item) => item.sourceType == AiReviewSourceType.systemHealthEvent)
          .length,
    );
  }
}

class AiReviewItem {
  const AiReviewItem({
    required this.id,
    required this.sourceType,
    required this.sourceId,
    required this.sourceLabel,
    this.companyId,
    this.companyName,
    required this.riskLevel,
    required this.recommendation,
    this.confidenceScore,
    required this.summary,
    this.checksPerformed = const [],
    this.missingInformation = const [],
    this.duplicateWarnings = const [],
    required this.createdAt,
    required this.updatedAt,
    required this.status,
    this.metadataOnly = true,
  });

  final String id;
  final AiReviewSourceType sourceType;
  final String sourceId;
  final String sourceLabel;
  final String? companyId;
  final String? companyName;
  final AiReviewRiskLevel riskLevel;
  final AiReviewRecommendation recommendation;
  final double? confidenceScore;
  final String summary;
  final List<String> checksPerformed;
  final List<String> missingInformation;
  final List<String> duplicateWarnings;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String status;
  final bool metadataOnly;

  bool get needsHumanReview =>
      status == 'pending_human' ||
      recommendation == AiReviewRecommendation.review ||
      recommendation == AiReviewRecommendation.requestInfo ||
      recommendation == AiReviewRecommendation.escalate ||
      recommendation == AiReviewRecommendation.cannotApproveYet;

  bool matchesSearch(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return [
      sourceLabel,
      companyName,
      summary,
      sourceType.backendValue,
    ].whereType<String>().any((value) => value.toLowerCase().contains(normalized));
  }

  bool matchesFilter(AiReviewFilter filter) {
    return switch (filter) {
      AiReviewFilter.all => true,
      AiReviewFilter.highRisk => riskLevel == AiReviewRiskLevel.high,
      AiReviewFilter.registration =>
        sourceType == AiReviewSourceType.registrationApplication,
      AiReviewFilter.bulkOnboarding =>
        sourceType == AiReviewSourceType.bulkOnboardingJob,
      AiReviewFilter.systemHealth =>
        sourceType == AiReviewSourceType.systemHealthEvent,
      AiReviewFilter.needsHumanReview => needsHumanReview,
    };
  }

  factory AiReviewItem.fromJson(Map<String, dynamic> json) {
    return AiReviewItem(
      id: json['id']?.toString() ?? '',
      sourceType: AiReviewSourceType.fromBackendValue(json['sourceType']?.toString()),
      sourceId: json['sourceId']?.toString() ?? '',
      sourceLabel: json['sourceLabel']?.toString() ?? '',
      companyId: json['companyId']?.toString(),
      companyName: json['companyName']?.toString(),
      riskLevel: AiReviewRiskLevel.fromBackendValue(json['riskLevel']?.toString()),
      recommendation: AiReviewRecommendation.fromBackendValue(
        json['recommendation']?.toString(),
      ),
      confidenceScore: _readDouble(json['confidenceScore']),
      summary: json['summary']?.toString() ?? '',
      checksPerformed: _readStringList(json['checksPerformed']),
      missingInformation: _readStringList(json['missingInformation']),
      duplicateWarnings: _readStringList(json['duplicateWarnings']),
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      updatedAt: DateTime.tryParse(json['updatedAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      status: json['status']?.toString() ?? 'unknown',
      metadataOnly: json['metadataOnly'] == true,
    );
  }
}

double? _readDouble(Object? value) {
  if (value == null) return null;
  if (value is num) return value.toDouble();
  return double.tryParse(value.toString());
}

List<String> _readStringList(Object? value) {
  if (value is! List) return const [];
  return value.map((entry) => entry.toString()).where((entry) => entry.isNotEmpty).toList();
}
