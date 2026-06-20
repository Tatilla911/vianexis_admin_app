import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_status_badge.dart';
import '../../../l10n/app_localizations.dart';
import 'ai_review_providers.dart';
import 'widgets/ai_review_checks_card.dart';
import 'widgets/ai_review_recommendation_badge.dart';
import 'widgets/ai_review_risk_badge.dart';
import 'widgets/ai_review_source_badge.dart';
import '../../translation/presentation/widgets/translation_panel.dart';

class AiReviewDetailScreen extends ConsumerWidget {
  const AiReviewDetailScreen({super.key, required this.reviewId});

  final String reviewId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final reviewAsync = ref.watch(aiReviewDetailProvider(reviewId));
    final locale = Localizations.localeOf(context).toString();

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.aiReviewsTitle),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: VianexisStatusBadge(
                label: l10n.privacyMetadataOnlyBadge,
                tone: VianexisStatusTone.unknown,
              ),
            ),
          ),
        ],
      ),
      body: reviewAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveAiReviewKey(context, 'aiReviewDetailError'),
          onRetry: () => ref.invalidate(aiReviewDetailProvider(reviewId)),
        ),
        data: (review) {
          final updatedLabel = DateFormat.yMMMd(locale)
              .add_Hm()
              .format(review.updatedAt.toLocal());

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        review.sourceLabel,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      if (review.companyName != null) ...[
                        const SizedBox(height: 8),
                        Text(review.companyName!),
                      ],
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          AiReviewSourceBadge(sourceType: review.sourceType),
                          AiReviewRiskBadge(riskLevel: review.riskLevel),
                          AiReviewRecommendationBadge(
                            recommendation: review.recommendation,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        resolveAiReviewKey(context, 'aiReviewSectionSummary'),
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Text(review.summary),
                      if (review.confidenceScore != null) ...[
                        const SizedBox(height: 12),
                        Text(
                          resolveAiReviewKey(
                            context,
                            'aiReviewFieldConfidenceScore',
                            params: {
                              'score': review.confidenceScore!.toStringAsFixed(2),
                            },
                          ),
                        ),
                      ],
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
              const SizedBox(height: 16),
              TranslationPanel(
                sourceType: 'ai_review',
                sourceId: reviewId,
                sourceField: 'summary',
                originalText: review.summary,
                companyId: review.companyId,
              ),
              const SizedBox(height: 16),
              AiReviewChecksCard(review: review),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.info_outline, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(resolveAiReviewKey(context, 'aiReviewAdvisoryNotice')),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(Icons.shield_outlined, size: 20),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(l10n.privacyNoOperationalContent),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
