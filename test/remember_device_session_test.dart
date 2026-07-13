import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_api.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_repository.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_session.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/core/auth/auth_refresh_coordinator.dart';
import 'package:vianexis_admin_app/core/auth/auth_refresh_result.dart';
import 'package:vianexis_admin_app/core/auth/auth_token_bundle.dart';
import 'package:vianexis_admin_app/core/device/admin_device_identity_service.dart';
import 'package:vianexis_admin_app/features/settings/domain/admin_session_display.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('Remember device session foundation', () {
    late AuthTokenStorage tokenStorage;
    late AdminDeviceIdentityService deviceIdentity;
    late Dio dio;
    late ApiClient apiClient;
    late AdminAuthApi authApi;
    late AuthRefreshCoordinator refreshCoordinator;
    late AdminAuthRepository repository;

    const sessionId = '11111111-1111-4111-8111-111111111111';
    const initialRefresh = 'refresh-token-initial';
    const rotatedRefresh = 'refresh-token-rotated';

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
    });

    test('login sends rememberDevice and device metadata payload', () async {
      Map<String, dynamic>? capturedBody;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/login' && options.method == 'POST') {
              capturedBody = Map<String, dynamic>.from(
                options.data as Map<String, dynamic>,
              );
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: _tokenResponse(
                    sessionId: sessionId,
                    refreshToken: initialRefresh,
                  ),
                ),
              );
              return;
            }
            if (options.path == '/auth/me') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: _userJson(),
                ),
              );
              return;
            }
            handler.reject(_notFound(options));
          },
        ),
      );

      await repository.signIn(
        email: 'superadmin@vianexis-dev.local',
        password: 'secret',
        rememberDevice: true,
      );

      expect(capturedBody?['rememberDevice'], isTrue);
      expect(capturedBody?['appType'], 'platform_admin_app');
      expect(capturedBody?['deviceName'], 'ViaNexis Admin');
      expect(capturedBody?['platform'], isNotNull);
      expect(capturedBody?['deviceId'], isNotEmpty);
      expect(await tokenStorage.readRememberDevice(), isTrue);
    });

    test('login with rememberDevice false stores preference', () async {
      dio.interceptors.add(_loginAndMeInterceptor());
      await repository.signIn(
        email: 'superadmin@vianexis-dev.local',
        password: 'secret',
        rememberDevice: false,
      );
      expect(await tokenStorage.readRememberDevice(), isFalse);
    });

    test('deviceId remains stable across calls and logout', () async {
      dio.interceptors.add(_loginAndMeInterceptor());
      final first = await deviceIdentity.getOrCreateDeviceId();
      final second = await deviceIdentity.getOrCreateDeviceId();
      expect(first, second);

      await repository.signIn(
        email: 'superadmin@vianexis-dev.local',
        password: 'secret',
        rememberDevice: true,
      );
      await repository.signOut();

      final afterLogout = await deviceIdentity.getOrCreateDeviceId();
      expect(afterLogout, first);
      expect(await tokenStorage.readRefreshToken(), isNull);
      expect(await tokenStorage.readSessionId(), isNull);
    });

    test('refresh stores rotated refresh token and keeps sessionId', () async {
      await tokenStorage.writeSessionBundle(
        _bundle(sessionId: sessionId, refreshToken: initialRefresh),
        rememberDevice: true,
      );

      var refreshCalls = 0;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/refresh') {
              refreshCalls++;
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: _tokenResponse(
                    sessionId: sessionId,
                    refreshToken: rotatedRefresh,
                  ),
                ),
              );
              return;
            }
            handler.reject(_notFound(options));
          },
        ),
      );

      final result = await refreshCoordinator.refreshOnce();
      expect(result, AuthRefreshResult.success);
      expect(refreshCalls, 1);
      expect(await tokenStorage.readRefreshToken(), rotatedRefresh);
      expect(await tokenStorage.readSessionId(), sessionId);
    });

    test('cold start restore succeeds with rememberDevice session', () async {
      await tokenStorage.writeSessionBundle(
        _bundle(sessionId: sessionId, refreshToken: initialRefresh),
        rememberDevice: true,
      );
      await tokenStorage.writeCachedUser(_adminUser());

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/refresh') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: _tokenResponse(
                    sessionId: sessionId,
                    refreshToken: rotatedRefresh,
                  ),
                ),
              );
              return;
            }
            if (options.path == '/auth/me') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: _userJson(),
                ),
              );
              return;
            }
            handler.reject(_notFound(options));
          },
        ),
      );

      final restored = await repository.restoreSession();
      expect(restored.outcome.name, 'success');
      expect(restored.user?.email, 'superadmin@vianexis-dev.local');
      expect(await tokenStorage.readRefreshToken(), rotatedRefresh);
    });

    test('invalid refresh clears session secrets', () async {
      await tokenStorage.writeSessionBundle(
        _bundle(sessionId: sessionId, refreshToken: initialRefresh),
        rememberDevice: true,
      );

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/refresh') {
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.badResponse,
                  response: Response(
                    requestOptions: options,
                    statusCode: 401,
                    data: const {
                      'message': 'invalid',
                      'code': 'REFRESH_TOKEN_INVALID',
                    },
                  ),
                ),
              );
              return;
            }
            handler.reject(_notFound(options));
          },
        ),
      );

      final restored = await repository.restoreSession();
      expect(restored.outcome.name, 'authInvalid');
      expect(await tokenStorage.readRefreshToken(), isNull);
    });

    test('network refresh failure preserves stored session', () async {
      await tokenStorage.writeSessionBundle(
        _bundle(sessionId: sessionId, refreshToken: initialRefresh),
        rememberDevice: true,
      );
      await tokenStorage.writeCachedUser(_adminUser());

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/auth/refresh') {
              handler.reject(
                DioException(
                  requestOptions: options,
                  type: DioExceptionType.connectionError,
                ),
              );
              return;
            }
            handler.reject(_notFound(options));
          },
        ),
      );

      final restored = await repository.restoreSession();
      expect(restored.outcome.name, 'networkPending');
      expect(await tokenStorage.readRefreshToken(), initialRefresh);
      expect(await tokenStorage.readSessionId(), sessionId);
    });

    test('single-flight refresh shares one network call', () async {
      await tokenStorage.writeSessionBundle(
        _bundle(sessionId: sessionId, refreshToken: initialRefresh),
        rememberDevice: true,
      );

      var refreshCalls = 0;
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) async {
            if (options.path == '/auth/refresh') {
              refreshCalls++;
              await Future<void>.delayed(const Duration(milliseconds: 30));
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: _tokenResponse(
                    sessionId: sessionId,
                    refreshToken: rotatedRefresh,
                  ),
                ),
              );
              return;
            }
            handler.reject(_notFound(options));
          },
        ),
      );

      final results = await Future.wait([
        refreshCoordinator.refreshOnce(),
        refreshCoordinator.refreshOnce(),
        refreshCoordinator.refreshOnce(),
      ]);

      expect(refreshCalls, 1);
      expect(results, everyElement(AuthRefreshResult.success));
    });

    test('logout clears session secrets but keeps deviceId', () async {
      dio.interceptors.add(_loginLogoutAndMeInterceptor());
      final deviceId = await deviceIdentity.getOrCreateDeviceId();
      await repository.signIn(
        email: 'superadmin@vianexis-dev.local',
        password: 'secret',
        rememberDevice: true,
      );

      await repository.signOut();

      expect(await tokenStorage.readAccessToken(), isNull);
      expect(await tokenStorage.readRefreshToken(), isNull);
      expect(await tokenStorage.readSessionId(), isNull);
      expect(await tokenStorage.readCachedUser(), isNull);
      expect(await deviceIdentity.getOrCreateDeviceId(), deviceId);
    });

    testWidgets('legacy null platform/appType renders localized label', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: Builder(
            builder: (context) {
              final l10n = AppLocalizations.of(context);
              final label = resolveSessionDeviceLabel(
                l10n,
                deviceName: null,
                platform: null,
                appType: null,
              );
              expect(label, l10n.authLegacySession);
              return const SizedBox.shrink();
            },
          ),
        ),
      );
    });

    test('current session flag is preserved from API model', () {
      final current = AdminAuthSession.fromJson({
        'id': sessionId,
        'deviceName': 'Pixel',
        'platform': 'android',
        'appType': 'platform_admin_app',
        'rememberDevice': true,
        'createdAt': '2026-01-01T00:00:00.000Z',
        'lastUsedAt': '2026-01-02T00:00:00.000Z',
        'expiresAt': '2026-02-01T00:00:00.000Z',
        'isCurrent': true,
      });
      final other = AdminAuthSession.fromJson({
        'id': '22222222-2222-4222-8222-222222222222',
        'deviceName': 'iPad',
        'platform': 'ios',
        'appType': 'platform_admin_app',
        'rememberDevice': true,
        'createdAt': '2026-01-01T00:00:00.000Z',
        'lastUsedAt': '2026-01-02T00:00:00.000Z',
        'expiresAt': '2026-02-01T00:00:00.000Z',
        'isCurrent': false,
      });
      expect(current.isCurrent, isTrue);
      expect(other.isCurrent, isFalse);
    });

    test('revoke session calls DELETE /auth/sessions/:id', () async {
      String? deletedPath;
      await tokenStorage.writeAccessToken('access-token');
      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.method == 'DELETE' &&
                options.path.startsWith('/auth/sessions/')) {
              deletedPath = options.path;
              handler.resolve(
                Response<void>(requestOptions: options, statusCode: 200),
              );
              return;
            }
            handler.reject(_notFound(options));
          },
        ),
      );

      await repository.revokeSession(sessionId);
      expect(deletedPath, '/auth/sessions/$sessionId');
    });
  });
}

InterceptorsWrapper _loginAndMeInterceptor() {
  return InterceptorsWrapper(
    onRequest: (options, handler) {
      if (options.path == '/auth/login') {
        handler.resolve(
          Response<Map<String, dynamic>>(
            requestOptions: options,
            statusCode: 200,
            data: _tokenResponse(),
          ),
        );
        return;
      }
      if (options.path == '/auth/me') {
        handler.resolve(
          Response<Map<String, dynamic>>(
            requestOptions: options,
            statusCode: 200,
            data: _userJson(),
          ),
        );
        return;
      }
      handler.reject(_notFound(options));
    },
  );
}

InterceptorsWrapper _loginLogoutAndMeInterceptor() {
  return InterceptorsWrapper(
    onRequest: (options, handler) {
      if (options.path == '/auth/login' || options.path == '/auth/logout') {
        handler.resolve(
          Response<Map<String, dynamic>>(
            requestOptions: options,
            statusCode: 200,
            data: options.path == '/auth/login' ? _tokenResponse() : null,
          ),
        );
        return;
      }
      if (options.path == '/auth/me') {
        handler.resolve(
          Response<Map<String, dynamic>>(
            requestOptions: options,
            statusCode: 200,
            data: _userJson(),
          ),
        );
        return;
      }
      handler.reject(_notFound(options));
    },
  );
}

AuthTokenBundle _bundle({
  required String sessionId,
  required String refreshToken,
}) {
  return AuthTokenBundle.fromResponse(
    _tokenResponse(sessionId: sessionId, refreshToken: refreshToken),
  );
}

Map<String, dynamic> _tokenResponse({
  String sessionId = '11111111-1111-4111-8111-111111111111',
  String refreshToken = 'refresh-token-initial',
}) {
  return {
    'access_token': 'access-token-123',
    'refresh_token': refreshToken,
    'token_type': 'Bearer',
    'expires_in': 900,
    'refresh_expires_at': '2026-12-31T00:00:00.000Z',
    'session_id': sessionId,
  };
}

Map<String, dynamic> _userJson() => {
  'userId': 99,
  'email': 'superadmin@vianexis-dev.local',
  'role': 'super_admin',
  'name': 'Super Admin',
};

AdminUser _adminUser() => AdminUser.fromAuthJson(_userJson());

DioException _notFound(RequestOptions options) => DioException(
  requestOptions: options,
  type: DioExceptionType.badResponse,
  response: Response(requestOptions: options, statusCode: 404),
);
