import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_api.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_repository.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/core/localization/localization_keys.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('AdminAuthRepository', () {
    late AuthTokenStorage tokenStorage;
    late Dio dio;
    late ApiClient apiClient;
    late AdminAuthApi authApi;
    late AdminAuthRepository repository;

    setUp(() {
      tokenStorage = AuthTokenStorage();
      dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      apiClient = ApiClient(
        tokenStorage: tokenStorage,
        dio: dio,
        enableDebugLogging: false,
      );
      authApi = AdminAuthApi(apiClient);
      repository = AdminAuthRepository(
        apiClient: apiClient,
        tokenStorage: tokenStorage,
        authApi: authApi,
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
                response: Response(
                  requestOptions: options,
                  statusCode: 404,
                ),
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
      );

      expect(user.role, AdminRole.superAdmin);
      expect(await tokenStorage.readAccessToken(), 'access-token-123');
      expect(await tokenStorage.readRefreshToken(), 'refresh-token-456');
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

    test('restoreSession returns null when no token is stored', () async {
      final user = await repository.restoreSession();
      expect(user, isNull);
    });

    test('restoreSession returns user when token and profile are valid', () async {
      await tokenStorage.writeTokens(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
      );

      final user = await repository.restoreSession();
      expect(user?.role, AdminRole.superAdmin);
    });
  });
}
