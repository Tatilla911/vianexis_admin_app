import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_row.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_row_status.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/presentation/widgets/bulk_onboarding_row_card.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  testWidgets('row status badge renders as chip', (tester) async {
    const row = BulkOnboardingRow(
      id: 'r-1',
      jobId: 'j-1',
      rowIndex: 1,
      type: 'driver',
      status: BulkOnboardingRowStatus.failed,
      email: 'driver@example.com',
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: const Scaffold(body: BulkOnboardingRowCard(row: row)),
      ),
    );

    expect(find.byKey(const ValueKey('row-status-r-1')), findsOneWidget);
    expect(find.text('Failed'), findsOneWidget);
  });
}
