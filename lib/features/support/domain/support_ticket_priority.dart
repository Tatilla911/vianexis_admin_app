enum SupportTicketPriority {
  low,
  normal,
  high,
  urgent,
  critical,
  unknown;

  static SupportTicketPriority fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'low' => low,
      'normal' => normal,
      'high' => high,
      'urgent' => urgent,
      'critical' => critical,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      SupportTicketPriority.low => 'supportTicketPriorityLow',
      SupportTicketPriority.normal => 'supportTicketPriorityNormal',
      SupportTicketPriority.high => 'supportTicketPriorityHigh',
      SupportTicketPriority.urgent => 'supportTicketPriorityUrgent',
      SupportTicketPriority.critical => 'supportTicketPriorityCritical',
      SupportTicketPriority.unknown => 'supportTicketPriorityUnknown',
    };
  }

  bool get isUrgentLike => this == urgent || this == critical;
}
