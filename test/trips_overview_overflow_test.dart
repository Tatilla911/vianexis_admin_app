import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/operations/data/operations_repository.dart';
import 'package:vianexis_admin_app/features/trips_overview/data/trips_overview_repository.dart';
import 'package:vianexis_admin_app/features/trips_overview/domain/trip_overview_item.dart';
import 'package:vianexis_admin_app/features/trips_overview/presentation/trips_overview_screen.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _LongNameTripsRepository implements TripsOverviewRepository {
  @override
  bool get usesMockData => true;

  @override
  Future<TripOverviewListResult> listTrips() async {
    return const TripOverviewListResult(
      listEndpointReady: true,
      metadataOnly: true,
      items: [
        TripOverviewItem(
          id: '42',
          reference: 'TR-VERY-LONG-REFERENCE-ABCDEFGHIJKLMNOPQRSTUVWXYZ-999',
          companyName:
              'Nemzetközi Szállítmányozási és Logisztikai Szolgáltató Kft.',
          driverName: 'Nagyon Hosszú Sofőrnév András Péter István',
          status: TripOverviewStatus.active,
          canonicalStatus: 'active',
          hasExchangeRecords: true,
          hasExchangeAttention: true,
          hasPackage: false,
          pendingSyncWarning: true,
        ),
      ],
    );
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('trips overview long names do not overflow at phone width', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);

    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          operationsRepositoryProvider.overrideWith(
            (ref) => MockOperationsRepository(),
          ),
          tripsOverviewRepositoryProvider.overrideWith(
            (ref) => _LongNameTripsRepository(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const TripsOverviewScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(find.textContaining('TR-VERY-LONG-REFERENCE'), findsOneWidget);
  });
}
