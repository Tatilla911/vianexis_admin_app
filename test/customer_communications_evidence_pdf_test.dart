import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/customer_communications/domain/customer_evidence_package.dart';
import 'package:vianexis_admin_app/features/customer_communications/presentation/widgets/evidence_package_card.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    home: Scaffold(body: child),
  );
}

void main() {
  group('CustomerEvidencePackage PDF states', () {
    test('pdf ready when backend sets pdfReady and fileUrl', () {
      final pkg = CustomerEvidencePackage.fromJson({
        'id': 1,
        'threadId': 2,
        'packageType': 'communication_evidence',
        'status': 'generated',
        'fileUrl':
            '/platform-admin/customer-communications/2/evidence-packages/1/download',
        'fileHash': 'abc',
        'pdfReady': true,
        'pdfRendererPending': false,
      });

      expect(pkg.isPdfReady, isTrue);
      expect(pkg.isPdfPending, isFalse);
      expect(pkg.isPdfFailed, isFalse);
      expect(pkg.canDownload, isTrue);
    });

    test('pdf pending when fileUrl is null', () {
      final pkg = CustomerEvidencePackage.fromJson({
        'id': 1,
        'threadId': 2,
        'packageType': 'communication_evidence',
        'status': 'generated',
        'fileUrl': null,
        'pdfRendererPending': true,
      });

      expect(pkg.isPdfPending, isTrue);
      expect(pkg.canDownload, isFalse);
    });

    test('pdf failed when status failed without fileUrl', () {
      final pkg = CustomerEvidencePackage.fromJson({
        'id': 1,
        'threadId': 2,
        'packageType': 'communication_evidence',
        'status': 'failed',
        'fileUrl': null,
        'pdfRendererPending': true,
      });

      expect(pkg.isPdfFailed, isTrue);
      expect(pkg.isPdfPending, isFalse);
      expect(pkg.canDownload, isFalse);
    });
  });

  group('EvidencePackageCard', () {
    testWidgets('shows download-ready notice when pdf ready', (tester) async {
      const pkg = CustomerEvidencePackage(
        id: '1',
        threadId: '2',
        packageType: CustomerEvidencePackageType.communicationEvidence,
        status: CustomerEvidencePackageStatus.generated,
        fileUrl:
            '/platform-admin/customer-communications/2/evidence-packages/1/download',
        fileHash: 'hash',
        pdfReady: true,
      );

      await tester.pumpWidget(
        _wrap(EvidencePackageCard(package: pkg, threadId: '2')),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('PDF evidence package is ready'), findsOneWidget);
    });

    testWidgets('does not crash when fileUrl is null', (tester) async {
      const pkg = CustomerEvidencePackage(
        id: '1',
        threadId: '2',
        packageType: CustomerEvidencePackageType.communicationEvidence,
        status: CustomerEvidencePackageStatus.generated,
      );

      await tester.pumpWidget(
        _wrap(EvidencePackageCard(package: pkg, threadId: '2')),
      );
      await tester.pumpAndSettle();

      expect(find.textContaining('PDF rendering pending'), findsOneWidget);
    });
  });
}
