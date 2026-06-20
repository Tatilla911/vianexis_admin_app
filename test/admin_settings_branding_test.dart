import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/core/widgets/permission_denied_screen.dart';
import 'package:vianexis_admin_app/features/settings/admin_settings_screen.dart';
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
  testWidgets('permission denied screen uses localized message', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const PermissionDeniedScreen(),
      ),
    );

    expect(find.text('Permission denied'), findsOneWidget);
    expect(
      find.text('Your account does not have access to this module.'),
      findsOneWidget,
    );
  });

  testWidgets('settings screen shows admin metadata with branded card', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminAuthProvider.overrideWith(_AuthenticatedAdminAuthNotifier.new),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const AdminSettingsScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('admin@vianexis.hu'), findsOneWidget);
    expect(find.text('Operational Control Center'), findsOneWidget);
    expect(find.text('Signed-in account'), findsOneWidget);
  });
}
