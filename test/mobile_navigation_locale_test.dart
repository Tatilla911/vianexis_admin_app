import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vianexis_admin_app/app/vianexis_admin_app.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';

class _AuthenticatedAdminAuthNotifier extends AdminAuthNotifier {
  _AuthenticatedAdminAuthNotifier(this.initialUser);

  final AdminUser initialUser;

  @override
  AdminAuthState build() {
    ref.watch(adminAuthRepositoryProvider);
    return AdminAuthState(user: initialUser);
  }
}

const _superAdmin = AdminUser(
  id: '1',
  email: 'admin@vianexis.hu',
  role: AdminRole.superAdmin,
);

Widget _authenticatedApp() {
  return ProviderScope(
    overrides: [
      adminAuthProvider.overrideWith(
        () => _AuthenticatedAdminAuthNotifier(_superAdmin),
      ),
    ],
    child: const VianexisAdminApp(),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('mobile nav shows at most five items for super_admin', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_authenticatedApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final navBar = find.byType(NavigationBar);
    expect(navBar, findsOneWidget);
    final bar = tester.widget<NavigationBar>(navBar);
    expect(bar.destinations.length, lessThanOrEqualTo(5));
    expect(find.text('Továbbiak'), findsOneWidget);
  });

  testWidgets('login screen renders Hungarian by default', (tester) async {
    await tester.pumpWidget(const ProviderScope(child: VianexisAdminApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Belépés'), findsWidgets);
    expect(find.text('Sign in'), findsNothing);
  });

  testWidgets('action center renders Hungarian labels by default', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(_authenticatedApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.byIcon(Icons.inbox_outlined));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Teendők'), findsWidgets);
    expect(find.text('Action center'), findsNothing);
  });

  testWidgets('English locale works when selected', (tester) async {
    SharedPreferences.setMockInitialValues({'admin_app_locale_code': 'en'});

    await tester.pumpWidget(const ProviderScope(child: VianexisAdminApp()));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 300));

    expect(find.text('Sign in'), findsWidgets);
  });
}
