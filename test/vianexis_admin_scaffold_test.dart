import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
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

Widget _localizedApp({required Widget home}) {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: home,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets(
    'scaffold without title renders child only when unauthenticated',
    (tester) async {
      await tester.pumpWidget(
        _localizedApp(
          home: const VianexisAdminScaffold(child: Text('child-only')),
        ),
      );

      expect(find.text('child-only'), findsOneWidget);
      expect(find.byType(AppBar), findsNothing);
      expect(find.byType(NavigationBar), findsNothing);
    },
  );

  testWidgets('scaffold with title renders AdminScreenAppBar', (tester) async {
    await tester.pumpWidget(
      _localizedApp(
        home: const VianexisAdminScaffold(
          title: 'Screen title',
          child: Text('screen-body'),
        ),
      ),
    );

    expect(find.text('Screen title'), findsOneWidget);
    expect(find.text('screen-body'), findsOneWidget);
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.byType(NavigationBar), findsNothing);
  });

  testWidgets('shell scaffold without title renders mobile navigation', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminAuthProvider.overrideWith(_AuthenticatedAdminAuthNotifier.new),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: const VianexisAdminScaffold(child: Text('shell-child')),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('shell-child'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    expect(find.byType(AppBar), findsNothing);
  });

  testWidgets('titled scaffold supports back navigation via GoRouter', (
    tester,
  ) async {
    final router = GoRouter(
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const VianexisAdminScaffold(
            title: 'List',
            child: Text('list-body'),
          ),
          routes: [
            GoRoute(
              path: 'detail',
              builder: (context, state) => const VianexisAdminScaffold(
                title: 'Detail',
                child: Text('detail-body'),
              ),
            ),
          ],
        ),
      ],
    );

    await tester.pumpWidget(
      ProviderScope(
        child: MaterialApp.router(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          routerConfig: router,
        ),
      ),
    );
    await tester.pumpAndSettle();

    router.push('/detail');
    await tester.pumpAndSettle();

    expect(find.text('Detail'), findsOneWidget);
    expect(find.text('detail-body'), findsOneWidget);

    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    expect(find.text('List'), findsOneWidget);
    expect(find.text('list-body'), findsOneWidget);
  });
}
