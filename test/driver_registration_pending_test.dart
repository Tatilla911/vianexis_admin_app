import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/driver_access/data/driver_access_repository.dart';
import 'package:vianexis_admin_app/features/driver_access/data/driver_registration_requests_repository.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_access_profile.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_device_notification_status.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_registration_request.dart';
import 'package:vianexis_admin_app/features/driver_access/presentation/driver_access_screen.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _FakePendingRepository implements DriverRegistrationRequestsRepository {
  _FakePendingRepository({required this.page});

  final DriverRegistrationRequestsPage page;
  int approveCalls = 0;
  int rejectCalls = 0;

  @override
  bool get usesMockData => false;

  @override
  Future<DriverRegistrationRequestsPage> listPending() async => page;

  @override
  Future<void> approve(String requestId, {int? companyId}) async {
    approveCalls++;
  }

  @override
  Future<void> reject(String requestId, {required String reviewNotes}) async {
    rejectCalls++;
  }
}

class _EmptyDriversRepository implements DriverAccessRepository {
  @override
  bool get usesMockData => false;

  @override
  Future<DriverAccessListResult> listDrivers() async {
    return DriverAccessListResult(
      items: const [],
      listEndpointReady: true,
      metadataOnly: true,
    );
  }

  @override
  Future<void> patchDriverStatus(
    String driverId, {
    required String status,
    String? reason,
  }) async {}

  @override
  Future<DriverDeviceNotificationStatus?> fetchDeviceNotificationStatus(
    String driverId,
  ) async =>
      null;
}

Widget _driverAccessTestApp({
  required DriverRegistrationRequestsRepository pendingRepo,
}) {
  return ProviderScope(
    overrides: [
      driverRegistrationRequestsRepositoryProvider.overrideWith((ref) => pendingRepo),
      driverAccessRepositoryProvider.overrideWith((ref) => _EmptyDriversRepository()),
    ],
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: const DriverAccessScreen(),
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Pending driver registrations', () {
    testWidgets('renders pending list with approve and reject actions', (tester) async {
      final repo = _FakePendingRepository(
        page: DriverRegistrationRequestsPage(
          listEndpointReady: true,
          total: 1,
          items: [
            DriverRegistrationRequestItem(
              id: 'req-1',
              fullName: 'UAT Pending Driver',
              email: 'uat.pending@example.test',
              phone: '+36 30 123 4567',
              status: 'pending',
              companyCode: 'ACME',
              createdAt: DateTime(2026, 7, 10, 12, 0),
            ),
          ],
        ),
      );

      await tester.pumpWidget(_driverAccessTestApp(pendingRepo: repo));
      await tester.pumpAndSettle();

      expect(find.text('Pending driver registrations'), findsOneWidget);
      expect(find.text('UAT Pending Driver'), findsOneWidget);
      expect(find.text('uat.pending@example.test'), findsOneWidget);
      expect(find.text('Approve'), findsOneWidget);
      expect(find.text('Reject'), findsOneWidget);
    });

    testWidgets('shows empty state when no pending registrations', (tester) async {
      final repo = _FakePendingRepository(
        page: const DriverRegistrationRequestsPage(
          listEndpointReady: true,
          total: 0,
          items: [],
        ),
      );

      await tester.pumpWidget(_driverAccessTestApp(pendingRepo: repo));
      await tester.pumpAndSettle();

      expect(find.text('No pending driver registrations.'), findsOneWidget);
    });

    testWidgets('approve calls repository and shows success snackbar', (tester) async {
      final repo = _FakePendingRepository(
        page: DriverRegistrationRequestsPage(
          listEndpointReady: true,
          total: 1,
          items: [
            DriverRegistrationRequestItem(
              id: 'req-approve',
              fullName: 'Approve Me',
              email: 'approve@example.test',
              status: 'pending',
              createdAt: DateTime.now(),
            ),
          ],
        ),
      );

      await tester.pumpWidget(_driverAccessTestApp(pendingRepo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Approve'));
      await tester.pumpAndSettle();

      expect(repo.approveCalls, 1);
      expect(find.text('Driver registration approved.'), findsOneWidget);
    });

    testWidgets('reject dialog calls repository with reason', (tester) async {
      final repo = _FakePendingRepository(
        page: DriverRegistrationRequestsPage(
          listEndpointReady: true,
          total: 1,
          items: [
            DriverRegistrationRequestItem(
              id: 'req-reject',
              fullName: 'Reject Me',
              email: 'reject@example.test',
              status: 'pending',
              createdAt: DateTime.now(),
            ),
          ],
        ),
      );

      await tester.pumpWidget(_driverAccessTestApp(pendingRepo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Reject'));
      await tester.pumpAndSettle();

      await tester.enterText(find.byType(TextField), 'Not eligible for UAT');
      await tester.tap(find.text('Reject registration'));
      await tester.pumpAndSettle();

      expect(repo.rejectCalls, 1);
      expect(find.text('Driver registration rejected.'), findsOneWidget);
    });

    testWidgets('narrow layout has no overflow with pending cards', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      final repo = _FakePendingRepository(
        page: DriverRegistrationRequestsPage(
          listEndpointReady: true,
          total: 1,
          items: [
            DriverRegistrationRequestItem(
              id: 'req-mobile',
              fullName: 'Mobile Layout Driver With A Long Display Name',
              email: 'mobile.layout.driver@example.test',
              phone: '+36 30 999 8888',
              status: 'pending',
              companyCode: 'VERY-LONG-COMPANY-CODE',
              createdAt: DateTime.now(),
            ),
          ],
        ),
      );

      await tester.pumpWidget(_driverAccessTestApp(pendingRepo: repo));
      await tester.pumpAndSettle();

      expect(tester.takeException(), isNull);
    });
  });
}
