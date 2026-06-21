enum CustomerMessageDeliveryChannel {
  email,
  portal,
  manual,
  none,
  unknown;

  static CustomerMessageDeliveryChannel fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'email' => email,
      'portal' => portal,
      'manual' => manual,
      'none' => none,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      CustomerMessageDeliveryChannel.email =>
        'customerCommunicationDeliveryChannelEmail',
      CustomerMessageDeliveryChannel.portal =>
        'customerCommunicationDeliveryChannelPortal',
      CustomerMessageDeliveryChannel.manual =>
        'customerCommunicationDeliveryChannelManual',
      CustomerMessageDeliveryChannel.none =>
        'customerCommunicationDeliveryChannelNone',
      CustomerMessageDeliveryChannel.unknown =>
        'customerCommunicationDeliveryChannelUnknown',
    };
  }
}

enum CustomerMessageDeliveryStatus {
  draft,
  queued,
  skipped,
  sent,
  failed,
  cancelled,
  unknown;

  static CustomerMessageDeliveryStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'draft' => draft,
      'queued' => queued,
      'skipped' => skipped,
      'sent' => sent,
      'failed' => failed,
      'cancelled' => cancelled,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      CustomerMessageDeliveryStatus.draft =>
        'customerCommunicationDeliveryStatusDraft',
      CustomerMessageDeliveryStatus.queued =>
        'customerCommunicationDeliveryStatusQueued',
      CustomerMessageDeliveryStatus.skipped =>
        'customerCommunicationDeliveryStatusSkipped',
      CustomerMessageDeliveryStatus.sent =>
        'customerCommunicationDeliveryStatusSent',
      CustomerMessageDeliveryStatus.failed =>
        'customerCommunicationDeliveryStatusFailed',
      CustomerMessageDeliveryStatus.cancelled =>
        'customerCommunicationDeliveryStatusCancelled',
      CustomerMessageDeliveryStatus.unknown =>
        'customerCommunicationDeliveryStatusUnknown',
    };
  }
}

class CustomerMessageDelivery {
  const CustomerMessageDelivery({
    required this.id,
    required this.threadId,
    this.messageId,
    required this.deliveryChannel,
    required this.deliveryProvider,
    required this.deliveryStatus,
    this.recipientEmailHash,
    this.recipientEmailDomain,
    this.attemptedAt,
    this.sentAt,
    this.failedAt,
    this.failureCode,
    this.humanConfirmed = false,
    this.translationApproved = false,
    this.metadataOnly = true,
  });

  final String id;
  final String threadId;
  final String? messageId;
  final CustomerMessageDeliveryChannel deliveryChannel;
  final String deliveryProvider;
  final CustomerMessageDeliveryStatus deliveryStatus;
  final String? recipientEmailHash;
  final String? recipientEmailDomain;
  final DateTime? attemptedAt;
  final DateTime? sentAt;
  final DateTime? failedAt;
  final String? failureCode;
  final bool humanConfirmed;
  final bool translationApproved;
  final bool metadataOnly;

  bool get isSkippedOrNoop =>
      deliveryStatus == CustomerMessageDeliveryStatus.skipped;

  factory CustomerMessageDelivery.fromJson(Map<String, dynamic> json) {
    return CustomerMessageDelivery(
      id: json['id']?.toString() ?? '',
      threadId: json['threadId']?.toString() ?? '',
      messageId: json['messageId']?.toString(),
      deliveryChannel: CustomerMessageDeliveryChannel.fromBackendValue(
        json['deliveryChannel']?.toString(),
      ),
      deliveryProvider: json['deliveryProvider']?.toString() ?? 'unknown',
      deliveryStatus: CustomerMessageDeliveryStatus.fromBackendValue(
        json['deliveryStatus']?.toString(),
      ),
      recipientEmailHash: json['recipientEmailHash']?.toString(),
      recipientEmailDomain: json['recipientEmailDomain']?.toString(),
      attemptedAt: _parseDate(json['attemptedAt']),
      sentAt: _parseDate(json['sentAt']),
      failedAt: _parseDate(json['failedAt']),
      failureCode: json['failureCode']?.toString(),
      humanConfirmed: json['humanConfirmed'] == true,
      translationApproved: json['translationApproved'] == true,
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString());
  }
}
