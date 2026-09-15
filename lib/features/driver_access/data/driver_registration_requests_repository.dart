import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/driver_registration_request.dart';
import 'driver_registration_requests_api.dart';

abstract class DriverRegistrationRequestsRepository {
  Future<DriverRegistrationRequestsPage> listPending();
  Future<DriverRegistrationRequestsPage> listRejected();
  Future<DriverRegistrationDecisionResult> approve(
    String requestId, {
    int? companyId,
    String? reviewNotes,
  });
  Future<DriverRegistrationDecisionResult> reject(
    String requestId, {
    required String reviewNotes,
  });
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
  Future<DriverRegistrationDecisionResult> approve(
    String requestId, {
    int? companyId,
    String? reviewNotes,
  }) {
    return _api.approve(
      requestId: requestId,
      companyId: companyId,
      reviewNotes: reviewNotes?.trim().isNotEmpty == true
          ? reviewNotes!.trim()
          : null,
    );
  }

  @override
  Future<DriverRegistrationDecisionResult> reject(
    String requestId, {
    required String reviewNotes,
  }) {
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
          notificationEmailStatus: 'sent',
        ),
      ],
    );
  }

  @override
  Future<DriverRegistrationDecisionResult> approve(
    String requestId, {
    int? companyId,
    String? reviewNotes,
  }) async {
    if (AppConfig.instance.environment.isStaging ||
        AppConfig.instance.environment.isProduction ||
        !kDebugMode) {
      throw const ApiException(
        messageKey: LocalizationKeys.authBackendNotConfigured,
        kind: ApiExceptionKind.notConfigured,
        errorCode: 'MOCK_DRIVER_APPROVE_FORBIDDEN',
        backendMessage:
            'Mock driver registration repository cannot approve drivers.',
      );
    }
    return const DriverRegistrationDecisionResult(
      notificationEmailStatus: 'sent',
    );
  }

  @override
  Future<DriverRegistrationDecisionResult> reject(
    String requestId, {
    required String reviewNotes,
  }) async {
    if (AppConfig.instance.environment.isStaging ||
        AppConfig.instance.environment.isProduction ||
        !kDebugMode) {
      throw const ApiException(
        messageKey: LocalizationKeys.authBackendNotConfigured,
        kind: ApiExceptionKind.notConfigured,
        errorCode: 'MOCK_DRIVER_APPROVE_FORBIDDEN',
        backendMessage:
            'Mock driver registration repository cannot reject drivers.',
      );
    }
    return const DriverRegistrationDecisionResult(
      notificationEmailStatus: 'sent',
    );
  }
}

final driverRegistrationRequestsRepositoryProvider =
    Provider<DriverRegistrationRequestsRepository>((ref) {
      final config = AppConfig.instance;
      // Staging/production must never silently mock-approve drivers.
      final forceLive =
          config.environment.isStaging ||
          config.environment.isProduction ||
          config.shouldUseLiveRepositories;
      if (forceLive) {
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
