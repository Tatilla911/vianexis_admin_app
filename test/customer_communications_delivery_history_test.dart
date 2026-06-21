import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vianexis_admin_app/features/customer_communications/domain/customer_delivery_models.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/customer_message_delivery.dart';
import 'package:vianexis_admin_app/features/customer_communications/presentation/widgets/delivery_history_section.dart';
import 'package:vianexis_admin_app/features/customer_communications/presentation/widgets/delivery_status_badge.dart';
import 'package:vianexis_admin_app/features/customer_communications/presentation/widgets/resend_customer_reply_dialog.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  test('parses resend delivery metadata', () {
    final delivery = CustomerMessageDelivery.fromJson({
      'id': 2,
      'threadId': 10,
      'messageId': 501,
      'deliveryChannel': 'email',
      'deliveryProvider': 'noop',
      'deliveryStatus': 'skipped',
      'resendOfDeliveryId': 1,
      'emailTemplateKey': 'customer_admin_reply',
      'emailTemplateVersion': '1.0.0',
      'humanConfirmed': true,
      'metadataOnly': true,
    });

    expect(delivery.isResendAttempt, isTrue);
    expect(delivery.emailTemplateKey, 'customer_admin_reply');
  });

  test('delivery filter maps backend status', () {
    expect(
      CustomerDeliveryHistoryFilter.skipped.backendStatusValue(),
      'skipped',
    );
    expect(CustomerDeliveryHistoryFilter.all.backendStatusValue(), isNull);
  });

  testWidgets('delivery badge renders skipped state', (tester) async {
    await tester.pumpWidget(
      _wrap(
        DeliveryStatusBadge(
          delivery: CustomerMessageDelivery(
            id: '1',
            threadId: '10',
            deliveryChannel: CustomerMessageDeliveryChannel.email,
            deliveryProvider: 'noop',
            deliveryStatus: CustomerMessageDeliveryStatus.skipped,
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Skipped'), findsOneWidget);
  });

  testWidgets('resend dialog requires reason and confirmation', (tester) async {
    await tester.pumpWidget(
      _wrap(const ResendCustomerReplyDialog(providerDisabled: true)),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('Resending creates'), findsOneWidget);
    expect(find.textContaining('Delivery provider disabled'), findsOneWidget);
  });

  testWidgets('delivery history empty state renders', (tester) async {
    await tester.pumpWidget(
      _wrap(
        const DeliveryHistorySection(
          threadId: '10',
          deliveries: [],
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(find.textContaining('No delivery attempts'), findsOneWidget);
  });
}
