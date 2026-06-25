import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/auth/admin_auth_state.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/features/public_intakes/data/public_intakes_repository.dart';
import 'package:vianexis_admin_app/features/public_intakes/domain/public_intake.dart';
import 'package:vianexis_admin_app/features/public_intakes/domain/public_intake_status.dart';
import 'package:vianexis_admin_app/features/public_intakes/domain/public_intake_type.dart';
import 'package:vianexis_admin_app/features/public_intakes/presentation/public_intake_detail_screen.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _NoLinksPublicIntakesRepository implements PublicIntakesRepository {
  @override
  bool get usesMockData => true;

  @override
  Future<List<PublicIntake>> fetchIntakes() async => [intake];

  @override
  Future<PublicIntake> fetchIntake(String id) async => intake;

  @override
  Future<PublicIntake> updateStatus({
    required String intakeId,
    required PublicIntakeStatus status,
    String? reason,
  }) async =>
      intake;

  static const intake = PublicIntake(
    id: '99',
    type: PublicIntakeType.contact,
    sourceLocale: 'en',
    preferredLanguage: 'en',
    messageOriginalLanguage: 'en',
    status: PublicIntakeStatus.newStatus,
    customerName: 'Test User',
    customerEmailDomain: 'example.com',
    messageOriginalText: 'Hello',
    consentPrivacy: true,
  );
}

class _AuthenticatedAdminAuthNotifier extends AdminAuthNotifier {
  @override
  AdminAuthState build() {
    return const AdminAuthState(
      user: AdminUser(
        id: '1',
        email: 'admin@vianexis.hu',
        role: AdminRole.superAdmin,
      ),
    );
  }
}

void main() {
  testWidgets('shows no linked records when intake has no links', (tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [
          adminAuthProvider.overrideWith(_AuthenticatedAdminAuthNotifier.new),
          publicIntakesRepositoryProvider.overrideWithValue(
            _NoLinksPublicIntakesRepository(),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('en'),
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: const PublicIntakeDetailScreen(intakeId: '99'),
        ),
      ),
    );

    await tester.pumpAndSettle();

    final scrollable = find.byType(Scrollable).first;
    await tester.scrollUntilVisible(
      find.text('No linked records'),
      500,
      scrollable: scrollable,
    );

    expect(find.text('No linked records'), findsOneWidget);
    expect(find.textContaining('No communication thread'), findsOneWidget);
  });
}
