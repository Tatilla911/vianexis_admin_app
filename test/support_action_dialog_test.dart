import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/support/domain/support_access_scope_type.dart';
import 'package:vianexis_admin_app/features/support/presentation/widgets/support_access_grant_dialog.dart';
import 'package:vianexis_admin_app/features/support/presentation/widgets/support_action_dialog.dart';
import 'package:vianexis_admin_app/features/support/domain/support_ticket_action_request.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<void> pumpGrantDialog(WidgetTester tester) async {
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
                showSupportAccessGrantDialog(
                  context: context,
                  prefill: const SupportAccessGrantDialogPrefill(
                    companyId: '12',
                    companyName: 'NordTrans Kft.',
                    defaultScopeType: SupportAccessScopeType.specificTrip,
                  ),
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

  testWidgets('grant dialog requires reason and scope id', (tester) async {
    await pumpGrantDialog(tester);

    await tester.tap(find.text('Create grant'));
    await tester.pump();

    expect(find.text('Enter at least 3 characters.'), findsOneWidget);
    expect(find.text('Scope ID is required for this scope type.'), findsOneWidget);

    await tester.enterText(find.byType(TextFormField).at(0), 'trip-42');
    await tester.enterText(find.byType(TextFormField).at(1), 'Need scoped trip metadata');
    await tester.tap(find.text('Create grant'));
    await tester.pumpAndSettle();

    expect(find.text('Scope ID is required for this scope type.'), findsNothing);
  });

  testWidgets('revoke dialog requires note before confirm', (tester) async {
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
              onPressed: () => showSupportRevokeDialog(context: context),
              child: const Text('open'),
            );
          },
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Revoke grant'));
    await tester.pump();

    expect(find.text('Enter at least 3 characters.'), findsOneWidget);
  });

  testWidgets('close ticket dialog requires note', (tester) async {
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
                showSupportActionDialog(
                  context: context,
                  type: SupportTicketActionType.close,
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

    await tester.tap(find.text('Close'));
    await tester.pump();

    expect(find.text('Enter at least 3 characters.'), findsOneWidget);
  });
}
