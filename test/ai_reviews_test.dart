import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/ai_reviews/data/ai_reviews_repository.dart';
import 'package:vianexis_admin_app/features/ai_reviews/domain/ai_review_item.dart';
import 'package:vianexis_admin_app/features/ai_reviews/domain/ai_review_recommendation.dart';
import 'package:vianexis_admin_app/features/ai_reviews/domain/ai_review_risk_level.dart';
import 'package:vianexis_admin_app/features/ai_reviews/domain/ai_review_source_type.dart';

void main() {
  group('AiReviewItem JSON parsing', () {
    test('parses backend review item', () {
      final item = AiReviewItem.fromJson({
        'id': 'system_health_event-9',
        'sourceType': 'system_health',
        'sourceId': '9',
        'sourceLabel': 'Worker backlog',
        'companyId': null,
        'companyName': null,
        'riskLevel': 'high',
        'recommendation': 'escalate',
        'confidenceScore': null,
        'summary': 'Advisory diagnostic summary.',
        'checksPerformed': ['component_health_scan'],
        'missingInformation': [],
        'duplicateWarnings': [],
        'createdAt': '2026-06-13T07:45:00.000Z',
        'updatedAt': '2026-06-13T08:00:00.000Z',
        'status': 'open',
        'metadataOnly': true,
      });

      expect(item.sourceType, AiReviewSourceType.systemHealthEvent);
      expect(item.riskLevel, AiReviewRiskLevel.high);
      expect(item.recommendation, AiReviewRecommendation.escalate);
      expect(item.metadataOnly, isTrue);
    });
  });

  group('AiReview enums', () {
    test('parses source, risk, and recommendation values', () {
      expect(
        AiReviewSourceType.fromBackendValue('registration_application'),
        AiReviewSourceType.registrationApplication,
      );
      expect(AiReviewRiskLevel.fromBackendValue('medium'), AiReviewRiskLevel.medium);
      expect(
        AiReviewRecommendation.fromBackendValue('cannot_approve_yet'),
        AiReviewRecommendation.cannotApproveYet,
      );
    });
  });

  group('MockAiReviewsRepository', () {
    test('uses mock data and returns advisory reviews', () async {
      final repository = MockAiReviewsRepository();
      expect(repository.usesMockData, isTrue);

      final reviews = await repository.fetchReviews();
      expect(reviews, isNotEmpty);
      expect(reviews.every((review) => review.metadataOnly), isTrue);
    });
  });

  group('AiReview filtering', () {
    test('filters by high risk and search text', () {
      final items = [
        AiReviewItem(
          id: '1',
          sourceType: AiReviewSourceType.registrationApplication,
          sourceId: '1',
          sourceLabel: 'Alpha registration',
          companyName: 'Alpha Co',
          riskLevel: AiReviewRiskLevel.high,
          recommendation: AiReviewRecommendation.review,
          summary: 'Needs review',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 2),
          status: 'pending_human',
        ),
        AiReviewItem(
          id: '2',
          sourceType: AiReviewSourceType.bulkOnboardingJob,
          sourceId: '2',
          sourceLabel: 'Beta bulk job',
          companyName: 'Beta Co',
          riskLevel: AiReviewRiskLevel.low,
          recommendation: AiReviewRecommendation.approveCandidate,
          summary: 'Looks clean',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 2),
          status: 'ready_for_review',
        ),
      ];

      final highRisk = items.where((item) => item.matchesFilter(AiReviewFilter.highRisk));
      expect(highRisk, hasLength(1));

      final alphaSearch = items.where((item) => item.matchesSearch('alpha'));
      expect(alphaSearch, hasLength(1));
    });
  });

  group('AiReviewSummary', () {
    test('computes dashboard counts from items', () {
      final summary = AiReviewSummary.fromItems([
        AiReviewItem(
          id: '1',
          sourceType: AiReviewSourceType.registrationApplication,
          sourceId: '1',
          sourceLabel: 'A',
          riskLevel: AiReviewRiskLevel.high,
          recommendation: AiReviewRecommendation.review,
          summary: 'A',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 2),
          status: 'pending_human',
        ),
        AiReviewItem(
          id: '2',
          sourceType: AiReviewSourceType.systemHealthEvent,
          sourceId: '2',
          sourceLabel: 'B',
          riskLevel: AiReviewRiskLevel.low,
          recommendation: AiReviewRecommendation.approveCandidate,
          summary: 'B',
          createdAt: DateTime.utc(2026, 1, 1),
          updatedAt: DateTime.utc(2026, 1, 2),
          status: 'open',
        ),
      ]);

      expect(summary.totalCount, 2);
      expect(summary.highRiskCount, 1);
      expect(summary.needsHumanReviewCount, 1);
      expect(summary.registrationCount, 1);
      expect(summary.systemHealthCount, 1);
    });
  });
}
