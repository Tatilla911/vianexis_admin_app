import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/dashboard/widgets/dashboard_operational_overview.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  testWidgets('dashboard overview shows operational title not placeholder', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: DashboardOperationalOverview(
            pendingRegistrations: 2,
            supportOpenIssues: 1,
          ),
        ),
      ),
    );

    expect(find.text('Operational overview'), findsOneWidget);
    expect(
      find.text('Operational summaries and platform metrics will appear here.'),
      findsNothing,
    );
    expect(find.text('Pending registrations'), findsOneWidget);
  });
}
