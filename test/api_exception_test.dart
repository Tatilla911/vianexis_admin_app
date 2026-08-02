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

      expect(
        exception.messageKey,
        LocalizationKeys.authPasswordChangeInvalidCurrent,
      );
    });

    test('prefers errorCode over code when reading API errors', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/platform-admin/companies/1'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(
              path: '/platform-admin/companies/1',
            ),
            statusCode: 409,
            data: const {
              'errorCode': 'COMPANY_DATA_VERSION_CONFLICT',
              'code': 'ignored_legacy_code',
              'message': 'Version conflict',
              'messageKey': 'company.conflict',
              'requestId': 'req-abc-123',
            },
          ),
        ),
      );

      expect(exception.kind, ApiExceptionKind.conflict);
      expect(exception.errorCode, 'COMPANY_DATA_VERSION_CONFLICT');
      expect(exception.requestId, 'req-abc-123');
      expect(exception.backendMessage, 'Version conflict');
      expect(exception.messageKeyFromApi, 'company.conflict');
      expect(exception.endpoint, '/platform-admin/companies/1');
      expect(exception.statusCode, 409);
    });

    test('falls back to code when errorCode is absent', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/me/password'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/auth/me/password'),
            statusCode: 401,
            data: const {'code': 'weak_password'},
          ),
        ),
      );

      expect(exception.errorCode, 'weak_password');
      expect(
        exception.messageKey,
        LocalizationKeys.authPasswordChangeWeakPassword,
      );
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

    test('maps 404 on login path to auth service unavailable', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/auth/login'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/auth/login'),
            statusCode: 404,
          ),
        ),
      );

      expect(exception.kind, ApiExceptionKind.notFound);
      expect(
        exception.messageKey,
        LocalizationKeys.authLoginServiceUnavailable,
      );
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

    test('maps APPLICATION_DETAILED_INTAKE_REQUIRED error code', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(
            path: '/platform-admin/applications/4/approve',
          ),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(
              path: '/platform-admin/applications/4/approve',
            ),
            statusCode: 409,
            data: const {
              'errorCode': 'APPLICATION_DETAILED_INTAKE_REQUIRED',
              'code': 'APPLICATION_DETAILED_INTAKE_REQUIRED',
              'requestId': 'req-intake',
            },
          ),
        ),
      );

      expect(
        exception.messageKey,
        LocalizationKeys.applicationDetailedIntakeRequired,
      );
      expect(exception.errorCode, 'APPLICATION_DETAILED_INTAKE_REQUIRED');
    });

    test('maps amendment 400/403/404/409/500 to specific keys', () {
      ApiException mapStatus(int status) {
        return mapDioException(
          DioException(
            requestOptions: RequestOptions(
              path: '/platform-admin/companies/9/amendments',
            ),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(
                path: '/platform-admin/companies/9/amendments',
              ),
              statusCode: status,
              data: const {
                'requestId': 'req-amend-1',
                'message': 'failed',
              },
            ),
          ),
        );
      }

      expect(
        mapStatus(400).messageKey,
        LocalizationKeys.platformCompanyAmendErrorValidation,
      );
      expect(
        mapStatus(403).messageKey,
        LocalizationKeys.platformCompanyAmendErrorForbidden,
      );
      expect(
        mapStatus(404).messageKey,
        LocalizationKeys.platformCompanyAmendErrorNotFound,
      );
      expect(
        mapStatus(409).messageKey,
        LocalizationKeys.platformCompanyAmendErrorConflict,
      );
      expect(
        mapStatus(500).messageKey,
        LocalizationKeys.platformCompanyAmendErrorServer,
      );
    });

    test('maps missing amendment relation 500 to migration key', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(
            path: '/platform-admin/companies/1/amendments',
          ),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(
              path: '/platform-admin/companies/1/amendments',
            ),
            statusCode: 500,
            data: const {
              'message':
                  'relation "company_data_amendments" does not exist',
              'requestId': 'req-mig',
            },
          ),
        ),
      );

      expect(
        exception.messageKey,
        LocalizationKeys.platformCompanyAmendErrorMigrationMissing,
      );
    });

    test('maps driver approval already_registered 409 specifically', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(
            path: '/platform-admin/driver-registration-requests/12/approve',
          ),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(
              path: '/platform-admin/driver-registration-requests/12/approve',
            ),
            statusCode: 409,
            data: const {
              'code': 'already_registered',
              'errorCode': 'already_registered',
              'message': 'An account already exists with this email.',
              'requestId': 'req-drv-1',
            },
          ),
        ),
      );

      expect(exception.kind, ApiExceptionKind.conflict);
      expect(
        exception.messageKey,
        LocalizationKeys.driverApprovalAlreadyRegistered,
      );
      expect(exception.requestId, 'req-drv-1');
    });

    test('maps driver approval HTTP statuses to specific keys', () {
      ApiException mapStatus(int status) {
        return mapDioException(
          DioException(
            requestOptions: RequestOptions(
              path: '/platform-admin/driver-registration-requests/3/approve',
            ),
            type: DioExceptionType.badResponse,
            response: Response(
              requestOptions: RequestOptions(
                path: '/platform-admin/driver-registration-requests/3/approve',
              ),
              statusCode: status,
              data: const {'requestId': 'req-drv-status'},
            ),
          ),
        );
      }

      expect(
        mapStatus(400).messageKey,
        LocalizationKeys.driverApprovalInvalidRequest,
      );
      expect(
        mapStatus(403).messageKey,
        LocalizationKeys.driverApprovalForbidden,
      );
      expect(
        mapStatus(404).messageKey,
        LocalizationKeys.driverApprovalNotFound,
      );
      expect(
        mapStatus(409).messageKey,
        LocalizationKeys.driverApprovalConflict,
      );
      expect(
        mapStatus(422).messageKey,
        LocalizationKeys.driverApprovalMissingFields,
      );
      expect(
        mapStatus(500).messageKey,
        LocalizationKeys.driverApprovalServerError,
      );
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
