import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
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
import 'bulk_onboarding_api.dart';

abstract class BulkOnboardingRepository {
  Future<List<BulkOnboardingJob>> fetchJobs();

  Future<BulkOnboardingJob> fetchJob(String id);

  Future<List<BulkOnboardingRow>> fetchRows(String jobId);

  Future<BulkOnboardingJob> submitAction({
    required String jobId,
    required BulkOnboardingActionRequest request,
  });

  Future<BulkOnboardingDashboardSummary> fetchDashboardSummary();

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
  Future<List<BulkOnboardingRow>> fetchRows(String jobId) async {
    final page = await _api.listRows(jobId: jobId, limit: 500);
    return page.items;
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
  Future<List<BulkOnboardingRow>> fetchRows(String jobId) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return List<BulkOnboardingRow>.from(_rowsByJob[jobId] ?? const []);
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
      aiSummary: aiSummary,
      riskLevel: riskLevel,
      validationSummary: validationSummary,
      processingAvailable: processingAvailable ?? this.processingAvailable,
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
  final apiClient = ref.watch(apiClientProvider);
  if (apiClient.isConfigured) {
    return LiveBulkOnboardingRepository(ref.watch(bulkOnboardingApiProvider));
  }
  return MockBulkOnboardingRepository();
});
