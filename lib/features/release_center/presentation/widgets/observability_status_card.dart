import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_metadata_notice.dart';
import '../../domain/observability_status.dart';

class ObservabilityStatusCard extends StatelessWidget {
  const ObservabilityStatusCard({super.key, required this.status});

  final ObservabilityStatus status;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveReleaseCenterKey(context, 'releaseObservabilityTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _row(context, 'releaseObservabilityLogLevel', status.logLevel),
            _row(
              context,
              'releaseObservabilityMetricsEnabled',
              status.metricsEnabled
                  ? resolveReleaseCenterKey(context, 'releaseYes')
                  : resolveReleaseCenterKey(context, 'releaseNo'),
            ),
            _row(
              context,
              'releaseObservabilitySentryConfigured',
              status.sentryConfigured
                  ? resolveReleaseCenterKey(context, 'releaseYes')
                  : resolveReleaseCenterKey(context, 'releaseNo'),
            ),
            _row(
              context,
              'releaseObservabilityOtelConfigured',
              status.otelConfigured
                  ? resolveReleaseCenterKey(context, 'releaseYes')
                  : resolveReleaseCenterKey(context, 'releaseNo'),
            ),
            _row(
              context,
              'releaseObservabilityCorrelationId',
              status.correlationIdEnabled
                  ? resolveReleaseCenterKey(context, 'releaseYes')
                  : resolveReleaseCenterKey(context, 'releaseNo'),
            ),
            const SizedBox(height: 12),
            VianexisMetadataNotice(
              message: resolveReleaseCenterKey(context, 'releaseObservabilityNotice'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 180,
            child: Text(
              resolveReleaseCenterKey(context, key),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
