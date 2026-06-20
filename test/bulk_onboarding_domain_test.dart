import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_action_request.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_dashboard_summary.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_execution.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_job.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_risk_level.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_row.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_row_status.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_status.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_type.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_row_action.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_upload_result.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/presentation/bulk_onboarding_providers.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';

void main() {
  group('BulkOnboardingJob JSON parsing', () {
    test('parses list item metadata fields', () {
      final job = BulkOnboardingJob.fromJson({
        'id': 42,
        'companyName': 'Acme Logistics',
        'submittedByUserId': 7,
        'submittedByName': 'Reviewer',
        'type': 'company_users',
        'status': 'ready_for_review',
        'totalRows': 10,
        'validRows': 8,
        'warningRows': 1,
        'invalidRows': 1,
        'duplicateRows': 0,
        'processedRows': 0,
        'failedRows': 0,
        'riskLevel': 'medium',
        'processingAvailable': false,
        'metadataOnly': true,
      });

      expect(job.id, '42');
      expect(job.companyName, 'Acme Logistics');
      expect(job.type, BulkOnboardingJobType.companyUsers);
      expect(job.status, BulkOnboardingJobStatus.readyForReview);
      expect(job.riskLevel, BulkOnboardingRiskLevel.medium);
      expect(job.processingAvailable, isFalse);
      expect(job.metadataOnly, isTrue);
    });

    test('parses detail wrapper', () {
      final job = BulkOnboardingJob.fromDetailResponseJson({
        'job': {
          'id': 1,
          'companyName': 'Wrapped Co',
          'submittedByUserId': 1,
          'type': 'drivers',
          'status': 'draft',
          'totalRows': 0,
          'validRows': 0,
          'warningRows': 0,
          'invalidRows': 0,
          'duplicateRows': 0,
          'processedRows': 0,
          'failedRows': 0,
          'riskLevel': 'low',
          'processingAvailable': false,
        },
      });

      expect(job.companyName, 'Wrapped Co');
      expect(job.type, BulkOnboardingJobType.drivers);
    });

    test('parses recommendedAction from validationSummary JSON', () {
      final job = BulkOnboardingJob.fromJson({
        'id': 2,
        'companyName': 'Summary Co',
        'submittedByUserId': 1,
        'type': 'mixed_company_import',
        'status': 'ready_for_review',
        'totalRows': 1,
        'validRows': 1,
        'warningRows': 0,
        'invalidRows': 0,
        'duplicateRows': 0,
        'processedRows': 0,
        'failedRows': 0,
        'riskLevel': 'low',
        'processingAvailable': false,
        'validationSummary':
            '{"recommendedAction":"approve_candidate","advisoryOnly":true}',
      });

      expect(job.recommendedAction, 'approve_candidate');
    });

    test('parses provisioning and execution policy from summary', () {
      final job = BulkOnboardingJob.fromJson({
        'id': 3,
        'companyName': 'Policy Co',
        'submittedByUserId': 1,
        'type': 'company_users',
        'status': 'approved_for_processing',
        'totalRows': 10,
        'validRows': 10,
        'warningRows': 0,
        'invalidRows': 0,
        'duplicateRows': 0,
        'processedRows': 0,
        'failedRows': 0,
        'riskLevel': 'low',
        'processingAvailable': true,
        'validationSummary':
            '{"provisioningAvailable":true,"provisioningStatus":"ready","executionPolicy":{"enabled":false,"reason":"dry_run_required","maxRows":500,"rowCount":10}}',
      });

      expect(job.provisioningAvailable, isTrue);
      expect(job.provisioningStatus, 'ready');
      expect(job.executionPolicy.enabled, isFalse);
      expect(job.executionPolicy.reason, 'dry_run_required');
    });
  });

  group('BulkOnboardingRow JSON parsing', () {
    test('parses row validation arrays', () {
      final row = BulkOnboardingRow.fromJson({
        'id': 9,
        'jobId': 42,
        'rowIndex': 3,
        'type': 'driver',
        'status': 'duplicate',
        'email': 'dup@example.com',
        'duplicateReason': 'duplicate_email_in_import',
        'validationErrors': ['email_required'],
        'validationWarnings': ['company_link_missing'],
        'aiFlags': ['duplicate_email_in_import'],
        'metadataOnly': true,
      });

      expect(row.status, BulkOnboardingRowStatus.duplicate);
      expect(row.validationErrors, ['email_required']);
      expect(row.aiFlags, ['duplicate_email_in_import']);
    });

    test('parses correction and skip metadata', () {
      final row = BulkOnboardingRow.fromJson({
        'id': 10,
        'jobId': 42,
        'rowIndex': 1,
        'type': 'driver',
        'status': 'valid',
        'email': 'fixed@example.com',
        'originalValues': {'email': 'bad-email'},
        'correctedValues': {'email': 'fixed@example.com'},
        'correctionNote': 'Fixed typo',
        'correctedByUserId': 7,
        'correctedAt': '2026-06-19T10:00:00.000Z',
        'skippedByUserId': null,
        'skipReason': null,
        'lastValidatedAt': '2026-06-19T10:05:00.000Z',
        'metadataOnly': true,
      });

      expect(row.originalValues?['email'], 'bad-email');
      expect(row.correctedValues?['email'], 'fixed@example.com');
      expect(row.correctionNote, 'Fixed typo');
      expect(row.correctedByUserId, 7);
      expect(row.lastValidatedAt, isNotNull);
    });

    test('parses skipped row detail wrapper', () {
      final row = BulkOnboardingRow.fromDetailResponseJson({
        'row': {
          'id': 11,
          'jobId': 42,
          'rowIndex': 2,
          'type': 'driver',
          'status': 'skipped',
          'skipReason': 'Duplicate in HR system',
          'skippedByUserId': 3,
          'skippedAt': '2026-06-19T11:00:00.000Z',
        },
      });

      expect(row.status, BulkOnboardingRowStatus.skipped);
      expect(row.skipReason, 'Duplicate in HR system');
    });
  });

  group('BulkOnboardingRow action validation', () {
    test('correction requires at least one field', () {
      expect(
        const BulkOnboardingRowCorrectionRequest().validate(),
        'bulkOnboardingRowCorrectionFieldRequired',
      );
      expect(
        const BulkOnboardingRowCorrectionRequest(
          email: 'fixed@example.com',
        ).validate(),
        isNull,
      );
    });

    test('skip requires reason', () {
      expect(
        const BulkOnboardingRowSkipRequest(reason: ' ').validate(),
        'bulkOnboardingRowSkipReasonRequired',
      );
      expect(
        const BulkOnboardingRowSkipRequest(reason: 'Out of scope').validate(),
        isNull,
      );
    });

    test('row action result parses row and job wrapper', () {
      final result = BulkOnboardingRowActionResult.fromJson({
        'row': {
          'id': 1,
          'jobId': 9,
          'rowIndex': 1,
          'type': 'driver',
          'status': 'valid',
        },
        'job': {
          'id': 9,
          'companyName': 'Co',
          'submittedByUserId': 1,
          'type': 'drivers',
          'status': 'ready_for_review',
          'totalRows': 1,
          'validRows': 1,
          'warningRows': 0,
          'invalidRows': 0,
          'duplicateRows': 0,
          'processedRows': 0,
          'failedRows': 0,
          'skippedRows': 0,
          'riskLevel': 'low',
          'processingAvailable': false,
        },
      });

      expect(result.row.status, BulkOnboardingRowStatus.valid);
      expect(result.job.skippedRows, 0);
    });
  });

  group('status and type parsing', () {
    test('unknown values fall back safely', () {
      expect(
        BulkOnboardingJobStatus.fromBackendValue('legacy_status'),
        BulkOnboardingJobStatus.unknown,
      );
      expect(
        BulkOnboardingRowStatus.fromBackendValue(null),
        BulkOnboardingRowStatus.unknown,
      );
      expect(
        BulkOnboardingJobType.fromBackendValue('vehicles'),
        BulkOnboardingJobType.vehicles,
      );
    });
  });

  group('BulkOnboardingActionRequest validation', () {
    test('reject and cancel require note', () {
      expect(
        const BulkOnboardingActionRequest(
          kind: BulkOnboardingActionKind.reject,
        ).validate(),
        'bulkOnboardingActionNoteRequired',
      );
      expect(
        const BulkOnboardingActionRequest(
          kind: BulkOnboardingActionKind.cancel,
        ).validate(),
        'bulkOnboardingActionNoteRequired',
      );
    });

    test('process requires explicit confirmation', () {
      expect(
        const BulkOnboardingActionRequest(
          kind: BulkOnboardingActionKind.process,
        ).validate(),
        'bulkOnboardingActionConfirmRequired',
      );
    });

    test('cancel action uses correct endpoint suffix', () {
      const request = BulkOnboardingActionRequest(
        kind: BulkOnboardingActionKind.cancel,
        note: 'No longer needed',
      );
      expect(request.endpointSuffix(), 'cancel');
      expect(request.endpointSuffix(), isNot('ccancel'));
      expect(request.httpMethod(), 'PATCH');
    });
  });

  group('execute visibility and policy', () {
    test('forbidden roles cannot execute', () {
      expect(
        canShowExecuteButton(
          role: AdminRole.supportAdmin,
          status: BulkOnboardingJobStatus.approvedForProcessing,
        ),
        isFalse,
      );
    });

    test('policy disables execution button', () {
      expect(
        isExecuteDisabledByPolicy(
          provisioningAvailable: true,
          policyEnabled: false,
          rowCount: 10,
          maxRows: 100,
        ),
        isTrue,
      );
      expect(
        isExecuteDisabledByPolicy(
          provisioningAvailable: true,
          policyEnabled: true,
          rowCount: 101,
          maxRows: 100,
        ),
        isTrue,
      );
    });
  });

  group('filter and dashboard summary', () {
    test('search and filter behavior', () {
      final job = BulkOnboardingJob.fromJson({
        'id': 100,
        'companyName': 'Searchable GmbH',
        'submittedByUserId': 1,
        'sourceFileName': 'fleet.csv',
        'type': 'vehicles',
        'status': 'ready_for_review',
        'totalRows': 1,
        'validRows': 1,
        'warningRows': 0,
        'invalidRows': 0,
        'duplicateRows': 0,
        'processedRows': 0,
        'failedRows': 0,
        'riskLevel': 'high',
        'processingAvailable': false,
      });

      expect(job.matchesSearch('searchable'), isTrue);
      expect(job.matchesFilter(BulkOnboardingListFilter.highRisk), isTrue);
      expect(
        job.matchesFilter(BulkOnboardingListFilter.validationFailed),
        isFalse,
      );
    });

    test('dashboard summary computation', () {
      final summary = BulkOnboardingDashboardSummary.fromJobs([
        BulkOnboardingJob.fromJson({
          'id': 1,
          'companyName': 'A',
          'submittedByUserId': 1,
          'type': 'drivers',
          'status': 'ready_for_review',
          'totalRows': 5,
          'validRows': 4,
          'warningRows': 1,
          'invalidRows': 2,
          'duplicateRows': 0,
          'processedRows': 0,
          'failedRows': 0,
          'riskLevel': 'high',
          'processingAvailable': false,
        }),
        BulkOnboardingJob.fromJson({
          'id': 2,
          'companyName': 'B',
          'submittedByUserId': 1,
          'type': 'drivers',
          'status': 'approved_for_processing',
          'totalRows': 2,
          'validRows': 2,
          'warningRows': 0,
          'invalidRows': 0,
          'duplicateRows': 0,
          'processedRows': 0,
          'failedRows': 0,
          'riskLevel': 'low',
          'processingAvailable': true,
        }),
      ]);

      expect(summary.jobsWaitingForReview, 1);
      expect(summary.highRiskJobs, 1);
      expect(summary.invalidRows, 2);
      expect(summary.processingJobs, 1);
    });

    test('parses upload response summary', () {
      final result = BulkOnboardingUploadResult.fromJson({
        'job': {
          'id': 77,
          'companyName': 'Upload Co',
          'submittedByUserId': 1,
          'type': 'drivers',
          'status': 'ready_for_review',
          'totalRows': 3,
          'validRows': 2,
          'warningRows': 0,
          'invalidRows': 0,
          'duplicateRows': 1,
          'processedRows': 0,
          'failedRows': 0,
          'riskLevel': 'medium',
          'processingAvailable': false,
        },
        'summary': {
          'totalRows': 3,
          'validRows': 2,
          'warningRows': 0,
          'invalidRows': 0,
          'duplicateRows': 1,
        },
        'processingAvailable': false,
        'metadataOnly': true,
      });

      expect(result.job.id, '77');
      expect(result.summary.duplicateRows, 1);
      expect(result.processingAvailable, isFalse);
    });

    test('row search and extended filters', () {
      const row = BulkOnboardingRow(
        id: '1',
        jobId: '9',
        rowIndex: 1,
        type: 'driver',
        status: BulkOnboardingRowStatus.valid,
        displayLabel: 'Driver One',
        email: 'driver@test.com',
        vehiclePlate: 'ABC123',
      );

      expect(row.matchesSearch('abc123'), isTrue);
      expect(row.matchesFilter(BulkOnboardingRowListFilter.valid), isTrue);
      expect(row.matchesFilter(BulkOnboardingRowListFilter.processed), isFalse);
    });

    test('skipped filter matches skipped status', () {
      const row = BulkOnboardingRow(
        id: '2',
        jobId: '9',
        rowIndex: 2,
        type: 'driver',
        status: BulkOnboardingRowStatus.skipped,
        skipReason: 'Manual skip',
      );

      expect(row.matchesFilter(BulkOnboardingRowListFilter.skipped), isTrue);
      expect(row.matchesFilter(BulkOnboardingRowListFilter.valid), isFalse);
    });

    test('job parses skippedRows and lastValidatedAt', () {
      final job = BulkOnboardingJob.fromJson({
        'id': 3,
        'companyName': 'Skipped Co',
        'submittedByUserId': 1,
        'type': 'drivers',
        'status': 'ready_for_review',
        'totalRows': 5,
        'validRows': 3,
        'warningRows': 0,
        'invalidRows': 1,
        'duplicateRows': 0,
        'processedRows': 0,
        'failedRows': 0,
        'skippedRows': 1,
        'riskLevel': 'medium',
        'processingAvailable': false,
        'lastValidatedAt': '2026-06-19T09:30:00.000Z',
      });

      expect(job.skippedRows, 1);
      expect(job.lastValidatedAt, isNotNull);
    });

    test('parses dry run and execute response payload', () {
      final result = BulkOnboardingExecutionResult.fromJson({
        'job': {
          'id': 22,
          'companyName': 'Execute Co',
          'submittedByUserId': 1,
          'type': 'drivers',
          'status': 'approved_for_processing',
          'totalRows': 2,
          'validRows': 2,
          'warningRows': 0,
          'invalidRows': 0,
          'duplicateRows': 0,
          'processedRows': 0,
          'failedRows': 0,
          'riskLevel': 'low',
          'processingAvailable': true,
        },
        'policy': {'enabled': true, 'maxRows': 1000, 'rowCount': 2},
        'summary': {
          'dryRunOk': 2,
          'blocked': 0,
          'duplicates': 0,
          'failed': 0,
          'provisioned': 2,
        },
        'rows': [
          {'rowId': 'r1', 'rowIndex': 1, 'status': 'processed'},
          {
            'rowId': 'r2',
            'rowIndex': 2,
            'status': 'failed',
            'reason': 'duplicate_email',
          },
        ],
      });

      expect(result.summary.provisioned, 2);
      expect(result.rows.first.status, BulkOnboardingRowStatus.processed);
      expect(result.rows.last.reason, 'duplicate_email');
      expect(result.policy.enabled, isTrue);
    });
  });
}
