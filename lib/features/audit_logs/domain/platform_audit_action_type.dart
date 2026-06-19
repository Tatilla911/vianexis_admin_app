enum PlatformAuditActionType {
  login,
  logout,
  loginFailed,
  registrationApproved,
  registrationRejected,
  registrationInfoRequested,
  supportTicketAcknowledged,
  supportTicketClosed,
  supportAccessGranted,
  supportAccessRevoked,
  systemHealthAcknowledged,
  systemHealthEscalated,
  billingUpdated,
  roleChanged,
  permissionDenied,
  exportRequested,
  apiKeyCreated,
  apiKeyRevoked,
  unknown;

  static PlatformAuditActionType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    final value = raw.trim().toLowerCase();
    return switch (value) {
      'login' => login,
      'logout' => logout,
      'login_failed' => loginFailed,
      'registration_approved' || 'platform.registration.approved' =>
        registrationApproved,
      'registration_rejected' || 'platform.registration.rejected' =>
        registrationRejected,
      'registration_info_requested' || 'platform.registration.request_info' =>
        registrationInfoRequested,
      'support_ticket_acknowledged' => supportTicketAcknowledged,
      'support_ticket_closed' => supportTicketClosed,
      'support_access_granted' || 'platform.support_grant.created' =>
        supportAccessGranted,
      'support_access_revoked' => supportAccessRevoked,
      'system_health_acknowledged' || 'platform.system_health.viewed' =>
        systemHealthAcknowledged,
      'system_health_escalated' => systemHealthEscalated,
      'billing_updated' => billingUpdated,
      'role_changed' => roleChanged,
      'permission_denied' => permissionDenied,
      'export_requested' => exportRequested,
      'api_key_created' => apiKeyCreated,
      'api_key_revoked' => apiKeyRevoked,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      PlatformAuditActionType.login => 'auditLogActionLogin',
      PlatformAuditActionType.logout => 'auditLogActionLogout',
      PlatformAuditActionType.loginFailed => 'auditLogActionLoginFailed',
      PlatformAuditActionType.registrationApproved => 'auditLogActionRegistrationApproved',
      PlatformAuditActionType.registrationRejected => 'auditLogActionRegistrationRejected',
      PlatformAuditActionType.registrationInfoRequested =>
        'auditLogActionRegistrationInfoRequested',
      PlatformAuditActionType.supportTicketAcknowledged =>
        'auditLogActionSupportTicketAcknowledged',
      PlatformAuditActionType.supportTicketClosed => 'auditLogActionSupportTicketClosed',
      PlatformAuditActionType.supportAccessGranted => 'auditLogActionSupportAccessGranted',
      PlatformAuditActionType.supportAccessRevoked => 'auditLogActionSupportAccessRevoked',
      PlatformAuditActionType.systemHealthAcknowledged =>
        'auditLogActionSystemHealthAcknowledged',
      PlatformAuditActionType.systemHealthEscalated =>
        'auditLogActionSystemHealthEscalated',
      PlatformAuditActionType.billingUpdated => 'auditLogActionBillingUpdated',
      PlatformAuditActionType.roleChanged => 'auditLogActionRoleChanged',
      PlatformAuditActionType.permissionDenied => 'auditLogActionPermissionDenied',
      PlatformAuditActionType.exportRequested => 'auditLogActionExportRequested',
      PlatformAuditActionType.apiKeyCreated => 'auditLogActionApiKeyCreated',
      PlatformAuditActionType.apiKeyRevoked => 'auditLogActionApiKeyRevoked',
      PlatformAuditActionType.unknown => 'auditLogActionUnknown',
    };
  }

  bool get isRegistrationAction =>
      this == registrationApproved ||
      this == registrationRejected ||
      this == registrationInfoRequested;

  bool get isSupportAccessAction =>
      this == supportAccessGranted ||
      this == supportAccessRevoked ||
      this == supportTicketAcknowledged ||
      this == supportTicketClosed;

  bool get isSystemHealthAction =>
      this == systemHealthAcknowledged || this == systemHealthEscalated;

  bool get isSecurityAction =>
      this == login ||
      this == logout ||
      this == loginFailed ||
      this == permissionDenied ||
      this == apiKeyCreated ||
      this == apiKeyRevoked ||
      this == roleChanged;
}
