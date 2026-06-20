enum AiReviewRecommendation {
  review('review'),
  requestInfo('request_info'),
  approveCandidate('approve_candidate'),
  rejectCandidate('reject_candidate'),
  escalate('escalate'),
  cannotApproveYet('cannot_approve_yet'),
  unknown('unknown');

  const AiReviewRecommendation(this.backendValue);

  final String backendValue;

  static AiReviewRecommendation fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return AiReviewRecommendation.unknown;
    final normalized = raw.trim().toLowerCase();
    return AiReviewRecommendation.values.firstWhere(
      (value) => value.backendValue == normalized,
      orElse: () => AiReviewRecommendation.unknown,
    );
  }

  String localizationKey() => switch (this) {
    AiReviewRecommendation.review => 'aiReviewRecommendationReview',
    AiReviewRecommendation.requestInfo => 'aiReviewRecommendationRequestInfo',
    AiReviewRecommendation.approveCandidate => 'aiReviewRecommendationApproveCandidate',
    AiReviewRecommendation.rejectCandidate => 'aiReviewRecommendationRejectCandidate',
    AiReviewRecommendation.escalate => 'aiReviewRecommendationEscalate',
    AiReviewRecommendation.cannotApproveYet => 'aiReviewRecommendationCannotApproveYet',
    AiReviewRecommendation.unknown => 'aiReviewRecommendationUnknown',
  };
}
