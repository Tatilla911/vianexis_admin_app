enum NotificationType {
  systemHealth('system_health'),
  security('security'),
  support('support'),
  billing('billing'),
  release('release'),
  general('general'),
  unknown('unknown');

  const NotificationType(this.backendValue);

  final String backendValue;

  static NotificationType fromBackendValue(String? raw) {
    for (final value in NotificationType.values) {
      if (value.backendValue == raw) {
        return value;
      }
    }
    return NotificationType.unknown;
  }
}
