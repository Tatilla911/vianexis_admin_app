import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/core/localization/localization_keys.dart';

void main() {
  group('mapDioException', () {
    test('maps timeout errors', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.connectionTimeout,
        ),
      );

      expect(exception.kind, ApiExceptionKind.timeout);
      expect(exception.messageKey, LocalizationKeys.authNetworkError);
    });

    test('maps network connection errors', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.connectionError,
          error: Exception('offline'),
        ),
      );

      expect(exception.kind, ApiExceptionKind.network);
      expect(exception.messageKey, LocalizationKeys.authNetworkError);
    });

    test('maps login 401 to invalid credentials', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 401,
          ),
        ),
      );

      expect(exception.kind, ApiExceptionKind.unauthorized);
      expect(exception.messageKey, LocalizationKeys.authInvalidCredentials);
    });

    test('maps login 401 with full URL path to invalid credentials', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(
            path: 'https://vianexis-staging-api.onrender.com/auth/login',
          ),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(
              path: 'https://vianexis-staging-api.onrender.com/auth/login',
            ),
            statusCode: 401,
          ),
        ),
      );

      expect(exception.kind, ApiExceptionKind.unauthorized);
      expect(exception.messageKey, LocalizationKeys.authInvalidCredentials);
    });

    test('maps login 400 to invalid credentials', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 400,
          ),
        ),
      );

      expect(exception.messageKey, LocalizationKeys.authInvalidCredentials);
    });

    test('maps password change invalid current code', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/me/password'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/auth/me/password'),
            statusCode: 401,
            data: const {'code': 'invalid_current_password'},
          ),
        ),
      );

      expect(exception.messageKey, LocalizationKeys.authPasswordChangeInvalidCurrent);
    });

    test('maps authenticated 401 to session expired', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/auth/me'),
            statusCode: 401,
          ),
        ),
      );

      expect(exception.kind, ApiExceptionKind.unauthorized);
      expect(exception.messageKey, LocalizationKeys.authSessionExpired);
    });

    test('maps 403 to forbidden role', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/me'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/auth/me'),
            statusCode: 403,
          ),
        ),
      );

      expect(exception.kind, ApiExceptionKind.forbidden);
      expect(exception.messageKey, LocalizationKeys.authForbiddenRole);
    });

    test('maps 404 to action unavailable', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/missing'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/missing'),
            statusCode: 404,
          ),
        ),
      );

      expect(exception.kind, ApiExceptionKind.notFound);
      expect(exception.messageKey, LocalizationKeys.errorActionUnavailable);
    });

    test('maps 409 to conflict', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/resource'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/resource'),
            statusCode: 409,
          ),
        ),
      );

      expect(exception.kind, ApiExceptionKind.conflict);
    });

    test('maps 500 to server error', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 500,
          ),
        ),
      );

      expect(exception.kind, ApiExceptionKind.server);
      expect(exception.messageKey, LocalizationKeys.authServerError);
    });
  });

  group('ApiClient', () {
    test('throws not configured when API_BASE_URL is empty', () async {
      final client = ApiClient(
        tokenStorage: AuthTokenStorage(),
        enableDebugLogging: false,
      );

      expect(client.isConfigured, isFalse);
      expect(
        () => client.post('/auth/login'),
        throwsA(
          isA<ApiException>().having(
            (error) => error.kind,
            'kind',
            ApiExceptionKind.notConfigured,
          ),
        ),
      );
    });
  });
}
