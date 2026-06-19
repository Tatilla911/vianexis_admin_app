import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/registrations/data/registration_applications_repository.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_application.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_application_status.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_decision_request.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_risk_level.dart';
import 'package:vianexis_admin_app/features/registrations/presentation/registration_applications_screen.dart';
import 'package:vianexis_admin_app/features/registrations/presentation/registration_providers.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _FakeRegistrationRepository implements RegistrationApplicationsRepository {
  _FakeRegistrationRepository(this.items);

  final List<RegistrationApplication> items;

  @override
  bool get usesMockData => true;

  @override
  Future<List<RegistrationApplication>> fetchApplications() async => items;

  @override
  Future<RegistrationApplication> fetchApplication(String id) async {
    return items.firstWhere((item) => item.id == id);
  }

  @override
  Future<void> submitDecision({
    required String applicationId,
    required RegistrationDecisionRequest request,
  }) async {}
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget buildApp(List<RegistrationApplication> items) {
    return ProviderScope(
      overrides: [
        registrationApplicationsRepositoryProvider.overrideWithValue(
          _FakeRegistrationRepository(items),
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
        home: const RegistrationApplicationsScreen(),
      ),
    );
  }

  testWidgets('shows loading then empty state', (tester) async {
    await tester.pumpWidget(buildApp(const []));
    expect(find.byType(CircularProgressIndicator), findsOneWidget);

    await tester.pumpAndSettle();
    expect(
      find.text('No registration applications match your filters.'),
      findsOneWidget,
    );
  });

  testWidgets('shows error state with retry', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          registrationApplicationsProvider.overrideWith(
            () => _ErrorApplicationsNotifier(),
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
          home: const RegistrationApplicationsScreen(),
        ),
      ),
    );

    await tester.pumpAndSettle();
    expect(find.text('Could not load registration applications.'), findsOneWidget);
    expect(find.text('Retry'), findsOneWidget);
  });

  testWidgets('renders application cards', (tester) async {
    await tester.pumpWidget(
      buildApp([
        const RegistrationApplication(
          id: '1',
          type: RegistrationApplicationType.company,
          companyName: 'Widget Test Co',
          contactEmail: 'widget@example.com',
          status: RegistrationApplicationStatus.pending,
          riskLevel: RegistrationRiskLevel.low,
        ),
      ]),
    );
    await tester.pumpAndSettle();

    expect(find.text('Widget Test Co'), findsOneWidget);
  });
}

class _ErrorApplicationsNotifier extends RegistrationApplicationsNotifier {
  @override
  Future<List<RegistrationApplication>> build() async {
    throw Exception('load failed');
  }
}
