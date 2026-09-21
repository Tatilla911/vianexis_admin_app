import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/localization/localization_keys.dart';
import 'package:vianexis_admin_app/features/login/login_screen.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _ConnectionFailureAuthNotifier extends AdminAuthNotifier {
  @override
  AdminAuthState build() {
    return const AdminAuthState(
      isRestoringSession: false,
      errorMessageKey: LocalizationKeys.authServerUnreachable,
      lastErrorKind: ApiExceptionKind.server,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AdminAuthState connection failures', () {
    test('treats network/timeout/server as connection failure', () {
      for (final kind in [
        ApiExceptionKind.network,
        ApiExceptionKind.timeout,
        ApiExceptionKind.server,
      ]) {
        final state = AdminAuthState(
          errorMessageKey: LocalizationKeys.authServerUnreachable,
          lastErrorKind: kind,
        );
        expect(state.isConnectionFailure, isTrue);
        expect(state.canRetrySignIn, isTrue);
      }
    });

    test('does not treat invalid credentials as connection failure', () {
      const state = AdminAuthState(
        errorMessageKey: LocalizationKeys.authInvalidCredentials,
        lastErrorKind: ApiExceptionKind.unauthorized,
      );
      expect(state.isConnectionFailure, isFalse);
      expect(state.canRetrySignIn, isFalse);
    });
  });

  group('LoginScreen outage UX', () {
    testWidgets('shows unreachable message and retry for server errors', (
      tester,
    ) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            adminAuthProvider.overrideWith(
              _ConnectionFailureAuthNotifier.new,
            ),
          ],
          child: MaterialApp(
            locale: const Locale('hu'),
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

      expect(
        find.text('Nem sikerült kapcsolódni a szerverhez.'),
        findsOneWidget,
      );
      expect(find.text('Újrapróbálás'), findsOneWidget);
    });

    testWidgets('EN localization for unreachable + retry', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            adminAuthProvider.overrideWith(
              _ConnectionFailureAuthNotifier.new,
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
            home: const LoginScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Could not connect to the server.'), findsOneWidget);
      expect(find.text('Retry'), findsOneWidget);
    });
  });
}
