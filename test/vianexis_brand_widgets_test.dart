import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/widgets/vianexis_admin_background.dart';
import 'package:vianexis_admin_app/core/widgets/vianexis_logo_mark.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  testWidgets('branded background renders without error', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: VianexisAdminBackground(
          child: SizedBox.expand(),
        ),
      ),
    );

    expect(find.byType(VianexisAdminBackground), findsOneWidget);
    expect(find.byType(ColoredBox), findsWidgets);
  });

  testWidgets('logo fallback does not crash when asset missing', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Scaffold(
          body: Center(
            child: VianexisLogoMark(
              showTitle: false,
              markAssetPath: 'assets/branding/missing_mark.png',
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('VN'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
}
