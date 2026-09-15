import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_client.dart';
import '../../driver_access/domain/driver_access_profile.dart';
import '../../trips_overview/domain/trip_overview_item.dart';
import '../domain/platform_admin_search_models.dart';

class PlatformAdminSearchApi {
  PlatformAdminSearchApi(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PlatformAdminSearchHit>> searchPlatformAdmin({
    required String q,
    int limit = 10,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/search',
      queryParameters: {
        'q': q,
        'context': 'platform_admin',
        'limit': limit,
        'types': kPlatformAdminSearchTypes,
      },
    );
    return _parseSearchHits(response.data);
  }

  Future<List<PlatformAdminSearchHit>> searchDrivers({
    required String q,
    int limit = 8,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/drivers',
      queryParameters: {'q': q, 'limit': limit},
    );
    final data = response.data;
    final rawItems = data?['items'];
    if (rawItems is! List) return const [];
    return rawItems
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(DriverAccessProfile.fromJson)
        .map(
          (driver) => PlatformAdminSearchHit(
            id: driver.id,
            type: PlatformAdminSearchResultType.driver,
            title: driver.displayName,
            subtitle: driver.companyName,
          ),
        )
        .toList(growable: false);
  }

  Future<List<PlatformAdminSearchHit>> searchTrips({
    required String q,
    int limit = 8,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/trips',
      queryParameters: {'q': q, 'limit': limit},
    );
    final data = response.data;
    final rawItems = data?['items'];
    if (rawItems is! List) return const [];
    return rawItems
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(TripOverviewItem.fromJson)
        .map(
          (trip) => PlatformAdminSearchHit(
            id: trip.id,
            type: PlatformAdminSearchResultType.trip,
            title: trip.reference,
            subtitle: '${trip.companyName} · ${trip.driverName}',
          ),
        )
        .toList(growable: false);
  }

  Future<List<PlatformAdminSearchHit>> searchAuditLogs({
    required String q,
    int limit = 8,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/audit-logs',
      queryParameters: {'q': q, 'limit': limit},
    );
    final data = response.data;
    final rawItems = data?['items'];
    if (rawItems is! List) return const [];
    return rawItems
        .whereType<Map>()
        .map((item) => Map<String, dynamic>.from(item))
        .map(_mapAuditHit)
        .toList(growable: false);
  }

  PlatformAdminSearchHit _mapAuditHit(Map<String, dynamic> json) {
    final actionType =
        json['actionType']?.toString() ??
        json['eventType']?.toString() ??
        '—';
    final companyName = json['companyName']?.toString();
    final targetId = json['targetId']?.toString();
    final timestamp =
        json['timestamp']?.toString() ?? json['createdAt']?.toString();
    final subtitleParts = <String>[
      if (companyName != null && companyName.isNotEmpty) companyName,
      if (targetId != null && targetId.isNotEmpty) 'target $targetId',
      if (timestamp != null && timestamp.isNotEmpty) timestamp,
    ];
    return PlatformAdminSearchHit(
      id: json['id']?.toString() ?? '',
      type: PlatformAdminSearchResultType.auditEvent,
      title: actionType,
      subtitle: subtitleParts.isEmpty ? null : subtitleParts.join(' · '),
      safeMetadata: {
        'companyId': ?json['companyId'],
        'companyName': ?companyName,
        'targetId': ?targetId,
      },
    );
  }

  List<PlatformAdminSearchHit> _parseSearchHits(Map<String, dynamic>? data) {
    if (data == null) return const [];
    final groups = data['groups'];
    if (groups is! List) return const [];
    final hits = <PlatformAdminSearchHit>[];
    for (final group in groups) {
      if (group is! Map) continue;
      final items = group['items'];
      if (items is! List) continue;
      for (final item in items) {
        if (item is Map<String, dynamic>) {
          hits.add(PlatformAdminSearchHit.fromJson(item));
        } else if (item is Map) {
          hits.add(
            PlatformAdminSearchHit.fromJson(Map<String, dynamic>.from(item)),
          );
        }
      }
    }
    return hits;
  }
}

abstract class PlatformAdminSearchRepository {
  Future<PlatformAdminSearchResponse> search(String q);

  bool get usesMockData;
}

class LivePlatformAdminSearchRepository
    implements PlatformAdminSearchRepository {
  LivePlatformAdminSearchRepository(this._api);

  final PlatformAdminSearchApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<PlatformAdminSearchResponse> search(String q) async {
    final query = q.trim();
    final limit = kPlatformAdminSearchGroupLimit;

    final results = await Future.wait([
      _safeResult(
        () => _api.searchPlatformAdmin(q: query, limit: limit),
        groupKey: 'primary',
      ),
      _safeResult(
        () => _api.searchDrivers(q: query, limit: limit),
        groupKey: PlatformAdminSearchResultType.driver.groupLocalizationKey,
      ),
      _safeResult(
        () => _api.searchTrips(q: query, limit: limit),
        groupKey: PlatformAdminSearchResultType.trip.groupLocalizationKey,
      ),
      _safeResult(
        () => _api.searchAuditLogs(q: query, limit: limit),
        groupKey:
            PlatformAdminSearchResultType.auditEvent.groupLocalizationKey,
      ),
    ]);

    final primary = results[0];
    final drivers = results[1];
    final trips = results[2];
    final audit = results[3];

    final failed = <String>[
      if (primary.failed) 'primary',
      if (drivers.failed)
        PlatformAdminSearchResultType.driver.groupLocalizationKey,
      if (trips.failed)
        PlatformAdminSearchResultType.trip.groupLocalizationKey,
      if (audit.failed)
        PlatformAdminSearchResultType.auditEvent.groupLocalizationKey,
    ];

    final merged = <String, PlatformAdminSearchHit>{};
    for (final list in [
      primary.hits,
      drivers.hits,
      trips.hits,
      audit.hits,
    ]) {
      for (final hit in list) {
        final key = '${hit.type.name}:${hit.id}';
        merged.putIfAbsent(key, () => hit);
      }
    }

    return PlatformAdminSearchResponse.fromGroupedHits(
      query: query,
      hits: merged.values.toList(growable: false),
      failedGroupKeys: failed,
      groupLimit: limit,
    );
  }

  Future<_SafeHits> _safeResult(
    Future<List<PlatformAdminSearchHit>> Function() load, {
    required String groupKey,
  }) async {
    try {
      return _SafeHits(hits: await load(), failed: false);
    } catch (_) {
      return _SafeHits(hits: const [], failed: true, groupKey: groupKey);
    }
  }
}

class _SafeHits {
  const _SafeHits({
    required this.hits,
    required this.failed,
    this.groupKey,
  });

  final List<PlatformAdminSearchHit> hits;
  final bool failed;
  final String? groupKey;
}

class MockPlatformAdminSearchRepository
    implements PlatformAdminSearchRepository {
  MockPlatformAdminSearchRepository({this.limit = kPlatformAdminSearchGroupLimit});

  final int limit;

  @override
  bool get usesMockData => true;

  @override
  Future<PlatformAdminSearchResponse> search(String q) async {
    final query = q.trim().toLowerCase();
    final all = const [
      PlatformAdminSearchHit(
        id: '1',
        type: PlatformAdminSearchResultType.company,
        title: 'NordTrans Kft.',
        subtitle: 'HU · active',
      ),
      PlatformAdminSearchHit(
        id: '2',
        type: PlatformAdminSearchResultType.company,
        title: 'EuroFleet Zrt.',
        subtitle: 'HU · pending_review',
      ),
      PlatformAdminSearchHit(
        id: 'd-101',
        type: PlatformAdminSearchResultType.driver,
        title: 'Kovács Péter',
        subtitle: 'NordTrans Kft.',
        safeMetadata: {'companyId': 1},
      ),
      PlatformAdminSearchHit(
        id: 'd-102',
        type: PlatformAdminSearchResultType.driver,
        title: 'Nagy Anna',
        subtitle: 'EuroFleet Zrt.',
        safeMetadata: {'companyId': 2},
      ),
      PlatformAdminSearchHit(
        id: 'reg-1',
        type: PlatformAdminSearchResultType.registration,
        title: 'Acme Logistics',
        subtitle: 'pending',
      ),
      PlatformAdminSearchHit(
        id: '42',
        type: PlatformAdminSearchResultType.trip,
        title: 'TR-42',
        subtitle: 'NordTrans Kft. · Kovács Péter',
        safeMetadata: {'companyId': 1},
      ),
      PlatformAdminSearchHit(
        id: 'doc-9',
        type: PlatformAdminSearchResultType.document,
        title: 'CMR-Nord-001.pdf',
        subtitle: 'NordTrans Kft.',
        safeMetadata: {'companyId': 1, 'tripId': 42},
      ),
      PlatformAdminSearchHit(
        id: 'truck-7',
        type: PlatformAdminSearchResultType.vehicle,
        title: 'ABC-123',
        subtitle: 'NordTrans Kft.',
        safeMetadata: {'companyId': 1, 'status': 'active'},
      ),
      PlatformAdminSearchHit(
        id: 'trailer-3',
        type: PlatformAdminSearchResultType.trailer,
        title: 'TRL-88',
        subtitle: 'NordTrans Kft.',
        safeMetadata: {'companyId': 1},
      ),
      PlatformAdminSearchHit(
        id: 'site-5',
        type: PlatformAdminSearchResultType.site,
        title: 'Budapest Depot',
        subtitle: 'NordTrans Kft. · Budapest',
        safeMetadata: {'companyId': 1},
      ),
      PlatformAdminSearchHit(
        id: '99',
        type: PlatformAdminSearchResultType.auditEvent,
        title: 'support_grant.created',
        subtitle: 'NordTrans Kft. · target 7',
        safeMetadata: {'companyId': 1, 'targetId': '7'},
      ),
    ];

    final hits = all
        .where((hit) {
          final haystack = [
            hit.title,
            hit.subtitle,
            hit.id,
          ].whereType<String>().join(' ').toLowerCase();
          return haystack.contains(query);
        })
        .toList(growable: false);

    return PlatformAdminSearchResponse.fromGroupedHits(
      query: q.trim(),
      hits: hits,
      groupLimit: limit,
    );
  }
}

/// Mock that returns a huge driver fan-out so callers can assert capping.
class BoundedMockPlatformAdminSearchRepository
    implements PlatformAdminSearchRepository {
  BoundedMockPlatformAdminSearchRepository({
    this.driverCount = 100000,
    this.limit = kPlatformAdminSearchGroupLimit,
  });

  final int driverCount;
  final int limit;

  @override
  bool get usesMockData => true;

  @override
  Future<PlatformAdminSearchResponse> search(String q) async {
    final hits = List<PlatformAdminSearchHit>.generate(
      driverCount,
      (i) => PlatformAdminSearchHit(
        id: 'd-$i',
        type: PlatformAdminSearchResultType.driver,
        title: 'Driver $i',
        subtitle: 'Company',
      ),
    ).take(limit).toList(growable: false);

    return PlatformAdminSearchResponse.fromGroupedHits(
      query: q.trim(),
      hits: hits,
      groupLimit: limit,
    );
  }
}

final platformAdminSearchRepositoryProvider =
    Provider<PlatformAdminSearchRepository>((ref) {
      if (AppConfig.instance.shouldUseLiveRepositories) {
        return LivePlatformAdminSearchRepository(
          PlatformAdminSearchApi(ref.watch(apiClientProvider)),
        );
      }
      return MockPlatformAdminSearchRepository();
    });
