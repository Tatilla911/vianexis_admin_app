enum NotificationSeverity {
  info('info'),
  warning('warning'),
  critical('critical'),
  unknown('unknown');

  const NotificationSeverity(this.backendValue);

  final String backendValue;

  static NotificationSeverity fromBackendValue(String? raw) {
    for (final value in NotificationSeverity.values) {
      if (value.backendValue == raw) {
        return value;
      }
    }
    return NotificationSeverity.unknown;
  }
}
