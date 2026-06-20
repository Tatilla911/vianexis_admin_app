import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../../app/app_router.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../domain/ai_review_item.dart';
import 'ai_review_recommendation_badge.dart';
import 'ai_review_risk_badge.dart';
import 'ai_review_source_badge.dart';

class AiReviewCard extends StatelessWidget {
  const AiReviewCard({super.key, required this.review});

  final AiReviewItem review;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final updatedLabel = DateFormat.yMMMd(locale)
        .add_Hm()
        .format(review.updatedAt.toLocal());

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(AdminRoutes.aiReviewDetail(review.id)),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Text(
                      review.sourceLabel,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                  AiReviewRiskBadge(riskLevel: review.riskLevel),
                ],
              ),
              if (review.companyName != null) ...[
                const SizedBox(height: 8),
                Text(
                  review.companyName!,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 12),
              Text(
                review.summary,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  AiReviewSourceBadge(sourceType: review.sourceType),
                  AiReviewRecommendationBadge(recommendation: review.recommendation),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                resolveAiReviewKey(
                  context,
                  'aiReviewUpdatedAt',
                  params: {'date': updatedLabel},
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AiReviewSummaryCard extends StatelessWidget {
  const AiReviewSummaryCard({
    super.key,
    required this.summary,
    this.compact = false,
  });

  final AiReviewSummary summary;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 16 : 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveAiReviewKey(context, 'aiReviewDashboardTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            Text(
              resolveAiReviewKey(
                context,
                'aiReviewDashboardTotal',
                params: {'count': '${summary.totalCount}'},
              ),
            ),
            Text(
              resolveAiReviewKey(
                context,
                'aiReviewDashboardHighRisk',
                params: {'count': '${summary.highRiskCount}'},
              ),
            ),
            Text(
              resolveAiReviewKey(
                context,
                'aiReviewDashboardNeedsHumanReview',
                params: {'count': '${summary.needsHumanReviewCount}'},
              ),
            ),
          ],
        ),
      ),
    );
  }
}
