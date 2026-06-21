import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/customer_communications/presentation/widgets/send_customer_reply_dialog.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  testWidgets('send reply dialog requires human confirmation', (tester) async {
    await tester.pumpWidget(_wrap(const SendCustomerReplyDialog()));
    await tester.pumpAndSettle();

    expect(find.textContaining('not sent automatically'), findsOneWidget);
    expect(find.textContaining('Delivery provider disabled'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'Hello customer');
    final sendButton = find.widgetWithText(FilledButton, 'Send reply');
    expect(tester.widget<FilledButton>(sendButton).onPressed, isNull);

    final checkbox = find.byType(CheckboxListTile).last;
    await tester.ensureVisible(checkbox);
    await tester.tap(checkbox, warnIfMissed: false);
    await tester.pumpAndSettle();
    expect(tester.widget<FilledButton>(sendButton).onPressed, isNotNull);
  });
}
