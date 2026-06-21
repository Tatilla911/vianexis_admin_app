import 'customer_message_delivery.dart';

enum CustomerCommunicationDirection {
  inbound,
  outbound,
  internalNote,
  systemEvent,
  unknown;

  static CustomerCommunicationDirection fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'inbound' => inbound,
      'outbound' => outbound,
      'internal_note' => internalNote,
      'system_event' => systemEvent,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      CustomerCommunicationDirection.inbound =>
        'customerCommunicationDirectionInbound',
      CustomerCommunicationDirection.outbound =>
        'customerCommunicationDirectionOutbound',
      CustomerCommunicationDirection.internalNote =>
        'customerCommunicationDirectionInternalNote',
      CustomerCommunicationDirection.systemEvent =>
        'customerCommunicationDirectionSystemEvent',
      CustomerCommunicationDirection.unknown =>
        'customerCommunicationDirectionUnknown',
    };
  }
}

enum CustomerCommunicationSenderType {
  customer,
  platformAdmin,
  companyAdmin,
  system,
  unknown;

  static CustomerCommunicationSenderType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'customer' => customer,
      'platform_admin' => platformAdmin,
      'company_admin' => companyAdmin,
      'system' => system,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      CustomerCommunicationSenderType.customer =>
        'customerCommunicationSenderCustomer',
      CustomerCommunicationSenderType.platformAdmin =>
        'customerCommunicationSenderPlatformAdmin',
      CustomerCommunicationSenderType.companyAdmin =>
        'customerCommunicationSenderCompanyAdmin',
      CustomerCommunicationSenderType.system =>
        'customerCommunicationSenderSystem',
      CustomerCommunicationSenderType.unknown =>
        'customerCommunicationSenderUnknown',
    };
  }
}

class CustomerCommunicationMessage {
  const CustomerCommunicationMessage({
    required this.id,
    required this.threadId,
    required this.direction,
    required this.senderType,
    this.senderUserId,
    this.senderEmailHash,
    this.senderEmailDomain,
    this.originalText,
    this.originalLanguage,
    this.translatedText,
    this.translatedLanguage,
    this.translationRecordId,
    this.humanReviewedTranslation = false,
    this.sentAt,
    this.createdAt,
    this.metadataOnly = false,
    this.delivery,
  });

  final String id;
  final String threadId;
  final CustomerCommunicationDirection direction;
  final CustomerCommunicationSenderType senderType;
  final String? senderUserId;
  final String? senderEmailHash;
  final String? senderEmailDomain;
  final String? originalText;
  final String? originalLanguage;
  final String? translatedText;
  final String? translatedLanguage;
  final String? translationRecordId;
  final bool humanReviewedTranslation;
  final DateTime? sentAt;
  final DateTime? createdAt;
  final bool metadataOnly;
  final CustomerMessageDelivery? delivery;

  bool get hasTranslation =>
      translatedText != null && translatedText!.trim().isNotEmpty;

  factory CustomerCommunicationMessage.fromJson(Map<String, dynamic> json) {
    return CustomerCommunicationMessage(
      id: json['id']?.toString() ?? '',
      threadId: json['threadId']?.toString() ?? '',
      direction: CustomerCommunicationDirection.fromBackendValue(
        json['direction']?.toString(),
      ),
      senderType: CustomerCommunicationSenderType.fromBackendValue(
        json['senderType']?.toString(),
      ),
      senderUserId: json['senderUserId']?.toString(),
      senderEmailHash: json['senderEmailHash']?.toString(),
      senderEmailDomain: json['senderEmailDomain']?.toString(),
      originalText: json['originalText']?.toString(),
      originalLanguage: json['originalLanguage']?.toString(),
      translatedText: json['translatedText']?.toString(),
      translatedLanguage: json['translatedLanguage']?.toString(),
      translationRecordId: json['translationRecordId']?.toString(),
      humanReviewedTranslation: json['humanReviewedTranslation'] == true,
      sentAt: _parseDate(json['sentAt']),
      createdAt: _parseDate(json['createdAt']),
      metadataOnly: json['metadataOnly'] == true,
      delivery: json['delivery'] is Map<String, dynamic>
          ? CustomerMessageDelivery.fromJson(
              json['delivery'] as Map<String, dynamic>,
            )
          : json['delivery'] is Map
              ? CustomerMessageDelivery.fromJson(
                  Map<String, dynamic>.from(json['delivery'] as Map),
                )
              : null,
    );
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}
