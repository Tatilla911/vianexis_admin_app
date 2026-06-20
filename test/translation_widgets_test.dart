import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:vianexis_admin_app/features/translation/presentation/widgets/language_selector.dart';
import 'package:vianexis_admin_app/features/translation/presentation/widgets/original_text_card.dart';
import 'package:vianexis_admin_app/features/translation/presentation/widgets/translated_text_card.dart';
import 'package:vianexis_admin_app/features/translation/domain/translation_record.dart';
import 'package:vianexis_admin_app/features/translation/domain/translation_status.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Widget wrap(Widget child) {
    return MaterialApp(
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: SingleChildScrollView(child: child)),
    );
  }

  testWidgets('language selector renders HU/EN options', (tester) async {
    await tester.pumpWidget(
      wrap(
        LanguageSelector(
          label: 'Target',
          selectedCode: 'hu',
          onChanged: (_) {},
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.textContaining('Magyar'), findsOneWidget);
    await tester.tap(find.byType(DropdownButtonFormField<String>));
    await tester.pumpAndSettle();
    expect(find.textContaining('English'), findsOneWidget);
  });

  testWidgets('original and translated cards both visible', (tester) async {
    final record = TranslationRecord(
      id: '1',
      sourceType: 'support_ticket',
      sourceId: '1',
      sourceField: 'summary',
      originalTextHash: 'hash',
      targetLanguage: 'de',
      translatedText: '[de] Hello',
      status: TranslationStatus.machineTranslated,
      needsReview: true,
      metadataOnly: false,
      humanConfirmationRequired: true,
      stale: false,
    );

    await tester.pumpWidget(
      wrap(
        Column(
          children: [
            const OriginalTextCard(text: 'Hello'),
            TranslatedTextCard(text: record.translatedText, record: record),
          ],
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Hello'), findsOneWidget);
    expect(find.text('[de] Hello'), findsOneWidget);
  });
}
