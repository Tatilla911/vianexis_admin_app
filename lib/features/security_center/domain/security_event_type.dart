enum SecurityEventType {
  failedLogin('failed_login'),
  permissionDenied('permission_denied'),
  supportAccess('support_access'),
  highRiskAi('high_risk_ai'),
  criticalSystem('critical_system'),
  adminRoleChange('admin_role_change'),
  suspiciousBulkOnboarding('suspicious_bulk_onboarding'),
  unknown('unknown');

  const SecurityEventType(this.backendValue);

  final String backendValue;

  static SecurityEventType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final type in SecurityEventType.values) {
      if (type.backendValue == raw) return type;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      failedLogin => 'securityEventTypeFailedLogin',
      permissionDenied => 'securityEventTypePermissionDenied',
      supportAccess => 'securityEventTypeSupportAccess',
      highRiskAi => 'securityEventTypeHighRiskAi',
      criticalSystem => 'securityEventTypeCriticalSystem',
      adminRoleChange => 'securityEventTypeAdminRoleChange',
      suspiciousBulkOnboarding => 'securityEventTypeSuspiciousBulkOnboarding',
      unknown => 'securityEventTypeUnknown',
    };
  }
}
