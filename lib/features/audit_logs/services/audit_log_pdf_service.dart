import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

import '../domain/platform_audit_action_type.dart';
import '../domain/platform_audit_log.dart';
import '../domain/platform_audit_result.dart';
import '../domain/platform_audit_severity.dart';

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
    String? generatedByLabel,
    String? periodLabel,
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

    final chapters = _groupIntoChapters(sorted);

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
            if (periodLabel != null && periodLabel.trim().isNotEmpty)
              pw.Text(
                periodLabel,
                style: pw.TextStyle(font: regular, fontSize: 9, color: _muted),
              ),
            if (generatedByLabel != null && generatedByLabel.trim().isNotEmpty)
              pw.Text(
                generatedByLabel,
                style: pw.TextStyle(font: regular, fontSize: 9, color: _muted),
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

          final widgets = <pw.Widget>[
            pw.Text(
              'Összesítés / Summary',
              style: pw.TextStyle(font: bold, fontSize: 14, color: _navy),
            ),
            pw.SizedBox(height: 6),
            pw.Text(
              'Összes esemény: ${sorted.length}',
              style: pw.TextStyle(font: regular, fontSize: 10, color: _ink),
            ),
            for (final chapter in chapters)
              if (chapter.logs.isNotEmpty)
                pw.Padding(
                  padding: const pw.EdgeInsets.only(top: 2),
                  child: pw.Text(
                    '${chapter.title}: ${chapter.logs.length}',
                    style: pw.TextStyle(
                      font: regular,
                      fontSize: 9,
                      color: _muted,
                    ),
                  ),
                ),
            pw.SizedBox(height: 14),
          ];

          for (final chapter in chapters) {
            if (chapter.logs.isEmpty) continue;
            widgets.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(bottom: 8, top: 6),
                child: pw.Text(
                  chapter.title,
                  style: pw.TextStyle(font: bold, fontSize: 13, color: _navy),
                ),
              ),
            );
            for (final log in chapter.logs) {
              widgets.add(_logCard(log, regular: regular, bold: bold));
            }
          }

          // Appendix: request / correlation ids
          final appendixIds = sorted
              .map((e) => e.correlationId?.trim())
              .whereType<String>()
              .where((id) => id.isNotEmpty)
              .toSet()
              .toList()
            ..sort();
          if (appendixIds.isNotEmpty) {
            widgets.add(
              pw.Padding(
                padding: const pw.EdgeInsets.only(top: 12, bottom: 6),
                child: pw.Text(
                  'Függelék / requestId-k',
                  style: pw.TextStyle(font: bold, fontSize: 13, color: _navy),
                ),
              ),
            );
            for (final id in appendixIds.take(200)) {
              widgets.add(
                pw.Text(
                  id,
                  style: pw.TextStyle(font: regular, fontSize: 8, color: _muted),
                ),
              );
            }
          }

          return widgets;
        },
      ),
    );

    return doc.save();
  }

  pw.Widget _logCard(
    PlatformAuditLog log, {
    required pw.Font regular,
    required pw.Font bold,
  }) {
    return pw.Container(
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: _panel,
        borderRadius: pw.BorderRadius.circular(6),
        border: pw.Border.all(color: const PdfColor.fromInt(0xFFCDD7E4)),
      ),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            log.timestamp.toUtc().toIso8601String(),
            style: pw.TextStyle(font: bold, fontSize: 9, color: _navy),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            _actionLabel(log),
            style: pw.TextStyle(font: bold, fontSize: 11, color: _ink),
          ),
          pw.SizedBox(height: 4),
          pw.Text(
            [
              if (log.actorName != null || log.actorEmail != null)
                'Actor: ${log.actorName ?? log.actorEmail}',
              if (log.companyName != null) 'Company: ${log.companyName}',
              if (log.targetLabel != null || log.targetId != null)
                'Target: ${log.targetLabel ?? log.targetId}',
              'Result: ${log.result.name} · Severity: ${log.severity.name}',
              if (log.reason != null && log.reason!.trim().isNotEmpty)
                'Reason: ${log.reason}',
              if (log.note != null && log.note!.trim().isNotEmpty)
                'Note: ${log.note}',
              if (log.correlationId != null &&
                  log.correlationId!.trim().isNotEmpty)
                'requestId: ${log.correlationId}',
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
    );
  }

  /// Chapter order for the unified audit PDF package (PHASE 1 foundation).
  List<_AuditPdfChapter> _groupIntoChapters(List<PlatformAuditLog> logs) {
    final buckets = <AuditPdfChapterId, List<PlatformAuditLog>>{
      for (final id in AuditPdfChapterId.values) id: <PlatformAuditLog>[],
    };
    for (final log in logs) {
      buckets[classifyAuditPdfChapter(log)]!.add(log);
    }
    return [
      for (final id in AuditPdfChapterId.values)
        _AuditPdfChapter(title: id.titleHuEn, logs: buckets[id]!),
    ];
  }

  String _actionLabel(PlatformAuditLog log) {
    final raw = log.actionType.name;
    return raw.replaceAllMapped(RegExp(r'([A-Z])'), (m) => ' ${m[1]}').trim();
  }
}

enum AuditPdfChapterId {
  critical,
  warnings,
  systemHealth,
  security,
  access,
  support,
  companyRegistration,
  driverRegistration,
  approvals,
  failedDenied,
  dataChanges,
  invitesEmail,
  qrEvents,
  archiveDelete,
  systemErrors,
  other;

  String get titleHuEn => switch (this) {
    critical => '3. Kritikus események',
    warnings => '4. Figyelmeztetések',
    systemHealth => '5. Rendszerállapot',
    security => '6. Biztonsági események',
    access => '7. Hozzáférések és jogosultságok',
    support => '8. Támogatási hozzáférések',
    companyRegistration => '9. Céges regisztrációk',
    driverRegistration => '10. Sofőrregisztrációk',
    approvals => '11. Jóváhagyások és elutasítások',
    failedDenied => '12. Sikertelen és megtagadott műveletek',
    dataChanges => '13. Adatmódosítások',
    invitesEmail => '14. Meghívók és e-mail-kézbesítés',
    qrEvents => '15. QR-események',
    archiveDelete => '16. Archiválás/törlés/anonymizálás',
    systemErrors => '17. Rendszerhibák',
    other => '18. Egyéb audit események',
  };
}

AuditPdfChapterId classifyAuditPdfChapter(PlatformAuditLog log) {
  final action = log.actionType;
  final hay =
      '${action.name} ${log.targetType ?? ''} ${log.note ?? ''} ${log.reason ?? ''}'
          .toLowerCase();

  if (log.severity == PlatformAuditSeverity.critical) {
    return AuditPdfChapterId.critical;
  }
  if (log.severity == PlatformAuditSeverity.warning &&
      log.result != PlatformAuditResult.failure &&
      log.result != PlatformAuditResult.denied) {
    return AuditPdfChapterId.warnings;
  }
  if (action == PlatformAuditActionType.systemHealthAcknowledged ||
      action == PlatformAuditActionType.systemHealthEscalated ||
      hay.contains('system_health') ||
      hay.contains('health')) {
    return AuditPdfChapterId.systemHealth;
  }
  if (action == PlatformAuditActionType.login ||
      action == PlatformAuditActionType.logout ||
      action == PlatformAuditActionType.loginFailed ||
      action == PlatformAuditActionType.apiKeyCreated ||
      action == PlatformAuditActionType.apiKeyRevoked ||
      hay.contains('security')) {
    return AuditPdfChapterId.security;
  }
  if (action == PlatformAuditActionType.roleChanged ||
      action == PlatformAuditActionType.permissionDenied ||
      hay.contains('permission') ||
      hay.contains('role')) {
    return AuditPdfChapterId.access;
  }
  if (action == PlatformAuditActionType.supportAccessGranted ||
      action == PlatformAuditActionType.supportAccessRevoked ||
      action == PlatformAuditActionType.supportTicketAcknowledged ||
      action == PlatformAuditActionType.supportTicketClosed ||
      hay.contains('support')) {
    return AuditPdfChapterId.support;
  }
  if (hay.contains('company') &&
      (hay.contains('registration') ||
          action == PlatformAuditActionType.registrationApproved ||
          action == PlatformAuditActionType.registrationRejected)) {
    return AuditPdfChapterId.companyRegistration;
  }
  if (hay.contains('driver') &&
      (hay.contains('registration') ||
          action == PlatformAuditActionType.registrationApproved ||
          action == PlatformAuditActionType.registrationRejected)) {
    return AuditPdfChapterId.driverRegistration;
  }
  if (action == PlatformAuditActionType.registrationApproved ||
      action == PlatformAuditActionType.registrationRejected ||
      action == PlatformAuditActionType.registrationInfoRequested) {
    return AuditPdfChapterId.approvals;
  }
  if (log.result == PlatformAuditResult.failure ||
      log.result == PlatformAuditResult.denied ||
      action == PlatformAuditActionType.permissionDenied) {
    return AuditPdfChapterId.failedDenied;
  }
  if (hay.contains('amendment') ||
      hay.contains('data_change') ||
      hay.contains('billing')) {
    return AuditPdfChapterId.dataChanges;
  }
  if (hay.contains('invite') ||
      hay.contains('email') ||
      hay.contains('password_setup') ||
      hay.contains('password-setup')) {
    return AuditPdfChapterId.invitesEmail;
  }
  if (hay.contains('qr')) {
    return AuditPdfChapterId.qrEvents;
  }
  if (hay.contains('archive') ||
      hay.contains('delete') ||
      hay.contains('anonym') ||
      hay.contains('tombstone')) {
    return AuditPdfChapterId.archiveDelete;
  }
  if (hay.contains('error') || hay.contains('exception')) {
    return AuditPdfChapterId.systemErrors;
  }
  return AuditPdfChapterId.other;
}

class _AuditPdfChapter {
  const _AuditPdfChapter({required this.title, required this.logs});

  final String title;
  final List<PlatformAuditLog> logs;
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
