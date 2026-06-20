import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_status_badge.dart';
import '../../domain/ai_review_risk_level.dart';

class AiReviewRiskBadge extends StatelessWidget {
  const AiReviewRiskBadge({super.key, required this.riskLevel});

  final AiReviewRiskLevel riskLevel;

  @override
  Widget build(BuildContext context) {
    return VianexisStatusBadge(
      label: resolveAiReviewKey(context, riskLevel.localizationKey()),
      tone: switch (riskLevel) {
        AiReviewRiskLevel.low => VianexisStatusTone.healthy,
        AiReviewRiskLevel.medium => VianexisStatusTone.degraded,
        AiReviewRiskLevel.high => VianexisStatusTone.degraded,
        AiReviewRiskLevel.unknown => VianexisStatusTone.unknown,
      },
    );
  }
}
