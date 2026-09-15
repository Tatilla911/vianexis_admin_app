import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/app/vianexis_brand.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/localization/localization_keys.dart';
import 'package:vianexis_admin_app/features/login/login_screen.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _UnauthenticatedAuthNotifier extends AdminAuthNotifier {
  @override
  AdminAuthState build() => const AdminAuthState.unauthenticated();
}

class _OfflineErrorAuthNotifier extends AdminAuthNotifier {
  @override
  AdminAuthState build() => const AdminAuthState(
        errorMessageKey: LocalizationKeys.authNetworkError,
      );

  @override
  Future<void> signIn({
    required String email,
    required String password,
    bool rememberDevice = true,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    await Future<void>.delayed(const Duration(milliseconds: 20));
    state = state.copyWith(
      isLoading: false,
      errorMessageKey: LocalizationKeys.authNetworkError,
    );
  }
}

Finder _signInButton() => find.widgetWithText(FilledButton, 'Sign in');

Future<void> _pumpLogin(
  WidgetTester tester, {
  AdminAuthNotifier Function()? authFactory,
  Size viewport = const Size(360, 740),
  double textScale = 1.0,
  ThemeMode themeMode = ThemeMode.light,
}) async {
  tester.view.physicalSize = viewport;
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        adminAuthProvider.overrideWith(
          authFactory ?? _UnauthenticatedAuthNotifier.new,
        ),
      ],
      child: MediaQuery(
        data: MediaQueryData(
          size: viewport,
          textScaler: TextScaler.linear(textScale),
        ),
        child: MaterialApp(
          themeMode: themeMode,
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
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
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  testWidgets('A empty credentials keep Sign in disabled', (tester) async {
    await _pumpLogin(tester);
    final button = tester.widget<FilledButton>(_signInButton());
    expect(button.onPressed, isNull);
  });

  testWidgets('B email+password enable Sign in', (tester) async {
    await _pumpLogin(tester);
    await tester.enterText(
      find.byType(TextFormField).at(0),
      'admin@vianexis.eu',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'Secret123!');
    await tester.pump();
    final button = tester.widget<FilledButton>(_signInButton());
    expect(button.onPressed, isNotNull);
  });

  testWidgets('C/D API offline error does not permanently disable button', (
    tester,
  ) async {
    await _pumpLogin(tester, authFactory: _OfflineErrorAuthNotifier.new);
    expect(
      find.textContaining('Network error. Check your internet connection'),
      findsOneWidget,
    );

    await tester.enterText(
      find.byType(TextFormField).at(0),
      'admin@vianexis.eu',
    );
    await tester.enterText(find.byType(TextFormField).at(1), 'Secret123!');
    await tester.pump();
    expect(tester.widget<FilledButton>(_signInButton()).onPressed, isNotNull);

    await tester.ensureVisible(_signInButton());
    await tester.tap(_signInButton());
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(_signInButton()).onPressed, isNotNull);
    expect(
      find.textContaining('Network error. Check your internet connection'),
      findsOneWidget,
    );
  });

  testWidgets('login contrast: primary / secondary / security / remember', (
    tester,
  ) async {
    await _pumpLogin(tester, themeMode: ThemeMode.light);
    expect(find.text('Sign in'), findsWidgets);
    expect(find.textContaining('Secure admin session'), findsOneWidget);
    expect(find.textContaining('Remember me on this device'), findsOneWidget);
    expect(find.textContaining('Platform admin access only'), findsOneWidget);

    final remember = tester.widget<Text>(
      find.textContaining('Remember me on this device'),
    );
    expect(remember.style?.color, VianexisBrand.textPrimary);

    final secure = tester.widget<Text>(
      find.textContaining('Secure admin session'),
    );
    expect(secure.style?.color, VianexisBrand.goldAccent);
  });

  testWidgets('small phone + large textScale no overflow', (tester) async {
    await _pumpLogin(
      tester,
      viewport: const Size(320, 640),
      textScale: 1.3,
    );
    expect(tester.takeException(), isNull);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
    expect(_signInButton(), findsOneWidget);
  });
}
