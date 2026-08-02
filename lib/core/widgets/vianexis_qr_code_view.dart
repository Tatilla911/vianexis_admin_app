import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../app/vianexis_brand.dart';

/// ViaNexis-branded QR code with the admin blue mark centered.
///
/// Uses high error correction so scanners tolerate the embedded logo.
class VianexisQrCodeView extends StatelessWidget {
  const VianexisQrCodeView({
    super.key,
    required this.data,
    this.size = 220,
    this.padding = const EdgeInsets.all(12),
    this.backgroundColor = Colors.white,
    this.embeddedLogoSize,
  });

  final String data;
  final double size;
  final EdgeInsetsGeometry padding;
  final Color backgroundColor;

  /// Logo box size; defaults to ~20% of [size] for scannability.
  final double? embeddedLogoSize;

  @override
  Widget build(BuildContext context) {
    final logoSize = embeddedLogoSize ?? (size * 0.2).clamp(36.0, 56.0);
    return ColoredBox(
      color: backgroundColor,
      child: Padding(
        padding: padding,
        child: QrImageView(
          data: data,
          size: size,
          backgroundColor: backgroundColor,
          version: QrVersions.auto,
          errorCorrectionLevel: QrErrorCorrectLevel.H,
          eyeStyle: const QrEyeStyle(
            eyeShape: QrEyeShape.square,
            color: Color(0xFF152536),
          ),
          dataModuleStyle: const QrDataModuleStyle(
            dataModuleShape: QrDataModuleShape.square,
            color: Color(0xFF152536),
          ),
          embeddedImage: const AssetImage(VianexisBrand.markAsset),
          embeddedImageStyle: QrEmbeddedImageStyle(
            size: Size(logoSize, logoSize),
          ),
          embeddedImageEmitsError: false,
        ),
      ),
    );
  }
}
