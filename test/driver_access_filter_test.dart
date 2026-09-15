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

class _RecordingDriversRepository implements DriverAccessRepository {
  String? lastStatus;
  String? lastQ;
  int? lastLimit;
  int? lastOffset;

  @override
  bool get usesMockData => true;

  @override
  Future<DriverAccessListResult> listDrivers({
    String? status,
    String? q,
    int limit = 50,
    int offset = 0,
  }) async {
    lastStatus = status;
    lastQ = q;
    lastLimit = limit;
    lastOffset = offset;
    return DriverAccessListResult(
      listEndpointReady: true,
      metadataOnly: true,
      total: 2,
      items:
          [
                DriverAccessProfile(
                  id: 'd-101',
                  displayName: 'Kovács Péter',
                  companyName: 'NordTrans Kft.',
                  companyId: '1',
                  registrationStatus: DriverRegistrationStatus.active,
                ),
                if (status == null || status == 'disabled' || status == 'all')
                  DriverAccessProfile(
                    id: 'd-103',
                    displayName: 'Szabó István',
                    companyName: 'NordTrans Kft.',
                    companyId: '1',
                    registrationStatus: DriverRegistrationStatus.disabled,
                  ),
              ]
              .where((d) {
                if (status == null || status == 'all') return true;
                if (status == 'operational') {
                  return d.registrationStatus !=
                      DriverRegistrationStatus.disabled;
                }
                return d.registrationStatus ==
                    DriverRegistrationStatus.fromBackend(status);
              })
              .toList(growable: false),
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

class _EmptyPendingRepository implements DriverRegistrationRequestsRepository {
  @override
  bool get usesMockData => true;

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

class _RejectedOnlyRepository extends _EmptyPendingRepository {
  _RejectedOnlyRepository(this.rejected);

  final DriverRegistrationRequestItem rejected;

  @override
  Future<DriverRegistrationRequestsPage> listRejected() async {
    return DriverRegistrationRequestsPage(
      items: [rejected],
      total: 1,
      listEndpointReady: true,
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('rejected applications do not appear in the driver list', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    const rejected = DriverRegistrationRequestItem(
      id: 'reg-rejected-1',
      fullName: 'Elutasított Teszt',
      email: 'rejected@example.com',
      status: 'rejected',
    );
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          driverAccessRepositoryProvider.overrideWith(
            (ref) => _RecordingDriversRepository(),
          ),
          driverRegistrationRequestsRepositoryProvider.overrideWith(
            (ref) => _RejectedOnlyRepository(rejected),
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
          locale: const Locale('hu'),
          home: const DriverAccessScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Elutasított Teszt'), findsOneWidget);
    expect(
      find.textContaining('Elutasított sofőr jelentkezések'),
      findsOneWidget,
    );

    await tester.scrollUntilVisible(
      find.text('Kovács Péter'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();

    expect(find.text('Kovács Péter'), findsOneWidget);
    expect(find.text('reg-rejected-1'), findsNothing);
  });

  test(
    'mock repository filters disabled drivers and passes query params',
    () async {
      final repo = MockDriverAccessRepository();
      final disabled = await repo.listDrivers(status: 'disabled');
      expect(disabled.items, isNotEmpty);
      expect(
        disabled.items.every(
          (d) => d.registrationStatus == DriverRegistrationStatus.disabled,
        ),
        isTrue,
      );

      final searched = await repo.listDrivers(q: 'Kovács');
      expect(searched.items, hasLength(1));
      expect(searched.items.first.displayName, contains('Kovács'));
      expect(searched.total, 1);
    },
  );

  testWidgets('filter chips call listDrivers with status query params', (
    tester,
  ) async {
    final driversRepo = _RecordingDriversRepository();

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          driverAccessRepositoryProvider.overrideWith((ref) => driversRepo),
          driverRegistrationRequestsRepositoryProvider.overrideWith(
            (ref) => _EmptyPendingRepository(),
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
      ),
    );
    await tester.pumpAndSettle();

    expect(find.byType(FilterChip), findsWidgets);
    expect(find.textContaining('Active'), findsWidgets);
    expect(find.textContaining('Disabled'), findsWidgets);

    await tester.tap(find.textContaining('Disabled').first);
    await tester.pumpAndSettle();

    expect(driversRepo.lastStatus, 'disabled');
    expect(find.text('Szabó István'), findsOneWidget);
  });
}
