import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/translation/domain/language_option.dart';
import 'package:vianexis_admin_app/features/translation/domain/reply_translation_preview.dart';
import 'package:vianexis_admin_app/features/translation/domain/translation_record.dart';
import 'package:vianexis_admin_app/features/translation/domain/translation_status.dart';

void main() {
  group('TranslationRecord parsing', () {
    test('parses machine translated record with metadata flags', () {
      final record = TranslationRecord.fromJson({
        'id': 42,
        'sourceType': 'support_ticket',
        'sourceId': '801',
        'sourceField': 'descriptionSummary',
        'originalTextHash': 'abc123',
        'sourceLanguage': 'en',
        'targetLanguage': 'hu',
        'translatedText': '[hu] stalled queue',
        'provider': 'mock',
        'providerModel': 'mock-v1',
        'confidence': 0.82,
        'status': 'machine_translated',
        'needsReview': true,
        'metadataOnly': false,
        'humanConfirmationRequired': true,
        'stale': false,
        'createdAt': '2026-06-19T10:00:00.000Z',
        'updatedAt': '2026-06-19T10:00:00.000Z',
      });

      expect(record.id, '42');
      expect(record.status, TranslationStatus.machineTranslated);
      expect(record.translatedText, contains('[hu]'));
      expect(record.humanConfirmationRequired, isTrue);
    });

    test('reply preview never allows auto send', () {
      final preview = ReplyTranslationPreview.fromJson({
        'enabled': true,
        'provider': 'mock',
        'originalText': 'Draft',
        'translatedText': '[de] Draft',
        'humanConfirmationRequired': true,
        'autoSendAllowed': false,
        'record': {
          'id': 1,
          'sourceType': 'support_ticket',
          'sourceId': '1',
          'sourceField': 'reply_draft',
          'originalTextHash': 'hash',
          'targetLanguage': 'de',
          'status': 'machine_translated',
          'needsReview': true,
          'metadataOnly': false,
          'humanConfirmationRequired': true,
          'stale': false,
        },
      });

      expect(preview.autoSendAllowed, isFalse);
      expect(preview.humanConfirmationRequired, isTrue);
      expect(preview.originalText, 'Draft');
    });
  });

  group('LanguageOption', () {
    test('includes HU and EN defaults', () {
      expect(
        LanguageOption.adminDefaults.map((option) => option.code),
        containsAll(['hu', 'en']),
      );
    });
  });
}
