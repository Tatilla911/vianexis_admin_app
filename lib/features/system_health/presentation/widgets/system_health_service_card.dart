import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/system_health_service_status.dart';
import 'system_health_severity_badge.dart';

class SystemHealthServiceCard extends StatelessWidget {
  const SystemHealthServiceCard({
    super.key,
    required this.service,
  });

  final SystemHealthServiceStatus service;

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
                Expanded(
                  child: Text(
                    resolveSystemHealthKey(
                      context,
                      service.serviceKey.localizationKey(),
                    ),
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                ),
                SystemHealthSeverityBadge(severity: service.severity),
              ],
            ),
            if (service.summary != null && service.summary!.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(
                service.summary!,
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
