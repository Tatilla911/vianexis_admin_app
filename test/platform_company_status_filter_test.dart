import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_status.dart';
import 'package:vianexis_admin_app/features/companies/presentation/platform_companies_providers.dart';
import 'package:vianexis_admin_app/features/companies/presentation/widgets/platform_company_card.dart';
import 'package:vianexis_admin_app/features/companies/presentation/widgets/platform_company_status_badge.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

PlatformCompany _company({
  required String id,
  required String name,
  required PlatformCompanyStatus status,
}) {
  return PlatformCompany(
    id: id,
    name: name,
    country: 'HU',
    vatNumber: 'HU12345678',
    status: status,
    createdAt: DateTime(2024, 1, 1),
    activeUsersCount: 2,
    driversCount: 1,
    vehiclesCount: 1,
    trailersCount: 0,
    openSupportTicketsCount: 0,
    activeSupportAccessGrantsCount: 0,
    pendingRegistrationApplicationsCount: 0,
    pendingBulkOnboardingJobsCount: 0,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final active = _company(
    id: '1',
    name: 'Active Co',
    status: PlatformCompanyStatus.active,
  );
  final archived = _company(
    id: '2',
    name: 'Archived Co',
    status: PlatformCompanyStatus.archived,
  );
  final items = [active, archived];

  test('archived filter matches archived companies', () {
    final filtered = filteredPlatformCompanies(
      items: items,
      query: const PlatformCompanyListQuery(
        filter: PlatformCompanyListFilter.archived,
      ),
    );
    expect(filtered, [archived]);
  });

  test('active filter excludes archived companies', () {
    final filtered = filteredPlatformCompanies(
      items: items,
      query: const PlatformCompanyListQuery(
        filter: PlatformCompanyListFilter.active,
      ),
    );
    expect(filtered, [active]);
    expect(
      filtered.any((c) => c.status == PlatformCompanyStatus.archived),
      isFalse,
    );
  });

  testWidgets('archived status badge shows Archived label', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: const Scaffold(
          body: PlatformCompanyStatusBadge(
            status: PlatformCompanyStatus.archived,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(PlatformCompanyStatusBadge), findsOneWidget);
    expect(find.text('Archived'), findsOneWidget);
  });

  testWidgets('company card still renders archived company name', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
        home: Scaffold(body: PlatformCompanyCard(company: archived)),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Archived Co'), findsOneWidget);
  });
}
