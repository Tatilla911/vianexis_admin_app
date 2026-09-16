import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/customer_communication_message.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/customer_message_language.dart';
import 'package:vianexis_admin_app/features/customer_communications/presentation/communications_translation_preference.dart';

void main() {
  group('communications translation preference', () {
    test('defaults to Hungarian', () {
      expect(
        resolveCommunicationsTranslationTarget(
          savedLocale: null,
          uiLocale: const Locale('de'),
        ),
        'hu',
      );
      expect(
        resolveCommunicationsTranslationTarget(
          savedLocale: const Locale('hu'),
          uiLocale: const Locale('en'),
        ),
        'hu',
      );
    });

    test('uses English only when settings are English', () {
      expect(
        resolveCommunicationsTranslationTarget(
          savedLocale: const Locale('en'),
          uiLocale: const Locale('hu'),
        ),
        'en',
      );
      expect(
        resolveCommunicationsTranslationTarget(
          savedLocale: null,
          uiLocale: const Locale('en'),
        ),
        'en',
      );
    });
  });

  group('customer sender language', () {
    test('resolves latest inbound originalLanguage', () {
      final messages = [
        CustomerCommunicationMessage(
          id: '1',
          threadId: 't',
          direction: CustomerCommunicationDirection.inbound,
          senderType: CustomerCommunicationSenderType.customer,
          originalText: 'Hello',
          originalLanguage: 'en',
        ),
        CustomerCommunicationMessage(
          id: '2',
          threadId: 't',
          direction: CustomerCommunicationDirection.outbound,
          senderType: CustomerCommunicationSenderType.platformAdmin,
          originalText: 'Reply',
          originalLanguage: 'hu',
        ),
        CustomerCommunicationMessage(
          id: '3',
          threadId: 't',
          direction: CustomerCommunicationDirection.inbound,
          senderType: CustomerCommunicationSenderType.customer,
          originalText: 'Guten Tag',
          originalLanguage: 'de-DE',
        ),
      ];
      expect(resolveCustomerSenderLanguage(messages), 'de');
      expect(latestInboundOriginalText(messages), 'Guten Tag');
    });
  });
}
