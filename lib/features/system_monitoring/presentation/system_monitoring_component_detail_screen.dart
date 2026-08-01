import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
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
          final locale = Localizations.localeOf(context).toString();
          String formatDate(DateTime? value) => value == null
              ? '—'
              : DateFormat.yMMMd(locale).add_Hm().format(value.toLocal());

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
              const SizedBox(height: 16),
              _Field(
                label: resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringFieldCheckedAt',
                ),
                value: formatDate(component.checkedAt),
              ),
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
                ),
              ],
            ],
          );
        },
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(label, style: Theme.of(context).textTheme.labelLarge),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
