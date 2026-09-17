import 'system_component_status.dart';
import 'system_monitoring_incident.dart';

/// Presentation mode for component health timestamps on the detail screen.
enum ComponentHealthTimingMode {
  /// Healthy / non-failing with no active failing window.
  healthy,

  /// Currently degraded or unhealthy with a continuous failing window.
  activeIncident,

  /// Component is healthy again; show closed incident window.
  recovered,
}

/// Resolved timestamps for current health vs incident history.
///
/// Incident start is never inferred from [SystemComponentStatus.checkedAt].
class ComponentHealthTiming {
  const ComponentHealthTiming({
    required this.mode,
    required this.lastCheckedAt,
    this.incidentStartedAt,
    this.recoveredAt,
    this.duration,
    this.lastIncidentStartedAt,
    this.lastIncidentRecoveredAt,
    this.tiedToActiveIncident = false,
    this.historyIncidents = const [],
  });

  final ComponentHealthTimingMode mode;
  final DateTime? lastCheckedAt;
  final DateTime? incidentStartedAt;
  final DateTime? recoveredAt;
  final Duration? duration;

  /// When healthy (no recovered card): optional closed incident start.
  final DateTime? lastIncidentStartedAt;
  final DateTime? lastIncidentRecoveredAt;

  /// Diagnostic copy should reference the active incident when true.
  final bool tiedToActiveIncident;

  /// Past incidents for the history section (newest first), excluding the
  /// window already shown on the current-health card.
  final List<SystemMonitoringIncident> historyIncidents;

  bool get showIncidentStarted =>
      (mode == ComponentHealthTimingMode.activeIncident ||
          mode == ComponentHealthTimingMode.recovered) &&
      incidentStartedAt != null;

  bool get showDurationSoFar =>
      mode == ComponentHealthTimingMode.activeIncident &&
      incidentStartedAt != null &&
      duration != null;

  bool get showRecovered =>
      mode == ComponentHealthTimingMode.recovered && recoveredAt != null;

  bool get showClosedDuration =>
      mode == ComponentHealthTimingMode.recovered && duration != null;

  bool get showLastIncident =>
      mode == ComponentHealthTimingMode.healthy &&
      lastIncidentStartedAt != null;
}

/// A single probe sample used when deriving continuous failure windows
/// from consecutive health history (tests / future sample feeds).
class ComponentHealthSample {
  const ComponentHealthSample({
    required this.checkedAt,
    required this.failing,
  });

  final DateTime checkedAt;
  final bool failing;
}

abstract final class ComponentHealthTimingResolver {
  /// Preferred order for current continuous failing/degraded start:
  /// 1. backend incidentStartedAt / degradedSince / failedSince / firstFailureAt
  /// 2. active incident firstOccurrenceAt / detectedAt
  /// 3. earliest consecutive failed sample (when provided)
  /// 4. lastFailureAt only when consecutiveFailures == 1
  ///
  /// Never uses [SystemComponentStatus.checkedAt] as incident start.
  static ComponentHealthTiming resolve({
    required SystemComponentStatus component,
    List<SystemMonitoringIncident> relatedIncidents = const [],
    List<ComponentHealthSample> consecutiveSamples = const [],
    DateTime? now,
  }) {
    final clock = now ?? DateTime.now().toUtc();
    final lastChecked = component.checkedAt;

    final forComponent = relatedIncidents
        .where((i) => i.componentKey == component.componentKey)
        .toList(growable: false);

    final failingActive = forComponent
        .where(
          (i) =>
              i.status == SystemIncidentStatus.open ||
              i.status == SystemIncidentStatus.investigating,
        )
        .toList(growable: false)
      ..sort(_byStartAsc);

    final monitoring = forComponent
        .where((i) => i.status == SystemIncidentStatus.monitoring)
        .toList(growable: false)
      ..sort(_byStartDesc);

    final resolved = forComponent
        .where(
          (i) =>
              i.status == SystemIncidentStatus.resolved ||
              i.status == SystemIncidentStatus.dismissed,
        )
        .toList(growable: false)
      ..sort(_byResolvedDesc);

    final explicitStart = _explicitIncidentStart(component);
    final sampleStart = earliestConsecutiveFailureStart(consecutiveSamples);
    final isProblem =
        component.status == SystemComponentStatusValue.degraded ||
        component.status == SystemComponentStatusValue.unhealthy;

    if (isProblem) {
      final activeIncident =
          failingActive.isNotEmpty ? failingActive.first : null;
      final start =
          explicitStart ??
          sampleStart ??
          activeIncident?.firstOccurrenceAt ??
          activeIncident?.detectedAt ??
          (component.consecutiveFailures == 1 ? component.lastFailureAt : null);

      final duration = start == null ? null : clock.difference(start);
      final shownId = activeIncident?.id;
      final history = forComponent
          .where((i) => i.id != shownId)
          .toList(growable: false)
        ..sort(_byStartDesc);

      return ComponentHealthTiming(
        mode: ComponentHealthTimingMode.activeIncident,
        lastCheckedAt: lastChecked,
        incidentStartedAt: start,
        duration: duration,
        tiedToActiveIncident: start != null,
        historyIncidents: history,
      );
    }

    // Healthy again while a monitoring incident awaits admin resolve, or a
    // recently resolved incident exists with recovery timestamps.
    if (component.status == SystemComponentStatusValue.healthy) {
      final recoveredIncident =
          monitoring.isNotEmpty
              ? monitoring.first
              : (resolved.isNotEmpty ? resolved.first : null);

      if (recoveredIncident != null) {
        final start =
            explicitStart ??
            recoveredIncident.firstOccurrenceAt ??
            recoveredIncident.detectedAt;
        final recoveredAt =
            recoveredIncident.resolvedAt ??
            _recoveryObservedAt(recoveredIncident) ??
            component.lastHealthyAt;

        if (start != null && recoveredAt != null) {
          final history = forComponent
              .where((i) => i.id != recoveredIncident.id)
              .toList(growable: false)
            ..sort(_byStartDesc);

          return ComponentHealthTiming(
            mode: ComponentHealthTimingMode.recovered,
            lastCheckedAt: lastChecked,
            incidentStartedAt: start,
            recoveredAt: recoveredAt,
            duration: recoveredAt.difference(start),
            tiedToActiveIncident: false,
            historyIncidents: history,
          );
        }

        // Have a past incident but incomplete recovery timestamps → last incident.
        return ComponentHealthTiming(
          mode: ComponentHealthTimingMode.healthy,
          lastCheckedAt: lastChecked,
          lastIncidentStartedAt:
              recoveredIncident.firstOccurrenceAt ??
              recoveredIncident.detectedAt,
          lastIncidentRecoveredAt: recoveredAt,
          tiedToActiveIncident: false,
          historyIncidents: forComponent.toList(growable: false)
            ..sort(_byStartDesc),
        );
      }
    }

    final last = resolved.isNotEmpty
        ? resolved.first
        : (monitoring.isNotEmpty ? monitoring.first : null);

    return ComponentHealthTiming(
      mode: ComponentHealthTimingMode.healthy,
      lastCheckedAt: lastChecked,
      lastIncidentStartedAt:
          last?.firstOccurrenceAt ?? last?.detectedAt,
      lastIncidentRecoveredAt:
          last?.resolvedAt ??
          (last == null ? null : _recoveryObservedAt(last)) ??
          component.lastHealthyAt,
      tiedToActiveIncident: false,
      historyIncidents: forComponent.toList(growable: false)..sort(_byStartDesc),
    );
  }

  /// Earliest timestamp of the current continuous failing streak.
  ///
  /// Samples must be chronological (oldest → newest). Example:
  /// PASS, FAIL, FAIL, FAIL → start of first FAIL after last PASS.
  static DateTime? earliestConsecutiveFailureStart(
    List<ComponentHealthSample> samplesChronological,
  ) {
    if (samplesChronological.isEmpty) return null;

    var lastPassIndex = -1;
    for (var i = 0; i < samplesChronological.length; i++) {
      if (!samplesChronological[i].failing) {
        lastPassIndex = i;
      }
    }

    final failStartIndex = lastPassIndex + 1;
    if (failStartIndex >= samplesChronological.length) return null;
    if (!samplesChronological[failStartIndex].failing) return null;

    for (var i = failStartIndex; i < samplesChronological.length; i++) {
      if (!samplesChronological[i].failing) return null;
    }
    return samplesChronological[failStartIndex].checkedAt;
  }

  /// Closed window from samples: start of fail streak + first subsequent PASS.
  static ({DateTime startedAt, DateTime recoveredAt, Duration duration})?
  recoveredWindowFromSamples(List<ComponentHealthSample> samplesChronological) {
    if (samplesChronological.length < 2) return null;

    DateTime? failStart;
    for (var i = 0; i < samplesChronological.length; i++) {
      final sample = samplesChronological[i];
      if (sample.failing) {
        failStart ??= sample.checkedAt;
        continue;
      }
      if (failStart != null) {
        return (
          startedAt: failStart,
          recoveredAt: sample.checkedAt,
          duration: sample.checkedAt.difference(failStart),
        );
      }
    }
    return null;
  }

  /// After a PASS closes an incident, a later FAIL starts a new window.
  static DateTime? startOfLatestFailureWindow(
    List<ComponentHealthSample> samplesChronological,
  ) {
    return earliestConsecutiveFailureStart(samplesChronological);
  }

  static DateTime? _explicitIncidentStart(SystemComponentStatus component) {
    return component.incidentStartedAt ??
        component.degradedSince ??
        component.failedSince ??
        component.firstFailureAt;
  }

  static DateTime? _recoveryObservedAt(SystemMonitoringIncident incident) {
    for (final event in incident.timeline.reversed) {
      final type = event.eventType.toLowerCase();
      if (type.contains('recovery') || type == 'recovered') {
        final meta = event.metadataSanitized['recoveredAt'];
        if (meta != null) {
          final parsed = DateTime.tryParse(meta.toString());
          if (parsed != null) return parsed;
        }
        if (event.createdAt != null) return event.createdAt;
      }
    }
    return null;
  }

  static int _byStartAsc(
    SystemMonitoringIncident a,
    SystemMonitoringIncident b,
  ) {
    final aStart = a.firstOccurrenceAt ?? a.detectedAt;
    final bStart = b.firstOccurrenceAt ?? b.detectedAt;
    if (aStart == null && bStart == null) return 0;
    if (aStart == null) return 1;
    if (bStart == null) return -1;
    return aStart.compareTo(bStart);
  }

  static int _byStartDesc(
    SystemMonitoringIncident a,
    SystemMonitoringIncident b,
  ) {
    return -_byStartAsc(a, b);
  }

  static int _byResolvedDesc(
    SystemMonitoringIncident a,
    SystemMonitoringIncident b,
  ) {
    final aEnd =
        a.resolvedAt ??
        _recoveryObservedAt(a) ??
        a.lastOccurrenceAt ??
        a.detectedAt;
    final bEnd =
        b.resolvedAt ??
        _recoveryObservedAt(b) ??
        b.lastOccurrenceAt ??
        b.detectedAt;
    if (aEnd == null && bEnd == null) return 0;
    if (aEnd == null) return 1;
    if (bEnd == null) return -1;
    return bEnd.compareTo(aEnd);
  }
}

/// Formats a duration for HU/EN health UI without inventing timestamps.
abstract final class ComponentHealthDurationFormat {
  static String format({
    required Duration duration,
    required String localeLanguageCode,
  }) {
    final totalMinutes = duration.inMinutes.abs();
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;
    final isHu = localeLanguageCode.toLowerCase().startsWith('hu');

    if (hours <= 0) {
      return isHu ? '$minutes perc' : '$minutes min';
    }
    if (minutes == 0) {
      return isHu ? '$hours óra' : (hours == 1 ? '1 hour' : '$hours hours');
    }
    return isHu ? '$hours óra $minutes perc' : '$hours h $minutes min';
  }
}
