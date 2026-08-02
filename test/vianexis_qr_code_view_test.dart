import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:vianexis_admin_app/app/vianexis_brand.dart';
import 'package:vianexis_admin_app/core/widgets/vianexis_qr_code_view.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('embeds ViaNexis admin blue mark in QR center', (tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: Scaffold(
          body: Center(
            child: VianexisQrCodeView(
              data: 'https://vianexis.eu/q/test-opaque-code',
              size: 200,
            ),
          ),
        ),
      ),
    );
    await tester.pump();

    final qr = tester.widget<QrImageView>(find.byType(QrImageView));
    expect(qr.errorCorrectionLevel, QrErrorCorrectLevel.H);
    expect(qr.embeddedImage, isA<AssetImage>());
    expect(
      (qr.embeddedImage! as AssetImage).assetName,
      VianexisBrand.markAsset,
    );
    expect(qr.embeddedImageStyle?.size, isNotNull);
    expect(qr.embeddedImageStyle!.size!.width, greaterThan(30));
  });
}
