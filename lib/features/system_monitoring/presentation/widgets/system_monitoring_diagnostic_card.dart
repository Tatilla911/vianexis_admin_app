import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/system_diagnostic_suggestion.dart';

class SystemMonitoringDiagnosticCard extends StatelessWidget {
  const SystemMonitoringDiagnosticCard({super.key, required this.suggestion});

  final SystemDiagnosticSuggestion suggestion;

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
                const Icon(Icons.psychology_alt_outlined, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    resolveSystemMonitoringKey(
                      context,
                      'systemMonitoringDiagnosticTitle',
                    ),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              resolveSystemMonitoringKey(context, suggestion.disclaimerKey),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Text(suggestion.summary),
            if (suggestion.possibleCauses.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringDiagnosticPossibleCauses',
                ),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              for (final cause in suggestion.possibleCauses) Text('• $cause'),
            ],
            if (suggestion.recommendedChecks.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringDiagnosticRecommendedChecks',
                ),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              for (final check in suggestion.recommendedChecks)
                Text('• $check'),
            ],
            if (suggestion.missingEvidence.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringDiagnosticMissingEvidence',
                ),
                style: Theme.of(context).textTheme.labelLarge,
              ),
              const SizedBox(height: 4),
              for (final item in suggestion.missingEvidence) Text('• $item'),
            ],
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(
                  label: Text(
                    resolveSystemMonitoringKey(
                      context,
                      suggestion.confidence.localizationKey(),
                    ),
                  ),
                ),
                Chip(
                  label: Text(
                    resolveSystemMonitoringKey(
                      context,
                      suggestion.urgency.localizationKey(),
                    ),
                  ),
                ),
                if (suggestion.aiGenerated)
                  Chip(
                    label: Text(
                      resolveSystemMonitoringKey(
                        context,
                        'systemMonitoringDiagnosticAiGenerated',
                      ),
                    ),
                  )
                else
                  Chip(
                    label: Text(
                      resolveSystemMonitoringKey(
                        context,
                        'systemMonitoringDiagnosticRuleBased',
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
