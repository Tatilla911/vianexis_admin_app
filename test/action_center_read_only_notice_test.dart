import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/features/action_center/presentation/action_center_screen.dart';
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
  testWidgets('shows read-only aggregate notice', (tester) async {
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
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const ActionCenterScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(
      find.textContaining('Server dismiss is not available'),
      findsOneWidget,
    );
  });
}
