enum ActionCenterItemType {
  registration('registration'),
  bulkOnboarding('bulk_onboarding'),
  support('support'),
  systemHealth('system_health'),
  security('security'),
  billing('billing'),
  aiReview('ai_review'),
  company('company'),
  customerCommunication('customer_communication'),
  unknown('unknown');

  const ActionCenterItemType(this.backendValue);

  final String backendValue;

  static ActionCenterItemType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final type in ActionCenterItemType.values) {
      if (type.backendValue == raw) return type;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      registration => 'actionCenterTypeRegistration',
      bulkOnboarding => 'actionCenterTypeBulkOnboarding',
      support => 'actionCenterTypeSupport',
      systemHealth => 'actionCenterTypeSystemHealth',
      security => 'actionCenterTypeSecurity',
      billing => 'actionCenterTypeBilling',
      aiReview => 'actionCenterTypeAiReview',
      company => 'actionCenterTypeCompany',
      customerCommunication => 'actionCenterTypeCustomerCommunication',
      unknown => 'actionCenterTypeUnknown',
    };
  }
}

enum ActionCenterPriority {
  low('low'),
  normal('normal'),
  high('high'),
  urgent('urgent'),
  critical('critical'),
  unknown('unknown');

  const ActionCenterPriority(this.backendValue);

  final String backendValue;

  static ActionCenterPriority fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final priority in ActionCenterPriority.values) {
      if (priority.backendValue == raw) return priority;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      low => 'actionCenterPriorityLow',
      normal => 'actionCenterPriorityNormal',
      high => 'actionCenterPriorityHigh',
      urgent => 'actionCenterPriorityUrgent',
      critical => 'actionCenterPriorityCritical',
      unknown => 'actionCenterPriorityUnknown',
    };
  }

  int get weight => switch (this) {
    critical => 5,
    urgent => 4,
    high => 3,
    normal => 2,
    low => 1,
    unknown => 0,
  };
}

enum ActionCenterStatus {
  open('open'),
  acknowledged('acknowledged'),
  dismissed('dismissed'),
  resolved('resolved'),
  unknown('unknown');

  const ActionCenterStatus(this.backendValue);

  final String backendValue;

  static ActionCenterStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final status in ActionCenterStatus.values) {
      if (status.backendValue == raw) return status;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      open => 'actionCenterStatusOpen',
      acknowledged => 'actionCenterStatusAcknowledged',
      dismissed => 'actionCenterStatusDismissed',
      resolved => 'actionCenterStatusResolved',
      unknown => 'actionCenterStatusUnknown',
    };
  }
}
