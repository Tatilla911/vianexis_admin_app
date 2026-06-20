import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_decision_request.dart';
import 'package:vianexis_admin_app/features/registrations/presentation/widgets/registration_decision_dialog.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpDialog(
    WidgetTester tester,
    RegistrationDecisionType type,
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
                showRegistrationDecisionDialog(context: context, type: type);
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
    await pumpDialog(tester, RegistrationDecisionType.reject);

    await tester.tap(find.text('Reject'));
    await tester.pump();

    expect(find.text('Enter at least 3 characters.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Incomplete VAT proof');
    await tester.tap(find.text('Reject'));
    await tester.pumpAndSettle();

    expect(find.text('Enter at least 3 characters.'), findsNothing);
  });

  testWidgets('request-info dialog requires note before confirm', (tester) async {
    await pumpDialog(tester, RegistrationDecisionType.requestInfo);

    await tester.tap(find.text('Send request'));
    await tester.pump();

    expect(find.text('Enter at least 3 characters.'), findsOneWidget);
  });

  testWidgets('approve dialog shows audit notice', (tester) async {
    await pumpDialog(tester, RegistrationDecisionType.approve);

    expect(
      find.text('This action will be recorded in the platform audit log.'),
      findsOneWidget,
    );
  });

  testWidgets('reject dialog uses shared cancel label', (tester) async {
    await pumpDialog(tester, RegistrationDecisionType.reject);

    expect(find.text('Cancel'), findsOneWidget);
  });
}
