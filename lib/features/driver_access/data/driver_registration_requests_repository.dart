import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../domain/driver_registration_request.dart';
import 'driver_registration_requests_api.dart';

abstract class DriverRegistrationRequestsRepository {
  Future<DriverRegistrationRequestsPage> listPending();
  Future<DriverRegistrationRequestsPage> listRejected();
  Future<void> approve(String requestId, {int? companyId});
  Future<void> reject(String requestId, {required String reviewNotes});
  bool get usesMockData;
}

class LiveDriverRegistrationRequestsRepository
    implements DriverRegistrationRequestsRepository {
  LiveDriverRegistrationRequestsRepository(this._api);

  final DriverRegistrationRequestsApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<DriverRegistrationRequestsPage> listPending() async {
    try {
      return await _api.listPending();
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 404 || status == 501) {
        return const DriverRegistrationRequestsPage(
          items: [],
          total: 0,
          listEndpointReady: false,
        );
      }
      rethrow;
    }
  }

  @override
  Future<DriverRegistrationRequestsPage> listRejected() async {
    try {
      return await _api.listRejected();
    } on DioException catch (error) {
      final status = error.response?.statusCode;
      if (status == 404 || status == 501) {
        return const DriverRegistrationRequestsPage(
          items: [],
          total: 0,
          listEndpointReady: false,
        );
      }
      rethrow;
    }
  }

  @override
  Future<void> approve(String requestId, {int? companyId}) {
    return _api.approve(
      requestId: requestId,
      companyId: companyId,
      reviewNotes: 'Approved from admin app staging UAT',
    );
  }

  @override
  Future<void> reject(String requestId, {required String reviewNotes}) {
    return _api.reject(requestId: requestId, reviewNotes: reviewNotes);
  }
}

class MockDriverRegistrationRequestsRepository
    implements DriverRegistrationRequestsRepository {
  @override
  bool get usesMockData => true;

  @override
  Future<DriverRegistrationRequestsPage> listPending() async {
    return DriverRegistrationRequestsPage(
      listEndpointReady: true,
      total: 1,
      items: [
        DriverRegistrationRequestItem(
          id: 'mock-1',
          fullName: 'Mock Pending Driver',
          email: 'pending.driver@example.test',
          status: 'pending',
          createdAt: DateTime.now(),
        ),
      ],
    );
  }

  @override
  Future<DriverRegistrationRequestsPage> listRejected() async {
    return DriverRegistrationRequestsPage(
      listEndpointReady: true,
      total: 1,
      items: [
        DriverRegistrationRequestItem(
          id: 'mock-rejected-1',
          fullName: 'Mock Rejected Driver',
          email: 'rejected.driver@example.test',
          status: 'rejected',
          createdAt: DateTime.now().subtract(const Duration(days: 2)),
          updatedAt: DateTime.now().subtract(const Duration(days: 1)),
          reviewNotes: 'Incomplete documentation',
        ),
      ],
    );
  }

  @override
  Future<void> approve(String requestId, {int? companyId}) async {}

  @override
  Future<void> reject(String requestId, {required String reviewNotes}) async {}
}

final driverRegistrationRequestsRepositoryProvider =
    Provider<DriverRegistrationRequestsRepository>((ref) {
      if (AppConfig.instance.shouldUseLiveRepositories) {
        return LiveDriverRegistrationRequestsRepository(
          ref.watch(driverRegistrationRequestsApiProvider),
        );
      }
      return MockDriverRegistrationRequestsRepository();
    });

final driverRegistrationRequestsProvider =
    FutureProvider.autoDispose<DriverRegistrationRequestsPage>((ref) {
      return ref
          .watch(driverRegistrationRequestsRepositoryProvider)
          .listPending();
    });

final rejectedDriverRegistrationRequestsProvider =
    FutureProvider.autoDispose<DriverRegistrationRequestsPage>((ref) {
      return ref
          .watch(driverRegistrationRequestsRepositoryProvider)
          .listRejected();
    });
