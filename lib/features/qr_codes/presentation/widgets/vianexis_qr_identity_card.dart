import 'dart:io';

import 'package:flutter/material.dart';

import 'package:vianexis_admin_app/core/widgets/vianexis_qr_code_view.dart';

/// Printable / shareable identity card wrapping a platform QR payload.
///
/// Mirrors the driver-app sofőr kártya layout: photo, basic fields, branded QR.
class VianexisQrIdentityCard extends StatelessWidget {
  const VianexisQrIdentityCard({
    super.key,
    required this.brandTitle,
    required this.displayName,
    required this.entityIdLabel,
    required this.roleLabel,
    required this.purposeLabel,
    required this.qrPayload,
    this.nameFieldLabel = 'Name',
    this.idFieldLabel = 'ID',
    this.roleFieldLabel = 'Role',
    this.purposeFieldLabel = 'Purpose',
    this.detailFieldLabel = 'Detail',
    this.subtitle,
    this.photoPath,
    this.compact = false,
    this.onQrTap,
    this.onPhotoTap,
  });

  final String brandTitle;
  final String displayName;
  final String entityIdLabel;
  final String roleLabel;
  final String purposeLabel;
  final String qrPayload;
  final String nameFieldLabel;
  final String idFieldLabel;
  final String roleFieldLabel;
  final String purposeFieldLabel;
  final String detailFieldLabel;
  final String? subtitle;
  final String? photoPath;
  final bool compact;
  final VoidCallback? onQrTap;
  final VoidCallback? onPhotoTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite
            ? constraints.maxWidth
            : 420.0;
        final qrSize = compact ? 76.0 : (width * 0.26).clamp(72.0, 104.0);
        final photoSize = compact ? 48.0 : (width * 0.15).clamp(46.0, 64.0);

        return Container(
          width: double.infinity,
          constraints: BoxConstraints(minHeight: compact ? 150 : 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF102A43), Color(0xFF1E6091), Color(0xFF4FA3E3)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF163B66).withValues(alpha: 0.25),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              Positioned(
                right: -20,
                bottom: -10,
                child: Opacity(
                  opacity: 0.08,
                  child: Text(
                    'VN',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: compact ? 100 : 130,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.all(compact ? 12 : 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            brandTitle,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.92),
                              fontWeight: FontWeight.w800,
                              fontSize: compact ? 11 : 12,
                            ),
                          ),
                          SizedBox(height: compact ? 6 : 8),
                          _photoAvatar(photoSize),
                          SizedBox(height: compact ? 6 : 8),
                          _infoLine(
                            nameFieldLabel,
                            displayName,
                            emphasize: true,
                          ),
                          if (subtitle != null && subtitle!.trim().isNotEmpty)
                            _infoLine(detailFieldLabel, subtitle!.trim()),
                          _infoLine(idFieldLabel, entityIdLabel),
                          _infoLine(roleFieldLabel, roleLabel),
                          _infoLine(purposeFieldLabel, purposeLabel),
                        ],
                      ),
                    ),
                    SizedBox(width: compact ? 6 : 8),
                    Padding(
                      padding: const EdgeInsets.only(top: 2),
                      child: _qrTile(qrSize),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _photoAvatar(double size) {
    final hasPhoto =
        photoPath != null &&
        photoPath!.trim().isNotEmpty &&
        File(photoPath!).existsSync();

    Widget imageChild;
    if (hasPhoto) {
      imageChild = Image.file(
        File(photoPath!),
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _defaultPhoto(size),
      );
    } else {
      imageChild = _defaultPhoto(size);
    }

    final avatar = ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(width: size, height: size, child: imageChild),
    );

    if (onPhotoTap == null) return avatar;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPhotoTap,
        borderRadius: BorderRadius.circular(10),
        child: avatar,
      ),
    );
  }

  Widget _defaultPhoto(double size) {
    return Container(
      color: Colors.white.withValues(alpha: 0.12),
      child: Center(
        child: Icon(
          Icons.badge_outlined,
          color: Colors.white.withValues(alpha: 0.9),
          size: size * 0.55,
        ),
      ),
    );
  }

  Widget _qrTile(double qrSize) {
    final qr = ColoredBox(
      color: Colors.white,
      child: VianexisQrCodeView(
        data: qrPayload,
        size: qrSize,
        padding: const EdgeInsets.all(6),
        embeddedLogoSize: (qrSize * 0.22).clamp(18.0, 28.0),
      ),
    );

    if (onQrTap == null) {
      return ClipRRect(borderRadius: BorderRadius.circular(12), child: qr);
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onQrTap,
        borderRadius: BorderRadius.circular(12),
        child: ClipRRect(borderRadius: BorderRadius.circular(12), child: qr),
      ),
    );
  }

  Widget _infoLine(String label, String value, {bool emphasize = false}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: RichText(
        maxLines: emphasize ? 2 : 1,
        overflow: TextOverflow.ellipsis,
        text: TextSpan(
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.9),
            fontSize: emphasize ? (compact ? 12 : 13) : (compact ? 10.5 : 11),
            height: 1.2,
          ),
          children: [
            TextSpan(
              text: '$label: ',
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            TextSpan(
              text: value,
              style: TextStyle(
                fontWeight: emphasize ? FontWeight.w900 : FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
