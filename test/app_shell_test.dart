import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vianexis_admin_app/app/app_router.dart';
import 'package:vianexis_admin_app/app/vianexis_admin_app.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _UnauthenticatedAuthNotifier extends AdminAuthNotifier {
  @override
  AdminAuthState build() => const AdminAuthState.unauthenticated();
}

class _AuthenticatedAdminAuthNotifier extends AdminAuthNotifier {
  _AuthenticatedAdminAuthNotifier(this.initialUser);

  final AdminUser initialUser;

  @override
  AdminAuthState build() {
    ref.watch(adminAuthRepositoryProvider);
    return AdminAuthState(user: initialUser);
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdminRole capabilities', () {
    test('super_admin can access all destinations', () {
      for (final destination in AdminDestination.values) {
        expect(AdminRole.superAdmin.canAccess(destination), isTrue);
      }
    });

    test('support_admin has support-focused access', () {
      expect(AdminRole.supportAdmin.canAccess(AdminDestination.supportTickets), isTrue);
      expect(AdminRole.supportAdmin.canAccess(AdminDestination.registrations), isFalse);
    });

    test('onboarding_reviewer can access registrations', () {
      expect(
        AdminRole.onboardingReviewer.canAccess(AdminDestination.registrations),
        isTrue,
      );
      expect(
        AdminRole.onboardingReviewer.canAccess(AdminDestination.supportTickets),
        isFalse,
      );
    });

    test('billing_admin can access registrations and settings', () {
      expect(AdminRole.billingAdmin.canAccess(AdminDestination.registrations), isTrue);
      expect(AdminRole.billingAdmin.canAccess(AdminDestination.auditLogs), isFalse);
    });
  });

  testWidgets('shows login screen when unauthenticated', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminAuthProvider.overrideWith(_UnauthenticatedAuthNotifier.new),
        ],
        child: const VianexisAdminApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Platform sign in'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('router redirects unauthenticated user away from dashboard', (tester) async {
    final router = GoRouter(
      initialLocation: AdminRoutes.dashboard,
      redirect: (context, state) {
        return AdminRoutes.login;
      },
      routes: [
        GoRoute(
          path: AdminRoutes.login,
          builder: (context, state) => const Scaffold(body: Text('login-route')),
        ),
        GoRoute(
          path: AdminRoutes.dashboard,
          builder: (context, state) => const Scaffold(body: Text('dashboard-route')),
        ),
      ],
    );

    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: router,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('login-route'), findsOneWidget);
    expect(find.text('dashboard-route'), findsNothing);
  });

  testWidgets('authenticated super_admin sees dashboard navigation', (tester) async {
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
                id: '1',
                email: 'admin@vianexis.hu',
                role: AdminRole.superAdmin,
              ),
            ),
          ),
        ],
        child: const VianexisAdminApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Platform dashboard'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
  });

  testWidgets('tablet layout uses navigation rail', (tester) async {
    tester.view.physicalSize = const Size(1280, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

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
        child: const VianexisAdminApp(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(NavigationRail), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('localizations resolve for English', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Text(AppLocalizations.of(context).appTitle);
          },
        ),
      ),
    );

    expect(find.text('ViaNexis Admin'), findsOneWidget);
  });
}
