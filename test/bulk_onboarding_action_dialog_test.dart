import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_action_request.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/presentation/widgets/bulk_onboarding_action_dialog.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpDialog(
    WidgetTester tester,
    BulkOnboardingActionKind kind,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        home: Builder(
          builder: (context) {
            return ElevatedButton(
              onPressed: () {
                showBulkOnboardingActionDialog(
                  context: context,
                  kind: kind,
                  processingAvailable: true,
                );
              },
              child: const Text('open'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  testWidgets('reject dialog requires note before confirm', (tester) async {
    await pumpDialog(tester, BulkOnboardingActionKind.reject);

    await tester.tap(find.text('Reject'));
    await tester.pump();

    expect(find.text('A reason is required.'), findsOneWidget);
  });

  testWidgets('reject dialog uses shared cancel label', (tester) async {
    await pumpDialog(tester, BulkOnboardingActionKind.reject);

    expect(find.text('Cancel'), findsOneWidget);
  });
}
