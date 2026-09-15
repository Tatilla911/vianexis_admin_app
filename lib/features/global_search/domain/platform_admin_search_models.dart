enum PlatformAdminSearchResultType {
  company,
  registration,
  driver,
  trip,
  document,
  vehicle,
  trailer,
  site,
  auditEvent,
  other;

  static PlatformAdminSearchResultType fromBackend(String? raw) {
    return switch (raw?.trim().toLowerCase()) {
      'company' => PlatformAdminSearchResultType.company,
      'registration_application' ||
      'registration' => PlatformAdminSearchResultType.registration,
      'driver' => PlatformAdminSearchResultType.driver,
      'trip' => PlatformAdminSearchResultType.trip,
      'document' => PlatformAdminSearchResultType.document,
      'truck' || 'vehicle' => PlatformAdminSearchResultType.vehicle,
      'trailer' => PlatformAdminSearchResultType.trailer,
      'site' => PlatformAdminSearchResultType.site,
      'audit_event' || 'audit' => PlatformAdminSearchResultType.auditEvent,
      _ => PlatformAdminSearchResultType.other,
    };
  }

  String get groupLocalizationKey => switch (this) {
    PlatformAdminSearchResultType.company => 'globalSearchGroupCompanies',
    PlatformAdminSearchResultType.registration =>
      'globalSearchGroupRegistrations',
    PlatformAdminSearchResultType.driver => 'globalSearchGroupDrivers',
    PlatformAdminSearchResultType.trip => 'globalSearchGroupTrips',
    PlatformAdminSearchResultType.document => 'globalSearchGroupDocuments',
    PlatformAdminSearchResultType.vehicle => 'globalSearchGroupVehicles',
    PlatformAdminSearchResultType.trailer => 'globalSearchGroupTrailers',
    PlatformAdminSearchResultType.site => 'globalSearchGroupSites',
    PlatformAdminSearchResultType.auditEvent => 'globalSearchGroupEvents',
    PlatformAdminSearchResultType.other => 'globalSearchTitle',
  };
}

class PlatformAdminSearchHit {
  const PlatformAdminSearchHit({
    required this.id,
    required this.type,
    required this.title,
    this.subtitle,
    this.route,
    this.safeMetadata = const {},
  });

  final String id;
  final PlatformAdminSearchResultType type;
  final String title;
  final String? subtitle;
  final String? route;
  final Map<String, dynamic> safeMetadata;

  factory PlatformAdminSearchHit.fromJson(Map<String, dynamic> json) {
    final metadata = json['safeMetadata'];
    return PlatformAdminSearchHit(
      id: json['id']?.toString() ?? '',
      type: PlatformAdminSearchResultType.fromBackend(json['type']?.toString()),
      title: json['title']?.toString() ?? '—',
      subtitle: json['subtitle']?.toString(),
      route: json['route']?.toString(),
      safeMetadata: metadata is Map<String, dynamic>
          ? Map<String, dynamic>.from(metadata)
          : metadata is Map
          ? Map<String, dynamic>.from(metadata)
          : const {},
    );
  }

  String? get companyIdFromMetadata {
    final raw = safeMetadata['companyId'];
    if (raw == null) return null;
    final text = raw.toString().trim();
    return text.isEmpty ? null : text;
  }
}

class PlatformAdminSearchGroup {
  const PlatformAdminSearchGroup({
    required this.type,
    required this.items,
  });

  final PlatformAdminSearchResultType type;
  final List<PlatformAdminSearchHit> items;
}

class PlatformAdminSearchResponse {
  const PlatformAdminSearchResponse({
    required this.query,
    required this.groups,
    this.total = 0,
    this.failedGroupKeys = const [],
    this.groupLimit = kPlatformAdminSearchGroupLimit,
  });

  final String query;
  final List<PlatformAdminSearchGroup> groups;
  final int total;
  final List<String> failedGroupKeys;
  final int groupLimit;

  bool get hasPartialErrors => failedGroupKeys.isNotEmpty;

  factory PlatformAdminSearchResponse.fromGroupedHits({
    required String query,
    required List<PlatformAdminSearchHit> hits,
    List<String> failedGroupKeys = const [],
    int groupLimit = kPlatformAdminSearchGroupLimit,
  }) {
    final byType = <PlatformAdminSearchResultType, List<PlatformAdminSearchHit>>{};
    for (final hit in hits) {
      if (hit.type == PlatformAdminSearchResultType.other) continue;
      byType.putIfAbsent(hit.type, () => []).add(hit);
    }

    const order = [
      PlatformAdminSearchResultType.company,
      PlatformAdminSearchResultType.registration,
      PlatformAdminSearchResultType.driver,
      PlatformAdminSearchResultType.trip,
      PlatformAdminSearchResultType.document,
      PlatformAdminSearchResultType.vehicle,
      PlatformAdminSearchResultType.trailer,
      PlatformAdminSearchResultType.site,
      PlatformAdminSearchResultType.auditEvent,
    ];

    final groups = <PlatformAdminSearchGroup>[
      for (final type in order)
        if ((byType[type] ?? const []).isNotEmpty)
          PlatformAdminSearchGroup(type: type, items: byType[type]!),
    ];

    return PlatformAdminSearchResponse(
      query: query,
      groups: groups,
      total: hits.length,
      failedGroupKeys: failedGroupKeys,
      groupLimit: groupLimit,
    );
  }
}

const kPlatformAdminSearchGroupLimit = 8;

const kPlatformAdminSearchTypes =
    'company,registration_application,driver,trip,truck,trailer,site,document';
