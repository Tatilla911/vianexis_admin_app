enum CustomerMessageDeliveryEventType {
  queued,
  sent,
  delivered,
  bounced,
  complained,
  opened,
  clicked,
  failed,
  providerStatus,
  unknown;

  static CustomerMessageDeliveryEventType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'queued' => queued,
      'sent' => sent,
      'delivered' => delivered,
      'bounced' => bounced,
      'complained' => complained,
      'opened' => opened,
      'clicked' => clicked,
      'failed' => failed,
      'provider_status' => providerStatus,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      CustomerMessageDeliveryEventType.queued =>
        'customerCommunicationDeliveryEventQueued',
      CustomerMessageDeliveryEventType.sent =>
        'customerCommunicationDeliveryEventSent',
      CustomerMessageDeliveryEventType.delivered =>
        'customerCommunicationDeliveryEventDelivered',
      CustomerMessageDeliveryEventType.bounced =>
        'customerCommunicationDeliveryEventBounced',
      CustomerMessageDeliveryEventType.complained =>
        'customerCommunicationDeliveryEventComplained',
      CustomerMessageDeliveryEventType.opened =>
        'customerCommunicationDeliveryEventOpened',
      CustomerMessageDeliveryEventType.clicked =>
        'customerCommunicationDeliveryEventClicked',
      CustomerMessageDeliveryEventType.failed =>
        'customerCommunicationDeliveryEventFailed',
      CustomerMessageDeliveryEventType.providerStatus =>
        'customerCommunicationDeliveryEventProviderStatus',
      CustomerMessageDeliveryEventType.unknown =>
        'customerCommunicationDeliveryEventUnknown',
    };
  }
}

class CustomerMessageDeliveryEvent {
  const CustomerMessageDeliveryEvent({
    required this.id,
    required this.deliveryId,
    required this.eventType,
    required this.provider,
    required this.eventAt,
    this.failureCode,
    this.failureMessageSafe,
    this.metadataOnly = true,
  });

  final String id;
  final String deliveryId;
  final CustomerMessageDeliveryEventType eventType;
  final String provider;
  final DateTime eventAt;
  final String? failureCode;
  final String? failureMessageSafe;
  final bool metadataOnly;

  factory CustomerMessageDeliveryEvent.fromJson(Map<String, dynamic> json) {
    return CustomerMessageDeliveryEvent(
      id: json['id']?.toString() ?? '',
      deliveryId: json['deliveryId']?.toString() ?? '',
      eventType: CustomerMessageDeliveryEventType.fromBackendValue(
        json['eventType']?.toString(),
      ),
      provider: json['provider']?.toString() ?? 'unknown',
      eventAt: DateTime.tryParse(json['eventAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      failureCode: json['failureCode']?.toString(),
      failureMessageSafe: json['failureMessageSafe']?.toString(),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}
