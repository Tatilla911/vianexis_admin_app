import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';

class AiDiagnosticSummaryCard extends StatelessWidget {
  const AiDiagnosticSummaryCard({
    super.key,
    required this.summary,
    this.recommendedAction,
  });

  final String summary;
  final String? recommendedAction;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.auto_awesome_outlined, size: 20),
                const SizedBox(width: 8),
                Text(
                  resolveSystemHealthKey(context, 'systemHealthAiDiagnosticTitle'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              resolveSystemHealthKey(context, 'systemHealthAiAdvisoryOnly'),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Text(summary),
            if (recommendedAction != null && recommendedAction!.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                resolveSystemHealthKey(context, 'systemHealthRecommendedAction'),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              Text(recommendedAction!),
            ],
          ],
        ),
      ),
    );
  }
}
