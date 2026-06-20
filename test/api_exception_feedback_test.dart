import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/api_exception_feedback.dart';
import 'package:vianexis_admin_app/core/localization/localization_keys.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('apiExceptionMessage resolves localized forbidden text', (tester) async {
    late String message;

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            message = apiExceptionMessage(
              context,
              const ApiException(
                messageKey: LocalizationKeys.authForbiddenRole,
                kind: ApiExceptionKind.forbidden,
              ),
            );
            return const SizedBox.shrink();
          },
        ),
      ),
    );

    expect(
      message,
      'This account is not authorized for the platform admin app.',
    );
  });
}
