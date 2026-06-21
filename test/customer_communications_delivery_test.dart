import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/customer_message_delivery.dart';

void main() {
  group('CustomerMessageDelivery', () {
    test('parses skipped noop delivery', () {
      final delivery = CustomerMessageDelivery.fromJson({
        'id': 1,
        'threadId': 10,
        'messageId': 501,
        'deliveryChannel': 'email',
        'deliveryProvider': 'noop',
        'deliveryStatus': 'skipped',
        'humanConfirmed': true,
        'translationApproved': false,
        'metadataOnly': true,
      });

      expect(delivery.deliveryStatus, CustomerMessageDeliveryStatus.skipped);
      expect(delivery.isSkippedOrNoop, isTrue);
    });
  });
}
