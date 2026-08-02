import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';

class UserAccessCatalogEntry {
  const UserAccessCatalogEntry({
    required this.targetType,
    required this.targetKey,
    required this.labelKey,
    required this.descriptionKey,
    required this.scope,
    required this.sensitive,
    required this.active,
    this.pendingChange,
    this.dependencyWarnings = const [],
  });

  final String targetType;
  final String targetKey;
  final String labelKey;
  final String descriptionKey;
  final String scope;
  final bool sensitive;
  final bool active;
  final Map<String, dynamic>? pendingChange;
  final List<Map<String, dynamic>> dependencyWarnings;

  factory UserAccessCatalogEntry.fromJson(Map<String, dynamic> json) {
    return UserAccessCatalogEntry(
      targetType: json['targetType']?.toString() ?? '',
      targetKey: json['targetKey']?.toString() ?? '',
      labelKey: json['labelKey']?.toString() ?? '',
      descriptionKey: json['descriptionKey']?.toString() ?? '',
      scope: json['scope']?.toString() ?? '',
      sensitive: json['sensitive'] == true,
      active: json['active'] == true,
      pendingChange: json['pendingChange'] is Map
          ? Map<String, dynamic>.from(json['pendingChange'] as Map)
          : null,
      dependencyWarnings: json['dependencyWarnings'] is List
          ? (json['dependencyWarnings'] as List)
                .whereType<Map>()
                .map((e) => Map<String, dynamic>.from(e))
                .toList()
          : const [],
    );
  }
}

class UserAccessSnapshot {
  const UserAccessSnapshot({
    required this.catalog,
    required this.pendingChangeRequests,
  });

  final List<UserAccessCatalogEntry> catalog;
  final List<Map<String, dynamic>> pendingChangeRequests;

  factory UserAccessSnapshot.fromJson(Map<String, dynamic> json) {
    final catalog = json['catalog'] is List
        ? (json['catalog'] as List)
              .whereType<Map>()
              .map(
                (e) =>
                    UserAccessCatalogEntry.fromJson(Map<String, dynamic>.from(e)),
              )
              .toList()
        : <UserAccessCatalogEntry>[];
    final pending = json['pendingChangeRequests'] is List
        ? (json['pendingChangeRequests'] as List)
              .whereType<Map>()
              .map((e) => Map<String, dynamic>.from(e))
              .toList()
        : <Map<String, dynamic>>[];
    return UserAccessSnapshot(catalog: catalog, pendingChangeRequests: pending);
  }
}

class UserAccessApi {
  UserAccessApi(this._client);

  final ApiClient _client;

  Future<UserAccessSnapshot> getAccess(String userId, {int? companyId}) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/platform-admin/users/$userId/access',
      queryParameters: {
        if (companyId != null) 'companyId': companyId,
      },
    );
    return UserAccessSnapshot.fromJson(response.data ?? const {});
  }

  Future<Map<String, dynamic>> createChangeRequest({
    required String userId,
    required List<Map<String, dynamic>> changes,
    required String reason,
    required String requestedByName,
    required String authorizedByName,
    required String authorizationMethod,
    String? authorizationReference,
    String? internalComment,
    String? userVisibleComment,
    String? effectiveAt,
    String? expiresAt,
    String applyMode = 'require_approval',
    int? companyId,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/platform-admin/users/$userId/access-change-requests',
      data: {
        'changes': changes,
        'reason': reason,
        'requestedByName': requestedByName,
        'authorizedByName': authorizedByName,
        'authorizationMethod': authorizationMethod,
        'applyMode': applyMode,
        if (authorizationReference != null)
          'authorizationReference': authorizationReference,
        if (internalComment != null) 'internalComment': internalComment,
        if (userVisibleComment != null) 'userVisibleComment': userVisibleComment,
        if (effectiveAt != null) 'effectiveAt': effectiveAt,
        if (expiresAt != null) 'expiresAt': expiresAt,
        if (companyId != null) 'companyId': companyId,
      },
    );
    return response.data ?? const {};
  }

  Future<Map<String, dynamic>> listChangeRequests(String userId) async {
    final response = await _client.get<Map<String, dynamic>>(
      '/platform-admin/users/$userId/access-change-requests',
    );
    return response.data ?? const {};
  }
}

final userAccessApiProvider = Provider<UserAccessApi>((ref) {
  return UserAccessApi(ref.watch(apiClientProvider));
});

final userAccessProvider = FutureProvider.autoDispose
    .family<UserAccessSnapshot, String>((ref, userId) {
      return ref.watch(userAccessApiProvider).getAccess(userId);
    });
