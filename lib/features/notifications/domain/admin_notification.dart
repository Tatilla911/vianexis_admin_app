import 'notification_severity.dart';
import 'notification_type.dart';

class AdminNotification {
  const AdminNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.severity,
    required this.createdAt,
    this.readAt,
    this.metadata = const {},
    this.inAppOnly = true,
  });

  final String id;
  final String title;
  final String body;
  final NotificationType type;
  final NotificationSeverity severity;
  final DateTime createdAt;
  final DateTime? readAt;
  final Map<String, String> metadata;
  final bool inAppOnly;

  bool get isRead => readAt != null;

  AdminNotification copyWith({DateTime? readAt}) {
    return AdminNotification(
      id: id,
      title: title,
      body: body,
      type: type,
      severity: severity,
      createdAt: createdAt,
      readAt: readAt ?? this.readAt,
      metadata: metadata,
      inAppOnly: inAppOnly,
    );
  }

  factory AdminNotification.fromJson(Map<String, dynamic> json) {
    final rawMetadata = json['metadata'];
    return AdminNotification(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      type: NotificationType.fromBackendValue(json['type']?.toString()),
      severity: NotificationSeverity.fromBackendValue(json['severity']?.toString()),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      readAt: DateTime.tryParse(json['readAt']?.toString() ?? ''),
      metadata: rawMetadata is Map
          ? rawMetadata.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            )
          : const {},
      inAppOnly: json['inAppOnly'] != false,
    );
  }
}
