import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/app/app_theme.dart';
import 'package:vianexis_admin_app/app/vianexis_brand.dart';
import 'package:vianexis_admin_app/core/widgets/vianexis_metric_tile.dart';
import 'package:vianexis_admin_app/features/dashboard/widgets/dashboard_operational_overview.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  testWidgets('light metric tile uses readable light tokens', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        home: const Scaffold(
          body: VianexisMetricTile(
            label: 'Pending registrations',
            value: '1',
            tone: VianexisMetricTone.info,
          ),
        ),
      ),
    );

    final label = tester.widget<Text>(find.text('Pending registrations'));
    expect(label.style?.color, VianexisBrand.textSecondaryLight);
    final value = tester.widget<Text>(find.text('1'));
    expect(value.style?.color, VianexisBrand.textPrimaryLight);
  });

  testWidgets('dark metric tile keeps dark secondary ink', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.dark(),
        home: const Scaffold(
          body: VianexisMetricTile(
            label: 'Pending registrations',
            value: '1',
          ),
        ),
      ),
    );
    final label = tester.widget<Text>(find.text('Pending registrations'));
    expect(label.style?.color, VianexisBrand.textSecondary);
  });

  testWidgets('dashboard light overview has no overflow', (tester) async {
    tester.view.physicalSize = const Size(360, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      MaterialApp(
        theme: AppTheme.light(),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(
          body: SingleChildScrollView(
            child: DashboardOperationalOverview(
              pendingRegistrations: 1,
              companiesNeedingAttention: 0,
              supportOpenIssues: 2,
            ),
          ),
        ),
      ),
    );
    expect(tester.takeException(), isNull);
    expect(find.text('Pending registrations'), findsOneWidget);
  });
}
