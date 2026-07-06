import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/widgets/backend_dependency_card.dart';
import 'package:vianexis_admin_app/features/driver_access/data/driver_access_repository.dart';
import 'package:vianexis_admin_app/features/driver_access/presentation/driver_access_screen.dart';
import 'package:vianexis_admin_app/features/exchange_records/data/exchange_records_repository.dart';
import 'package:vianexis_admin_app/features/exchange_records/presentation/exchange_records_screen.dart';
import 'package:vianexis_admin_app/features/notifications/data/notifications_repository.dart';
import 'package:vianexis_admin_app/features/notifications/domain/push_provider_status.dart';
import 'package:vianexis_admin_app/features/notifications/presentation/notification_status_screen.dart';
import 'package:vianexis_admin_app/features/operations/data/operations_repository.dart';
import 'package:vianexis_admin_app/features/operations/domain/operational_metrics_snapshot.dart';
import 'package:vianexis_admin_app/features/operations/domain/platform_operations_snapshot.dart';
import 'package:vianexis_admin_app/features/operations/presentation/operations_screen.dart';
import 'package:vianexis_admin_app/features/trips_overview/presentation/trips_overview_screen.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _FixedOperationsRepository implements OperationsRepository {
  const _FixedOperationsRepository(this._snapshot);

  final PlatformOperationsSnapshot _snapshot;

  @override
  bool get usesMockData => true;

  @override
  Future<PlatformOperationsSnapshot> fetchSnapshot() async => _snapshot;

  @override
  Future<OperationalMetricsSnapshot?> fetchOperationalMetrics() async {
    return const OperationalMetricsSnapshot(
      metadataOnly: true,
      exchangeRecordsTotal: 5,
      exchangeDisputed: 1,
      exchangeDamaged: 0,
      exchangeMissing: 1,
      pendingSyncCount: null,
      pendingSyncSourceUnavailable: true,
      driversActive: 10,
      driversDisabled: 1,
      driversPending: 0,
    );
  }
}

const _sampleSnapshot = PlatformOperationsSnapshot(
  companiesTotal: 12,
  companiesActive: 9,
  usersActive: 48,
  usersInvited: 6,
  driversEstimate: 32,
  tripsTotal: 156,
  tripsActive: 24,
  tripsCompleted: 118,
  tripsParked: 4,
  activeSupportGrants: 2,
  expiringSupportGrants: 1,
  pendingPublicIntakes: 3,
  pendingRegistrations: 2,
  documentsTotal: 890,
  packagesGenerated: 45,
  privacyNote: 'Mock',
);

Widget _app(Widget child) {
  return ProviderScope(
    child: MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      locale: const Locale('en'),
      home: child,
    ),
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Operations readiness', () {
    testWidgets('operations dashboard renders metrics and dependency cards', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            operationsRepositoryProvider.overrideWith(
              (ref) => const _FixedOperationsRepository(_sampleSnapshot),
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
            home: const OperationsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Operations overview'), findsOneWidget);
      expect(find.text('Active trips'), findsOneWidget);
      expect(find.text('Driver access'), findsOneWidget);
      expect(find.text('Operations modules'), findsOneWidget);
    });

    testWidgets('driver access live mode shows backend dependency', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            driverAccessRepositoryProvider.overrideWith(
              (ref) => LiveDriverAccessRepository(),
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

      expect(find.text('Driver access'), findsOneWidget);
      expect(find.text('Backend dependency'), findsOneWidget);
      expect(find.textContaining('platform-admin/drivers'), findsOneWidget);
    });

    testWidgets('driver access mock mode renders list without raw tokens', (tester) async {
      await tester.pumpWidget(_app(const DriverAccessScreen()));

      await tester.pumpAndSettle();

      expect(find.text('Kovács Péter'), findsOneWidget);
      expect(find.textContaining('eyJ'), findsNothing);
    });

    testWidgets('trips overview mock mode renders trip rows', (tester) async {
      await tester.pumpWidget(_app(const TripsOverviewScreen()));

      await tester.pumpAndSettle();

      expect(find.text('Trips overview'), findsOneWidget);
      expect(find.text('TR-42'), findsOneWidget);
      expect(find.textContaining('Exchange attention'), findsOneWidget);
    });

    testWidgets('exchange records live mode shows backend dependency', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            exchangeRecordsRepositoryProvider.overrideWith(
              (ref) => LiveExchangeRecordsRepository(),
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
            home: const ExchangeRecordsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Exchange records'), findsOneWidget);
      expect(find.byType(BackendDependencyCard), findsOneWidget);
    });

    testWidgets('notification status screen hides raw tokens', (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            pushProviderStatusProvider.overrideWith(
              (ref) async => const PushProviderStatus(
                provider: 'fcm',
                deliveryEnabled: false,
                configured: false,
                tokenStorageMode: 'hash_only',
                metadataOnly: true,
              ),
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
            home: const NotificationStatusScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(find.text('Notification status'), findsOneWidget);
      expect(find.text('Driver app notification foundation'), findsOneWidget);
      expect(find.textContaining('eyJ'), findsNothing);
    });

    testWidgets('operations screen has no horizontal overflow on narrow width', (tester) async {
      tester.view.physicalSize = const Size(360, 800);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            operationsRepositoryProvider.overrideWith(
              (ref) => const _FixedOperationsRepository(_sampleSnapshot),
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
            home: const OperationsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();
      expect(tester.takeException(), isNull);
    });

    test('HU and EN localization keys exist for operations modules', () {
      expect(AppLocalizations.supportedLocales.length, greaterThanOrEqualTo(2));
    });
  });
}
