import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_config.dart';
import '../api/api_error_mapping.dart';
import '../api/api_exception.dart';
import '../api/auth_token_storage.dart';
import '../device/admin_device_identity_service.dart';
import 'auth_refresh_result.dart';
import 'auth_token_bundle.dart';

/// Single-flight refresh coordinator — concurrent 401s share one refresh call.
class AuthRefreshCoordinator {
  AuthRefreshCoordinator({
    required AuthTokenStorage tokenStorage,
    required AdminDeviceIdentityService deviceIdentity,
    Dio? dio,
  }) : _tokenStorage = tokenStorage,
       _deviceIdentity = deviceIdentity,
       _dio =
           dio ??
           Dio(
             BaseOptions(
               baseUrl: ApiConfig.baseUrl,
               connectTimeout: ApiConfig.connectTimeout,
               receiveTimeout: ApiConfig.receiveTimeout,
               headers: ApiConfig.jsonHeaders,
             ),
           );

  final AuthTokenStorage _tokenStorage;
  final AdminDeviceIdentityService _deviceIdentity;
  final Dio _dio;

  Future<AuthRefreshResult>? _inFlight;

  Future<AuthRefreshResult> refreshOnce() {
    final existing = _inFlight;
    if (existing != null) return existing;
    final future = _refresh().whenComplete(() => _inFlight = null);
    _inFlight = future;
    return future;
  }

  Future<AuthRefreshResult> _refresh() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      return AuthRefreshResult.authInvalid;
    }

    try {
      final sessionId = await _tokenStorage.readSessionId();
      final response = await _dio.post<Map<String, dynamic>>(
        '/auth/refresh',
        data: {
          'refresh_token': refreshToken,
          if (sessionId != null && sessionId.isNotEmpty) 'sessionId': sessionId,
          'platform': _deviceIdentity.resolvePlatform(),
          'deviceName': AdminDeviceIdentityService.deviceName,
        },
      );
      final data = response.data;
      if (data == null) {
        return AuthRefreshResult.transientFailure;
      }
      final bundle = AuthTokenBundle.fromResponse(data);
      final rememberDevice = await _tokenStorage.readRememberDevice();
      final previousSessionId = await _tokenStorage.readSessionId();
      await _tokenStorage.writeSessionBundle(
        bundle,
        rememberDevice: rememberDevice,
      );
      assert(
        previousSessionId == null || bundle.sessionId == previousSessionId,
        'session_id must remain stable across refresh rotation',
      );
      return AuthRefreshResult.success;
    } on DioException catch (error) {
      if (isTransportLevelDioException(error)) {
        return AuthRefreshResult.transientFailure;
      }
      final apiError = mapHttpStatusException(
        statusCode: error.response?.statusCode,
        path: '/auth/refresh',
        error: error,
      );
      if (_shouldPreserveSessionOnRefreshFailure(apiError)) {
        return AuthRefreshResult.transientFailure;
      }
      return AuthRefreshResult.authInvalid;
    } on ApiException catch (error) {
      if (_shouldPreserveSessionOnRefreshFailure(error)) {
        return AuthRefreshResult.transientFailure;
      }
      return AuthRefreshResult.authInvalid;
    } catch (_) {
      return AuthRefreshResult.transientFailure;
    }
  }

  static bool _shouldPreserveSessionOnRefreshFailure(ApiException error) {
    return error.kind == ApiExceptionKind.network ||
        error.kind == ApiExceptionKind.timeout ||
        error.kind == ApiExceptionKind.server ||
        error.kind == ApiExceptionKind.notFound;
  }
}

final authRefreshCoordinatorProvider = Provider<AuthRefreshCoordinator>((ref) {
  return AuthRefreshCoordinator(
    tokenStorage: ref.watch(authTokenStorageProvider),
    deviceIdentity: ref.watch(adminDeviceIdentityServiceProvider),
  );
});
