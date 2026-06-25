import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'evidence_pdf_bytes.dart';

/// Writes evidence PDF bytes to a temp file and opens the platform share sheet.
class EvidencePdfShareService {
  const EvidencePdfShareService();

  Future<void> sharePdfBytes({
    required List<int> bytes,
    required String packageId,
    String? shareSubject,
  }) async {
    if (bytes.isEmpty) {
      throw EvidencePdfShareFailure.empty;
    }
    if (!EvidencePdfBytes.isValidPdf(bytes)) {
      throw EvidencePdfShareFailure.invalid;
    }

    if (kIsWeb) {
      await Share.shareXFiles(
        [
          XFile.fromData(
            Uint8List.fromList(bytes),
            mimeType: 'application/pdf',
            name: EvidencePdfBytes.safeFileName(packageId),
          ),
        ],
        subject: shareSubject,
      );
      return;
    }

    final directory = await getTemporaryDirectory();
    final file = File(
      '${directory.path}${Platform.pathSeparator}${EvidencePdfBytes.safeFileName(packageId)}',
    );
    await file.writeAsBytes(bytes, flush: true);

    final result = await Share.shareXFiles(
      [XFile(file.path, mimeType: 'application/pdf')],
      subject: shareSubject,
    );

    if (result.status == ShareResultStatus.unavailable) {
      throw EvidencePdfShareFailure.shareUnavailable;
    }
  }
}
