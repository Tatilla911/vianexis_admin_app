import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/audit_logs/domain/platform_audit_action_type.dart';
import 'package:vianexis_admin_app/features/audit_logs/domain/platform_audit_log.dart';
import 'package:vianexis_admin_app/features/audit_logs/domain/platform_audit_result.dart';
import 'package:vianexis_admin_app/features/audit_logs/domain/platform_audit_severity.dart';
import 'package:vianexis_admin_app/features/audit_logs/services/audit_log_pdf_service.dart';

PlatformAuditLog _log({
  required PlatformAuditActionType action,
  PlatformAuditSeverity severity = PlatformAuditSeverity.info,
  PlatformAuditResult result = PlatformAuditResult.success,
  String? note,
  String? targetType,
}) {
  return PlatformAuditLog(
    id: '1',
    timestamp: DateTime.utc(2026, 7, 29),
    actionType: action,
    result: result,
    severity: severity,
    note: note,
    targetType: targetType,
  );
}

void main() {
  test('classifies critical severity into critical chapter', () {
    final chapter = classifyAuditPdfChapter(
      _log(
        action: PlatformAuditActionType.login,
        severity: PlatformAuditSeverity.critical,
      ),
    );
    expect(chapter, AuditPdfChapterId.critical);
  });

  test('classifies invite notes into invitesEmail chapter', () {
    final chapter = classifyAuditPdfChapter(
      _log(
        action: PlatformAuditActionType.unknown,
        note: 'company_invite_resent',
      ),
    );
    expect(chapter, AuditPdfChapterId.invitesEmail);
  });

  test('classifies denied results into failedDenied chapter', () {
    final chapter = classifyAuditPdfChapter(
      _log(
        action: PlatformAuditActionType.exportRequested,
        result: PlatformAuditResult.denied,
      ),
    );
    expect(chapter, AuditPdfChapterId.failedDenied);
  });

  test('classifies qr notes into qrEvents chapter', () {
    final chapter = classifyAuditPdfChapter(
      _log(
        action: PlatformAuditActionType.unknown,
        note: 'company_qr_created',
      ),
    );
    expect(chapter, AuditPdfChapterId.qrEvents);
  });
}
