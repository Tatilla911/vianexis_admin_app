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

class _DriversRepo implements DriverAccessRepository {
  _DriversRepo(this.items);

  final List<DriverAccessProfile> items;

  @override
  bool get usesMockData => true;

  @override
  Future<DriverAccessListResult> listDrivers({
    String? status,
    String? q,
    int limit = 50,
    int offset = 0,
  }) async {
    return DriverAccessListResult(
      items: items,
      listEndpointReady: true,
      metadataOnly: true,
    );
  }

  @override
  Future<DriverAccessProfile?> fetchDriver(String driverProfileId) async =>
      null;

  @override
  Future<void> patchDriverStatus(
    String driverProfileId, {
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
    String driverProfileId,
  ) async => null;

  @override
  Future<DriverOperationalHealthDetail?> fetchOperationalHealth(
    String driverProfileId,
  ) async => null;
}

class _RegistrationRepo implements DriverRegistrationRequestsRepository {
  _RegistrationRepo({this.pending = const [], this.rejected = const []});

  final List<DriverRegistrationRequestItem> pending;
  final List<DriverRegistrationRequestItem> rejected;

  @override
  bool get usesMockData => true;

  @override
  Future<DriverRegistrationRequestsPage> listPending() async {
    return DriverRegistrationRequestsPage(
      items: pending,
      total: pending.length,
      listEndpointReady: true,
    );
  }

  @override
  Future<DriverRegistrationRequestsPage> listRejected() async {
    return DriverRegistrationRequestsPage(
      items: rejected,
      total: rejected.length,
      listEndpointReady: true,
    );
  }

  @override
  Future<DriverRegistrationDecisionResult> approve(
    String requestId, {
    int? companyId,
    String? reviewNotes,
  }) async {
    return const DriverRegistrationDecisionResult(
      notificationEmailStatus: 'sent',
    );
  }

  @override
  Future<DriverRegistrationDecisionResult> reject(
    String requestId, {
    required String reviewNotes,
  }) async {
    return const DriverRegistrationDecisionResult(
      notificationEmailStatus: 'sent',
    );
  }
}

DriverAccessProfile _driver({
  required String id,
  required String name,
  required DriverRegistrationStatus status,
}) {
  return DriverAccessProfile(
    id: id,
    displayName: name,
    companyName: 'NordTrans',
    companyId: '1',
    registrationStatus: status,
  );
}

Future<void> _pumpScreen(
  WidgetTester tester, {
  required DriverAccessRepository drivers,
  required DriverRegistrationRequestsRepository registrations,
  Locale locale = const Locale('en'),
}) async {
  tester.view.physicalSize = const Size(900, 1800);
  tester.view.devicePixelRatio = 1.0;
  addTearDown(tester.view.resetPhysicalSize);
  addTearDown(tester.view.resetDevicePixelRatio);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        driverAccessRepositoryProvider.overrideWith((ref) => drivers),
        driverRegistrationRequestsRepositoryProvider.overrideWith(
          (ref) => registrations,
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
        locale: locale,
        home: const DriverAccessScreen(),
      ),
    ),
  );
  await tester.pumpAndSettle();
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final rejectedApp = DriverRegistrationRequestItem(
    id: 'reg-rejected-1',
    fullName: 'Rejected Applicant',
    email: 'rejected@example.com',
    status: 'rejected',
    updatedAt: DateTime.utc(2026, 8, 1),
    reviewNotes: 'Incomplete docs',
  );
  final pendingApp = const DriverRegistrationRequestItem(
    id: 'reg-pending-1',
    fullName: 'Pending Applicant',
    email: 'pending@example.com',
    status: 'pending',
  );
  final activeDriver = _driver(
    id: 'd-active',
    name: 'Active Driver',
    status: DriverRegistrationStatus.active,
  );
  final disabledDriver = _driver(
    id: 'd-disabled',
    name: 'Disabled Driver',
    status: DriverRegistrationStatus.disabled,
  );

  testWidgets(
    'rejected application appears in Rejected driver applications section',
    (tester) async {
      await _pumpScreen(
        tester,
        drivers: _DriversRepo([activeDriver]),
        registrations: _RegistrationRepo(rejected: [rejectedApp]),
      );

      expect(find.text('Rejected driver applications'), findsOneWidget);
      expect(find.text('Rejected Applicant'), findsOneWidget);
      expect(find.textContaining('rejected@example.com'), findsOneWidget);
    },
  );

  testWidgets('rejected application does NOT appear as a DriverProfile row', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      drivers: _DriversRepo([activeDriver]),
      registrations: _RegistrationRepo(rejected: [rejectedApp]),
    );

    expect(
      find.descendant(
        of: find.byType(ExpansionTile),
        matching: find.text('Rejected Applicant'),
      ),
      findsOneWidget,
    );
    expect(find.widgetWithText(ListTile, 'Active Driver'), findsOneWidget);
    expect(find.byType(ExpansionTile), findsOneWidget);
  });

  testWidgets('active DriverProfile remains in Driver list', (tester) async {
    await _pumpScreen(
      tester,
      drivers: _DriversRepo([activeDriver, disabledDriver]),
      registrations: _RegistrationRepo(rejected: [rejectedApp]),
    );
    expect(find.text('Active Driver'), findsOneWidget);
  });

  testWidgets('rejected application count is correct', (tester) async {
    await _pumpScreen(
      tester,
      drivers: _DriversRepo([activeDriver]),
      registrations: _RegistrationRepo(
        rejected: [
          rejectedApp,
          const DriverRegistrationRequestItem(
            id: 'reg-rejected-2',
            fullName: 'Second Rejected',
            email: 'r2@example.com',
            status: 'rejected',
          ),
        ],
      ),
    );

    expect(find.byType(ExpansionTile), findsNWidgets(2));
    expect(find.text('Rejected Applicant'), findsOneWidget);
    expect(find.text('Second Rejected'), findsOneWidget);
  });

  testWidgets('empty rejected section state is compact', (tester) async {
    await _pumpScreen(
      tester,
      drivers: _DriversRepo([activeDriver]),
      registrations: _RegistrationRepo(),
    );

    expect(find.text('Rejected driver applications'), findsOneWidget);
    expect(find.text('No rejected driver applications.'), findsOneWidget);
    expect(find.byType(ExpansionTile), findsNothing);
  });

  testWidgets('tap rejected application expands inline application history', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      drivers: _DriversRepo([activeDriver]),
      registrations: _RegistrationRepo(rejected: [rejectedApp]),
    );

    await tester.tap(find.text('Rejected Applicant'));
    await tester.pumpAndSettle();

    expect(find.textContaining('Rejected at'), findsOneWidget);
    expect(find.textContaining('Incomplete docs'), findsOneWidget);
    expect(find.byType(ExpansionTile), findsOneWidget);
  });

  testWidgets('no duplicate row between pending/rejected/driver lists', (
    tester,
  ) async {
    await _pumpScreen(
      tester,
      drivers: _DriversRepo([activeDriver]),
      registrations: _RegistrationRepo(
        pending: [pendingApp],
        rejected: [rejectedApp],
      ),
    );

    expect(find.text('Pending Applicant'), findsOneWidget);
    expect(find.text('Rejected Applicant'), findsOneWidget);
    expect(find.text('Active Driver'), findsOneWidget);
  });

  testWidgets('HU labels for rejected section', (tester) async {
    await _pumpScreen(
      tester,
      drivers: _DriversRepo([activeDriver]),
      registrations: _RegistrationRepo(rejected: [rejectedApp]),
      locale: const Locale('hu'),
    );

    expect(
      find.textContaining('Elutasított sofőr jelentkezések'),
      findsOneWidget,
    );
    expect(find.textContaining('Elutasítva'), findsWidgets);
  });
}
