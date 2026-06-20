import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/localization/localization_resolver.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  testWidgets('advisory-only notice string is localized', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return Text(resolveAiReviewKey(context, 'aiReviewAdvisoryNotice'));
          },
        ),
      ),
    );

    expect(
      find.textContaining('advisory only', findRichText: true),
      findsOneWidget,
    );
  });
}
