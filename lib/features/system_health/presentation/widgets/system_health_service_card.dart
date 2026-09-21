import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/system_health_service_status.dart';
import 'system_health_severity_badge.dart';

class SystemHealthServiceCard extends StatelessWidget {
  const SystemHealthServiceCard({super.key, required this.service});

  final SystemHealthServiceStatus service;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => _openDetails(context),
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
                      resolveSystemHealthKey(
                        context,
                        service.serviceKey.localizationKey(),
                      ),
                      softWrap: true,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  const SizedBox(width: 8),
                  SystemHealthSeverityBadge(severity: service.severity),
                ],
              ),
              if (service.summary != null && service.summary!.isNotEmpty) ...[
                const SizedBox(height: 8),
                Text(
                  service.summary!,
                  softWrap: true,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
              const SizedBox(height: 8),
              Text(
                resolveSystemHealthKey(context, 'systemHealthServiceTapDetails'),
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _openDetails(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    String fmt(DateTime? value) {
      if (value == null) return '—';
      return DateFormat.yMMMd(locale).add_Hm().format(value.toLocal());
    }

    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (sheetContext) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    resolveSystemHealthKey(
                      context,
                      service.serviceKey.localizationKey(),
                    ),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  const SizedBox(height: 16),
                  _detailRow(
                    context,
                    'systemHealthDetailService',
                    resolveSystemHealthKey(
                      context,
                      service.serviceKey.localizationKey(),
                    ),
                  ),
                  _detailRow(
                    context,
                    'systemHealthDetailCurrentState',
                    service.currentState ?? service.severity.name,
                  ),
                  _detailRow(
                    context,
                    'systemHealthDetailLastChecked',
                    fmt(service.lastCheckedAt),
                  ),
                  _detailRow(
                    context,
                    'systemHealthDetailLastSuccess',
                    fmt(service.lastSuccessAt),
                  ),
                  _detailRow(
                    context,
                    'systemHealthDetailLastError',
                    service.lastError ?? '—',
                  ),
                  if (service.affectedPlatform != null)
                    _detailRow(
                      context,
                      'systemHealthDetailAffectedPlatform',
                      service.affectedPlatform!,
                    ),
                  if (service.recommendedAction != null)
                    _detailRow(
                      context,
                      'systemHealthDetailRecommendedAction',
                      service.recommendedAction!,
                    ),
                  for (final entry in service.detailFields.entries)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            entry.key,
                            style: Theme.of(context).textTheme.labelLarge,
                          ),
                          const SizedBox(height: 2),
                          Text(entry.value, softWrap: true),
                        ],
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _detailRow(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            resolveSystemHealthKey(context, key),
            style: Theme.of(context).textTheme.labelLarge,
          ),
          const SizedBox(height: 2),
          Text(value, softWrap: true),
        ],
      ),
    );
  }
}
