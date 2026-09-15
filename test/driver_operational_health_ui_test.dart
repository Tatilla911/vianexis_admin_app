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

class _EmptyPendingRepository implements DriverRegistrationRequestsRepository {
  @override
  bool get usesMockData => false;

  @override
  Future<DriverRegistrationRequestsPage> listPending() async {
    return const DriverRegistrationRequestsPage(
      items: [],
      total: 0,
      listEndpointReady: true,
    );
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
    return const DriverRegistrationDecisionResult();
  }

  @override
  Future<DriverRegistrationDecisionResult> reject(
    String requestId, {
    required String reviewNotes,
  }) async {
    return const DriverRegistrationDecisionResult();
  }
}

class _HealthDriversRepository implements DriverAccessRepository {
  _HealthDriversRepository({required this.drivers, this.healthById = const {}});

  final List<DriverAccessProfile> drivers;
  final Map<String, DriverOperationalHealthDetail?> healthById;

  @override
  bool get usesMockData => false;

  @override
  Future<DriverAccessListResult> listDrivers({
    String? status,
    String? q,
    int limit = 50,
    int offset = 0,
  }) async {
    return DriverAccessListResult(
      items: drivers,
      listEndpointReady: true,
      metadataOnly: true,
    );
  }

  @override
  Future<DriverAccessProfile?> fetchDriver(String driverProfileId) async {
    for (final driver in drivers) {
      if (driver.id == driverProfileId) return driver;
    }
    return null;
  }

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
    String driverId,
  ) async => null;

  @override
  Future<DriverOperationalHealthDetail?> fetchOperationalHealth(
    String driverId,
  ) async {
    if (!healthById.containsKey(driverId)) return null;
    return healthById[driverId];
  }
}

Widget _app({required DriverAccessRepository drivers, Widget? home}) {
  return ProviderScope(
    overrides: [
      driverRegistrationRequestsRepositoryProvider.overrideWith(
        (ref) => _EmptyPendingRepository(),
      ),
      driverAccessRepositoryProvider.overrideWith((ref) => drivers),
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
      home: home ?? const DriverAccessScreen(),
    ),
  );
}

DriverAccessProfile _driver({
  required String id,
  DriverOperationalHealthSummary? health,
}) {
  return DriverAccessProfile(
    id: id,
    displayName: 'Ada Driver',
    companyName: 'Acme',
    companyId: '9',
    registrationStatus: DriverRegistrationStatus.active,
    operationalHealth: health,
  );
}

Future<void> _setTallSurface(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(800, 2400));
  addTearDown(() => tester.binding.setSurfaceSize(null));
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('list shows reported sync-health and omits fake healthy icons', (
    tester,
  ) async {
    await tester.pumpWidget(
      _app(
        drivers: _HealthDriversRepository(
          drivers: [
            _driver(
              id: 'd-warn',
              health: const DriverOperationalHealthSummary(
                level: DriverOperationalHealthLevel.yellow,
                activeIssueCount: 1,
              ),
            ),
            _driver(id: 'd-unknown'),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.warning_amber_outlined), findsOneWidget);
    expect(find.byIcon(Icons.check_circle_outline), findsNothing);
    expect(find.text('Ada Driver'), findsNWidgets(2));
  });

  testWidgets('detail shows fetched operational issue, not invented healthy', (
    tester,
  ) async {
    await _setTallSurface(tester);
    await tester.pumpWidget(
      _app(
        drivers: _HealthDriversRepository(
          drivers: [
            _driver(
              id: 'd-warn',
              health: const DriverOperationalHealthSummary(
                level: DriverOperationalHealthLevel.yellow,
                activeIssueCount: 1,
              ),
            ),
          ],
          healthById: {
            'd-warn': DriverOperationalHealthDetail(
              overallLevel: DriverOperationalHealthLevel.yellow,
              activeIssueCount: 1,
              issues: [
                DriverOperationalHealthIssueView(
                  id: '9',
                  category: 'profile_sync',
                  code: 'sync.profile.failed',
                  severity: 'yellow',
                  status: 'active',
                  attemptCount: 2,
                  safeErrorCode: 'network',
                ),
              ],
            ),
          },
        ),
        home: const DriverAccessDetailScreen(driverId: 'd-warn'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Operational system health'), findsOneWidget);
    expect(find.text('Profile sync'), findsOneWidget);
    expect(find.textContaining('network'), findsOneWidget);
    expect(find.text('No active operational issues.'), findsNothing);
    expect(
      find.text('Retry is required on the driver device.'),
      findsOneWidget,
    );
  });

  testWidgets('detail does not claim healthy when health is unavailable', (
    tester,
  ) async {
    await _setTallSurface(tester);
    await tester.pumpWidget(
      _app(
        drivers: _HealthDriversRepository(drivers: [_driver(id: 'd-unknown')]),
        home: const DriverAccessDetailScreen(driverId: 'd-unknown'),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Operational system health'), findsOneWidget);
    expect(
      find.text('Operational system health is currently unavailable.'),
      findsOneWidget,
    );
    expect(find.text('No active operational issues.'), findsNothing);
    expect(find.textContaining('OK'), findsNothing);
  });
}
