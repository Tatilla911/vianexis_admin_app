class PlatformCompanyMember {
  const PlatformCompanyMember({
    required this.membershipId,
    required this.userId,
    required this.companyId,
    this.displayName,
    this.firstName,
    this.lastName,
    this.email,
    this.phone,
    this.primaryRole,
    this.additionalRoles = const [],
    this.status,
    this.invitationStatus,
    this.emailDeliveryStatus,
    this.joinedAt,
    this.lastLoginAt,
    this.driverProfileId,
    this.createdAt,
    this.updatedAt,
  });

  final String membershipId;
  final String userId;
  final String companyId;
  final String? displayName;
  final String? firstName;
  final String? lastName;
  final String? email;
  final String? phone;
  final String? primaryRole;
  final List<String> additionalRoles;
  final String? status;
  final String? invitationStatus;
  final String? emailDeliveryStatus;
  final DateTime? joinedAt;
  final DateTime? lastLoginAt;
  final String? driverProfileId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  /// Prefer display name; fall back to email (never a bare "Unknown user").
  String get listDisplayName {
    final name = displayName?.trim();
    if (name != null && name.isNotEmpty) return name;

    final composed = [
      firstName?.trim(),
      lastName?.trim(),
    ].whereType<String>().where((part) => part.isNotEmpty).join(' ');
    if (composed.isNotEmpty) return composed;

    final mail = email?.trim();
    if (mail != null && mail.isNotEmpty) return mail;

    return '—';
  }

  bool get hasInvitationStatus {
    final value = invitationStatus?.trim().toLowerCase();
    return value != null && value.isNotEmpty && value != 'none';
  }

  factory PlatformCompanyMember.fromJson(Map<String, dynamic> json) {
    final additional = json['additionalRoles'];
    return PlatformCompanyMember(
      membershipId: (json['membershipId'] ?? json['userId'])?.toString() ?? '',
      userId: json['userId']?.toString() ?? '',
      companyId: json['companyId']?.toString() ?? '',
      displayName: json['displayName']?.toString(),
      firstName: json['firstName']?.toString(),
      lastName: json['lastName']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      primaryRole: json['primaryRole']?.toString(),
      additionalRoles: additional is List
          ? additional.map((e) => e.toString()).toList(growable: false)
          : const [],
      status: json['status']?.toString(),
      invitationStatus: json['invitationStatus']?.toString(),
      emailDeliveryStatus: json['emailDeliveryStatus']?.toString(),
      joinedAt: _parseDate(json['joinedAt']),
      lastLoginAt: _parseDate(json['lastLoginAt']),
      driverProfileId: json['driverProfileId']?.toString(),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
    );
  }
}

class PlatformCompanyMembersPage {
  const PlatformCompanyMembersPage({
    required this.companyId,
    required this.items,
    required this.total,
    required this.limit,
    required this.offset,
    this.metadataOnly = false,
  });

  final String companyId;
  final List<PlatformCompanyMember> items;
  final int total;
  final int limit;
  final int offset;
  final bool metadataOnly;

  factory PlatformCompanyMembersPage.fromJson(Map<String, dynamic> json) {
    final rawItems = (json['items'] as List?) ?? const [];
    return PlatformCompanyMembersPage(
      companyId: json['companyId']?.toString() ?? '',
      items: rawItems
          .whereType<Map>()
          .map(
            (e) =>
                PlatformCompanyMember.fromJson(Map<String, dynamic>.from(e)),
          )
          .toList(growable: false),
      total: _parseInt(json['total']),
      limit: _parseInt(json['limit']),
      offset: _parseInt(json['offset']),
      metadataOnly: json['metadataOnly'] == true,
    );
  }
}

enum PlatformCompanyMemberRoleFilter {
  all,
  owners,
  dispatchers,
  drivers,
  workshop,
  documentation,
  other;

  /// Backend `role` query when a single role maps 1:1; null for composite filters.
  String? get apiRole => switch (this) {
    PlatformCompanyMemberRoleFilter.all => null,
    PlatformCompanyMemberRoleFilter.owners => null,
    PlatformCompanyMemberRoleFilter.dispatchers => 'dispatcher',
    PlatformCompanyMemberRoleFilter.drivers => 'driver',
    PlatformCompanyMemberRoleFilter.workshop => 'workshop',
    PlatformCompanyMemberRoleFilter.documentation => 'documentation',
    PlatformCompanyMemberRoleFilter.other => null,
  };

  bool matches(PlatformCompanyMember member) {
    final role = member.primaryRole?.trim().toLowerCase() ?? '';
    return switch (this) {
      PlatformCompanyMemberRoleFilter.all => true,
      PlatformCompanyMemberRoleFilter.owners =>
        role == 'company_owner' || role == 'company_admin',
      PlatformCompanyMemberRoleFilter.dispatchers => role == 'dispatcher',
      PlatformCompanyMemberRoleFilter.drivers => role == 'driver',
      PlatformCompanyMemberRoleFilter.workshop => role == 'workshop',
      PlatformCompanyMemberRoleFilter.documentation => role == 'documentation',
      PlatformCompanyMemberRoleFilter.other =>
        role != 'company_owner' &&
            role != 'company_admin' &&
            role != 'dispatcher' &&
            role != 'driver' &&
            role != 'workshop' &&
            role != 'documentation',
    };
  }

  int countFromSummary(Map<String, int> usersByRole) {
    int roleCount(String key) => usersByRole[key] ?? 0;
    return switch (this) {
      PlatformCompanyMemberRoleFilter.all =>
        usersByRole.values.fold<int>(0, (sum, v) => sum + v),
      PlatformCompanyMemberRoleFilter.owners =>
        roleCount('company_owner') + roleCount('company_admin'),
      PlatformCompanyMemberRoleFilter.dispatchers => roleCount('dispatcher'),
      PlatformCompanyMemberRoleFilter.drivers => roleCount('driver'),
      PlatformCompanyMemberRoleFilter.workshop => roleCount('workshop'),
      PlatformCompanyMemberRoleFilter.documentation =>
        roleCount('documentation'),
      PlatformCompanyMemberRoleFilter.other => usersByRole.entries
          .where(
            (e) =>
                e.key != 'company_owner' &&
                e.key != 'company_admin' &&
                e.key != 'dispatcher' &&
                e.key != 'driver' &&
                e.key != 'workshop' &&
                e.key != 'documentation',
          )
          .fold<int>(0, (sum, e) => sum + e.value),
    };
  }

  String get l10nKey => switch (this) {
    PlatformCompanyMemberRoleFilter.all =>
      'platformCompanyMembersFilterAll',
    PlatformCompanyMemberRoleFilter.owners =>
      'platformCompanyMembersFilterOwners',
    PlatformCompanyMemberRoleFilter.dispatchers =>
      'platformCompanyMembersFilterDispatchers',
    PlatformCompanyMemberRoleFilter.drivers =>
      'platformCompanyMembersFilterDrivers',
    PlatformCompanyMemberRoleFilter.workshop =>
      'platformCompanyMembersFilterWorkshop',
    PlatformCompanyMemberRoleFilter.documentation =>
      'platformCompanyMembersFilterDocumentation',
    PlatformCompanyMemberRoleFilter.other =>
      'platformCompanyMembersFilterOther',
  };
}

class PlatformCompanyMembersQuery {
  const PlatformCompanyMembersQuery({
    required this.companyId,
    this.roleFilter = PlatformCompanyMemberRoleFilter.all,
  });

  final String companyId;
  final PlatformCompanyMemberRoleFilter roleFilter;

  @override
  bool operator ==(Object other) {
    return other is PlatformCompanyMembersQuery &&
        other.companyId == companyId &&
        other.roleFilter == roleFilter;
  }

  @override
  int get hashCode => Object.hash(companyId, roleFilter);
}

String platformCompanyMemberRoleL10nKey(String? role) {
  return switch (role?.trim().toLowerCase()) {
    'company_owner' => 'platformCompanyRoleCompanyOwner',
    'company_admin' => 'platformCompanyRoleCompanyAdmin',
    'dispatcher' => 'platformCompanyRoleDispatcher',
    'driver' => 'platformCompanyRoleDriver',
    'workshop' => 'platformCompanyRoleWorkshop',
    'documentation' => 'platformCompanyRoleDocumentation',
    'claims_insurance' => 'platformCompanyRoleClaimsInsurance',
    'finance' => 'platformCompanyRoleFinance',
    'company_support' => 'platformCompanyRoleCompanySupport',
    'subcontractor_manager' => 'platformCompanyRoleSubcontractorManager',
    final value when value != null && value.isNotEmpty => value,
    _ => 'platformCompanyRoleUnknown',
  };
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString());
}

int _parseInt(Object? raw) {
  if (raw is int) return raw;
  return int.tryParse(raw?.toString() ?? '') ?? 0;
}
