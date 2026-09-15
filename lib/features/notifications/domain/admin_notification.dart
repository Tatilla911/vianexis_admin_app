import 'notification_severity.dart';
import 'notification_type.dart';

const _sensitiveMetadataKeys = {
  'email',
  'phone',
  'password',
  'token',
  'fcmtoken',
  'pushtoken',
};

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
    this.titleKey,
    this.messageKey,
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
  final String? titleKey;
  final String? messageKey;

  bool get isRead => readAt != null;

  String? get deepLink {
    final value = metadata['deepLink']?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  String? get applicationId {
    final value = metadata['applicationId']?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  String? get driverRegistrationRequestId {
    final value = metadata['driverRegistrationRequestId']?.trim();
    if (value == null || value.isEmpty) return null;
    return value;
  }

  Map<String, String> get displayMetadata {
    return Map<String, String>.fromEntries(
      metadata.entries.where((entry) {
        final key = entry.key.toLowerCase();
        if (_sensitiveMetadataKeys.contains(key)) return false;
        if (key.contains('password') ||
            key.contains('token') ||
            key.contains('secret')) {
          return false;
        }
        return true;
      }),
    );
  }

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
      titleKey: titleKey,
      messageKey: messageKey,
    );
  }

  factory AdminNotification.fromJson(Map<String, dynamic> json) {
    final rawMetadata = json['metadata'];
    final metadata = _sanitizeMetadata(
      rawMetadata is Map
          ? rawMetadata.map(
              (key, value) => MapEntry(key.toString(), value.toString()),
            )
          : const <String, String>{},
    );

    final type = NotificationType.fromBackendValue(json['type']?.toString());
    final titleKey = json['titleKey']?.toString();
    final messageKey = json['messageKey']?.toString();

    var title = json['title']?.toString().trim() ?? '';
    var body = json['body']?.toString().trim() ?? '';

    if (title.isEmpty || title.startsWith('platformAdmin.')) {
      title = _firstNonEmpty([
        metadata['titleEn'],
        metadata['titleHu'],
        if (title.isNotEmpty && !title.startsWith('platformAdmin.')) title,
      ]);
    }
    if (body.isEmpty || body.startsWith('platformAdmin.')) {
      body = _firstNonEmpty([
        metadata['inAppBodyEn'],
        metadata['bodyEn'],
        metadata['inAppBodyHu'],
        metadata['bodyHu'],
      ]);
    }

    return AdminNotification(
      id: json['id']?.toString() ?? '',
      title: title,
      body: body,
      type: type,
      severity: NotificationSeverity.fromBackendValue(
        json['severity']?.toString(),
      ),
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      readAt: DateTime.tryParse(json['readAt']?.toString() ?? ''),
      metadata: metadata,
      inAppOnly: json['inAppOnly'] != false,
      titleKey: titleKey,
      messageKey: messageKey,
    );
  }

  static Map<String, String> _sanitizeMetadata(Map<String, String> raw) {
    return Map<String, String>.fromEntries(
      raw.entries.where((entry) {
        final key = entry.key.toLowerCase();
        if (_sensitiveMetadataKeys.contains(key)) return false;
        if (key.contains('password') || key.contains('secret')) return false;
        return true;
      }),
    );
  }

  static String _firstNonEmpty(List<String?> values) {
    for (final value in values) {
      final trimmed = value?.trim() ?? '';
      if (trimmed.isNotEmpty && !trimmed.startsWith('platformAdmin.')) {
        return trimmed;
      }
    }
    return '';
  }
}
