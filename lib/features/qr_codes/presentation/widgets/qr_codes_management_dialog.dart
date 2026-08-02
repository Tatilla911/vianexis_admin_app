import 'dart:io';
import 'dart:ui' as ui;

import 'package:file_picker/file_picker.dart';
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
import 'package:vianexis_admin_app/features/qr_codes/data/qr_codes_repository.dart';
import 'package:vianexis_admin_app/features/qr_codes/domain/platform_qr_code.dart';
import 'package:vianexis_admin_app/features/qr_codes/presentation/widgets/qr_code_preview_sheet.dart';
import 'package:vianexis_admin_app/features/qr_codes/presentation/widgets/vianexis_qr_identity_card.dart';

Future<void> showQrCodesManagementDialog(
  BuildContext context, {
  required String entityType,
  required int entityId,
  required String displayName,
  required List<QrPurpose> allowedPurposes,
  int? companyId,
  String? titleKey,
  String? subtitle,
  String? roleLabel,
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
      subtitle: subtitle,
      roleLabel: roleLabel,
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
    this.subtitle,
    this.roleLabel,
  });

  final String entityType;
  final int entityId;
  final String displayName;
  final List<QrPurpose> allowedPurposes;
  final int? companyId;
  final String titleKey;
  final String? subtitle;
  final String? roleLabel;

  @override
  ConsumerState<QrCodesManagementDialog> createState() =>
      _QrCodesManagementDialogState();
}

class _QrCodesManagementDialogState
    extends ConsumerState<QrCodesManagementDialog> {
  final GlobalKey _cardBoundaryKey = GlobalKey();
  late QrPurpose _purpose;
  bool _loading = true;
  bool _busy = false;
  String? _error;
  List<PlatformQrCode> _history = const [];
  PlatformQrCode? _preview;
  String? _photoPath;

  @override
  void initState() {
    super.initState();
    _purpose = widget.allowedPurposes.first;
    _reload();
  }

  String get _roleLabel {
    if (widget.roleLabel != null && widget.roleLabel!.trim().isNotEmpty) {
      return widget.roleLabel!.trim();
    }
    return switch (widget.entityType) {
      'driver' => resolveQrCodesKey(context, 'qrCodesRoleDriver'),
      'company' => resolveQrCodesKey(context, 'qrCodesRoleCompany'),
      'user' || 'company_admin' => resolveQrCodesKey(context, 'qrCodesRoleUser'),
      _ => widget.entityType,
    };
  }

  String get _brandTitle {
    return switch (widget.entityType) {
      'driver' => resolveQrCodesKey(context, 'qrCodesCardBrandDriver'),
      'company' => resolveQrCodesKey(context, 'qrCodesCardBrandCompany'),
      _ => resolveQrCodesKey(context, 'qrCodesCardBrandUser'),
    };
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
      PlatformQrCode? autoPreview = _preview;
      if (autoPreview == null) {
        for (final item in items) {
          if (item.status == 'active' &&
              (item.displayPayload?.isNotEmpty ?? false)) {
            autoPreview = item;
            break;
          }
        }
        autoPreview ??= items.isNotEmpty ? items.first : null;
      }
      setState(() {
        _history = items;
        _loading = false;
        _preview = autoPreview;
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
        SnackBar(
          content: Text(resolveQrCodesKey(context, 'qrCodesCreateSuccess')),
        ),
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
        SnackBar(
          content: Text(resolveQrCodesKey(context, 'qrCodesRevokeSuccess')),
        ),
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

  Future<void> _pickPhoto() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: false,
    );
    final path = result?.files.single.path;
    if (path == null || path.isEmpty) return;
    setState(() => _photoPath = path);
  }

  Future<File?> _captureCardPng(PlatformQrCode item) async {
    final boundary =
        _cardBoundaryKey.currentContext?.findRenderObject()
            as RenderRepaintBoundary?;
    if (boundary == null) return null;
    final image = await boundary.toImage(pixelRatio: 3);
    final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (bytes == null) return null;
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/vianexis-id-card-${item.id}.png');
    await file.writeAsBytes(bytes.buffer.asUint8List(), flush: true);
    return file;
  }

  Future<void> _shareCard(PlatformQrCode item) async {
    setState(() => _busy = true);
    try {
      final link = item.displayPayload ?? '';
      final file = await _captureCardPng(item);
      if (file == null) {
        if (link.isNotEmpty) {
          await Share.share(link, subject: item.displayName);
        }
        return;
      }
      if (!mounted) return;
      final subject = resolveQrCodesKey(context, 'qrCodesShareCard');
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        text: '${item.displayName}\n$link',
        subject: subject,
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _saveCard(PlatformQrCode item) async {
    setState(() => _busy = true);
    try {
      final file = await _captureCardPng(item);
      if (file == null || !mounted) return;
      await Share.shareXFiles(
        [XFile(file.path, mimeType: 'image/png')],
        subject: resolveQrCodesKey(context, 'qrCodesSaveCard'),
      );
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveQrCodesKey(context, 'qrCodesCardSaved'))),
      );
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _openQr(PlatformQrCode item) async {
    final payload = item.displayPayload;
    if (payload == null || payload.isEmpty) return;
    await showQrCodePreviewSheet(
      context,
      qrPayload: payload,
      displayName: item.displayName,
      qrId: item.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final preview = _preview;
    final payload = preview?.displayPayload;
    final isStaging = preview?.environment == 'staging';
    final purposeLabel = resolveQrCodesKey(
      context,
      preview?.purpose != null
          ? (QrPurpose.tryParse(preview!.purpose)?.l10nKey ?? 'qrCodesTitle')
          : _purpose.l10nKey,
    );

    return AlertDialog(
      title: Text(resolveQrCodesKey(context, widget.titleKey)),
      content: SizedBox(
        width: 520,
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
              if (preview != null && payload != null && payload.isNotEmpty) ...[
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
                Text(
                  resolveQrCodesKey(context, 'qrCodesIdentityCard'),
                  style: Theme.of(context).textTheme.titleSmall,
                ),
                const SizedBox(height: 8),
                RepaintBoundary(
                  key: _cardBoundaryKey,
                  child: VianexisQrIdentityCard(
                    brandTitle: _brandTitle,
                    displayName: widget.displayName,
                    subtitle: widget.subtitle,
                    entityIdLabel: '${widget.entityId}',
                    roleLabel: _roleLabel,
                    purposeLabel: purposeLabel,
                    qrPayload: payload,
                    photoPath: _photoPath,
                    nameFieldLabel: resolveQrCodesKey(
                      context,
                      'qrCodesCardFieldName',
                    ),
                    idFieldLabel: resolveQrCodesKey(
                      context,
                      'qrCodesCardFieldId',
                    ),
                    roleFieldLabel: resolveQrCodesKey(
                      context,
                      'qrCodesCardFieldRole',
                    ),
                    purposeFieldLabel: resolveQrCodesKey(
                      context,
                      'qrCodesCardFieldPurpose',
                    ),
                    detailFieldLabel: resolveQrCodesKey(
                      context,
                      'qrCodesCardFieldDetail',
                    ),
                    onQrTap: () => _openQr(preview),
                  ),
                ),
                if (preview.expiresAt != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    '${resolveQrCodesKey(context, 'qrCodesExpiresLabel')}: ${DateFormat.yMMMd().add_Hm().format(preview.expiresAt!.toLocal())}',
                    textAlign: TextAlign.center,
                  ),
                ],
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
                    OutlinedButton.icon(
                      onPressed: _busy ? null : _pickPhoto,
                      icon: const Icon(Icons.add_a_photo_outlined),
                      label: Text(
                        resolveQrCodesKey(
                          context,
                          _photoPath == null
                              ? 'qrCodesAttachPhoto'
                              : 'qrCodesChangePhoto',
                        ),
                      ),
                    ),
                    if (_photoPath != null)
                      OutlinedButton.icon(
                        onPressed: _busy
                            ? null
                            : () => setState(() => _photoPath = null),
                        icon: const Icon(Icons.hide_image_outlined),
                        label: Text(
                          resolveQrCodesKey(context, 'qrCodesRemovePhoto'),
                        ),
                      ),
                    OutlinedButton.icon(
                      onPressed: _busy ? null : () => _shareCard(preview),
                      icon: const Icon(Icons.ios_share),
                      label: Text(
                        resolveQrCodesKey(context, 'qrCodesShareCard'),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _busy ? null : () => _saveCard(preview),
                      icon: const Icon(Icons.download),
                      label: Text(
                        resolveQrCodesKey(context, 'qrCodesSaveCard'),
                      ),
                    ),
                    OutlinedButton.icon(
                      onPressed: _busy ? null : () => _openQr(preview),
                      icon: const Icon(Icons.qr_code_2),
                      label: Text(resolveQrCodesKey(context, 'qrCodesOpenQr')),
                    ),
                    OutlinedButton(
                      onPressed: _busy ? null : () => _copyLink(preview),
                      child: Text(
                        resolveQrCodesKey(context, 'qrCodesCopyLink'),
                      ),
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
                          tooltip: resolveQrCodesKey(
                            context,
                            'qrCodesRegenerate',
                          ),
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
