import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/applications/data/public_applications_api.dart';
import 'package:vianexis_admin_app/features/applications/presentation/applications_inbox_screen.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _FakePublicApplicationsApi extends PublicApplicationsApi {
  _FakePublicApplicationsApi()
    : super(
        ApiClient(tokenStorage: AuthTokenStorage(), enableDebugLogging: false),
      );

  @override
  Future<Map<String, dynamic>> listApplications({
    String? type,
    String? status,
    int limit = 100,
    int offset = 0,
  }) async {
    return {
      'items': [
        {
          'id': 42,
          'displayName': 'Acme Logistics',
          'applicationType': 'company',
          'status': 'new',
          'email': 'ops@acme.example',
        },
      ],
      'total': 1,
    };
  }

  @override
  Future<Map<String, dynamic>> getApplication(int id) async {
    return {
      'application': {
        'applicationType': 'company',
        'status': 'new',
        'email': 'ops@acme.example',
      },
    };
  }
}

Widget _buildApp({required Widget home, GoRouter? router}) {
  return ProviderScope(
    overrides: [
      publicApplicationsApiProvider.overrideWithValue(
        _FakePublicApplicationsApi(),
      ),
    ],
    child: router != null
        ? MaterialApp.router(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            routerConfig: router,
          )
        : MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            locale: const Locale('en'),
            home: home,
          ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('ApplicationsInboxScreen loads with localized title', (
    tester,
  ) async {
    await tester.pumpWidget(_buildApp(home: const ApplicationsInboxScreen()));
    await tester.pumpAndSettle();

    expect(find.text('Applications'), findsOneWidget);
    expect(find.text('Acme Logistics'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('ApplicationDetailScreen loads with localized title', (
    tester,
  ) async {
    await tester.pumpWidget(
      _buildApp(home: const ApplicationDetailScreen(id: '42')),
    );
    await tester.pumpAndSettle();

    expect(find.text('Application #42'), findsOneWidget);
    expect(find.text('company · new'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
  });

  testWidgets('application detail back navigation returns to inbox', (
    tester,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const ApplicationsInboxScreen(),
          routes: [
            GoRoute(
              path: ':id',
              builder: (context, state) =>
                  ApplicationDetailScreen(id: state.pathParameters['id'] ?? ''),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(_buildApp(home: const SizedBox(), router: router));
    await tester.pumpAndSettle();

    expect(find.text('Applications'), findsOneWidget);

    router.push('/42');
    await tester.pumpAndSettle();

    expect(find.text('Application #42'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('Applications'), findsOneWidget);
    expect(find.text('Acme Logistics'), findsOneWidget);
  });
}
