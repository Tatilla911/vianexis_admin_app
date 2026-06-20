import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../domain/ai_review_item.dart';
import '../domain/ai_review_recommendation.dart';
import '../domain/ai_review_risk_level.dart';
import '../domain/ai_review_source_type.dart';
import 'ai_reviews_api.dart';

abstract class AiReviewsRepository {
  Future<List<AiReviewItem>> fetchReviews();

  Future<AiReviewItem> fetchReview(String id);

  bool get usesMockData;
}

class LiveAiReviewsRepository implements AiReviewsRepository {
  LiveAiReviewsRepository(this._api);

  final AiReviewsApi _api;
  List<AiReviewItem>? _cachedReviews;

  @override
  bool get usesMockData => false;

  @override
  Future<List<AiReviewItem>> fetchReviews() async {
    final reviews = await _api.listReviews();
    _cachedReviews = reviews;
    return reviews;
  }

  @override
  Future<AiReviewItem> fetchReview(String id) async {
    try {
      return await _api.getReview(id);
    } on ApiException catch (error) {
      if (error.kind != ApiExceptionKind.notFound) rethrow;
      final cached = _cachedReviews;
      if (cached != null) {
        return cached.firstWhere(
          (review) => review.id == id,
          orElse: () => throw error,
        );
      }
      rethrow;
    }
  }
}

class MockAiReviewsRepository implements AiReviewsRepository {
  MockAiReviewsRepository();

  final List<AiReviewItem> _reviews = _buildReviews();

  @override
  bool get usesMockData => true;

  @override
  Future<List<AiReviewItem>> fetchReviews() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _reviews;
  }

  @override
  Future<AiReviewItem> fetchReview(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _reviews.firstWhere(
      (review) => review.id == id,
      orElse: () => throw const ApiException(
        messageKey: 'aiReviewLoadError',
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  static List<AiReviewItem> _buildReviews() {
    return [
      AiReviewItem(
        id: 'registration_application-101-advisory',
        sourceType: AiReviewSourceType.registrationApplication,
        sourceId: '101',
        sourceLabel: 'NordTrans Kft. registration',
        companyName: 'NordTrans Kft.',
        riskLevel: AiReviewRiskLevel.medium,
        recommendation: AiReviewRecommendation.requestInfo,
        confidenceScore: 0.72,
        summary:
            'Advisory AI review: VAT format valid; company registry lookup pending. Human approval required.',
        checksPerformed: const ['completeness_score', 'duplicate_check'],
        missingInformation: const ['registry_lookup'],
        duplicateWarnings: const [],
        createdAt: DateTime.utc(2026, 6, 10, 9, 30),
        updatedAt: DateTime.utc(2026, 6, 11, 8, 15),
        status: 'pending_human',
      ),
      AiReviewItem(
        id: 'bulk_onboarding_job-15',
        sourceType: AiReviewSourceType.bulkOnboardingJob,
        sourceId: '15',
        sourceLabel: 'Mock CSV Upload Co',
        companyName: 'Mock CSV Upload Co',
        riskLevel: AiReviewRiskLevel.high,
        recommendation: AiReviewRecommendation.review,
        summary:
            'Advisory AI review: high duplicate or invalid row rate detected. Human review required before any invitations or accounts are activated.',
        checksPerformed: const [
          'csv_header_validation',
          'row_duplicate_scan',
          'row_format_validation',
        ],
        missingInformation: const [],
        duplicateWarnings: const ['2 duplicate row(s) detected in import'],
        createdAt: DateTime.utc(2026, 6, 12, 14, 0),
        updatedAt: DateTime.utc(2026, 6, 12, 14, 5),
        status: 'ready_for_review',
      ),
      AiReviewItem(
        id: 'system_health_event-9',
        sourceType: AiReviewSourceType.systemHealthEvent,
        sourceId: '9',
        sourceLabel: 'Worker backlog',
        riskLevel: AiReviewRiskLevel.high,
        recommendation: AiReviewRecommendation.escalate,
        summary:
            'Advisory: review worker metadata only. Do not auto-repair.',
        checksPerformed: const ['component_health_scan', 'severity_classification'],
        createdAt: DateTime.utc(2026, 6, 13, 7, 45),
        updatedAt: DateTime.utc(2026, 6, 13, 8, 0),
        status: 'open',
      ),
    ];
  }
}

final aiReviewsRepositoryProvider = Provider<AiReviewsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  if (apiClient.isConfigured) {
    return LiveAiReviewsRepository(ref.watch(aiReviewsApiProvider));
  }
  return MockAiReviewsRepository();
});
