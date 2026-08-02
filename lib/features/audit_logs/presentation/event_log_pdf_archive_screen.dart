import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/widgets/vianexis_confirm_dialog.dart';
import '../../../l10n/app_localizations.dart';
import '../services/audit_log_pdf_service.dart';
import 'audit_log_providers.dart';

final eventLogPdfArchiveStoreProvider = Provider<EventLogPdfArchiveStore>(
  (ref) => EventLogPdfArchiveStore(),
);

final eventLogPdfArchiveListProvider =
    FutureProvider.autoDispose<List<EventLogPdfArchiveEntry>>((ref) {
      return ref.watch(eventLogPdfArchiveStoreProvider).list();
    });

/// Separate section: store event logs as ViaNexis PDFs, open/zoom/share/delete.
class EventLogPdfArchiveScreen extends ConsumerStatefulWidget {
  const EventLogPdfArchiveScreen({super.key});

  @override
  ConsumerState<EventLogPdfArchiveScreen> createState() =>
      _EventLogPdfArchiveScreenState();
}

class _EventLogPdfArchiveScreenState
    extends ConsumerState<EventLogPdfArchiveScreen> {
  bool _generating = false;

  Future<void> _generateFromCurrentFilter() async {
    final l10n = AppLocalizations.of(context);
    setState(() => _generating = true);
    try {
      final logsAsync = ref.read(filteredPlatformAuditLogsProvider);
      final logs = logsAsync.asData?.value;
      if (logs == null) {
        throw StateError('logs unavailable');
      }
      final bytes = await const AuditLogPdfService().buildEventLogPdf(
        logs: logs,
        title: l10n.eventLogPdfTitle,
        subtitle: l10n.eventLogPdfSubtitle,
        generatedLabel: l10n.eventLogPdfGeneratedAt(
          DateFormat.yMMMd().add_Hm().format(DateTime.now()),
        ),
        emptyLabel: l10n.eventLogPdfEmpty,
      );
      await ref
          .read(eventLogPdfArchiveStoreProvider)
          .savePdf(
            bytes: bytes,
            title: l10n.eventLogPdfTitle,
            entryCount: logs.length,
          );
      ref.invalidate(eventLogPdfArchiveListProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.eventLogPdfSaved)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.eventLogPdfSaveFailed)),
      );
    } finally {
      if (mounted) setState(() => _generating = false);
    }
  }

  Future<void> _deleteEntry(EventLogPdfArchiveEntry entry) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showVianexisConfirmDialog(
      context: context,
      title: l10n.eventLogPdfDeleteTitle,
      body: l10n.eventLogPdfDeleteBody(entry.fileName),
      confirmLabel: l10n.eventLogPdfDeleteConfirm,
      isDestructive: true,
    );
    if (confirmed != true) return;
    await ref.read(eventLogPdfArchiveStoreProvider).delete(entry.id);
    ref.invalidate(eventLogPdfArchiveListProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.eventLogPdfDeleted)),
    );
  }

  Future<void> _deleteAllActivities() async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showVianexisConfirmDialog(
      context: context,
      title: l10n.eventLogPdfDeleteAllTitle,
      body: l10n.eventLogPdfDeleteAllBody,
      confirmLabel: l10n.eventLogPdfDeleteConfirm,
      isDestructive: true,
    );
    if (confirmed != true) return;
    await ref.read(eventLogPdfArchiveStoreProvider).deleteAll();
    ref.invalidate(eventLogPdfArchiveListProvider);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.eventLogPdfDeleted)),
    );
  }

  Future<void> _openEntry(EventLogPdfArchiveEntry entry) async {
    final store = ref.read(eventLogPdfArchiveStoreProvider);
    final bytes = await store.readBytes(entry);
    if (!mounted) return;
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => EventLogPdfViewerScreen(
          title: entry.title ?? entry.fileName,
          bytes: bytes,
          fileName: entry.fileName,
        ),
      ),
    );
  }

  Future<void> _shareEntry(EventLogPdfArchiveEntry entry) async {
    final l10n = AppLocalizations.of(context);
    try {
      await Share.shareXFiles([
        XFile(entry.filePath, mimeType: 'application/pdf', name: entry.fileName),
      ], subject: entry.title ?? l10n.eventLogPdfTitle);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.eventLogPdfShareFailed)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final archiveAsync = ref.watch(eventLogPdfArchiveListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.eventLogPdfArchiveTitle),
        actions: [
          IconButton(
            tooltip: l10n.eventLogPdfDeleteAllTitle,
            onPressed: _deleteAllActivities,
            icon: const Icon(Icons.delete_sweep_outlined),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _generating ? null : _generateFromCurrentFilter,
        icon: _generating
            ? const SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : const Icon(Icons.picture_as_pdf_outlined),
        label: Text(l10n.eventLogPdfGenerate),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.eventLogPdfArchiveBody,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          Expanded(
            child: archiveAsync.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (_, __) =>
                  Center(child: Text(l10n.eventLogPdfArchiveLoadFailed)),
              data: (entries) {
                if (entries.isEmpty) {
                  return Center(child: Text(l10n.eventLogPdfArchiveEmpty));
                }
                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 96),
                  itemCount: entries.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final entry = entries[index];
                    final created = DateFormat.yMMMd(
                      Localizations.localeOf(context).toString(),
                    ).add_Hm().format(entry.createdAt.toLocal());
                    return Card(
                      child: ListTile(
                        leading: const Icon(Icons.picture_as_pdf_outlined),
                        title: Text(entry.title ?? entry.fileName),
                        subtitle: Text(
                          '$created · ${l10n.eventLogPdfEntryCount(entry.entryCount)}',
                        ),
                        onTap: () => _openEntry(entry),
                        trailing: Wrap(
                          spacing: 4,
                          children: [
                            IconButton(
                              tooltip: l10n.eventLogPdfShare,
                              onPressed: () => _shareEntry(entry),
                              icon: const Icon(Icons.ios_share_outlined),
                            ),
                            IconButton(
                              tooltip: l10n.eventLogPdfDeleteConfirm,
                              onPressed: () => _deleteEntry(entry),
                              icon: const Icon(Icons.delete_outline),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class EventLogPdfViewerScreen extends StatelessWidget {
  const EventLogPdfViewerScreen({
    super.key,
    required this.title,
    required this.bytes,
    required this.fileName,
  });

  final String title;
  final Uint8List bytes;
  final String fileName;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            tooltip: l10n.eventLogPdfShare,
            onPressed: () async {
              await Share.shareXFiles([
                XFile.fromData(
                  bytes,
                  mimeType: 'application/pdf',
                  name: fileName,
                ),
              ], subject: title);
            },
            icon: const Icon(Icons.ios_share_outlined),
          ),
          IconButton(
            tooltip: l10n.eventLogPdfDownload,
            onPressed: () async {
              await Printing.sharePdf(bytes: bytes, filename: fileName);
            },
            icon: const Icon(Icons.download_outlined),
          ),
        ],
      ),
      body: InteractiveViewer(
        minScale: 0.6,
        maxScale: 4,
        child: PdfPreview(
          build: (_) async => bytes,
          allowPrinting: true,
          allowSharing: true,
          canChangeOrientation: false,
          canChangePageFormat: false,
          useActions: false,
        ),
      ),
    );
  }
}
