import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/features/dashboard/admin_dashboard_screen.dart';
import 'package:vianexis_admin_app/features/public_intakes/data/public_intakes_repository.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _AuthenticatedAdminAuthNotifier extends AdminAuthNotifier {
  @override
  AdminAuthState build() {
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
  testWidgets('dashboard shows public intake quick action', (tester) async {
    tester.view.physicalSize = const Size(400, 800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminAuthProvider.overrideWith(_AuthenticatedAdminAuthNotifier.new),
          publicIntakesRepositoryProvider.overrideWithValue(
            MockPublicIntakesRepository(),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AdminDashboardScreen(),
        ),
      ),
    );

    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('Open public intakes'),
      500,
      scrollable: scrollable,
    );

    expect(find.text('Open public intakes'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 500));
  });
}
