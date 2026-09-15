enum NotificationType {
  systemHealth('system_health'),
  security('security'),
  support('support'),
  billing('billing'),
  release('release'),
  general('general'),
  driverApplicationSubmitted('driver_application_submitted'),
  companyApplicationSubmitted('company_application_submitted'),
  unknown('unknown');

  const NotificationType(this.backendValue);

  final String backendValue;

  bool get isRegistrationReview =>
      this == NotificationType.driverApplicationSubmitted ||
      this == NotificationType.companyApplicationSubmitted;

  static NotificationType fromBackendValue(String? raw) {
    final value = raw?.trim();
    if (value == null || value.isEmpty) return NotificationType.unknown;
    for (final item in NotificationType.values) {
      if (item.backendValue == value) {
        return item;
      }
    }
    return switch (value) {
      'system_health_critical' => NotificationType.systemHealth,
      'support_urgent' => NotificationType.support,
      'security_alert' => NotificationType.security,
      _ => NotificationType.unknown,
    };
  }
}
