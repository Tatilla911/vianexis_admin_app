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

class _OpsDriversRepository implements DriverAccessRepository {
  _OpsDriversRepository(this.driver);

  final DriverAccessProfile driver;
  int inviteCalls = 0;
  int passwordCalls = 0;
  int deleteCalls = 0;
  Duration inviteDelay = Duration.zero;

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
      items: [driver],
      listEndpointReady: true,
      metadataOnly: true,
    );
  }

  @override
  Future<DriverAccessProfile?> fetchDriver(String driverProfileId) async {
    return driverProfileId == driver.id ? driver : null;
  }

  @override
  Future<void> patchDriverStatus(
    String driverProfileId, {
    required String status,
    String? reason,
  }) async {}

  @override
  Future<Map<String, dynamic>> resendInvite(String driverProfileId) async {
    if (inviteDelay > Duration.zero) {
      await Future<void>.delayed(inviteDelay);
    }
    inviteCalls++;
    return {
      'driverProfileId': driverProfileId,
      'emailSent': false,
      'deliveryStatus': 'provider_disabled',
    };
  }

  @override
  Future<Map<String, dynamic>> sendPasswordSetup(String driverProfileId) async {
    passwordCalls++;
    return {
      'driverProfileId': driverProfileId,
      'emailSent': true,
      'deliveryStatus': 'sent',
    };
  }

  @override
  Future<Map<String, dynamic>> softDelete({
    required String driverProfileId,
    required String reason,
  }) async {
    deleteCalls++;
    return {'driverProfileId': driverProfileId, 'deleted': true};
  }

  @override
  Future<DriverDeviceNotificationStatus?> fetchDeviceNotificationStatus(
    String driverProfileId,
  ) async => null;

  @override
  Future<DriverOperationalHealthDetail?> fetchOperationalHealth(
    String driverProfileId,
  ) async => null;
}

Widget _detailApp(DriverAccessRepository drivers) {
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
      home: DriverAccessDetailScreen(driverId: 'd-1'),
    ),
  );
}

DriverAccessProfile _invited() {
  return const DriverAccessProfile(
    id: 'd-1',
    displayName: 'Invited Driver',
    companyName: 'Acme',
    companyId: '9',
    registrationStatus: DriverRegistrationStatus.invited,
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> setTallSurface(WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(800, 2400));
    addTearDown(() => tester.binding.setSurfaceSize(null));
  }

  testWidgets('invited driver can resend invite and shows delivery snackbar', (
    tester,
  ) async {
    await setTallSurface(tester);
    final repo = _OpsDriversRepository(_invited());
    await tester.pumpWidget(_detailApp(repo));
    await tester.pumpAndSettle();

    expect(find.text('Resend invite'), findsOneWidget);
    await tester.tap(find.text('Resend invite'));
    await tester.pumpAndSettle();

    expect(repo.inviteCalls, 1);
    expect(find.textContaining('email delivery is disabled'), findsOneWidget);
  });

  testWidgets('password setup shows success snackbar', (tester) async {
    await setTallSurface(tester);
    final repo = _OpsDriversRepository(_invited());
    await tester.pumpWidget(_detailApp(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Send password setup'));
    await tester.pumpAndSettle();

    expect(repo.passwordCalls, 1);
    expect(find.textContaining('Password setup link sent.'), findsOneWidget);
  });

  testWidgets('ops busy guard prevents double invite', (tester) async {
    await setTallSurface(tester);
    final repo = _OpsDriversRepository(_invited())
      ..inviteDelay = const Duration(milliseconds: 200);
    await tester.pumpWidget(_detailApp(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Resend invite'));
    await tester.pump();
    await tester.tap(find.text('Resend invite'), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pumpAndSettle();

    expect(repo.inviteCalls, 1);
  });

  testWidgets('archive driver requires reason and calls softDelete', (
    tester,
  ) async {
    await setTallSurface(tester);
    final repo = _OpsDriversRepository(_invited());
    await tester.pumpWidget(_detailApp(repo));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Archive driver'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'UAT archive reason');
    await tester.tap(find.widgetWithText(FilledButton, 'Archive driver'));
    await tester.pumpAndSettle();

    expect(repo.deleteCalls, 1);
    expect(find.textContaining('Driver archived.'), findsOneWidget);
  });
}
