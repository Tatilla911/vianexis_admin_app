import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/driver_access/data/driver_access_repository.dart';
import 'package:vianexis_admin_app/features/driver_access/data/driver_registration_requests_repository.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_access_profile.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_device_notification_status.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_operational_health_detail.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_registration_request.dart';
import 'package:vianexis_admin_app/features/driver_access/presentation/driver_access_screen.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _FakePendingRepository implements DriverRegistrationRequestsRepository {
  _FakePendingRepository({
    required this.page,
    this.approveDelay = Duration.zero,
  });

  final DriverRegistrationRequestsPage page;
  final Duration approveDelay;
  int approveCalls = 0;
  int rejectCalls = 0;
  int listPendingCalls = 0;

  @override
  bool get usesMockData => false;

  @override
  Future<DriverRegistrationRequestsPage> listPending() async {
    listPendingCalls++;
    return page;
  }

  @override
  Future<DriverRegistrationRequestsPage> listRejected() async {
    return const DriverRegistrationRequestsPage(
      items: [],
      total: 0,
      listEndpointReady: true,
    );
  }

  @override
  Future<DriverRegistrationDecisionResult> approve(
    String requestId, {
    int? companyId,
    String? reviewNotes,
  }) async {
    if (approveDelay > Duration.zero) {
      await Future<void>.delayed(approveDelay);
    }
    approveCalls++;
    return const DriverRegistrationDecisionResult(
      notificationEmailStatus: 'sent',
    );
  }

  @override
  Future<DriverRegistrationDecisionResult> reject(
    String requestId, {
    required String reviewNotes,
  }) async {
    rejectCalls++;
    return const DriverRegistrationDecisionResult(
      notificationEmailStatus: 'sent',
    );
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
  Future<DriverAccessProfile?> fetchDriver(String driverProfileId) async =>
      null;

  @override
  Future<void> patchDriverStatus(
    String driverId, {
    required String status,
    String? reason,
  }) async {}

  @override
  Future<Map<String, dynamic>> resendInvite(String driverProfileId) async =>
      const <String, dynamic>{};

  @override
  Future<Map<String, dynamic>> sendPasswordSetup(
    String driverProfileId,
  ) async => const <String, dynamic>{};

  @override
  Future<Map<String, dynamic>> softDelete({
    required String driverProfileId,
    required String reason,
  }) async => const <String, dynamic>{};

  @override
  Future<DriverDeviceNotificationStatus?> fetchDeviceNotificationStatus(
    String driverId,
  ) async => null;

  @override
  Future<DriverOperationalHealthDetail?> fetchOperationalHealth(
    String driverId,
  ) async => null;
}

Widget _driverAccessTestApp({
  required DriverRegistrationRequestsRepository pendingRepo,
}) {
  return ProviderScope(
    overrides: [
      driverRegistrationRequestsRepositoryProvider.overrideWith(
        (ref) => pendingRepo,
      ),
      driverAccessRepositoryProvider.overrideWith(
        (ref) => _EmptyDriversRepository(),
      ),
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
    testWidgets('renders pending list with approve and reject actions', (
      tester,
    ) async {
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

    testWidgets('shows empty state when no pending registrations', (
      tester,
    ) async {
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

    testWidgets('approve calls repository and shows success snackbar', (
      tester,
    ) async {
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
      expect(
        find.textContaining('Driver registration approved.'),
        findsOneWidget,
      );
      expect(find.textContaining('Email sent'), findsOneWidget);
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
      expect(
        find.textContaining('Driver registration rejected.'),
        findsOneWidget,
      );
      expect(find.textContaining('Email sent'), findsOneWidget);
    });

    testWidgets('double approve tap only submits once', (tester) async {
      final repo = _FakePendingRepository(
        page: DriverRegistrationRequestsPage(
          listEndpointReady: true,
          total: 1,
          items: [
            DriverRegistrationRequestItem(
              id: 'req-double',
              fullName: 'Double Approve',
              email: 'double@example.test',
              status: 'pending',
              createdAt: DateTime.now(),
            ),
          ],
        ),
        approveDelay: const Duration(milliseconds: 200),
      );

      await tester.pumpWidget(_driverAccessTestApp(pendingRepo: repo));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Approve'));
      await tester.pump();
      await tester.tap(find.text('Approve'), warnIfMissed: false);
      await tester.pump(const Duration(milliseconds: 250));
      await tester.pumpAndSettle();

      expect(repo.approveCalls, 1);
      expect(
        find.textContaining('Driver registration approved.'),
        findsOneWidget,
      );
    });

    testWidgets('approve invalidates pending queue after success', (
      tester,
    ) async {
      final repo = _FakePendingRepository(
        page: DriverRegistrationRequestsPage(
          listEndpointReady: true,
          total: 1,
          items: [
            DriverRegistrationRequestItem(
              id: 'req-invalidate',
              fullName: 'Invalidate Me',
              email: 'invalidate@example.test',
              status: 'pending',
              createdAt: DateTime.now(),
            ),
          ],
        ),
      );

      await tester.pumpWidget(_driverAccessTestApp(pendingRepo: repo));
      await tester.pumpAndSettle();
      expect(repo.listPendingCalls, greaterThanOrEqualTo(1));
      final before = repo.listPendingCalls;

      await tester.tap(find.text('Approve'));
      await tester.pumpAndSettle();

      expect(repo.approveCalls, 1);
      expect(repo.listPendingCalls, greaterThan(before));
    });

    testWidgets('narrow layout has no overflow with pending cards', (
      tester,
    ) async {
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
