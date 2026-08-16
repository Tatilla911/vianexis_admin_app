import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_status.dart';
import 'package:vianexis_admin_app/features/companies/presentation/widgets/platform_company_card.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('long company names do not overflow at phone width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const company = PlatformCompany(
      id: '1',
      name:
          'Nemzetközi Szállítmányozási és Logisztikai Szolgáltató Korlátolt Felelősségű Társaság',
      country: 'HU',
      vatNumber: 'HU12345678-VERY-LONG-IDENTIFIER',
      status: PlatformCompanyStatus.active,
      createdAt: null,
      activeUsersCount: 12,
      driversCount: 4,
      vehiclesCount: 8,
      trailersCount: 3,
      openSupportTicketsCount: 1,
      activeSupportAccessGrantsCount: 0,
      pendingRegistrationApplicationsCount: 0,
      pendingBulkOnboardingJobsCount: 0,
    );

    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('hu'),
        home: const Scaffold(
          body: SizedBox(
            width: 320,
            child: PlatformCompanyCard(company: company),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.textContaining('Nemzetközi Szállítmányozási'), findsOneWidget);
  });
}
