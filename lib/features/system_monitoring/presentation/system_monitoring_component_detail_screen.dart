import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/component_health_timing.dart';
import '../domain/system_monitoring_incident.dart';
import 'system_monitoring_providers.dart';
import 'widgets/system_monitoring_diagnostic_card.dart';
import 'widgets/system_monitoring_status_badge.dart';

class SystemMonitoringComponentDetailScreen extends ConsumerWidget {
  const SystemMonitoringComponentDetailScreen({
    super.key,
    required this.componentKey,
  });

  final String componentKey;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(
      systemMonitoringComponentDetailProvider(componentKey),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.systemMonitoringComponentDetailTitle)),
      body: detailAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveSystemMonitoringKey(
            context,
            'systemMonitoringLoadError',
          ),
          onRetry: () => ref.invalidate(
            systemMonitoringComponentDetailProvider(componentKey),
          ),
        ),
        data: (detail) {
          final component = detail.component;
          final locale = Localizations.localeOf(context);
          final timing = ComponentHealthTimingResolver.resolve(
            component: component,
            relatedIncidents: detail.relatedIncidents,
          );
          final formatDate = _HealthDateFormat(locale.languageCode);

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Expanded(
                    child: Text(
                      component.displayName,
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                  ),
                  SystemMonitoringStatusBadge(status: component.status),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                component.componentKey,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 16),
              Text(component.message),
              const SizedBox(height: 20),
              Text(
                resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringCurrentHealthTitle',
                ),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              _Field(
                label: resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringFieldStatus',
                ),
                value: resolveSystemMonitoringKey(
                  context,
                  component.status.localizationKey(),
                ),
              ),
              if (timing.showIncidentStarted)
                _Field(
                  label: resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringFieldIncidentStarted',
                  ),
                  value: formatDate(timing.incidentStartedAt),
                ),
              if (timing.showRecovered)
                _Field(
                  label: resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringFieldRecoveredAt',
                  ),
                  value: formatDate(timing.recoveredAt),
                ),
              if (timing.showDurationSoFar)
                _Field(
                  label: resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringFieldDurationSoFar',
                  ),
                  value: ComponentHealthDurationFormat.format(
                    duration: timing.duration!,
                    localeLanguageCode: locale.languageCode,
                  ),
                ),
              if (timing.showClosedDuration)
                _Field(
                  label: resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringFieldDuration',
                  ),
                  value: ComponentHealthDurationFormat.format(
                    duration: timing.duration!,
                    localeLanguageCode: locale.languageCode,
                  ),
                ),
              _Field(
                label: resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringFieldLastChecked',
                ),
                value: formatDate(timing.lastCheckedAt),
              ),
              if (timing.showLastIncident)
                _Field(
                  label: resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringFieldLastIncident',
                  ),
                  value: formatDate(timing.lastIncidentStartedAt),
                  muted: true,
                ),
              const SizedBox(height: 8),
              _Field(
                label: resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringFieldDependencyType',
                ),
                value: resolveSystemMonitoringKey(
                  context,
                  component.dependencyType.localizationKey(),
                ),
              ),
              if (component.responseTimeMs != null)
                _Field(
                  label: resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringFieldResponseTime',
                  ),
                  value: '${component.responseTimeMs} ms',
                ),
              if (component.technicalCode != null)
                _Field(
                  label: resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringFieldTechnicalCode',
                  ),
                  value: component.technicalCode!,
                ),
              _Field(
                label: resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringFieldConfigured',
                ),
                value: resolveSystemMonitoringKey(
                  context,
                  component.isConfigured
                      ? 'systemMonitoringYes'
                      : 'systemMonitoringNo',
                ),
              ),
              if (component.affectedCapabilities.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringFieldAffectedCapabilities',
                  ),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                Text(component.affectedCapabilities.join(', ')),
              ],
              if (component.evidence.isNotEmpty) ...[
                const SizedBox(height: 12),
                Text(
                  resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringFieldEvidence',
                  ),
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                const SizedBox(height: 4),
                for (final item in component.evidence) Text('• $item'),
              ],
              if (detail.diagnosticSuggestion != null) ...[
                const SizedBox(height: 16),
                SystemMonitoringDiagnosticCard(
                  suggestion: detail.diagnosticSuggestion!,
                  tiedToActiveIncident: timing.tiedToActiveIncident,
                ),
              ],
              if (timing.historyIncidents.isNotEmpty) ...[
                const SizedBox(height: 24),
                Text(
                  resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringIncidentHistoryTitle',
                  ),
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                for (final incident in timing.historyIncidents)
                  _IncidentHistoryTile(
                    incident: incident,
                    formatDate: formatDate.call,
                    localeLanguageCode: locale.languageCode,
                  ),
              ],
            ],
          );
        },
      ),
    );
  }
}

typedef _DateFormatter = String Function(DateTime? value);

class _HealthDateFormat {
  _HealthDateFormat(this.languageCode);

  final String languageCode;

  String call(DateTime? value) {
    if (value == null) return '—';
    final local = value.toLocal();
    // Spec: YYYY.MM.DD. HH:mm (stable across locales for ops readability).
    return DateFormat('yyyy.MM.dd. HH:mm').format(local);
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.label,
    required this.value,
    this.muted = false,
  });

  final String label;
  final String value;
  final bool muted;

  @override
  Widget build(BuildContext context) {
    final style = muted
        ? Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          )
        : Theme.of(context).textTheme.bodyMedium;
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          Expanded(child: Text(value, style: style)),
        ],
      ),
    );
  }
}

class _IncidentHistoryTile extends StatelessWidget {
  const _IncidentHistoryTile({
    required this.incident,
    required this.formatDate,
    required this.localeLanguageCode,
  });

  final SystemMonitoringIncident incident;
  final _DateFormatter formatDate;
  final String localeLanguageCode;

  @override
  Widget build(BuildContext context) {
    final start = incident.firstOccurrenceAt ?? incident.detectedAt;
    final end =
        incident.resolvedAt ??
        _recoveryFromTimeline(incident) ??
        (incident.status.isActive ? null : incident.lastOccurrenceAt);
    final duration = (start != null && end != null)
        ? end.difference(start)
        : null;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            incident.title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 4),
          _Field(
            label: resolveSystemMonitoringKey(
              context,
              'systemMonitoringFieldIncidentStarted',
            ),
            value: formatDate(start),
          ),
          if (end != null)
            _Field(
              label: resolveSystemMonitoringKey(
                context,
                'systemMonitoringFieldRecoveredAt',
              ),
              value: formatDate(end),
            ),
          if (duration != null)
            _Field(
              label: resolveSystemMonitoringKey(
                context,
                'systemMonitoringFieldDuration',
              ),
              value: ComponentHealthDurationFormat.format(
                duration: duration,
                localeLanguageCode: localeLanguageCode,
              ),
            ),
          _Field(
            label: resolveSystemMonitoringKey(
              context,
              'systemMonitoringFieldStatus',
            ),
            value: resolveSystemMonitoringKey(
              context,
              incident.status.localizationKey(),
            ),
          ),
        ],
      ),
    );
  }

  DateTime? _recoveryFromTimeline(SystemMonitoringIncident incident) {
    for (final event in incident.timeline.reversed) {
      final type = event.eventType.toLowerCase();
      if (type.contains('recovery') || type == 'recovered') {
        final meta = event.metadataSanitized['recoveredAt'];
        if (meta != null) {
          final parsed = DateTime.tryParse(meta.toString());
          if (parsed != null) return parsed;
        }
        return event.createdAt;
      }
    }
    return null;
  }
}
