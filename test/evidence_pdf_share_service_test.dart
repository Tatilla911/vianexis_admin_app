import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/customer_communications/services/evidence_pdf_bytes.dart';
import 'package:vianexis_admin_app/features/customer_communications/services/evidence_pdf_share_service.dart';

void main() {
  const service = EvidencePdfShareService();

  group('EvidencePdfShareService validation', () {
    test('throws empty when bytes are empty', () {
      expect(
        () => service.sharePdfBytes(bytes: [], packageId: '1'),
        throwsA(EvidencePdfShareFailure.empty),
      );
    });

    test('throws invalid when bytes are not a PDF', () {
      expect(
        () => service.sharePdfBytes(bytes: [1, 2, 3], packageId: '1'),
        throwsA(EvidencePdfShareFailure.invalid),
      );
    });
  });
}
