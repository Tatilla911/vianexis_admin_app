import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../domain/platform_audit_log.dart';

/// ViaNexis-styled audit / event-log PDF generator (Unicode / ékezet-safe fonts).
class AuditLogPdfService {
  const AuditLogPdfService();

  static const _navy = PdfColor.fromInt(0xFF152536);
  static const _gold = PdfColor.fromInt(0xFFD4AF37);
  static const _panel = PdfColor.fromInt(0xFFF3F6FA);
  static const _ink = PdfColor.fromInt(0xFF152536);
  static const _muted = PdfColor.fromInt(0xFF4A5D73);

  Future<Uint8List> buildEventLogPdf({
    required List<PlatformAuditLog> logs,
    required String title,
    required String generatedLabel,
    required String emptyLabel,
    String? subtitle,
  }) async {
    // Noto Sans covers Hungarian / Latin Extended accents (no tofu boxes).
    final regular = await PdfGoogleFonts.notoSansRegular();
    final bold = await PdfGoogleFonts.notoSansBold();

    final doc = pw.Document(
      title: title,
      author: 'ViaNexis Admin',
      creator: 'ViaNexis Event Log Archive',
    );

    final sorted = [...logs]
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));

    doc.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(28),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Container(
              width: double.infinity,
              padding: const pw.EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 12,
              ),
              decoration: pw.BoxDecoration(
                color: _navy,
                borderRadius: pw.BorderRadius.circular(8),
              ),
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    'ViaNexis',
                    style: pw.TextStyle(
                      font: bold,
                      fontSize: 18,
                      color: _gold,
                    ),
                  ),
                  pw.Text(
                    title,
                    style: pw.TextStyle(
                      font: regular,
                      fontSize: 11,
                      color: PdfColors.white,
                    ),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 10),
            if (subtitle != null && subtitle.trim().isNotEmpty)
              pw.Text(
                subtitle,
                style: pw.TextStyle(font: regular, fontSize: 10, color: _muted),
              ),
            pw.Text(
              generatedLabel,
              style: pw.TextStyle(font: regular, fontSize: 9, color: _muted),
            ),
            pw.SizedBox(height: 8),
            pw.Divider(color: _gold, thickness: 1),
            pw.SizedBox(height: 8),
          ],
        ),
        footer: (context) => pw.Row(
          mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          children: [
            pw.Text(
              'ViaNexis Event Log',
              style: pw.TextStyle(font: regular, fontSize: 8, color: _muted),
            ),
            pw.Text(
              '${context.pageNumber} / ${context.pagesCount}',
              style: pw.TextStyle(font: regular, fontSize: 8, color: _muted),
            ),
          ],
        ),
        build: (context) {
          if (sorted.isEmpty) {
            return [
              pw.Text(
                emptyLabel,
                style: pw.TextStyle(font: regular, fontSize: 12, color: _ink),
              ),
            ];
          }
          return [
            for (final log in sorted)
              pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 10),
                padding: const pw.EdgeInsets.all(10),
                decoration: pw.BoxDecoration(
                  color: _panel,
                  borderRadius: pw.BorderRadius.circular(6),
                  border: pw.Border.all(
                    color: const PdfColor.fromInt(0xFFCDD7E4),
                  ),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      log.timestamp.toUtc().toIso8601String(),
                      style: pw.TextStyle(
                        font: bold,
                        fontSize: 9,
                        color: _navy,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      _actionLabel(log),
                      style: pw.TextStyle(
                        font: bold,
                        fontSize: 11,
                        color: _ink,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      [
                        if (log.actorName != null || log.actorEmail != null)
                          'Actor: ${log.actorName ?? log.actorEmail}',
                        if (log.companyName != null)
                          'Company: ${log.companyName}',
                        if (log.targetLabel != null || log.targetId != null)
                          'Target: ${log.targetLabel ?? log.targetId}',
                        'Result: ${log.result.name} · Severity: ${log.severity.name}',
                        if (log.reason != null && log.reason!.trim().isNotEmpty)
                          'Reason: ${log.reason}',
                        if (log.note != null && log.note!.trim().isNotEmpty)
                          'Note: ${log.note}',
                      ].join('\n'),
                      style: pw.TextStyle(
                        font: regular,
                        fontSize: 9,
                        color: _muted,
                        lineSpacing: 2,
                      ),
                    ),
                  ],
                ),
              ),
          ];
        },
      ),
    );

    return doc.save();
  }

  String _actionLabel(PlatformAuditLog log) {
    final raw = log.actionType.name;
    return raw.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}').trim();
  }
}

class EventLogPdfArchiveEntry {
  const EventLogPdfArchiveEntry({
    required this.id,
    required this.fileName,
    required this.filePath,
    required this.createdAt,
    required this.entryCount,
    this.title,
  });

  final String id;
  final String fileName;
  final String filePath;
  final DateTime createdAt;
  final int entryCount;
  final String? title;

  Map<String, dynamic> toJson() => {
    'id': id,
    'fileName': fileName,
    'filePath': filePath,
    'createdAt': createdAt.toIso8601String(),
    'entryCount': entryCount,
    'title': title,
  };

  factory EventLogPdfArchiveEntry.fromJson(Map<String, dynamic> json) {
    return EventLogPdfArchiveEntry(
      id: json['id']?.toString() ?? '',
      fileName: json['fileName']?.toString() ?? 'event-log.pdf',
      filePath: json['filePath']?.toString() ?? '',
      createdAt:
          DateTime.tryParse(json['createdAt']?.toString() ?? '') ??
          DateTime.fromMillisecondsSinceEpoch(0, isUtc: true),
      entryCount: int.tryParse('${json['entryCount'] ?? 0}') ?? 0,
      title: json['title']?.toString(),
    );
  }
}

/// Local persistent store for generated event-log PDFs (activities archive).
class EventLogPdfArchiveStore {
  static const _indexFileName = 'event_log_pdf_index.json';

  Future<Directory> _dir() async {
    final root = await getApplicationDocumentsDirectory();
    final dir = Directory('${root.path}/vianexis_event_log_pdfs');
    if (!await dir.exists()) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  Future<File> _indexFile() async {
    final dir = await _dir();
    return File('${dir.path}/$_indexFileName');
  }

  Future<List<EventLogPdfArchiveEntry>> list() async {
    final file = await _indexFile();
    if (!await file.exists()) return const [];
    try {
      final raw = await file.readAsString();
      final decoded = jsonDecode(raw);
      if (decoded is! List) return const [];
      final entries = decoded
          .whereType<Map>()
          .map(
            (item) => EventLogPdfArchiveEntry.fromJson(
              Map<String, dynamic>.from(item),
            ),
          )
          .toList();
      entries.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return entries;
    } catch (_) {
      return const [];
    }
  }

  Future<void> _saveIndex(List<EventLogPdfArchiveEntry> entries) async {
    final file = await _indexFile();
    final payload = entries.map((e) => e.toJson()).toList(growable: false);
    await file.writeAsString(jsonEncode(payload));
  }

  Future<EventLogPdfArchiveEntry> savePdf({
    required Uint8List bytes,
    required String title,
    required int entryCount,
  }) async {
    final dir = await _dir();
    final id = DateTime.now().toUtc().millisecondsSinceEpoch.toString();
    final stamp = DateTime.now().toUtc().toIso8601String().replaceAll(':', '-');
    final fileName = 'vianexis-event-log-$stamp.pdf';
    final path = '${dir.path}/$fileName';
    await File(path).writeAsBytes(bytes, flush: true);

    final entry = EventLogPdfArchiveEntry(
      id: id,
      fileName: fileName,
      filePath: path,
      createdAt: DateTime.now().toUtc(),
      entryCount: entryCount,
      title: title,
    );
    final existing = await list();
    await _saveIndex([entry, ...existing]);
    return entry;
  }

  Future<void> delete(String id) async {
    final entries = await list();
    final remaining = <EventLogPdfArchiveEntry>[];
    for (final entry in entries) {
      if (entry.id == id) {
        final file = File(entry.filePath);
        if (await file.exists()) {
          await file.delete();
        }
      } else {
        remaining.add(entry);
      }
    }
    await _saveIndex(remaining);
  }

  Future<void> deleteAll() async {
    final entries = await list();
    for (final entry in entries) {
      final file = File(entry.filePath);
      if (await file.exists()) {
        await file.delete();
      }
    }
    await _saveIndex(const []);
  }

  Future<Uint8List> readBytes(EventLogPdfArchiveEntry entry) {
    return File(entry.filePath).readAsBytes();
  }
}
