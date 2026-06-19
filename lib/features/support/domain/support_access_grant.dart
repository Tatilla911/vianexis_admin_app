import 'support_access_grant_status.dart';
import 'support_access_scope_type.dart';

enum SupportAccessGrantListFilter {
  all,
  pending,
  active,
  expired,
  revoked,
}

extension SupportAccessGrantListFilterX on SupportAccessGrantListFilter {
  String localizationKey() {
    return switch (this) {
      SupportAccessGrantListFilter.all => 'supportGrantFilterAll',
      SupportAccessGrantListFilter.pending => 'supportGrantFilterPending',
      SupportAccessGrantListFilter.active => 'supportGrantFilterActive',
      SupportAccessGrantListFilter.expired => 'supportGrantFilterExpired',
      SupportAccessGrantListFilter.revoked => 'supportGrantFilterRevoked',
    };
  }
}

class SupportAccessGrant {
  const SupportAccessGrant({
    required this.id,
    required this.companyId,
    this.companyName,
    this.requestedByUserId,
    this.requestedByName,
    this.approvedByUserId,
    this.approvedByName,
    required this.scopeType,
    this.scopeId,
    required this.reason,
    required this.status,
    this.allowedDataCategories = const [],
    this.excludesSensitiveDocuments = true,
    this.createdAt,
    this.expiresAt,
    this.revokedAt,
    this.auditLogId,
    this.metadataOnly = const {},
  });

  final String id;
  final String companyId;
  final String? companyName;
  final String? requestedByUserId;
  final String? requestedByName;
  final String? approvedByUserId;
  final String? approvedByName;
  final SupportAccessScopeType scopeType;
  final String? scopeId;
  final String reason;
  final SupportAccessGrantStatus status;
  final List<String> allowedDataCategories;
  final bool excludesSensitiveDocuments;
  final DateTime? createdAt;
  final DateTime? expiresAt;
  final DateTime? revokedAt;
  final String? auditLogId;
  final Map<String, dynamic> metadataOnly;

  bool matchesSearch(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return [
      companyName,
      scopeId,
      requestedByName,
      reason,
    ].whereType<String>().any((value) => value.toLowerCase().contains(normalized));
  }

  bool matchesFilter(SupportAccessGrantListFilter filter) {
    return switch (filter) {
      SupportAccessGrantListFilter.all => true,
      SupportAccessGrantListFilter.pending => status == SupportAccessGrantStatus.pending,
      SupportAccessGrantListFilter.active => status == SupportAccessGrantStatus.active,
      SupportAccessGrantListFilter.expired => status == SupportAccessGrantStatus.expired,
      SupportAccessGrantListFilter.revoked => status == SupportAccessGrantStatus.revoked,
    };
  }

  factory SupportAccessGrant.fromJson(Map<String, dynamic> json) {
    final metadata = _asMap(json['metadataOnly'] ?? json['metadata']);
    final scopes = json['scope'];
    final scopeList = scopes is List
        ? scopes.map((item) => item.toString()).toList(growable: false)
        : <String>[];

    final scopeTypeRaw =
        metadata['scopeType']?.toString() ?? json['scopeType']?.toString();
    var scopeType = SupportAccessScopeType.fromBackendValue(scopeTypeRaw);
    if (scopeType == SupportAccessScopeType.unknown) {
      scopeType = _inferScopeType(scopeList);
    }

    final expiresAt = _parseDate(json['expiresAt']);
    final revokedAt = _parseDate(json['revokedAt']);

    return SupportAccessGrant(
      id: json['id']?.toString() ?? '',
      companyId: json['companyId']?.toString() ?? '',
      companyName: json['companyName']?.toString(),
      requestedByUserId: json['requestedByUserId']?.toString(),
      requestedByName: json['requestedByName']?.toString(),
      approvedByUserId: (json['approvedByUserId'] ?? json['grantedByUserId'])?.toString(),
      approvedByName: json['approvedByName']?.toString(),
      scopeType: scopeType,
      scopeId: (json['scopeId'] ?? metadata['scopeId'])?.toString(),
      reason: json['reason']?.toString() ?? '',
      status: SupportAccessGrantStatus.derive(
        explicitStatus: json['status']?.toString(),
        revokedAt: revokedAt,
        expiresAt: expiresAt ?? DateTime.now().toUtc(),
        isActive: json['isActive'] == true,
      ),
      allowedDataCategories: scopeList.isNotEmpty
          ? scopeList
          : (json['allowedDataCategories'] is List
              ? (json['allowedDataCategories'] as List).map((e) => e.toString()).toList()
              : const []),
      excludesSensitiveDocuments: json['excludesSensitiveDocuments'] != false &&
          json['documentsAllowed'] != true,
      createdAt: _parseDate(json['createdAt']),
      expiresAt: expiresAt,
      revokedAt: revokedAt,
      auditLogId: json['auditLogId']?.toString(),
      metadataOnly: metadata,
    );
  }

  SupportAccessGrant copyWith({
    SupportAccessGrantStatus? status,
    DateTime? revokedAt,
  }) {
    return SupportAccessGrant(
      id: id,
      companyId: companyId,
      companyName: companyName,
      requestedByUserId: requestedByUserId,
      requestedByName: requestedByName,
      approvedByUserId: approvedByUserId,
      approvedByName: approvedByName,
      scopeType: scopeType,
      scopeId: scopeId,
      reason: reason,
      status: status ?? this.status,
      allowedDataCategories: allowedDataCategories,
      excludesSensitiveDocuments: excludesSensitiveDocuments,
      createdAt: createdAt,
      expiresAt: expiresAt,
      revokedAt: revokedAt ?? this.revokedAt,
      auditLogId: auditLogId,
      metadataOnly: metadataOnly,
    );
  }

  static SupportAccessScopeType _inferScopeType(List<String> scopes) {
    if (scopes.contains('trip_groups')) {
      return SupportAccessScopeType.specificTrip;
    }
    if (scopes.contains('audit')) return SupportAccessScopeType.systemHealthIssue;
    if (scopes.contains('company_settings')) {
      return SupportAccessScopeType.billingIssue;
    }
    if (scopes.contains('workshop')) return SupportAccessScopeType.uploadQueueIssue;
    if (scopes.contains('organization')) {
      return SupportAccessScopeType.integrationIssue;
    }
    return SupportAccessScopeType.companyMetadata;
  }

  static Map<String, dynamic> _asMap(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return const {};
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}
