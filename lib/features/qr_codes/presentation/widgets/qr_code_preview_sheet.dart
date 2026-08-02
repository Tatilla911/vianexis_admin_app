import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:vianexis_admin_app/core/localization/localization_resolver.dart';
import 'package:vianexis_admin_app/core/widgets/vianexis_qr_code_view.dart';

/// Full-size QR open / download / share sheet (QR only, no identity card chrome).
Future<void> showQrCodePreviewSheet(
  BuildContext context, {
  required String qrPayload,
  required String displayName,
  required int qrId,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (sheetContext) {
      return _QrCodePreviewSheet(
        qrPayload: qrPayload,
        displayName: displayName,
        qrId: qrId,
      );
    },
  );
}

class _QrCodePreviewSheet extends StatefulWidget {
  const _QrCodePreviewSheet({
    required this.qrPayload,
    required this.displayName,
    required this.qrId,
  });

  final String qrPayload;
  final String displayName;
  final int qrId;

  @override
  State<_QrCodePreviewSheet> createState() => _QrCodePreviewSheetState();
}

class _QrCodePreviewSheetState extends State<_QrCodePreviewSheet> {
  final GlobalKey _boundaryKey = GlobalKey();
  bool _busy = false;

  Future<File?> _capturePng() async {
    final boundary =
        _boundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (bytes == null) return null;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/vianexis-qr-only-${widget.qrId}.png');
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    return file;
  }

  Future<void> _share() async {
    setState(() => _busy = true);
    try {
      final file = await _capturePng();
      if (file == null) return;
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: '${widget.displayName}\n${widget.qrPayload}',
        subject: widget.displayName,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _save() async {
    setState(() => _busy = true);
    try {
      final file = await _capturePng();
      if (file == null || !mounted) return;
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: resolveQrCodesKey(context, 'qrCodesSave'),
        subject: widget.displayName,
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveQrCodesKey(context, 'qrCodesQrSaved'))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.paddingOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(16, 12, 16, bottom + 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  resolveQrCodesKey(context, 'qrCodesOpenQr'),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close),
              ),
            ],
          ),
          const SizedBox(height: 8),
          RepaintBoundary(
            key: _boundaryKey,
            child: VianexisQrCodeView(data: widget.qrPayload, size: 280),
          ),
          const SizedBox(height: 8),
          Text(
            widget.displayName,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: _busy ? null : _share,
                icon: const Icon(Icons.ios_share),
                label: Text(resolveQrCodesKey(context, 'qrCodesShare')),
              ),
              OutlinedButton.icon(
                onPressed: _busy ? null : _save,
                icon: const Icon(Icons.download),
                label: Text(resolveQrCodesKey(context, 'qrCodesSave')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
