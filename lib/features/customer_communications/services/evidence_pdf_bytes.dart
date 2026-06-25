/// Validates evidence PDF byte payloads before share/export.
abstract final class EvidencePdfBytes {
  static const pdfMagic = '%PDF';

  static bool isValidPdf(List<int> bytes) {
    if (bytes.isEmpty) return false;
    if (bytes.length < 4) return false;
    return String.fromCharCodes(bytes.take(4)) == pdfMagic;
  }

  static String safeFileName(String packageId) {
    final sanitized = packageId.replaceAll(RegExp(r'[^a-zA-Z0-9_-]'), '_');
    final base = sanitized.isEmpty ? 'package' : sanitized;
    return 'vianexis_evidence_$base.pdf';
  }
}

enum EvidencePdfShareFailure {
  empty,
  invalid,
  shareUnavailable,
}
