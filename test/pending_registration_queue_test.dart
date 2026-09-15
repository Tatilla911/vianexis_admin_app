import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:vianexis_admin_app/app/app_router.dart';
import 'package:vianexis_admin_app/features/dashboard/widgets/dashboard_operational_overview.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_application.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_application_status.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_risk_level.dart';
import 'package:vianexis_admin_app/features/registrations/presentation/registration_providers.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

RegistrationApplication _app({
  required String id,
  required RegistrationApplicationStatus status,
}) {
  return RegistrationApplication(
    id: id,
    type: RegistrationApplicationType.company,
    companyName: 'Co $id',
    contactEmail: 'a$id@example.com',
    status: status,
    submittedAt: DateTime.utc(2026, 1, 1),
    riskLevel: RegistrationRiskLevel.unknown,
  );
}

int _dashboardPendingCount(List<RegistrationApplication> items) {
  return items
      .where((item) => item.status.isPending || item.status.isNeedsInfo)
      .length;
}

void main() {
  group('pending registration canonical queue', () {
    test('dashboard pending count matches pending + needsMoreInfo items', () {
      final items = [
        _app(id: '1', status: RegistrationApplicationStatus.pending),
        _app(id: '2', status: RegistrationApplicationStatus.approved),
        _app(id: '3', status: RegistrationApplicationStatus.needsMoreInfo),
      ];
      expect(_dashboardPendingCount(items), 2);

      final pending = filteredRegistrationApplications(
        items: items,
        query: const RegistrationListQuery(
          filter: RegistrationListFilter.pending,
        ),
      );
      final needsInfo = filteredRegistrationApplications(
        items: items,
        query: const RegistrationListQuery(
          filter: RegistrationListFilter.needsInfo,
        ),
      );
      expect(pending.map((e) => e.id), ['1']);
      expect(needsInfo.map((e) => e.id), ['3']);
      expect(pending.length + needsInfo.length, _dashboardPendingCount(items));
    });

    test('pending=0 empty linked queue', () {
      final items = [
        _app(id: '1', status: RegistrationApplicationStatus.approved),
      ];
      expect(_dashboardPendingCount(items), 0);
      expect(
        filteredRegistrationApplications(
          items: items,
          query: const RegistrationListQuery(
            filter: RegistrationListFilter.pending,
          ),
        ),
        isEmpty,
      );
      expect(
        filteredRegistrationApplications(
          items: items,
          query: const RegistrationListQuery(
            filter: RegistrationListFilter.needsInfo,
          ),
        ),
        isEmpty,
      );
    });

    test('approved and rejected are outside the dashboard pending count', () {
      expect(RegistrationApplicationStatus.pending.isPending, isTrue);
      expect(RegistrationApplicationStatus.needsMoreInfo.isNeedsInfo, isTrue);
      expect(RegistrationApplicationStatus.approved.isPending, isFalse);
      expect(RegistrationApplicationStatus.rejected.isPending, isFalse);
    });
  });

  testWidgets('pending registrations tile routes to registrations queue', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp.router(
        routerConfig: GoRouter(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, _) => Scaffold(
                body: DashboardOperationalOverview(
                  pendingRegistrations: 2,
                  onPendingRegistrationsTap: () =>
                      GoRouter.of(context).push(AdminRoutes.registrations),
                ),
              ),
            ),
            GoRoute(
              path: AdminRoutes.registrations,
              builder: (_, _) => const Scaffold(body: Text('regs-queue')),
            ),
          ],
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('en'),
      ),
    );

    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('dashboard-pending-registrations')));
    await tester.pumpAndSettle();

    expect(find.text('regs-queue'), findsOneWidget);
    expect(find.textContaining('Pending registrations'), findsNothing);
  });
}
