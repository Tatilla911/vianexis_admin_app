import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_api.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_repository.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/core/auth/auth_refresh_coordinator.dart';
import 'package:vianexis_admin_app/core/auth/auth_token_bundle.dart';
import 'package:vianexis_admin_app/core/device/admin_device_identity_service.dart';
import 'package:vianexis_admin_app/core/localization/localization_keys.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('AdminAuthRepository', () {
    late AuthTokenStorage tokenStorage;
    late AdminDeviceIdentityService deviceIdentity;
    late Dio dio;
    late ApiClient apiClient;
    late AdminAuthApi authApi;
    late AuthRefreshCoordinator refreshCoordinator;
    late AdminAuthRepository repository;

    setUp(() {
      tokenStorage = AuthTokenStorage();
      deviceIdentity = AdminDeviceIdentityService();
      dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      refreshCoordinator = AuthRefreshCoordinator(
        tokenStorage: tokenStorage,
        deviceIdentity: deviceIdentity,
        dio: dio,
      );
      apiClient = ApiClient(
        tokenStorage: tokenStorage,
        refreshCoordinator: refreshCoordinator,
        dio: dio,
        enableDebugLogging: false,
      );
      authApi = AdminAuthApi(apiClient);
      repository = AdminAuthRepository(
        apiClient: apiClient,
        tokenStorage: tokenStorage,
        authApi: authApi,
        deviceIdentity: deviceIdentity,
        refreshCoordinator: refreshCoordinator,
      );

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/login' && options.method == 'POST') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'access_token': 'access-token-123',
                    'refresh_token': 'refresh-token-456',
                    'token_type': 'Bearer',
                    'expires_in': 900,
                    'refresh_expires_at': '2026-12-31T00:00:00.000Z',
                    'session_id': '11111111-1111-4111-8111-111111111111',
                  },
                ),
              );
              return;
            }

            if (options.path == '/auth/me' && options.method == 'GET') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'userId': 99,
                    'email': 'superadmin@vianexis-dev.local',
                    'role': 'super_admin',
                    'name': 'Super Admin',
                  },
                ),
              );
              return;
            }

            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(requestOptions: options, statusCode: 404),
              ),
            );
          },
        ),
      );
    });

    test('login stores tokens and returns platform admin user', () async {
      final user = await repository.signIn(
        email: 'superadmin@vianexis-dev.local',
        password: 'secret',
        rememberDevice: true,
      );

      expect(user.role, AdminRole.superAdmin);
      expect(await tokenStorage.readAccessToken(), 'access-token-123');
      expect(await tokenStorage.readRefreshToken(), 'refresh-token-456');
      expect(
        await tokenStorage.readSessionId(),
        '11111111-1111-4111-8111-111111111111',
      );
    });

    test('rejects non-platform role and clears stored tokens', () async {
      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/login') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'access_token': 'access-token-123',
                    'refresh_token': 'refresh-token-456',
                    'session_id': '11111111-1111-4111-8111-111111111111',
                    'user': {
                      'id': 1,
                      'email': 'driver@vianexis-dev.local',
                      'role': 'driver',
                    },
                  },
                ),
              );
              return;
            }
            handler.next(options);
          },
        ),
      );

      expect(
        () => repository.signIn(
          email: 'driver@vianexis-dev.local',
          password: 'secret',
          rememberDevice: false,
        ),
        throwsA(
          isA<ApiException>().having(
            (error) => error.messageKey,
            'messageKey',
            LocalizationKeys.authForbiddenRole,
          ),
        ),
      );

      expect(await tokenStorage.readAccessToken(), isNull);
      expect(await tokenStorage.readRefreshToken(), isNull);
    });

    test(
      'restoreSession returns unauthenticated when no remember session',
      () async {
        final restored = await repository.restoreSession();
        expect(restored.outcome.name, 'unauthenticated');
        expect(restored.user, isNull);
      },
    );

    test(
      'restoreSession returns user when rememberDevice refresh succeeds',
      () async {
        await tokenStorage.writeSessionBundle(
          AuthTokenBundle.fromResponse({
            'access_token': 'access-token-123',
            'refresh_token': 'refresh-token-456',
            'session_id': '11111111-1111-4111-8111-111111111111',
            'expires_in': 900,
            'refresh_expires_at': '2026-12-31T00:00:00.000Z',
          }),
          rememberDevice: true,
        );

        dio.interceptors.clear();
        dio.interceptors.add(
          InterceptorsWrapper(
            onRequest: (options, handler) {
              if (options.path == '/auth/refresh') {
                handler.resolve(
                  Response<Map<String, dynamic>>(
                    requestOptions: options,
                    statusCode: 200,
                    data: {
                      'access_token': 'access-token-new',
                      'refresh_token': 'refresh-token-new',
                      'session_id': '11111111-1111-4111-8111-111111111111',
                      'expires_in': 900,
                      'refresh_expires_at': '2026-12-31T00:00:00.000Z',
                    },
                  ),
                );
                return;
              }
              if (options.path == '/auth/me') {
                handler.resolve(
                  Response<Map<String, dynamic>>(
                    requestOptions: options,
                    statusCode: 200,
                    data: {
                      'userId': 99,
                      'email': 'superadmin@vianexis-dev.local',
                      'role': 'super_admin',
                      'name': 'Super Admin',
                    },
                  ),
                );
                return;
              }
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                  response: Response(
                    requestOptions: options,
                    statusCode: 404,
                  ),
                ),
              );
            },
          ),
        );

        final restored = await repository.restoreSession();
        expect(restored.user?.role, AdminRole.superAdmin);
      },
    );

    test('changePassword clears stored tokens after success', () async {
      await tokenStorage.writeSessionBundle(
        AuthTokenBundle.fromResponse({
          'access_token': 'access-token-123',
          'refresh_token': 'refresh-token-456',
          'session_id': '11111111-1111-4111-8111-111111111111',
        }),
        rememberDevice: true,
      );

      dio.interceptors.clear();
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/me/password' &&
                options.method == 'PATCH') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: const {'success': true},
                ),
              );
              return;
            }
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(requestOptions: options, statusCode: 404),
              ),
            );
          },
        ),
      );

      await repository.changePassword(
        currentPassword: 'CurrentPassword123!',
        newPassword: 'NewSecurePassword99!',
      );

      expect(await tokenStorage.readAccessToken(), isNull);
      expect(await tokenStorage.readRefreshToken(), isNull);
    });
  });
}
