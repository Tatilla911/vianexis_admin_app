import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../domain/driver_access_profile.dart';
import '../domain/driver_device_notification_status.dart';
import '../domain/driver_operational_health_detail.dart';

abstract class DriverAccessRepository {
  Future<DriverAccessListResult> listDrivers({
    String? status,
    String? q,
    int limit = 50,
    int offset = 0,
  });

  Future<DriverAccessProfile?> fetchDriver(String driverProfileId);

  Future<void> patchDriverStatus(
    String driverProfileId, {
    required String status,
    String? reason,
  });

  Future<Map<String, dynamic>> resendInvite(String driverProfileId);

  Future<Map<String, dynamic>> sendPasswordSetup(String driverProfileId);

  Future<Map<String, dynamic>> softDelete({
    required String driverProfileId,
    required String reason,
  });

  Future<DriverDeviceNotificationStatus?> fetchDeviceNotificationStatus(
    String driverProfileId,
  );

  Future<DriverOperationalHealthDetail?> fetchOperationalHealth(
    String driverProfileId,
  ) async => null;

  bool get usesMockData;
}

class LiveDriverAccessRepository implements DriverAccessRepository {
  LiveDriverAccessRepository([this._apiClient]);

  final ApiClient? _apiClient;

  @override
  bool get usesMockData => false;

  @override
  Future<DriverAccessListResult> listDrivers({
    String? status,
    String? q,
    int limit = 50,
    int offset = 0,
  }) async {
    final apiClient = _apiClient;
    if (apiClient == null) {
      return const DriverAccessListResult(
        items: [],
        listEndpointReady: false,
        metadataOnly: true,
        total: 0,
      );
    }

    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        '/platform-admin/drivers',
        queryParameters: {
          if (status != null && status.trim().isNotEmpty)
            'status': status.trim(),
          if (q != null && q.trim().isNotEmpty) 'q': q.trim(),
          'limit': limit,
          'offset': offset,
        },
      );
      final data = response.data;
      final rawItems = data?['items'];
      final items = rawItems is List
          ? rawItems
                .whereType<Map<String, dynamic>>()
                .map(DriverAccessProfile.fromJson)
                .toList(growable: false)
          : const <DriverAccessProfile>[];
      final total =
          int.tryParse(data?['total']?.toString() ?? '') ?? items.length;

      return DriverAccessListResult(
        items: items,
        listEndpointReady: true,
        metadataOnly: true,
        total: total,
        statusCounts: DriverAccessStatusCounts.fromJson(
          data?['statusCounts'] is Map<String, dynamic>
              ? data!['statusCounts'] as Map<String, dynamic>
              : null,
        ),
      );
    } on DioException catch (error) {
      final statusCode = error.response?.statusCode;
      if (statusCode == 404 || statusCode == 501) {
        return const DriverAccessListResult(
          items: [],
          listEndpointReady: false,
          metadataOnly: true,
          total: 0,
        );
      }
      rethrow;
    }
  }

  @override
  Future<DriverAccessProfile?> fetchDriver(String driverProfileId) async {
    final apiClient = _apiClient;
    if (apiClient == null) return null;
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        '/platform-admin/drivers/$driverProfileId',
      );
      final data = response.data;
      if (data == null) return null;
      return DriverAccessProfile.fromJson(data);
    } on ApiException catch (error) {
      // Detail endpoint may not be deployed yet — fall back to list.
      if (error.kind == ApiExceptionKind.notFound ||
          error.statusCode == 404 ||
          error.statusCode == 501) {
        return null;
      }
      rethrow;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 404 || status == 501) return null;
      rethrow;
    }
  }

  @override
  Future<void> patchDriverStatus(
    String driverProfileId, {
    required String status,
    String? reason,
  }) async {
    final apiClient = _apiClient;
    if (apiClient == null) {
      throw StateError('Driver status endpoint unavailable');
    }
    await apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/drivers/$driverProfileId/status',
      data: {
        'status': status,
        if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
      },
    );
  }

  @override
  Future<Map<String, dynamic>> resendInvite(String driverProfileId) async {
    final apiClient = _apiClient;
    if (apiClient == null) {
      throw StateError('Driver invite endpoint unavailable');
    }
    final response = await apiClient.post<Map<String, dynamic>>(
      '/platform-admin/drivers/$driverProfileId/resend-invite',
    );
    return response.data ?? const <String, dynamic>{};
  }

  @override
  Future<Map<String, dynamic>> sendPasswordSetup(String driverProfileId) async {
    final apiClient = _apiClient;
    if (apiClient == null) {
      throw StateError('Driver password-setup endpoint unavailable');
    }
    final response = await apiClient.post<Map<String, dynamic>>(
      '/platform-admin/drivers/$driverProfileId/send-password-setup',
    );
    return response.data ?? const <String, dynamic>{};
  }

  @override
  Future<Map<String, dynamic>> softDelete({
    required String driverProfileId,
    required String reason,
  }) async {
    final apiClient = _apiClient;
    if (apiClient == null) {
      throw StateError('Driver delete endpoint unavailable');
    }
    final response = await apiClient.post<Map<String, dynamic>>(
      '/platform-admin/drivers/$driverProfileId/delete',
      data: {'reason': reason},
    );
    return response.data ?? const <String, dynamic>{};
  }

  @override
  Future<DriverDeviceNotificationStatus?> fetchDeviceNotificationStatus(
    String driverProfileId,
  ) async {
    final apiClient = _apiClient;
    if (apiClient == null) return null;
    final response = await apiClient.get<Map<String, dynamic>>(
      '/platform-admin/drivers/$driverProfileId/device-notification-status',
    );
    final data = response.data;
    if (data == null) return null;
    return DriverDeviceNotificationStatus.fromJson(data);
  }

  @override
  Future<DriverOperationalHealthDetail?> fetchOperationalHealth(
    String driverProfileId,
  ) async {
    final apiClient = _apiClient;
    if (apiClient == null) return null;
    try {
      final response = await apiClient.get<Map<String, dynamic>>(
        '/platform-admin/drivers/$driverProfileId/operational-health',
      );
      final data = response.data;
      if (data == null) return null;
      return DriverOperationalHealthDetail.fromJson(data);
    } on ApiException catch (error) {
      if (error.kind == ApiExceptionKind.notFound ||
          error.statusCode == 404 ||
          error.statusCode == 501) {
        return null;
      }
      rethrow;
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 404 || status == 501) return null;
      rethrow;
    }
  }
}

class MockDriverAccessRepository implements DriverAccessRepository {
  @override
  bool get usesMockData => true;

  static final List<DriverAccessProfile> _allItems = [
    DriverAccessProfile(
      id: 'd-101',
      displayName: 'Kovács Péter',
      companyName: 'NordTrans Kft.',
      companyId: '1',
      registrationStatus: DriverRegistrationStatus.active,
      lastActivityAt: DateTime.now().subtract(const Duration(hours: 2)),
      deviceLabel: 'Samsung Galaxy A54',
      activeSessionCount: 1,
      operationalHealth: const DriverOperationalHealthSummary(
        level: DriverOperationalHealthLevel.yellow,
        activeIssueCount: 1,
        labelKey: 'driverHealthWarning',
      ),
    ),
    DriverAccessProfile(
      id: 'd-102',
      displayName: 'Nagy Anna',
      companyName: 'EuroFleet Zrt.',
      companyId: '2',
      registrationStatus: DriverRegistrationStatus.invited,
      deviceLabel: '—',
      activeSessionCount: 0,
    ),
    DriverAccessProfile(
      id: 'd-103',
      displayName: 'Szabó István',
      companyName: 'NordTrans Kft.',
      companyId: '1',
      registrationStatus: DriverRegistrationStatus.disabled,
      lastActivityAt: DateTime.now().subtract(const Duration(days: 14)),
      deviceLabel: 'iPhone 13',
      activeSessionCount: 0,
    ),
    DriverAccessProfile(
      id: 'd-104',
      displayName: 'Tóth Eszter',
      companyName: 'EuroFleet Zrt.',
      companyId: '2',
      registrationStatus: DriverRegistrationStatus.pending,
      deviceLabel: '—',
      activeSessionCount: 0,
    ),
  ];

  @override
  Future<DriverAccessListResult> listDrivers({
    String? status,
    String? q,
    int limit = 50,
    int offset = 0,
  }) async {
    var items = List<DriverAccessProfile>.from(_allItems);

    final statusFilter = status?.trim().toLowerCase();
    if (statusFilter != null && statusFilter.isNotEmpty) {
      items = items
          .where((d) {
            if (statusFilter == 'operational') {
              return d.registrationStatus != DriverRegistrationStatus.disabled;
            }
            return d.registrationStatus ==
                DriverRegistrationStatus.fromBackend(statusFilter);
          })
          .toList(growable: false);
    }

    final term = q?.trim().toLowerCase() ?? '';
    if (term.isNotEmpty) {
      items = items
          .where((d) {
            final haystack = [
              d.displayName,
              d.companyName,
              d.id,
              d.companyId,
            ].join(' ').toLowerCase();
            return haystack.contains(term);
          })
          .toList(growable: false);
    }

    final total = items.length;
    final start = offset.clamp(0, total);
    final end = (start + limit).clamp(0, total);
    final page = items.sublist(start, end);

    return DriverAccessListResult(
      listEndpointReady: true,
      metadataOnly: true,
      items: page,
      total: total,
      statusCounts: DriverAccessStatusCounts(
        all: _allItems.length,
        operational: _allItems
            .where(
              (d) => d.registrationStatus != DriverRegistrationStatus.disabled,
            )
            .length,
        active: _allItems
            .where(
              (d) => d.registrationStatus == DriverRegistrationStatus.active,
            )
            .length,
        pending: _allItems
            .where(
              (d) => d.registrationStatus == DriverRegistrationStatus.pending,
            )
            .length,
        invited: _allItems
            .where(
              (d) => d.registrationStatus == DriverRegistrationStatus.invited,
            )
            .length,
        disabled: _allItems
            .where(
              (d) => d.registrationStatus == DriverRegistrationStatus.disabled,
            )
            .length,
      ),
    );
  }

  @override
  Future<DriverAccessProfile?> fetchDriver(String driverProfileId) async {
    for (final item in _allItems) {
      if (item.id == driverProfileId) return item;
    }
    return null;
  }

  @override
  Future<void> patchDriverStatus(
    String driverProfileId, {
    required String status,
    String? reason,
  }) async {}

  @override
  Future<Map<String, dynamic>> resendInvite(String driverProfileId) async {
    return {
      'driverProfileId': driverProfileId,
      'emailSent': false,
      'deliveryStatus': 'provider_disabled',
    };
  }

  @override
  Future<Map<String, dynamic>> sendPasswordSetup(String driverProfileId) async {
    return {
      'driverProfileId': driverProfileId,
      'mode': 'password_reset',
      'emailSent': false,
      'deliveryStatus': 'provider_disabled',
    };
  }

  @override
  Future<Map<String, dynamic>> softDelete({
    required String driverProfileId,
    required String reason,
  }) async {
    return {
      'driverProfileId': driverProfileId,
      'deleted': true,
      'reason': reason,
    };
  }

  @override
  Future<DriverDeviceNotificationStatus?> fetchDeviceNotificationStatus(
    String driverProfileId,
  ) async {
    return const DriverDeviceNotificationStatus(
      metadataOnly: true,
      sourceUnavailable: false,
      hasPushToken: true,
      tokenProvider: 'fcm',
      platform: 'android',
      appVersion: '2.0.1',
      tokenLast4: '7890',
      deliveryEnabled: false,
      notificationPermissionStatus: 'granted',
    );
  }

  @override
  Future<DriverOperationalHealthDetail?> fetchOperationalHealth(
    String driverProfileId,
  ) async {
    if (driverProfileId == 'd-101') {
      return DriverOperationalHealthDetail(
        overallLevel: DriverOperationalHealthLevel.yellow,
        activeIssueCount: 1,
        issues: [
          DriverOperationalHealthIssueView(
            id: '1',
            category: 'profile_sync',
            code: 'sync.profile.failed',
            severity: 'yellow',
            status: 'active',
            attemptCount: 1,
            lastAttemptedAt: DateTime.now().subtract(
              const Duration(minutes: 12),
            ),
            safeErrorCode: 'network',
            source: 'driver_app_sync',
          ),
        ],
      );
    }
    return null;
  }
}

final driverAccessRepositoryProvider = Provider<DriverAccessRepository>((ref) {
  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveDriverAccessRepository(ref.watch(apiClientProvider));
  }
  return MockDriverAccessRepository();
});

class DriverAccessListQuery {
  const DriverAccessListQuery({
    this.search = '',
    this.filter = DriverAccessListFilter.operational,
  });

  final String search;
  final DriverAccessListFilter filter;

  DriverAccessListQuery copyWith({
    String? search,
    DriverAccessListFilter? filter,
  }) {
    return DriverAccessListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }
}

final driverAccessListQueryProvider =
    NotifierProvider<DriverAccessListQueryNotifier, DriverAccessListQuery>(
      DriverAccessListQueryNotifier.new,
    );

class DriverAccessListQueryNotifier extends Notifier<DriverAccessListQuery> {
  @override
  DriverAccessListQuery build() => const DriverAccessListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(DriverAccessListFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

class DriverAccessListState {
  const DriverAccessListState({
    required this.items,
    required this.total,
    required this.listEndpointReady,
    required this.metadataOnly,
    this.statusCounts,
    this.loadingMore = false,
    this.loadMoreError,
  });

  final List<DriverAccessProfile> items;
  final int total;
  final bool listEndpointReady;
  final bool metadataOnly;
  final DriverAccessStatusCounts? statusCounts;
  final bool loadingMore;
  final Object? loadMoreError;

  bool get hasMore => items.length < total;

  DriverAccessListState copyWith({
    List<DriverAccessProfile>? items,
    int? total,
    bool? listEndpointReady,
    bool? metadataOnly,
    DriverAccessStatusCounts? statusCounts,
    bool? loadingMore,
    Object? loadMoreError = _driverListSentinel,
  }) {
    return DriverAccessListState(
      items: items ?? this.items,
      total: total ?? this.total,
      listEndpointReady: listEndpointReady ?? this.listEndpointReady,
      metadataOnly: metadataOnly ?? this.metadataOnly,
      statusCounts: statusCounts ?? this.statusCounts,
      loadingMore: loadingMore ?? this.loadingMore,
      loadMoreError: identical(loadMoreError, _driverListSentinel)
          ? this.loadMoreError
          : loadMoreError,
    );
  }
}

const Object _driverListSentinel = Object();

const int kDriverAccessPageSize = 50;

final driverAccessListProvider =
    AsyncNotifierProvider.autoDispose<
      DriverAccessListNotifier,
      DriverAccessListState
    >(DriverAccessListNotifier.new);

class DriverAccessListNotifier extends AsyncNotifier<DriverAccessListState> {
  @override
  Future<DriverAccessListState> build() {
    ref.watch(driverAccessListQueryProvider);
    return _loadFirstPage();
  }

  Future<DriverAccessListState> _loadFirstPage() async {
    final query = ref.read(driverAccessListQueryProvider);
    final search = query.search.trim();
    final page = await ref
        .read(driverAccessRepositoryProvider)
        .listDrivers(
          status: query.filter.statusForApi(),
          q: search.isEmpty ? null : search,
          limit: kDriverAccessPageSize,
          offset: 0,
        );
    return DriverAccessListState(
      items: page.items,
      total: page.total,
      listEndpointReady: page.listEndpointReady,
      metadataOnly: page.metadataOnly,
      statusCounts: page.statusCounts,
    );
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(_loadFirstPage);
  }

  Future<void> loadMore() async {
    final current = state.asData?.value;
    if (current == null ||
        current.loadingMore ||
        !current.hasMore ||
        !current.listEndpointReady) {
      return;
    }

    state = AsyncData(current.copyWith(loadingMore: true, loadMoreError: null));
    final queryAtStart = ref.read(driverAccessListQueryProvider);
    try {
      final search = queryAtStart.search.trim();
      final page = await ref
          .read(driverAccessRepositoryProvider)
          .listDrivers(
            status: queryAtStart.filter.statusForApi(),
            q: search.isEmpty ? null : search,
            limit: kDriverAccessPageSize,
            offset: current.items.length,
          );
      final queryNow = ref.read(driverAccessListQueryProvider);
      if (queryNow.search != queryAtStart.search ||
          queryNow.filter != queryAtStart.filter) {
        return;
      }
      final seen = {for (final item in current.items) item.id};
      final merged = [
        ...current.items,
        for (final item in page.items)
          if (!seen.contains(item.id)) item,
      ];
      state = AsyncData(
        DriverAccessListState(
          items: merged,
          total: page.total,
          listEndpointReady: page.listEndpointReady,
          metadataOnly: page.metadataOnly,
          statusCounts: page.statusCounts,
        ),
      );
    } catch (error) {
      final queryNow = ref.read(driverAccessListQueryProvider);
      if (queryNow.search != queryAtStart.search ||
          queryNow.filter != queryAtStart.filter) {
        return;
      }
      state = AsyncData(
        current.copyWith(loadingMore: false, loadMoreError: error),
      );
    }
  }
}

final driverAccessDetailProvider = FutureProvider.autoDispose
    .family<DriverAccessProfile?, String>((ref, driverId) async {
      final repo = ref.watch(driverAccessRepositoryProvider);

      // Prefer the list (already loaded when navigating from /drivers).
      try {
        final list = await ref.watch(driverAccessListProvider.future);
        for (final item in list.items) {
          if (item.id == driverId) return item;
        }
      } catch (_) {
        // List unavailable — try dedicated detail endpoint below.
      }

      return repo.fetchDriver(driverId);
    });

final driverDeviceNotificationStatusProvider = FutureProvider.autoDispose
    .family<DriverDeviceNotificationStatus?, String>((ref, driverId) {
      return ref
          .watch(driverAccessRepositoryProvider)
          .fetchDeviceNotificationStatus(driverId);
    });

final driverOperationalHealthProvider = FutureProvider.autoDispose
    .family<DriverOperationalHealthDetail?, String>((ref, driverId) {
      return ref
          .watch(driverAccessRepositoryProvider)
          .fetchOperationalHealth(driverId);
    });
