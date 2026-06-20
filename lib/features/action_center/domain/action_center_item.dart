import 'action_center_item_type.dart';

class ActionCenterItem {
  const ActionCenterItem({
    required this.id,
    required this.type,
    required this.priority,
    required this.title,
    required this.summary,
    required this.sourceType,
    required this.sourceId,
    required this.status,
    this.companyId,
    this.companyName,
    this.createdAt,
    this.dueAt,
    this.actionRouteHint,
    this.metadataOnly = true,
  });

  final String id;
  final ActionCenterItemType type;
  final ActionCenterPriority priority;
  final String title;
  final String summary;
  final String sourceType;
  final String sourceId;
  final String? companyId;
  final String? companyName;
  final DateTime? createdAt;
  final DateTime? dueAt;
  final ActionCenterStatus status;
  final String? actionRouteHint;
  final bool metadataOnly;

  bool matchesSearch(String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return true;
    return title.toLowerCase().contains(query) ||
        summary.toLowerCase().contains(query) ||
        (companyName ?? '').toLowerCase().contains(query) ||
        type.backendValue.contains(query);
  }

  factory ActionCenterItem.fromJson(Map<String, dynamic> json) {
    return ActionCenterItem(
      id: json['id']?.toString() ?? '',
      type: ActionCenterItemType.fromBackendValue(json['type']?.toString()),
      priority: ActionCenterPriority.fromBackendValue(json['priority']?.toString()),
      title: json['title']?.toString() ?? '',
      summary: json['summary']?.toString() ?? '',
      sourceType: json['sourceType']?.toString() ?? '',
      sourceId: json['sourceId']?.toString() ?? '',
      companyId: json['companyId']?.toString(),
      companyName: json['companyName']?.toString(),
      createdAt: _parseDate(json['createdAt']),
      dueAt: _parseDate(json['dueAt']),
      status: ActionCenterStatus.fromBackendValue(json['status']?.toString()),
      actionRouteHint: json['actionRouteHint']?.toString(),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class ActionCenterSnapshot {
  const ActionCenterSnapshot({
    required this.items,
    this.total = 0,
    this.metadataOnly = true,
  });

  final List<ActionCenterItem> items;
  final int total;
  final bool metadataOnly;

  int get needsAttentionCount =>
      items.where((item) => item.status == ActionCenterStatus.open).length;

  int get criticalCount => items
      .where(
        (item) =>
            item.priority == ActionCenterPriority.critical ||
            item.priority == ActionCenterPriority.urgent,
      )
      .length;

  factory ActionCenterSnapshot.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(ActionCenterItem.fromJson)
            .toList(growable: false)
        : const <ActionCenterItem>[];
    return ActionCenterSnapshot(
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
