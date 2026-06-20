import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/features/login/login_screen.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _UnauthenticatedAuthNotifier extends AdminAuthNotifier {
  @override
  AdminAuthState build() => const AdminAuthState.unauthenticated();
}

void main() {
  testWidgets('login screen contains ViaNexis Admin branding', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminAuthProvider.overrideWith(_UnauthenticatedAuthNotifier.new),
        ],
        child: MaterialApp(
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const LoginScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('ViaNexis Admin'), findsWidgets);
    expect(find.text('Sign in'), findsWidgets);
    expect(
      find.textContaining('Platform admin access only'),
      findsOneWidget,
    );
  });
}
