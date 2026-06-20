import 'security_event_severity.dart';
import 'security_event_type.dart';

class SecurityEvent {
  const SecurityEvent({
    required this.id,
    required this.type,
    required this.severity,
    required this.title,
    required this.summary,
    required this.sourceType,
    this.actorUserId,
    this.actorEmail,
    this.actorRole,
    this.companyId,
    this.companyName,
    this.sourceId,
    this.correlationId,
    this.createdAt,
    this.metadataOnly = true,
  });

  final String id;
  final SecurityEventType type;
  final SecurityEventSeverity severity;
  final String title;
  final String summary;
  final String? actorUserId;
  final String? actorEmail;
  final String? actorRole;
  final String? companyId;
  final String? companyName;
  final String sourceType;
  final String? sourceId;
  final String? correlationId;
  final DateTime? createdAt;
  final bool metadataOnly;

  bool matchesSearch(String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return true;
    return title.toLowerCase().contains(query) ||
        summary.toLowerCase().contains(query) ||
        (actorEmail ?? '').toLowerCase().contains(query) ||
        (companyName ?? '').toLowerCase().contains(query) ||
        (correlationId ?? '').toLowerCase().contains(query);
  }

  factory SecurityEvent.fromJson(Map<String, dynamic> json) {
    return SecurityEvent(
      id: json['id']?.toString() ?? '',
      type: SecurityEventType.fromBackendValue(json['type']?.toString()),
      severity: SecurityEventSeverity.fromBackendValue(json['severity']?.toString()),
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      actorUserId: json['actorUserId']?.toString(),
      actorEmail: json['actorEmail']?.toString(),
      actorRole: json['actorRole']?.toString(),
      companyId: json['companyId']?.toString(),
      companyName: json['companyName']?.toString(),
      sourceType: json['sourceType']?.toString() ?? '',
      sourceId: json['sourceId']?.toString(),
      correlationId: json['correlationId']?.toString(),
      createdAt: _parseDate(json['createdAt']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class SecurityEventsPage {
  const SecurityEventsPage({
    required this.items,
    this.total = 0,
    this.metadataOnly = true,
  });

  final List<SecurityEvent> items;
  final int total;
  final bool metadataOnly;

  factory SecurityEventsPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(SecurityEvent.fromJson)
            .toList(growable: false)
        : const <SecurityEvent>[];
    return SecurityEventsPage(
      items: items,
      total: _parseInt(json['total'], fallback: items.length),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString());
}

int _parseInt(Object? raw, {required int fallback}) {
  if (raw is int) return raw;
  return int.tryParse(raw?.toString() ?? '') ?? fallback;
}
