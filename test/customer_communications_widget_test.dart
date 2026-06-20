import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/customer_communication_message.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/customer_communication_thread.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/evidence_package_request.dart';
import 'package:vianexis_admin_app/features/customer_communications/presentation/widgets/communication_thread_card.dart';
import 'package:vianexis_admin_app/features/customer_communications/presentation/widgets/generate_evidence_package_dialog.dart';
import 'package:vianexis_admin_app/features/customer_communications/presentation/widgets/translated_message_view.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('CommunicationThreadCard', () {
    testWidgets('shows disputed badge', (tester) async {
      const thread = CustomerCommunicationThread(
        id: '101',
        customerDisplayName: 'Anna',
        status: CustomerCommunicationThreadStatus.disputed,
        source: CustomerCommunicationSource.publicSite,
        disputed: true,
      );

      await tester.pumpWidget(_wrap(CommunicationThreadCard(thread: thread)));
      await tester.pumpAndSettle();

      expect(find.text('Disputed'), findsAtLeastNWidgets(1));
    });
  });

  group('TranslatedMessageView', () {
    testWidgets('shows original and translated text', (tester) async {
      const message = CustomerCommunicationMessage(
        id: '1',
        threadId: '101',
        direction: CustomerCommunicationDirection.inbound,
        senderType: CustomerCommunicationSenderType.customer,
        originalText: 'Eredeti szoveg',
        originalLanguage: 'hu',
        translatedText: 'Original text',
        translatedLanguage: 'en',
      );

      await tester.pumpWidget(_wrap(TranslatedMessageView(message: message)));
      await tester.pumpAndSettle();

      expect(find.text('Eredeti szoveg'), findsOneWidget);
      expect(find.text('Original text'), findsOneWidget);
    });
  });

  group('GenerateEvidencePackageDialog', () {
    testWidgets('requires reason before submit', (tester) async {
      EvidencePackageRequest? result;

      await tester.pumpWidget(
        MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Builder(
            builder: (context) {
              return Scaffold(
                body: Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      result = await showDialog<EvidencePackageRequest>(
                        context: context,
                        builder: (context) =>
                            const GenerateEvidencePackageDialog(),
                      );
                    },
                    child: const Text('open'),
                  ),
                ),
              );
            },
          ),
        ),
      );

      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Generate package'));
      await tester.pumpAndSettle();

      expect(result, isNull);
      expect(find.text('Enter at least 5 characters.'), findsOneWidget);
    });
  });
}
