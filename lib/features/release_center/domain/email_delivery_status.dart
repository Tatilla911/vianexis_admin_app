class EmailDeliveryStatus {
  const EmailDeliveryStatus({
    required this.provider,
    required this.deliveryEnabled,
    this.lastDeliveryStatus,
    this.lastDeliveryAt,
    this.metadataOnly = true,
  });

  final String provider;
  final bool deliveryEnabled;
  final String? lastDeliveryStatus;
  final DateTime? lastDeliveryAt;
  final bool metadataOnly;

  factory EmailDeliveryStatus.fromJson(Map<String, dynamic> json) {
    return EmailDeliveryStatus(
      provider: json['provider']?.toString() ?? 'noop',
      deliveryEnabled: json['deliveryEnabled'] == true,
      lastDeliveryStatus: json['lastDeliveryStatus']?.toString(),
      lastDeliveryAt: _parseDate(json['lastDeliveryAt']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  /// Values rendered in the release center email delivery card.
  List<String> get safeDisplayValues => [
        provider,
        deliveryEnabled ? 'yes' : 'no',
        ?lastDeliveryStatus,
      ];
}

class EmailDeliveryLog {
  const EmailDeliveryLog({
    required this.id,
    required this.type,
    required this.status,
    required this.provider,
    required this.createdAt,
    this.recipientEmailHash,
    this.recipientEmailDomain,
    this.errorCode,
    this.sentAt,
    this.relatedUserId,
    this.relatedCompanyId,
    this.metadataOnly = true,
  });

  final int id;
  final String type;
  final String? recipientEmailHash;
  final String? recipientEmailDomain;
  final String status;
  final String provider;
  final String? errorCode;
  final DateTime createdAt;
  final DateTime? sentAt;
  final int? relatedUserId;
  final int? relatedCompanyId;
  final bool metadataOnly;

  factory EmailDeliveryLog.fromJson(Map<String, dynamic> json) {
    return EmailDeliveryLog(
      id: _parseInt(json['id']),
      type: json['type']?.toString() ?? 'unknown',
      recipientEmailHash: json['recipientEmailHash']?.toString(),
      recipientEmailDomain: json['recipientEmailDomain']?.toString(),
      status: json['status']?.toString() ?? 'unknown',
      provider: json['provider']?.toString() ?? 'noop',
      errorCode: json['errorCode']?.toString(),
      createdAt: _parseDate(json['createdAt']) ?? DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      sentAt: _parseDate(json['sentAt']),
      relatedUserId: _parseOptionalInt(json['relatedUserId']),
      relatedCompanyId: _parseOptionalInt(json['relatedCompanyId']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class EmailDeliveryLogsPage {
  const EmailDeliveryLogsPage({
    required this.items,
    this.total = 0,
    this.metadataOnly = true,
  });

  final List<EmailDeliveryLog> items;
  final int total;
  final bool metadataOnly;

  factory EmailDeliveryLogsPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return EmailDeliveryLogsPage(
      items: rawItems is List
          ? rawItems
              .whereType<Map<String, dynamic>>()
              .map(EmailDeliveryLog.fromJson)
              .toList(growable: false)
          : const [],
      total: _parseInt(json['total']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString());
}

int _parseInt(Object? raw) {
  if (raw is int) return raw;
  return int.tryParse(raw?.toString() ?? '') ?? 0;
}

int? _parseOptionalInt(Object? raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  return int.tryParse(raw.toString());
}
