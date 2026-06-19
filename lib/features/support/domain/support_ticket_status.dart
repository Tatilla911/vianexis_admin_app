enum SupportTicketStatus {
  open,
  acknowledged,
  investigating,
  waitingForCustomer,
  resolved,
  closed,
  unknown;

  static SupportTicketStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return open;
    return switch (raw.trim().toLowerCase()) {
      'open' => open,
      'acknowledged' => acknowledged,
      'investigating' || 'in_progress' => investigating,
      'waiting_for_customer' || 'waiting_on_customer' => waitingForCustomer,
      'resolved' => resolved,
      'closed' => closed,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      SupportTicketStatus.open => 'supportTicketStatusOpen',
      SupportTicketStatus.acknowledged => 'supportTicketStatusAcknowledged',
      SupportTicketStatus.investigating => 'supportTicketStatusInvestigating',
      SupportTicketStatus.waitingForCustomer => 'supportTicketStatusWaitingForCustomer',
      SupportTicketStatus.resolved => 'supportTicketStatusResolved',
      SupportTicketStatus.closed => 'supportTicketStatusClosed',
      SupportTicketStatus.unknown => 'supportTicketStatusUnknown',
    };
  }

  bool get isOpenLike =>
      this == open ||
      this == acknowledged ||
      this == investigating ||
      this == waitingForCustomer;
}
