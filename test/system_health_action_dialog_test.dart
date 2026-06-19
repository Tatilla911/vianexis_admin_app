import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/system_health/domain/system_health_action_request.dart';
import 'package:vianexis_admin_app/features/system_health/presentation/widgets/system_health_action_dialog.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpDialog(
    WidgetTester tester,
    SystemHealthActionType type,
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
                showSystemHealthActionDialog(context: context, type: type);
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

  testWidgets('escalate dialog requires note before confirm', (tester) async {
    await pumpDialog(tester, SystemHealthActionType.escalate);

    await tester.tap(find.text('Escalate'));
    await tester.pump();

    expect(find.text('Enter at least 3 characters.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField), 'Need infra support');
    await tester.tap(find.text('Escalate'));
    await tester.pumpAndSettle();

    expect(find.text('Enter at least 3 characters.'), findsNothing);
  });

  testWidgets('acknowledge dialog shows audit notice', (tester) async {
    await pumpDialog(tester, SystemHealthActionType.acknowledge);

    expect(
      find.text('This action will be recorded in the platform audit log.'),
      findsOneWidget,
    );
    expect(
      find.text('No automatic production repair will be performed.'),
      findsOneWidget,
    );
  });
}
