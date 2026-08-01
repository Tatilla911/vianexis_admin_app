import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/app_router.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../domain/system_component_status.dart';
import 'system_monitoring_status_badge.dart';

class SystemMonitoringComponentCard extends StatelessWidget {
  const SystemMonitoringComponentCard({super.key, required this.component});

  final SystemComponentStatus component;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push(
          AdminRoutes.systemMonitoringComponentDetail(component.componentKey),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      component.displayName,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  SystemMonitoringStatusBadge(status: component.status),
                ],
              ),
              if (component.message.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  component.message,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              if (component.responseTimeMs != null) ...[
                const SizedBox(height: 8),
                Text(
                  resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringResponseTimeMs',
                    params: {'ms': '${component.responseTimeMs}'},
                  ),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
