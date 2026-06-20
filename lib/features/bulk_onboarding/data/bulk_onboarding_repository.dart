import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/bulk_onboarding_action_request.dart';
import '../domain/bulk_onboarding_dashboard_summary.dart';
import '../domain/bulk_onboarding_job.dart';
import '../domain/bulk_onboarding_risk_level.dart';
import '../domain/bulk_onboarding_row.dart';
import '../domain/bulk_onboarding_row_status.dart';
import '../domain/bulk_onboarding_status.dart';
import '../domain/bulk_onboarding_type.dart';
import '../domain/bulk_onboarding_row_action.dart';
import '../domain/bulk_onboarding_upload_result.dart';
import 'bulk_onboarding_api.dart';

abstract class BulkOnboardingRepository {
  Future<List<BulkOnboardingJob>> fetchJobs();

  Future<BulkOnboardingJob> fetchJob(String id);

  Future<List<BulkOnboardingRow>> fetchRows(
    String jobId, {
    BulkOnboardingRowStatus? status,
    String? search,
  });

  Future<BulkOnboardingUploadResult> uploadCsv({
    required List<int> bytes,
    required String fileName,
    required BulkOnboardingJobType type,
    int? companyId,
    String? companyName,
    String? note,
    void Function(int sent, int total)? onProgress,
  });

  Future<String> downloadTemplate(BulkOnboardingJobType type);

  Future<String> downloadValidationReport(String jobId);

  Future<BulkOnboardingJob> submitAction({
    required String jobId,
    required BulkOnboardingActionRequest request,
  });

  Future<BulkOnboardingDashboardSummary> fetchDashboardSummary();

  Future<BulkOnboardingRow> fetchRow(String jobId, String rowId);

  Future<BulkOnboardingRowActionResult> correctRow({
    required String jobId,
    required String rowId,
    required BulkOnboardingRowCorrectionRequest request,
  });

  Future<BulkOnboardingRowActionResult> skipRow({
    required String jobId,
    required String rowId,
    required BulkOnboardingRowSkipRequest request,
  });

  Future<BulkOnboardingRowActionResult> revalidateRow({
    required String jobId,
    required String rowId,
  });

  Future<BulkOnboardingJob> revalidateJob(String jobId);

  bool get usesMockData;
}

class LiveBulkOnboardingRepository implements BulkOnboardingRepository {
  LiveBulkOnboardingRepository(this._api);

  final BulkOnboardingApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<List<BulkOnboardingJob>> fetchJobs() async {
    final page = await _api.listJobs(limit: 200);
    return page.items;
  }

  @override
  Future<BulkOnboardingJob> fetchJob(String id) => _api.getJob(id);

  @override
  Future<List<BulkOnboardingRow>> fetchRows(
    String jobId, {
    BulkOnboardingRowStatus? status,
    String? search,
  }) async {
    final page = await _api.listRows(
      jobId: jobId,
      status: status,
      search: search,
      limit: 500,
    );
    return page.items;
  }

  @override
  Future<BulkOnboardingUploadResult> uploadCsv({
    required List<int> bytes,
    required String fileName,
    required BulkOnboardingJobType type,
    int? companyId,
    String? companyName,
    String? note,
    void Function(int sent, int total)? onProgress,
  }) {
    return _api.uploadCsv(
      bytes: bytes,
      fileName: fileName,
      type: type,
      companyId: companyId,
      companyName: companyName,
      note: note,
      onSendProgress: onProgress == null
          ? null
          : (sent, total) => onProgress(sent, total),
    );
  }

  @override
  Future<String> downloadTemplate(BulkOnboardingJobType type) {
    return _api.downloadTemplate(type);
  }

  @override
  Future<String> downloadValidationReport(String jobId) {
    return _api.downloadValidationReport(jobId);
  }

  @override
  Future<BulkOnboardingJob> submitAction({
    required String jobId,
    required BulkOnboardingActionRequest request,
  }) {
    return _api.submitAction(jobId: jobId, request: request);
  }

  @override
  Future<BulkOnboardingDashboardSummary> fetchDashboardSummary() async {
    final jobs = await fetchJobs();
    return BulkOnboardingDashboardSummary.fromJobs(jobs);
  }

  @override
  Future<BulkOnboardingRow> fetchRow(String jobId, String rowId) {
    return _api.getRow(jobId: jobId, rowId: rowId);
  }

  @override
  Future<BulkOnboardingRowActionResult> correctRow({
    required String jobId,
    required String rowId,
    required BulkOnboardingRowCorrectionRequest request,
  }) {
    return _api.correctRow(jobId: jobId, rowId: rowId, request: request);
  }

  @override
  Future<BulkOnboardingRowActionResult> skipRow({
    required String jobId,
    required String rowId,
    required BulkOnboardingRowSkipRequest request,
  }) {
    return _api.skipRow(jobId: jobId, rowId: rowId, request: request);
  }

  @override
  Future<BulkOnboardingRowActionResult> revalidateRow({
    required String jobId,
    required String rowId,
  }) {
    return _api.revalidateRow(jobId: jobId, rowId: rowId);
  }

  @override
  Future<BulkOnboardingJob> revalidateJob(String jobId) {
    return _api.revalidateJob(jobId: jobId);
  }
}

class MockBulkOnboardingRepository implements BulkOnboardingRepository {
  MockBulkOnboardingRepository();

  final List<BulkOnboardingJob> _jobs = [
    BulkOnboardingJob(
      id: '501',
      companyId: 1,
      companyName: 'NordTrans Kft.',
      submittedByUserId: 1,
      submittedByName: 'Anna Kovács',
      sourceFileName: 'nordtrans-users.csv',
      sourceFileMimeType: 'text/csv',
      sourceFileSizeBytes: 2048,
      type: BulkOnboardingJobType.companyUsers,
      status: BulkOnboardingJobStatus.readyForReview,
      totalRows: 120,
      validRows: 112,
      warningRows: 5,
      invalidRows: 2,
      duplicateRows: 1,
      processedRows: 0,
      failedRows: 0,
      aiSummary:
          'Advisory AI review: warnings present. Human approval required before processing.',
      riskLevel: BulkOnboardingRiskLevel.medium,
      validationSummary:
          '{"recommendedAction":"review","advisoryOnly":true}',
      processingAvailable: false,
      createdAt: DateTime.utc(2026, 6, 12, 10, 0),
    ),
    BulkOnboardingJob(
      id: '502',
      companyName: 'Alpine Logistics GmbH',
      submittedByUserId: 1,
      submittedByName: 'Platform Admin',
      sourceFileName: 'drivers-import.csv',
      type: BulkOnboardingJobType.drivers,
      status: BulkOnboardingJobStatus.validationFailed,
      totalRows: 80,
      validRows: 40,
      warningRows: 5,
      invalidRows: 30,
      duplicateRows: 5,
      processedRows: 0,
      failedRows: 0,
      aiSummary:
          'Advisory AI review: high invalid row rate detected. Human review required.',
      riskLevel: BulkOnboardingRiskLevel.high,
      validationSummary:
          '{"recommendedAction":"review","advisoryOnly":true}',
      processingAvailable: false,
      createdAt: DateTime.utc(2026, 6, 11, 14, 30),
    ),
    BulkOnboardingJob(
      id: '503',
      companyId: 2,
      companyName: 'Danube Fleet Zrt.',
      submittedByUserId: 1,
      submittedByName: 'Platform Admin',
      sourceFileName: 'fleet-mixed.csv',
      type: BulkOnboardingJobType.mixedCompanyImport,
      status: BulkOnboardingJobStatus.approvedForProcessing,
      totalRows: 45,
      validRows: 45,
      warningRows: 0,
      invalidRows: 0,
      duplicateRows: 0,
      processedRows: 0,
      failedRows: 0,
      aiSummary:
          'Advisory AI review: no blocking issues found. Job may be approvable after human review.',
      riskLevel: BulkOnboardingRiskLevel.low,
      validationSummary:
          '{"recommendedAction":"approve_candidate","advisoryOnly":true}',
      processingAvailable: true,
      createdAt: DateTime.utc(2026, 6, 10, 9, 15),
    ),
  ];

  final Map<String, List<BulkOnboardingRow>> _rowsByJob = {
    '501': [
      BulkOnboardingRow(
        id: '9001',
        jobId: '501',
        rowIndex: 1,
        type: 'company_user',
        status: BulkOnboardingRowStatus.valid,
        displayLabel: 'Valid User',
        name: 'Valid User',
        email: 'valid@nordtrans.example',
        role: 'dispatcher',
        country: 'HU',
      ),
      BulkOnboardingRow(
        id: '9002',
        jobId: '501',
        rowIndex: 2,
        type: 'company_user',
        status: BulkOnboardingRowStatus.duplicate,
        displayLabel: 'Duplicate User',
        name: 'Duplicate User',
        email: 'dup@nordtrans.example',
        duplicateReason: 'duplicate_email_in_import',
        aiFlags: const ['duplicate_email_in_import'],
      ),
    ],
    '502': [
      BulkOnboardingRow(
        id: '9102',
        jobId: '502',
        rowIndex: 1,
        type: 'driver',
        status: BulkOnboardingRowStatus.invalid,
        displayLabel: 'Invalid Driver',
        name: 'Invalid Driver',
        email: 'bad-email',
        validationErrors: const ['email_invalid'],
      ),
      BulkOnboardingRow(
        id: '9103',
        jobId: '502',
        rowIndex: 2,
        type: 'driver',
        status: BulkOnboardingRowStatus.valid,
        displayLabel: 'Valid Driver',
        name: 'Valid Driver',
        email: 'valid@alpine.example',
        country: 'DE',
      ),
    ],
  };

  @override
  bool get usesMockData => true;

  @override
  Future<List<BulkOnboardingJob>> fetchJobs() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return List<BulkOnboardingJob>.from(_jobs);
  }

  @override
  Future<BulkOnboardingJob> fetchJob(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _jobs.firstWhere(
      (job) => job.id == id,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  @override
  Future<List<BulkOnboardingRow>> fetchRows(
    String jobId, {
    BulkOnboardingRowStatus? status,
    String? search,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final rows = List<BulkOnboardingRow>.from(_rowsByJob[jobId] ?? const []);
    return rows
        .where((row) => status == null || row.status == status)
        .where((row) => search == null || row.matchesSearch(search))
        .toList(growable: false);
  }

  @override
  Future<BulkOnboardingUploadResult> uploadCsv({
    required List<int> bytes,
    required String fileName,
    required BulkOnboardingJobType type,
    int? companyId,
    String? companyName,
    String? note,
    void Function(int sent, int total)? onProgress,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (onProgress != null) {
      onProgress(bytes.length, bytes.length);
    }
    final mockJob = BulkOnboardingJob(
      id: '599',
      companyId: companyId,
      companyName: companyName ?? 'Mock CSV Upload Co',
      submittedByUserId: 1,
      submittedByName: 'Mock Upload',
      sourceFileName: fileName,
      sourceFileMimeType: 'text/csv',
      sourceFileSizeBytes: bytes.length,
      type: type,
      status: BulkOnboardingJobStatus.readyForReview,
      totalRows: 2,
      validRows: 1,
      warningRows: 0,
      invalidRows: 0,
      duplicateRows: 1,
      processedRows: 0,
      failedRows: 0,
      aiSummary:
          'Advisory AI review (mock upload preview). Human approval required.',
      riskLevel: BulkOnboardingRiskLevel.medium,
      validationSummary:
          '{"recommendedAction":"review","advisoryOnly":true}',
      processingAvailable: false,
      createdAt: DateTime.now().toUtc(),
    );
    _jobs.insert(0, mockJob);
    _rowsByJob[mockJob.id] = [
      BulkOnboardingRow(
        id: '9100',
        jobId: mockJob.id,
        rowIndex: 1,
        type: 'driver',
        status: BulkOnboardingRowStatus.valid,
        displayLabel: 'Mock Valid Row',
        name: 'Mock Valid Row',
        email: 'mock-valid@example.com',
      ),
      BulkOnboardingRow(
        id: '9101',
        jobId: mockJob.id,
        rowIndex: 2,
        type: 'driver',
        status: BulkOnboardingRowStatus.duplicate,
        displayLabel: 'Mock Duplicate Row',
        name: 'Mock Duplicate Row',
        email: 'mock-dup@example.com',
        duplicateReason: 'duplicate_email_in_import',
      ),
    ];
    return BulkOnboardingUploadResult(
      job: mockJob,
      summary: const BulkOnboardingValidationCounts(
        totalRows: 2,
        validRows: 1,
        duplicateRows: 1,
      ),
      processingAvailable: false,
      metadataOnly: true,
    );
  }

  @override
  Future<String> downloadTemplate(BulkOnboardingJobType type) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return switch (type) {
      BulkOnboardingJobType.drivers =>
        'name,email,phone,country,role,preferredLanguage,driverIdentifier\n',
      BulkOnboardingJobType.vehicles => 'vehiclePlate,country,vehicleType\n',
      BulkOnboardingJobType.trailers => 'trailerPlate,country,trailerType\n',
      BulkOnboardingJobType.mixedCompanyImport =>
        'type,name,email,phone,country,role,vehiclePlate,trailerPlate\n',
      BulkOnboardingJobType.companyUsers =>
        'name,email,phone,country,role,preferredLanguage,employeeId\n',
      BulkOnboardingJobType.unknown => 'name,email\n',
    };
  }

  @override
  Future<String> downloadValidationReport(String jobId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    if (!_rowsByJob.containsKey(jobId) && _jobs.every((job) => job.id != jobId)) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorActionUnavailable,
        kind: ApiExceptionKind.notFound,
      );
    }
    final rows = _rowsByJob[jobId] ?? const [];
    return _buildValidationReportCsv(rows);
  }

  String _buildValidationReportCsv(List<BulkOnboardingRow> rows) {
    const headers = [
      'rowIndex',
      'status',
      'displayLabel',
      'name',
      'email',
      'phone',
      'role',
      'vehiclePlate',
      'trailerPlate',
      'validationErrors',
      'validationWarnings',
      'duplicateReason',
    ];
    final buffer = StringBuffer('${headers.join(',')}\n');
    for (final row in rows) {
      buffer.writeln([
        row.rowIndex,
        row.status.backendValue,
        _csvCell(row.displayLabel),
        _csvCell(row.name),
        _csvCell(row.email),
        _csvCell(row.phone),
        _csvCell(row.role),
        _csvCell(row.vehiclePlate),
        _csvCell(row.trailerPlate),
        _csvCell(row.validationErrors.join('; ')),
        _csvCell(row.validationWarnings.join('; ')),
        _csvCell(row.duplicateReason),
      ].join(','));
    }
    return buffer.toString();
  }

  String _csvCell(String? value) {
    if (value == null || value.isEmpty) {
      return '';
    }
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }

  @override
  Future<BulkOnboardingJob> submitAction({
    required String jobId,
    required BulkOnboardingActionRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _jobs.indexWhere((job) => job.id == jobId);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }
    final current = _jobs[index];
    final updated = switch (request.kind) {
      BulkOnboardingActionKind.validate => current.copyWithStatus(
        BulkOnboardingJobStatus.readyForReview,
      ),
      BulkOnboardingActionKind.approve => current.copyWithStatus(
        BulkOnboardingJobStatus.approvedForProcessing,
        processingAvailable: true,
      ),
      BulkOnboardingActionKind.reject => current.copyWithStatus(
        BulkOnboardingJobStatus.rejected,
        processingAvailable: false,
      ),
      BulkOnboardingActionKind.cancel => current.copyWithStatus(
        BulkOnboardingJobStatus.cancelled,
        processingAvailable: false,
      ),
      BulkOnboardingActionKind.process => current.copyWithStatus(
        BulkOnboardingJobStatus.completed,
        processingAvailable: false,
        processedRows: current.totalRows,
      ),
    };
    _jobs[index] = updated;
    return updated;
  }

  @override
  Future<BulkOnboardingDashboardSummary> fetchDashboardSummary() async {
    final jobs = await fetchJobs();
    return BulkOnboardingDashboardSummary.fromJobs(jobs);
  }

  @override
  Future<BulkOnboardingRow> fetchRow(String jobId, String rowId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _findRow(jobId, rowId);
  }

  @override
  Future<BulkOnboardingRowActionResult> correctRow({
    required String jobId,
    required String rowId,
    required BulkOnboardingRowCorrectionRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final row = _findRow(jobId, rowId);
    if (row.status == BulkOnboardingRowStatus.skipped) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.validation,
      );
    }

    final originalValues = row.originalValues ??
        {
          if (row.name != null) 'name': row.name,
          if (row.email != null) 'email': row.email,
          if (row.phone != null) 'phone': row.phone,
          if (row.country != null) 'country': row.country,
          if (row.role != null) 'role': row.role,
          if (row.vehiclePlate != null) 'vehiclePlate': row.vehiclePlate,
          if (row.trailerPlate != null) 'trailerPlate': row.trailerPlate,
        };

    final updated = row.copyWithFields(
      name: request.name ?? row.name,
      email: request.email ?? row.email,
      phone: request.phone ?? row.phone,
      country: request.country ?? row.country,
      role: request.role ?? row.role,
      vehiclePlate: request.vehiclePlate ?? row.vehiclePlate,
      trailerPlate: request.trailerPlate ?? row.trailerPlate,
      originalValues: originalValues,
      correctedValues: request.toJson()
        ..remove('note'),
      correctionNote: request.note?.trim().isEmpty ?? true ? row.correctionNote : request.note!.trim(),
      correctedByUserId: 1,
      correctedAt: DateTime.now().toUtc(),
      lastValidatedAt: DateTime.now().toUtc(),
    );
    final validated = _mockValidateRow(updated);
    _replaceRow(jobId, validated);
    final job = _syncMockJobSummary(jobId);
    return BulkOnboardingRowActionResult(row: validated, job: job);
  }

  @override
  Future<BulkOnboardingRowActionResult> skipRow({
    required String jobId,
    required String rowId,
    required BulkOnboardingRowSkipRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final row = _findRow(jobId, rowId);
    final skipped = row.copyWithFields(
      status: BulkOnboardingRowStatus.skipped,
      skipReason: request.reason.trim(),
      skippedByUserId: 1,
      skippedAt: DateTime.now().toUtc(),
      validationErrors: const [],
      validationWarnings: const [],
      duplicateReason: null,
    );
    _replaceRow(jobId, skipped);
    final job = _syncMockJobSummary(jobId);
    return BulkOnboardingRowActionResult(row: skipped, job: job);
  }

  @override
  Future<BulkOnboardingRowActionResult> revalidateRow({
    required String jobId,
    required String rowId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    final row = _findRow(jobId, rowId);
    if (row.status == BulkOnboardingRowStatus.skipped) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.validation,
      );
    }
    final validated = _mockValidateRow(
      row.copyWithFields(lastValidatedAt: DateTime.now().toUtc()),
    );
    _replaceRow(jobId, validated);
    final job = _syncMockJobSummary(jobId);
    return BulkOnboardingRowActionResult(row: validated, job: job);
  }

  @override
  Future<BulkOnboardingJob> revalidateJob(String jobId) async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    final rows = List<BulkOnboardingRow>.from(_rowsByJob[jobId] ?? const []);
    final updatedRows = rows.map((row) {
      if (row.status == BulkOnboardingRowStatus.skipped) return row;
      return _mockValidateRow(
        row.copyWithFields(lastValidatedAt: DateTime.now().toUtc()),
      );
    }).toList(growable: false);
    _rowsByJob[jobId] = updatedRows;
    return _syncMockJobSummary(
      jobId,
      lastValidatedAt: DateTime.now().toUtc(),
    );
  }

  BulkOnboardingRow _findRow(String jobId, String rowId) {
    final rows = _rowsByJob[jobId] ?? const [];
    return rows.firstWhere(
      (row) => row.id == rowId,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  void _replaceRow(String jobId, BulkOnboardingRow row) {
    final rows = List<BulkOnboardingRow>.from(_rowsByJob[jobId] ?? const []);
    final index = rows.indexWhere((item) => item.id == row.id);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }
    rows[index] = row;
    _rowsByJob[jobId] = rows;
  }

  BulkOnboardingRow _mockValidateRow(BulkOnboardingRow row) {
    final email = row.email?.trim() ?? '';
    final hasValidEmail = email.contains('@') && email.contains('.');
    if (hasValidEmail) {
      return row.copyWithFields(
        status: BulkOnboardingRowStatus.valid,
        validationErrors: const [],
      );
    }
    return row.copyWithFields(
      status: BulkOnboardingRowStatus.invalid,
      validationErrors: const ['email_invalid'],
    );
  }

  BulkOnboardingJob _syncMockJobSummary(
    String jobId, {
    DateTime? lastValidatedAt,
  }) {
    final index = _jobs.indexWhere((job) => job.id == jobId);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }
    final rows = _rowsByJob[jobId] ?? const [];
    var validRows = 0;
    var warningRows = 0;
    var invalidRows = 0;
    var duplicateRows = 0;
    var skippedRows = 0;
    for (final row in rows) {
      switch (row.status) {
        case BulkOnboardingRowStatus.valid:
          validRows++;
        case BulkOnboardingRowStatus.warning:
          warningRows++;
        case BulkOnboardingRowStatus.invalid:
          invalidRows++;
        case BulkOnboardingRowStatus.duplicate:
          duplicateRows++;
        case BulkOnboardingRowStatus.skipped:
          skippedRows++;
        default:
          break;
      }
    }
    final current = _jobs[index];
    final updated = BulkOnboardingJob(
      id: current.id,
      companyId: current.companyId,
      companyName: current.companyName,
      submittedByUserId: current.submittedByUserId,
      submittedByName: current.submittedByName,
      sourceFileName: current.sourceFileName,
      sourceFileMimeType: current.sourceFileMimeType,
      sourceFileSizeBytes: current.sourceFileSizeBytes,
      type: current.type,
      status: current.status,
      totalRows: rows.length,
      validRows: validRows,
      warningRows: warningRows,
      invalidRows: invalidRows,
      duplicateRows: duplicateRows,
      processedRows: current.processedRows,
      failedRows: current.failedRows,
      skippedRows: skippedRows,
      aiSummary: current.aiSummary,
      riskLevel: invalidRows > 0
          ? BulkOnboardingRiskLevel.high
          : BulkOnboardingRiskLevel.low,
      validationSummary: current.validationSummary,
      processingAvailable: current.processingAvailable,
      lastValidatedAt: lastValidatedAt ?? DateTime.now().toUtc(),
      createdAt: current.createdAt,
      updatedAt: DateTime.now().toUtc(),
      approvedAt: current.approvedAt,
      approvedByUserId: current.approvedByUserId,
      processedAt: current.processedAt,
      lastErrorSummary: current.lastErrorSummary,
      messageKey: current.messageKey,
      metadataOnly: current.metadataOnly,
    );
    _jobs[index] = updated;
    return updated;
  }
}

extension _BulkOnboardingRowMockCopy on BulkOnboardingRow {
  BulkOnboardingRow copyWithFields({
    BulkOnboardingRowStatus? status,
    String? name,
    String? email,
    String? phone,
    String? country,
    String? role,
    String? vehiclePlate,
    String? trailerPlate,
    String? duplicateReason,
    List<String>? validationErrors,
    List<String>? validationWarnings,
    Map<String, dynamic>? originalValues,
    Map<String, dynamic>? correctedValues,
    String? correctionNote,
    int? correctedByUserId,
    DateTime? correctedAt,
    int? skippedByUserId,
    DateTime? skippedAt,
    String? skipReason,
    DateTime? lastValidatedAt,
  }) {
    return BulkOnboardingRow(
      id: id,
      jobId: jobId,
      rowIndex: rowIndex,
      type: type,
      status: status ?? this.status,
      displayLabel: displayLabel,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      country: country ?? this.country,
      role: role ?? this.role,
      vehiclePlate: vehiclePlate ?? this.vehiclePlate,
      trailerPlate: trailerPlate ?? this.trailerPlate,
      duplicateReason: duplicateReason ?? this.duplicateReason,
      validationErrors: validationErrors ?? this.validationErrors,
      validationWarnings: validationWarnings ?? this.validationWarnings,
      aiFlags: aiFlags,
      processedEntityType: processedEntityType,
      processedEntityId: processedEntityId,
      originalValues: originalValues ?? this.originalValues,
      correctedValues: correctedValues ?? this.correctedValues,
      correctionNote: correctionNote ?? this.correctionNote,
      correctedByUserId: correctedByUserId ?? this.correctedByUserId,
      correctedAt: correctedAt ?? this.correctedAt,
      skippedByUserId: skippedByUserId ?? this.skippedByUserId,
      skippedAt: skippedAt ?? this.skippedAt,
      skipReason: skipReason ?? this.skipReason,
      lastValidatedAt: lastValidatedAt ?? this.lastValidatedAt,
      metadataOnly: metadataOnly,
    );
  }
}

extension _BulkOnboardingJobMockCopy on BulkOnboardingJob {
  BulkOnboardingJob copyWithStatus(
    BulkOnboardingJobStatus status, {
    bool? processingAvailable,
    int? processedRows,
  }) {
    return BulkOnboardingJob(
      id: id,
      companyId: companyId,
      companyName: companyName,
      submittedByUserId: submittedByUserId,
      submittedByName: submittedByName,
      sourceFileName: sourceFileName,
      sourceFileMimeType: sourceFileMimeType,
      sourceFileSizeBytes: sourceFileSizeBytes,
      type: type,
      status: status,
      totalRows: totalRows,
      validRows: validRows,
      warningRows: warningRows,
      invalidRows: invalidRows,
      duplicateRows: duplicateRows,
      processedRows: processedRows ?? this.processedRows,
      failedRows: failedRows,
      skippedRows: skippedRows,
      aiSummary: aiSummary,
      riskLevel: riskLevel,
      validationSummary: validationSummary,
      processingAvailable: processingAvailable ?? this.processingAvailable,
      lastValidatedAt: lastValidatedAt,
      createdAt: createdAt,
      updatedAt: DateTime.now().toUtc(),
      approvedAt: approvedAt,
      approvedByUserId: approvedByUserId,
      processedAt: processedAt,
      lastErrorSummary: lastErrorSummary,
      messageKey: messageKey,
      metadataOnly: metadataOnly,
    );
  }
}

final bulkOnboardingRepositoryProvider = Provider<BulkOnboardingRepository>((ref) {

  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveBulkOnboardingRepository(ref.watch(bulkOnboardingApiProvider));
  }
  return MockBulkOnboardingRepository();
});
