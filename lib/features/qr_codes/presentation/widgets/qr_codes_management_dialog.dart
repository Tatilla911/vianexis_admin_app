import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/api_exception_feedback.dart';
import 'package:vianexis_admin_app/core/localization/localization_resolver.dart';
import 'package:vianexis_admin_app/core/widgets/vianexis_confirm_dialog.dart';
import 'package:vianexis_admin_app/core/widgets/vianexis_qr_code_view.dart';
import 'package:vianexis_admin_app/features/qr_codes/data/qr_codes_repository.dart';
import 'package:vianexis_admin_app/features/qr_codes/domain/platform_qr_code.dart';

Future<void> showQrCodesManagementDialog(
  BuildContext context, {
  required String entityType,
  required int entityId,
  required String displayName,
  required List<QrPurpose> allowedPurposes,
  int? companyId,
  String? titleKey,
}) {
  return showDialog<void>(
    context: context,
    builder: (context) => QrCodesManagementDialog(
      entityType: entityType,
      entityId: entityId,
      displayName: displayName,
      allowedPurposes: allowedPurposes,
      companyId: companyId,
      titleKey: titleKey ?? 'qrCodesTitle',
    ),
  );
}

class QrCodesManagementDialog extends ConsumerStatefulWidget {
  const QrCodesManagementDialog({
    super.key,
    required this.entityType,
    required this.entityId,
    required this.displayName,
    required this.allowedPurposes,
    this.companyId,
    this.titleKey = 'qrCodesTitle',
  });

  final String entityType;
  final int entityId;
  final String displayName;
  final List<QrPurpose> allowedPurposes;
  final int? companyId;
  final String titleKey;

  @override
  ConsumerState<QrCodesManagementDialog> createState() =>
      _QrCodesManagementDialogState();
}

class _QrCodesManagementDialogState
    extends ConsumerState<QrCodesManagementDialog> {
  final GlobalKey _qrBoundaryKey = GlobalKey();
  late QrPurpose _purpose;
  bool _loading = true;
  bool _busy = false;
  String? _error;
  List<PlatformQrCode> _history = const [];
  PlatformQrCode? _preview;

  @override
  void initState() {
    super.initState();
    _purpose = widget.allowedPurposes.first;
    _reload();
  }

  Future<void> _reload() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final items = await ref
          .read(qrCodesRepositoryProvider)
          .list(entityType: widget.entityType, entityId: widget.entityId);
      if (!mounted) return;
      setState(() {
        _history = items;
        _loading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = error.toString();
      });
    }
  }

  Future<void> _create() async {
    setState(() => _busy = true);
    try {
      final created = await ref
          .read(qrCodesRepositoryProvider)
          .create(
            CreatePlatformQrRequest(
              entityType: widget.entityType,
              entityId: widget.entityId,
              displayName: widget.displayName,
              purpose: _purpose.apiValue,
              companyId: widget.companyId,
              locale: Localizations.localeOf(context).languageCode,
            ),
          );
      if (!mounted) return;
      setState(() => _preview = created);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveQrCodesKey(context, 'qrCodesCreateSuccess'))),
      );
      await _reload();
    } catch (error) {
      if (!mounted) return;
      if (error is ApiException) {
        showApiExceptionSnackBar(context, error);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(error.toString())));
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _revoke(PlatformQrCode item) async {
    final confirmed = await showVianexisConfirmDialog(
      context: context,
      title: resolveQrCodesKey(context, 'qrCodesRevoke'),
      body: item.displayName,
      isDestructive: true,
    );
    if (confirmed != true) return;
    setState(() => _busy = true);
    try {
      await ref.read(qrCodesRepositoryProvider).revoke(item.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveQrCodesKey(context, 'qrCodesRevokeSuccess'))),
      );
      if (_preview?.id == item.id) setState(() => _preview = null);
      await _reload();
    } catch (error) {
      if (!mounted) return;
      if (error is ApiException) {
        showApiExceptionSnackBar(context, error);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _regenerate(PlatformQrCode item) async {
    setState(() => _busy = true);
    try {
      final created = await ref
          .read(qrCodesRepositoryProvider)
          .regenerate(item.id);
      if (!mounted) return;
      setState(() => _preview = created);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolveQrCodesKey(context, 'qrCodesRegenerateSuccess')),
        ),
      );
      await _reload();
    } catch (error) {
      if (!mounted) return;
      if (error is ApiException) {
        showApiExceptionSnackBar(context, error);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _copyLink(PlatformQrCode item) async {
    final link = item.displayPayload;
    if (link == null || link.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: link));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(resolveQrCodesKey(context, 'qrCodesLinkCopied'))),
    );
  }

  Future<void> _sharePng(PlatformQrCode item) async {
    final link = item.displayPayload;
    if (link == null) return;
    final boundary =
        _qrBoundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) {
      await Share.share(link, subject: item.displayName);
      return;
    }
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    if (bytes == null) return;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/vianexis-qr-${item.id}.png');
    await file.writeAsBytes(bytes.buffer.asUint8List());
    await Share.shareXFiles([
      XFile(file.path),
    ], text: '${item.displayName}\n$link');
  }

  @override
  Widget build(BuildContext context) {
    final preview = _preview;
    final isStaging = preview?.environment == 'staging';
    return AlertDialog(
      title: Text(resolveQrCodesKey(context, widget.titleKey)),
      content: SizedBox(
        width: 460,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                '${resolveQrCodesKey(context, 'qrCodesTargetSummary')}: ${widget.displayName}',
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<QrPurpose>(
                // ignore: deprecated_member_use
                value: _purpose,
                decoration: InputDecoration(
                  labelText: resolveQrCodesKey(context, 'qrCodesPurposeLabel'),
                ),
                items: widget.allowedPurposes
                    .map(
                      (purpose) => DropdownMenuItem(
                        value: purpose,
                        child: Text(
                          resolveQrCodesKey(context, purpose.l10nKey),
                        ),
                      ),
                    )
                    .toList(),
                onChanged: _busy
                    ? null
                    : (value) {
                        if (value != null) setState(() => _purpose = value);
                      },
              ),
              const SizedBox(height: 12),
              FilledButton(
                onPressed: _busy ? null : _create,
                child: Text(resolveQrCodesKey(context, 'qrCodesCreate')),
              ),
              if (preview?.displayPayload != null) ...[
                const SizedBox(height: 16),
                if (isStaging)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                      resolveQrCodesKey(context, 'qrCodesStagingBadge'),
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.error,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                Center(
                  child: RepaintBoundary(
                    key: _qrBoundaryKey,
                    child: VianexisQrCodeView(
                      data: preview!.displayPayload!,
                      size: 220,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  resolveQrCodesKey(context, preview.purpose != null
                      ? (QrPurpose.tryParse(preview.purpose)?.l10nKey ??
                            'qrCodesTitle')
                      : 'qrCodesTitle'),
                  textAlign: TextAlign.center,
                ),
                if (preview.expiresAt != null)
                  Text(
                    '${resolveQrCodesKey(context, 'qrCodesExpiresLabel')}: ${DateFormat.yMMMd().add_Hm().format(preview.expiresAt!.toLocal())}',
                    textAlign: TextAlign.center,
                  ),
                Text(
                  resolveQrCodesKey(context, 'qrCodesSecurityWarning'),
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  alignment: WrapAlignment.center,
                  children: [
                    OutlinedButton(
                      onPressed: _busy ? null : () => _copyLink(preview),
                      child: Text(
                        resolveQrCodesKey(context, 'qrCodesCopyLink'),
                      ),
                    ),
                    OutlinedButton(
                      onPressed: _busy ? null : () => _sharePng(preview),
                      child: Text(resolveQrCodesKey(context, 'qrCodesShare')),
                    ),
                    OutlinedButton(
                      onPressed: _busy ? null : () => _sharePng(preview),
                      child: Text(resolveQrCodesKey(context, 'qrCodesSave')),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 16),
              Text(
                resolveQrCodesKey(context, 'qrCodesHistory'),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              if (_loading)
                const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                )
              else if (_error != null)
                Text(_error!)
              else if (_history.isEmpty)
                Text(resolveQrCodesKey(context, 'qrCodesEmptyHistory'))
              else
                ..._history.take(8).map((item) {
                  final statusKey = switch (item.status) {
                    'expired' => 'qrCodesStatusExpired',
                    'consumed' => 'qrCodesStatusConsumed',
                    'revoked' => 'qrCodesStatusRevoked',
                    _ => 'qrCodesStatusActive',
                  };
                  return ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(
                      resolveQrCodesKey(
                        context,
                        QrPurpose.tryParse(item.purpose)?.l10nKey ??
                            'qrCodesTitle',
                      ),
                    ),
                    subtitle: Text(
                      '${resolveQrCodesKey(context, statusKey)} · ${resolveQrCodesKey(context, 'qrCodesUsedCount')}: ${item.usedCount}',
                    ),
                    trailing: Wrap(
                      spacing: 4,
                      children: [
                        IconButton(
                          tooltip: resolveQrCodesKey(context, 'qrCodesRegenerate'),
                          onPressed: _busy ? null : () => _regenerate(item),
                          icon: const Icon(Icons.refresh),
                        ),
                        IconButton(
                          tooltip: resolveQrCodesKey(context, 'qrCodesRevoke'),
                          onPressed: _busy || item.status == 'revoked'
                              ? null
                              : () => _revoke(item),
                          icon: const Icon(Icons.block),
                        ),
                      ],
                    ),
                    onTap: () => setState(() => _preview = item),
                  );
                }),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(resolveQrCodesKey(context, 'qrCodesClose')),
        ),
      ],
    );
  }
}
