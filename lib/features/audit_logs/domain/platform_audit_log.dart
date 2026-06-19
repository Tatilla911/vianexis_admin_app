import 'platform_audit_action_type.dart';
import 'platform_audit_filter.dart';
import 'platform_audit_result.dart';
import 'platform_audit_severity.dart';

class PlatformAuditLog {
  const PlatformAuditLog({
    required this.id,
    required this.timestamp,
    this.actorUserId,
    this.actorName,
    this.actorEmail,
    this.actorRole,
    required this.actionType,
    this.targetType,
    this.targetId,
    this.targetLabel,
    this.companyId,
    this.companyName,
    this.tenantId,
    required this.result,
    required this.severity,
    this.reason,
    this.note,
    this.ipAddress,
    this.deviceLabel,
    this.correlationId,
    this.supportAccessGrantId,
    this.registrationApplicationId,
    this.systemHealthEventId,
    this.metadataOnly = const {},
  });

  final String id;
  final DateTime timestamp;
  final String? actorUserId;
  final String? actorName;
  final String? actorEmail;
  final String? actorRole;
  final PlatformAuditActionType actionType;
  final String? targetType;
  final String? targetId;
  final String? targetLabel;
  final String? companyId;
  final String? companyName;
  final String? tenantId;
  final PlatformAuditResult result;
  final PlatformAuditSeverity severity;
  final String? reason;
  final String? note;
  final String? ipAddress;
  final String? deviceLabel;
  final String? correlationId;
  final String? supportAccessGrantId;
  final String? registrationApplicationId;
  final String? systemHealthEventId;
  final Map<String, dynamic> metadataOnly;

  bool matchesSearch(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return [
      actorEmail,
      actorName,
      companyName,
      targetId,
      correlationId,
      targetLabel,
    ].whereType<String>().any((value) => value.toLowerCase().contains(normalized));
  }

  bool matchesFilter(PlatformAuditLogFilter filter) {
    return switch (filter) {
      PlatformAuditLogFilter.all => true,
      PlatformAuditLogFilter.critical => severity == PlatformAuditSeverity.critical,
      PlatformAuditLogFilter.warning => severity == PlatformAuditSeverity.warning,
      PlatformAuditLogFilter.failures =>
        result == PlatformAuditResult.failure || result == PlatformAuditResult.partial,
      PlatformAuditLogFilter.denied => result == PlatformAuditResult.denied,
      PlatformAuditLogFilter.registration => actionType.isRegistrationAction,
      PlatformAuditLogFilter.supportAccess => actionType.isSupportAccessAction,
      PlatformAuditLogFilter.systemHealth => actionType.isSystemHealthAction,
      PlatformAuditLogFilter.security => actionType.isSecurityAction,
    };
  }

  factory PlatformAuditLog.fromJson(Map<String, dynamic> json) {
    final metadata = _asMap(json['metadataOnly'] ?? json['metadata']);
    final actionType = PlatformAuditActionType.fromBackendValue(
      json['actionType']?.toString() ?? json['eventType']?.toString(),
    );

    var result = PlatformAuditResult.fromBackendValue(
      metadata['result']?.toString() ?? json['result']?.toString(),
    );
    if (result == PlatformAuditResult.unknown) {
      result = _defaultResultForAction(actionType);
    }

    var severity = PlatformAuditSeverity.fromBackendValue(
      metadata['severity']?.toString() ?? json['severity']?.toString(),
    );
    if (severity == PlatformAuditSeverity.unknown) {
      severity = _defaultSeverityForAction(actionType, result);
    }

    final description = json['description']?.toString();
    final targetLabel = json['targetLabel']?.toString() ??
        metadata['targetLabel']?.toString() ??
        description;

    return PlatformAuditLog(
      id: json['id']?.toString() ?? '',
      timestamp: _parseDate(json['timestamp'] ?? json['createdAt']) ??
          DateTime.now().toUtc(),
      actorUserId: (json['actorUserId'] ?? json['userId'])?.toString(),
      actorName: json['actorName']?.toString() ?? metadata['actorName']?.toString(),
      actorEmail: json['actorEmail']?.toString() ?? metadata['actorEmail']?.toString(),
      actorRole: (json['actorRole'] ?? json['platformAdminRole'])?.toString(),
      actionType: actionType,
      targetType: json['targetType']?.toString() ?? metadata['targetType']?.toString(),
      targetId: (json['targetId'] ?? metadata['targetId'])?.toString(),
      targetLabel: targetLabel,
      companyId: json['companyId']?.toString(),
      companyName: json['companyName']?.toString() ?? metadata['companyName']?.toString(),
      tenantId: (json['tenantId'] ?? metadata['tenantId'])?.toString(),
      result: result,
      severity: severity,
      reason: json['reason']?.toString() ?? metadata['reason']?.toString(),
      note: json['note']?.toString() ?? description,
      ipAddress: json['ipAddress']?.toString() ?? metadata['ipAddress']?.toString(),
      deviceLabel: json['deviceLabel']?.toString() ?? metadata['deviceLabel']?.toString(),
      correlationId:
          (json['correlationId'] ?? metadata['correlationId'])?.toString(),
      supportAccessGrantId: (json['supportAccessGrantId'] ??
              metadata['supportAccessGrantId'] ??
              metadata['grantId'])
          ?.toString(),
      registrationApplicationId: (json['registrationApplicationId'] ??
              metadata['registrationApplicationId'])
          ?.toString(),
      systemHealthEventId: (json['systemHealthEventId'] ??
              metadata['systemHealthEventId'] ??
              metadata['eventId'])
          ?.toString(),
      metadataOnly: metadata,
    );
  }

  static PlatformAuditResult _defaultResultForAction(PlatformAuditActionType action) {
    return switch (action) {
      PlatformAuditActionType.loginFailed => PlatformAuditResult.failure,
      PlatformAuditActionType.permissionDenied => PlatformAuditResult.denied,
      _ => PlatformAuditResult.success,
    };
  }

  static PlatformAuditSeverity _defaultSeverityForAction(
    PlatformAuditActionType action,
    PlatformAuditResult result,
  ) {
    if (result == PlatformAuditResult.denied || action == PlatformAuditActionType.loginFailed) {
      return PlatformAuditSeverity.warning;
    }
    if (result == PlatformAuditResult.failure) {
      return PlatformAuditSeverity.critical;
    }
    if (action == PlatformAuditActionType.systemHealthEscalated) {
      return PlatformAuditSeverity.critical;
    }
    if (action.isSecurityAction && action != PlatformAuditActionType.login) {
      return PlatformAuditSeverity.warning;
    }
    return PlatformAuditSeverity.info;
  }

  static Map<String, dynamic> _asMap(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return const {};
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}

class PlatformAuditLogSummary {
  const PlatformAuditLogSummary({
    this.lastCriticalEvent,
    required this.failedDeniedCount,
    required this.recentPlatformActionsCount,
    this.lastUpdatedAt,
  });

  final PlatformAuditLog? lastCriticalEvent;
  final int failedDeniedCount;
  final int recentPlatformActionsCount;
  final DateTime? lastUpdatedAt;

  factory PlatformAuditLogSummary.fromLogs(List<PlatformAuditLog> logs) {
    PlatformAuditLog? lastCritical;
    var failedDenied = 0;
    var recentPlatformActions = 0;
    final cutoff = DateTime.now().toUtc().subtract(const Duration(hours: 24));

    for (final log in logs) {
      if (log.severity == PlatformAuditSeverity.critical &&
          (lastCritical == null || log.timestamp.isAfter(lastCritical.timestamp))) {
        lastCritical = log;
      }
      if (log.result == PlatformAuditResult.failure ||
          log.result == PlatformAuditResult.denied) {
        failedDenied++;
      }
      if (log.timestamp.isAfter(cutoff) &&
          (log.actionType.isRegistrationAction ||
              log.actionType.isSupportAccessAction ||
              log.actionType.isSystemHealthAction)) {
        recentPlatformActions++;
      }
    }

    return PlatformAuditLogSummary(
      lastCriticalEvent: lastCritical,
      failedDeniedCount: failedDenied,
      recentPlatformActionsCount: recentPlatformActions,
      lastUpdatedAt: DateTime.now().toUtc(),
    );
  }
}
