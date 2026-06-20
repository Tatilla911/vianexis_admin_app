import 'platform_admin_user_role.dart';
import 'platform_admin_user_status.dart';

class PlatformAdminUser {
  const PlatformAdminUser({
    required this.id,
    required this.email,
    required this.role,
    required this.status,
    this.name,
    this.createdAt,
    this.updatedAt,
    this.lastLoginAt,
    this.failedLoginCount = 0,
    this.lastFailedLoginAt,
    this.metadataOnly = true,
  });

  final String id;
  final String email;
  final String? name;
  final PlatformAdminUserRole role;
  final PlatformAdminUserStatus status;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastLoginAt;
  final int failedLoginCount;
  final DateTime? lastFailedLoginAt;
  final bool metadataOnly;

  String get displayName => name?.trim().isNotEmpty == true ? name!.trim() : email;

  bool matchesSearch(String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return true;
    return email.toLowerCase().contains(query) ||
        (name ?? '').toLowerCase().contains(query) ||
        role.backendValue.contains(query) ||
        status.backendValue.contains(query);
  }

  bool matchesFilter(AdminUserListFilter filter) => status.matchesFilter(filter);

  factory PlatformAdminUser.fromJson(Map<String, dynamic> json) {
    return PlatformAdminUser(
      id: _stringId(json['id'] ?? json['userId']),
      email: json['email']?.toString() ?? '',
      name: json['name']?.toString(),
      role: PlatformAdminUserRole.fromBackendValue(json['role']?.toString()),
      status: PlatformAdminUserStatus.fromBackendValue(json['status']?.toString()),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      lastLoginAt: _parseDate(json['lastLoginAt']),
      failedLoginCount: _parseInt(json['failedLoginCount']),
      lastFailedLoginAt: _parseDate(json['lastFailedLoginAt']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class PlatformAdminUsersPage {
  const PlatformAdminUsersPage({
    required this.items,
    this.metadataOnly = true,
  });

  final List<PlatformAdminUser> items;
  final bool metadataOnly;

  factory PlatformAdminUsersPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(PlatformAdminUser.fromJson)
            .toList(growable: false)
        : const <PlatformAdminUser>[];
    return PlatformAdminUsersPage(
      items: items,
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

String _stringId(Object? raw) {
  if (raw == null) return '';
  return raw.toString();
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString());
}

int _parseInt(Object? raw) {
  if (raw is int) return raw;
  return int.tryParse(raw?.toString() ?? '') ?? 0;
}
