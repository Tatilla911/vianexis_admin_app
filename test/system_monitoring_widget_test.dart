import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/system_monitoring/data/system_monitoring_repository.dart';
import 'package:vianexis_admin_app/features/system_monitoring/domain/system_monitoring_overview.dart';
import 'package:vianexis_admin_app/features/system_monitoring/presentation/system_monitoring_providers.dart';
import 'package:vianexis_admin_app/features/system_monitoring/presentation/system_monitoring_screen.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  testWidgets('system monitoring screen shows loading then overview', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          systemMonitoringRepositoryProvider.overrideWithValue(
            MockSystemMonitoringRepository(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const SystemMonitoringScreen(),
        ),
      ),
    );

    expect(find.byType(CircularProgressIndicator), findsWidgets);
    await tester.pumpAndSettle();

    expect(find.text('System monitoring'), findsOneWidget);
    expect(find.text('Components'), findsOneWidget);
    expect(find.text('Active incidents'), findsOneWidget);
    expect(find.textContaining('Mock data'), findsOneWidget);
  });

  testWidgets('degraded/unhealthy filter chip toggles filter state', (
    tester,
  ) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          systemMonitoringRepositoryProvider.overrideWithValue(
            MockSystemMonitoringRepository(),
          ),
        ],
        child: MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          locale: const Locale('en'),
          home: const SystemMonitoringScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(SystemMonitoringScreen)),
    );
    expect(
      container.read(systemMonitoringComponentFilterProvider).filter,
      SystemMonitoringComponentFilter.all,
    );

    await tester.tap(find.text('Degraded / unhealthy'));
    await tester.pumpAndSettle();

    expect(
      container.read(systemMonitoringComponentFilterProvider).filter,
      SystemMonitoringComponentFilter.degradedOrUnhealthy,
    );
  });
}
