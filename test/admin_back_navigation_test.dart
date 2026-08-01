import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vianexis_admin_app/app/app_router.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/core/navigation/admin_back_navigation.dart';
import 'package:vianexis_admin_app/core/widgets/vianexis_admin_scaffold.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _AuthenticatedAdminAuthNotifier extends AdminAuthNotifier {
  @override
  AdminAuthState build() {
    ref.watch(adminAuthRepositoryProvider);
    return const AdminAuthState(
      user: AdminUser(
        id: '1',
        email: 'admin@vianexis.hu',
        role: AdminRole.superAdmin,
      ),
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test('parentAdminLocation strips nested segments', () {
    expect(parentAdminLocation('/registrations/42'), '/registrations');
    expect(
      parentAdminLocation('/customer-communications/t1/evidence-packages/p1'),
      '/customer-communications/t1/evidence-packages',
    );
    expect(parentAdminLocation('/dashboard'), isNull);
  });

  test('isAdminExitLocation covers dashboard and auth roots', () {
    expect(isAdminExitLocation('/dashboard'), isTrue);
    expect(isAdminExitLocation('/login'), isTrue);
    expect(isAdminExitLocation('/registrations'), isFalse);
  });

  testWidgets('system back from shell module returns to dashboard', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    final router = GoRouter(
      initialLocation: AdminRoutes.registrations,
      routes: [
        ShellRoute(
          builder: (context, state, child) =>
              VianexisAdminScaffold(child: child),
          routes: [
            GoRoute(
              path: AdminRoutes.dashboard,
              builder: (context, state) => const Text('dashboard-body'),
            ),
            GoRoute(
              path: AdminRoutes.registrations,
              builder: (context, state) => const Text('registrations-body'),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminAuthProvider.overrideWith(_AuthenticatedAdminAuthNotifier.new),
        ],
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('registrations-body'), findsOneWidget);

    final handled = handleAdminBack(
      tester.element(find.text('registrations-body')),
    );
    expect(handled, isTrue);
    await tester.pumpAndSettle();

    expect(find.text('dashboard-body'), findsOneWidget);
    expect(router.state.uri.path, AdminRoutes.dashboard);
  });
}
