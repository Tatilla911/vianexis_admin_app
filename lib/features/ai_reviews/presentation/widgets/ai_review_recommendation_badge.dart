import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_status_badge.dart';
import '../../domain/ai_review_recommendation.dart';

class AiReviewRecommendationBadge extends StatelessWidget {
  const AiReviewRecommendationBadge({super.key, required this.recommendation});

  final AiReviewRecommendation recommendation;

  @override
  Widget build(BuildContext context) {
    return VianexisStatusBadge(
      label: resolveAiReviewKey(context, recommendation.localizationKey()),
      tone: recommendation == AiReviewRecommendation.approveCandidate
          ? VianexisStatusTone.healthy
          : recommendation == AiReviewRecommendation.rejectCandidate
          ? VianexisStatusTone.degraded
          : VianexisStatusTone.unknown,
    );
  }
}
