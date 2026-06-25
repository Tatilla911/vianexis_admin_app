import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/customer_communications/services/evidence_pdf_bytes.dart';

void main() {
  group('EvidencePdfBytes', () {
    test('validates PDF magic header', () {
      final bytes = '%PDF-1.4\n%'.codeUnits;
      expect(EvidencePdfBytes.isValidPdf(bytes), isTrue);
    });

    test('rejects empty bytes', () {
      expect(EvidencePdfBytes.isValidPdf([]), isFalse);
    });

    test('rejects invalid header', () {
      expect(EvidencePdfBytes.isValidPdf([1, 2, 3, 4]), isFalse);
    });

    test('sanitizes package id in filename', () {
      expect(
        EvidencePdfBytes.safeFileName('pkg/99'),
        'vianexis_evidence_pkg_99.pdf',
      );
    });
  });
}
