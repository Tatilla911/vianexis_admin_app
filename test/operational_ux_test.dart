import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/app/app_router.dart';
import 'package:vianexis_admin_app/app/vianexis_admin_app.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/api_config.dart';
import 'package:vianexis_admin_app/core/api/api_error_resolver.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_api.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_repository.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/core/localization/localization_keys.dart';
import 'package:vianexis_admin_app/core/widgets/backend_mode_banner.dart';
import 'package:vianexis_admin_app/core/widgets/mock_data_badge.dart';
import 'package:vianexis_admin_app/core/widgets/offline_banner.dart';
import 'package:vianexis_admin_app/features/registrations/data/registration_applications_repository.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_application.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_decision_request.dart';
import 'package:vianexis_admin_app/features/registrations/presentation/registration_applications_screen.dart';
import 'package:vianexis_admin_app/features/settings/admin_settings_screen.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _AuthenticatedAdminAuthNotifier extends AdminAuthNotifier {
  _AuthenticatedAdminAuthNotifier(this.initialUser);

  final AdminUser initialUser;

  @override
  AdminAuthState build() {
    ref.watch(adminAuthRepositoryProvider);
    return AdminAuthState(user: initialUser);
  }
}

class _MockRegistrationRepository implements RegistrationApplicationsRepository {
  @override
  bool get usesMockData => true;

  @override
  Future<List<RegistrationApplication>> fetchApplications() async => const [];

  @override
  Future<RegistrationApplication> fetchApplication(String id) {
    throw UnimplementedError();
  }

  @override
  Future<void> submitDecision({
    required String applicationId,
    required RegistrationDecisionRequest request,
  }) {
    throw UnimplementedError();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('mapDioException session handling', () {
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

      expect(exception.messageKey, LocalizationKeys.authInvalidCredentials);
    });

    test('maps authenticated 401 to session expired', () {
      final exception = mapDioException(
        DioException(
          requestOptions: RequestOptions(path: '/platform-admin/companies'),
          type: DioExceptionType.badResponse,
          response: Response(
            requestOptions: RequestOptions(path: '/platform-admin/companies'),
            statusCode: 401,
          ),
        ),
      );

      expect(exception.messageKey, LocalizationKeys.authSessionExpired);
      expect(exception.kind, ApiExceptionKind.unauthorized);
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

  group('AdminAuthRepository logout and session restore', () {
    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
    });

    test('restoreSession rethrows unauthorized as session expired', () async {
      final tokenStorage = AuthTokenStorage();
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      final apiClient = ApiClient(
        tokenStorage: tokenStorage,
        dio: dio,
        enableDebugLogging: false,
      );
      final repository = AdminAuthRepository(
        apiClient: apiClient,
        tokenStorage: tokenStorage,
        authApi: AdminAuthApi(apiClient),
      );

      await tokenStorage.writeTokens(
        accessToken: 'expired-token',
        refreshToken: 'refresh-token',
      );

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            handler.reject(
              DioException(
                requestOptions: options,
                type: DioExceptionType.badResponse,
                response: Response(
                  requestOptions: options,
                  statusCode: 401,
                ),
              ),
            );
          },
        ),
      );

      await expectLater(
        repository.restoreSession(),
        throwsA(
          isA<ApiException>().having(
            (error) => error.messageKey,
            'messageKey',
            LocalizationKeys.authSessionExpired,
          ),
        ),
      );
      expect(await tokenStorage.readAccessToken(), isNull);
    });

    test('signOut clears stored tokens', () async {
      final tokenStorage = AuthTokenStorage();
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      final apiClient = ApiClient(
        tokenStorage: tokenStorage,
        dio: dio,
        enableDebugLogging: false,
      );
      final repository = AdminAuthRepository(
        apiClient: apiClient,
        tokenStorage: tokenStorage,
        authApi: AdminAuthApi(apiClient),
      );

      await tokenStorage.writeTokens(
        accessToken: 'access-token-123',
        refreshToken: 'refresh-token-456',
      );

      await repository.signOut();

      expect(await tokenStorage.readAccessToken(), isNull);
      expect(await tokenStorage.readRefreshToken(), isNull);
    });
  });

  testWidgets('mock badge is shown when repository uses mock data', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registrationApplicationsRepositoryProvider.overrideWithValue(
            _MockRegistrationRepository(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const RegistrationApplicationsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(MockDataBadge), findsOneWidget);
    expect(find.text('Mock data'), findsOneWidget);
  });

  testWidgets('backend-not-configured banner is visible without API base URL', (tester) async {
    expect(ApiConfig.isConfigured, isFalse);

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: BackendModeBanner()),
      ),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('Live backend is not configured. Modules may use mock data.'),
      findsOneWidget,
    );
  });

  testWidgets('offline banner is visible when connectivity is offline', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: OfflineBanner(isOnline: false)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.wifi_off_outlined), findsOneWidget);
  });

  testWidgets('forbidden deep link shows permission denied screen', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminAuthProvider.overrideWith(
            () => _AuthenticatedAdminAuthNotifier(
              const AdminUser(
                id: '2',
                email: 'support@vianexis.hu',
                role: AdminRole.supportAdmin,
              ),
            ),
          ),
        ],
        child: const VianexisAdminApp(),
      ),
    );
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(VianexisAdminApp)),
    );
    container.read(appRouterProvider).go(AdminRoutes.registrations);
    await tester.pumpAndSettle();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Permission denied'), findsWidgets);
    expect(find.text('Back to dashboard'), findsOneWidget);
  });

  testWidgets('settings screen shows signed-in admin metadata', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminAuthProvider.overrideWith(
            () => _AuthenticatedAdminAuthNotifier(
              const AdminUser(
                id: '1',
                email: 'admin@vianexis.hu',
                role: AdminRole.superAdmin,
              ),
            ),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AdminSettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('admin@vianexis.hu'), findsOneWidget);
    expect(find.text('Super admin'), findsOneWidget);
    expect(find.text('Not configured'), findsOneWidget);
    expect(find.text('dev'), findsOneWidget);
  });

  testWidgets('resolveApiException maps forbidden to permission denied title', (tester) async {
    late ApiErrorPresentation presentation;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            presentation = resolveApiException(
              context,
              const ApiException(
                messageKey: LocalizationKeys.authForbiddenRole,
                kind: ApiExceptionKind.forbidden,
              ),
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(presentation.title, 'Permission denied');
    expect(presentation.showRetry, isFalse);
  });
}
