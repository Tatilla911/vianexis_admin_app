import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/system_monitoring_action_request.dart';
import '../domain/system_monitoring_incident.dart';
import 'system_monitoring_providers.dart';
import 'widgets/system_monitoring_diagnostic_card.dart';
import 'widgets/system_monitoring_status_badge.dart';

class SystemMonitoringIncidentDetailScreen extends ConsumerStatefulWidget {
  const SystemMonitoringIncidentDetailScreen({
    super.key,
    required this.incidentId,
  });

  final String incidentId;

  @override
  ConsumerState<SystemMonitoringIncidentDetailScreen> createState() =>
      _SystemMonitoringIncidentDetailScreenState();
}

class _SystemMonitoringIncidentDetailScreenState
    extends ConsumerState<SystemMonitoringIncidentDetailScreen> {
  final _noteController = TextEditingController();
  bool _submitting = false;

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _runAction(Future<void> Function() action) async {
    setState(() => _submitting = true);
    try {
      await action();
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveSystemMonitoringKey(
              context,
              'systemMonitoringActionSuccess',
            ),
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveSystemMonitoringKey(context, 'systemMonitoringActionError'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  Future<void> _acknowledge() async {
    await _runAction(() async {
      await acknowledgeSystemMonitoringIncident(
        ref: ref,
        incidentId: widget.incidentId,
        request: SystemMonitoringAcknowledgeRequest(
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        ),
      );
      _noteController.clear();
    });
  }

  Future<void> _changeStatus(SystemIncidentStatus status) async {
    await _runAction(() async {
      await updateSystemMonitoringIncidentStatus(
        ref: ref,
        incidentId: widget.incidentId,
        request: SystemMonitoringStatusUpdateRequest(
          status: status.backendValue,
          resolutionSummary: status == SystemIncidentStatus.resolved
              ? (_noteController.text.trim().isEmpty
                    ? null
                    : _noteController.text.trim())
              : null,
        ),
      );
      _noteController.clear();
    });
  }

  Future<void> _addNote() async {
    final note = _noteController.text.trim();
    if (note.length < 3) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveSystemMonitoringKey(context, 'systemMonitoringNoteRequired'),
          ),
        ),
      );
      return;
    }
    await _runAction(() async {
      await addSystemMonitoringIncidentNote(
        ref: ref,
        incidentId: widget.incidentId,
        request: SystemMonitoringNoteRequest(note: note),
      );
      _noteController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final incidentAsync = ref.watch(
      systemMonitoringIncidentDetailProvider(widget.incidentId),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.systemMonitoringIncidentDetailTitle)),
      body: incidentAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveSystemMonitoringKey(
            context,
            'systemMonitoringLoadError',
          ),
          onRetry: () =>
              refreshSystemMonitoringIncidentDetail(ref, widget.incidentId),
        ),
        data: (incident) {
          final locale = Localizations.localeOf(context).toString();
          String formatDate(DateTime? value) => value == null
              ? '—'
              : DateFormat.yMMMd(locale).add_Hm().format(value.toLocal());
          final canAct = incident.status.isActive;

          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Text(
                incident.title,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  SystemMonitoringIncidentSeverityBadge(
                    severity: incident.severity,
                  ),
                  SystemMonitoringIncidentStatusBadge(status: incident.status),
                ],
              ),
              const SizedBox(height: 16),
              Text(incident.summary),
              const SizedBox(height: 16),
              Text(
                '${resolveSystemMonitoringKey(context, 'systemMonitoringFieldComponent')}: ${incident.componentKey}',
              ),
              Text(
                resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringIncidentDetectedAt',
                  params: {'date': formatDate(incident.detectedAt)},
                ),
              ),
              if (incident.acknowledgedAt != null)
                Text(
                  resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringIncidentAcknowledgedAt',
                    params: {'date': formatDate(incident.acknowledgedAt)},
                  ),
                ),
              if (incident.technicalCode != null)
                Text(
                  '${resolveSystemMonitoringKey(context, 'systemMonitoringFieldTechnicalCode')}: ${incident.technicalCode}',
                ),
              if (incident.diagnosticSuggestion != null) ...[
                const SizedBox(height: 16),
                SystemMonitoringDiagnosticCard(
                  suggestion: incident.diagnosticSuggestion!,
                ),
              ],
              const SizedBox(height: 20),
              Text(
                resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringTimelineTitle',
                ),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              if (incident.timeline.isEmpty)
                Text(
                  resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringTimelineEmpty',
                  ),
                )
              else
                for (final event in incident.timeline)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.timeline, size: 20),
                    title: Text(event.message),
                    subtitle: Text(
                      '${event.eventType} · ${formatDate(event.createdAt)}',
                    ),
                  ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _noteController,
                enabled: !_submitting && canAct,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: resolveSystemMonitoringKey(
                    context,
                    'systemMonitoringNoteLabel',
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: (!_submitting && canAct) ? _acknowledge : null,
                    child: Text(
                      resolveSystemMonitoringKey(
                        context,
                        'systemMonitoringActionAcknowledge',
                      ),
                    ),
                  ),
                  OutlinedButton(
                    onPressed: (!_submitting && canAct) ? _addNote : null,
                    child: Text(
                      resolveSystemMonitoringKey(
                        context,
                        'systemMonitoringActionAddNote',
                      ),
                    ),
                  ),
                  PopupMenuButton<SystemIncidentStatus>(
                    enabled: !_submitting && canAct,
                    tooltip: resolveSystemMonitoringKey(
                      context,
                      'systemMonitoringActionChangeStatus',
                    ),
                    onSelected: _changeStatus,
                    itemBuilder: (context) => [
                      for (final status in [
                        SystemIncidentStatus.investigating,
                        SystemIncidentStatus.monitoring,
                        SystemIncidentStatus.resolved,
                        SystemIncidentStatus.dismissed,
                      ])
                        PopupMenuItem(
                          value: status,
                          child: Text(
                            resolveSystemMonitoringKey(
                              context,
                              status.localizationKey(),
                            ),
                          ),
                        ),
                    ],
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            resolveSystemMonitoringKey(
                              context,
                              'systemMonitoringActionChangeStatus',
                            ),
                          ),
                          const Icon(Icons.arrow_drop_down),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                resolveSystemMonitoringKey(
                  context,
                  'systemMonitoringActionAuditNotice',
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          );
        },
      ),
    );
  }
}
