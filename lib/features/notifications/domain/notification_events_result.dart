class NotificationEventItem {
  const NotificationEventItem({
    required this.id,
    required this.type,
    required this.status,
    this.createdAt,
    this.sentAt,
    this.failedAt,
    this.failureCategory,
    this.targetType,
    this.targetDriverId,
    this.companyId,
    this.provider,
  });

  final String id;
  final String type;
  final String status;
  final DateTime? createdAt;
  final DateTime? sentAt;
  final DateTime? failedAt;
  final String? failureCategory;
  final String? targetType;
  final String? targetDriverId;
  final String? companyId;
  final String? provider;

  factory NotificationEventItem.fromJson(Map<String, dynamic> json) {
    return NotificationEventItem(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '—',
      status: json['status']?.toString() ?? '—',
      createdAt: DateTime.tryParse(json['createdAt']?.toString() ?? ''),
      sentAt: DateTime.tryParse(json['sentAt']?.toString() ?? ''),
      failedAt: DateTime.tryParse(json['failedAt']?.toString() ?? ''),
      failureCategory: json['failureCategory']?.toString(),
      targetType: json['targetType']?.toString(),
      targetDriverId: json['targetDriverId']?.toString(),
      companyId: json['companyId']?.toString(),
      provider: json['provider']?.toString(),
    );
  }
}

class NotificationEventsResult {
  const NotificationEventsResult({
    required this.metadataOnly,
    required this.sourceUnavailable,
    required this.items,
    required this.total,
  });

  final bool metadataOnly;
  final bool sourceUnavailable;
  final List<NotificationEventItem> items;
  final int total;

  factory NotificationEventsResult.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    return NotificationEventsResult(
      metadataOnly: json['metadataOnly'] != false,
      sourceUnavailable: json['sourceUnavailable'] == true,
      items: rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(NotificationEventItem.fromJson)
                .toList(growable: false)
          : const [],
      total: json['total'] is int
          ? json['total'] as int
          : int.tryParse(json['total']?.toString() ?? '') ??
                (rawItems is List ? rawItems.length : 0),
    );
  }
}
