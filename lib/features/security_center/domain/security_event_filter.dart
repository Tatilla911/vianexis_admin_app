import 'security_event_severity.dart';
import 'security_event_type.dart';

enum SecurityEventFilter {
  all,
  failedLogin,
  permissionDenied,
  supportAccess,
  highRiskAi,
  criticalSystem,
  adminRoleChange,
  suspiciousBulkOnboarding,
  critical,
  warning,
}

extension SecurityEventFilterX on SecurityEventFilter {
  String localizationKey() {
    return switch (this) {
      SecurityEventFilter.all => 'securityEventFilterAll',
      SecurityEventFilter.failedLogin => 'securityEventFilterFailedLogin',
      SecurityEventFilter.permissionDenied => 'securityEventFilterPermissionDenied',
      SecurityEventFilter.supportAccess => 'securityEventFilterSupportAccess',
      SecurityEventFilter.highRiskAi => 'securityEventFilterHighRiskAi',
      SecurityEventFilter.criticalSystem => 'securityEventFilterCriticalSystem',
      SecurityEventFilter.adminRoleChange => 'securityEventFilterAdminRoleChange',
      SecurityEventFilter.suspiciousBulkOnboarding =>
        'securityEventFilterSuspiciousBulkOnboarding',
      SecurityEventFilter.critical => 'securityEventFilterCritical',
      SecurityEventFilter.warning => 'securityEventFilterWarning',
    };
  }

  SecurityEventType? typeForApi() {
    return switch (this) {
      SecurityEventFilter.all ||
      SecurityEventFilter.critical ||
      SecurityEventFilter.warning => null,
      SecurityEventFilter.failedLogin => SecurityEventType.failedLogin,
      SecurityEventFilter.permissionDenied => SecurityEventType.permissionDenied,
      SecurityEventFilter.supportAccess => SecurityEventType.supportAccess,
      SecurityEventFilter.highRiskAi => SecurityEventType.highRiskAi,
      SecurityEventFilter.criticalSystem => SecurityEventType.criticalSystem,
      SecurityEventFilter.adminRoleChange => SecurityEventType.adminRoleChange,
      SecurityEventFilter.suspiciousBulkOnboarding =>
        SecurityEventType.suspiciousBulkOnboarding,
    };
  }

  SecurityEventSeverity? severityForApi() {
    return switch (this) {
      SecurityEventFilter.critical => SecurityEventSeverity.critical,
      SecurityEventFilter.warning => SecurityEventSeverity.warning,
      _ => null,
    };
  }
}

class SecurityEventListQuery {
  const SecurityEventListQuery({
    this.search = '',
    this.filter = SecurityEventFilter.all,
  });

  final String search;
  final SecurityEventFilter filter;

  SecurityEventListQuery copyWith({
    String? search,
    SecurityEventFilter? filter,
  }) {
    return SecurityEventListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }
}
