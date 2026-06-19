import 'system_health_severity.dart';

enum SystemHealthEventStatus {
  open,
  acknowledged,
  investigating,
  resolved,
  unknown;

  static SystemHealthEventStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return open;
    return switch (raw.trim().toLowerCase()) {
      'open' => open,
      'acknowledged' => acknowledged,
      'investigating' => investigating,
      'resolved' => resolved,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      SystemHealthEventStatus.open => 'systemHealthEventStatusOpen',
      SystemHealthEventStatus.acknowledged => 'systemHealthEventStatusAcknowledged',
      SystemHealthEventStatus.investigating => 'systemHealthEventStatusInvestigating',
      SystemHealthEventStatus.resolved => 'systemHealthEventStatusResolved',
      SystemHealthEventStatus.unknown => 'systemHealthEventStatusUnknown',
    };
  }
}

enum SystemHealthTenantImpactLevel {
  none,
  singleTenant,
  multipleTenants,
  platformWide,
  unknown;

  static SystemHealthTenantImpactLevel fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return none;
    return switch (raw.trim().toLowerCase()) {
      'none' => none,
      'single_tenant' => singleTenant,
      'multiple_tenants' => multipleTenants,
      'platform_wide' => platformWide,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      SystemHealthTenantImpactLevel.none => 'systemHealthImpactNone',
      SystemHealthTenantImpactLevel.singleTenant => 'systemHealthImpactSingleTenant',
      SystemHealthTenantImpactLevel.multipleTenants => 'systemHealthImpactMultipleTenants',
      SystemHealthTenantImpactLevel.platformWide => 'systemHealthImpactPlatformWide',
      SystemHealthTenantImpactLevel.unknown => 'systemHealthImpactUnknown',
    };
  }

  bool get isTenantImpacting =>
      this == singleTenant ||
      this == multipleTenants ||
      this == platformWide;
}

enum SystemHealthEventFilter {
  all,
  critical,
  warning,
  open,
  acknowledged,
  resolved,
  tenantImpacting,
}

extension SystemHealthEventFilterX on SystemHealthEventFilter {
  String localizationKey() {
    return switch (this) {
      SystemHealthEventFilter.all => 'systemHealthFilterAll',
      SystemHealthEventFilter.critical => 'systemHealthFilterCritical',
      SystemHealthEventFilter.warning => 'systemHealthFilterWarning',
      SystemHealthEventFilter.open => 'systemHealthFilterOpen',
      SystemHealthEventFilter.acknowledged => 'systemHealthFilterAcknowledged',
      SystemHealthEventFilter.resolved => 'systemHealthFilterResolved',
      SystemHealthEventFilter.tenantImpacting => 'systemHealthFilterTenantImpacting',
    };
  }
}

class SystemHealthEvent {
  const SystemHealthEvent({
    required this.id,
    required this.severity,
    required this.serviceName,
    required this.status,
    required this.title,
    required this.summary,
    required this.tenantImpactLevel,
    this.affectedCompanyName,
    this.affectedCompanyId,
    this.startedAt,
    this.lastSeenAt,
    this.resolvedAt,
    this.failedJobsCount = 0,
    this.aiDiagnosticSummary,
    this.recommendedAction,
    this.correlationId,
    this.metadataOnly = const {},
  });

  final String id;
  final SystemHealthSeverity severity;
  final String serviceName;
  final SystemHealthEventStatus status;
  final String title;
  final String summary;
  final SystemHealthTenantImpactLevel tenantImpactLevel;
  final String? affectedCompanyName;
  final String? affectedCompanyId;
  final DateTime? startedAt;
  final DateTime? lastSeenAt;
  final DateTime? resolvedAt;
  final int failedJobsCount;
  final String? aiDiagnosticSummary;
  final String? recommendedAction;
  final String? correlationId;
  final Map<String, dynamic> metadataOnly;

  bool matchesFilter(SystemHealthEventFilter filter) {
    return switch (filter) {
      SystemHealthEventFilter.all => true,
      SystemHealthEventFilter.critical => severity == SystemHealthSeverity.critical,
      SystemHealthEventFilter.warning => severity == SystemHealthSeverity.warning,
      SystemHealthEventFilter.open => status == SystemHealthEventStatus.open,
      SystemHealthEventFilter.acknowledged =>
        status == SystemHealthEventStatus.acknowledged,
      SystemHealthEventFilter.resolved => status == SystemHealthEventStatus.resolved,
      SystemHealthEventFilter.tenantImpacting => tenantImpactLevel.isTenantImpacting,
    };
  }

  factory SystemHealthEvent.fromJson(Map<String, dynamic> json) {
    final component = json['component']?.toString() ?? json['serviceName']?.toString();
    final metrics = _asMap(json['metrics'] ?? json['metadataOnly']);

    return SystemHealthEvent(
      id: json['id']?.toString() ?? '',
      severity: SystemHealthSeverity.fromBackendValue(json['severity']?.toString()),
      serviceName: component ?? 'platform',
      status: SystemHealthEventStatus.fromBackendValue(json['status']?.toString()),
      title: json['title']?.toString() ?? json['messageKey']?.toString() ?? component ?? '—',
      summary: json['summary']?.toString() ?? json['detailSummary']?.toString() ?? '—',
      tenantImpactLevel: SystemHealthTenantImpactLevel.fromBackendValue(
        json['tenantImpactLevel']?.toString(),
      ),
      affectedCompanyName: json['affectedCompanyName']?.toString(),
      affectedCompanyId: json['affectedCompanyId']?.toString(),
      startedAt: parseDate(json['startedAt'] ?? json['createdAt']),
      lastSeenAt: parseDate(json['lastSeenAt'] ?? json['updatedAt'] ?? json['createdAt']),
      resolvedAt: parseDate(json['resolvedAt']),
      failedJobsCount: _asInt(json['failedJobsCount']) ?? 0,
      aiDiagnosticSummary: json['aiDiagnosticSummary']?.toString(),
      recommendedAction: json['recommendedAction']?.toString(),
      correlationId: json['correlationId']?.toString(),
      metadataOnly: metrics,
    );
  }

  SystemHealthEvent copyWith({
    SystemHealthEventStatus? status,
    DateTime? lastSeenAt,
    DateTime? resolvedAt,
  }) {
    return SystemHealthEvent(
      id: id,
      severity: severity,
      serviceName: serviceName,
      status: status ?? this.status,
      title: title,
      summary: summary,
      tenantImpactLevel: tenantImpactLevel,
      affectedCompanyName: affectedCompanyName,
      affectedCompanyId: affectedCompanyId,
      startedAt: startedAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      resolvedAt: resolvedAt ?? this.resolvedAt,
      failedJobsCount: failedJobsCount,
      aiDiagnosticSummary: aiDiagnosticSummary,
      recommendedAction: recommendedAction,
      correlationId: correlationId,
      metadataOnly: metadataOnly,
    );
  }

  static Map<String, dynamic> _asMap(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return const {};
  }

  static int? _asInt(Object? raw) {
    if (raw is int) return raw;
    if (raw is num) return raw.toInt();
    if (raw is String) return int.tryParse(raw);
    return null;
  }

  static DateTime? parseDate(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}
