import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_status_badge.dart';
import '../../domain/ai_review_source_type.dart';

class AiReviewSourceBadge extends StatelessWidget {
  const AiReviewSourceBadge({super.key, required this.sourceType});

  final AiReviewSourceType sourceType;

  @override
  Widget build(BuildContext context) {
    return VianexisStatusBadge(
      label: resolveAiReviewKey(context, sourceType.localizationKey()),
      tone: VianexisStatusTone.unknown,
    );
  }
}
