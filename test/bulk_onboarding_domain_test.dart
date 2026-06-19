import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_action_request.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_dashboard_summary.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_job.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_risk_level.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_row.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_row_status.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_status.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_type.dart';

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
        const BulkOnboardingActionRequest(kind: BulkOnboardingActionKind.reject)
            .validate(),
        'bulkOnboardingActionNoteRequired',
      );
      expect(
        const BulkOnboardingActionRequest(kind: BulkOnboardingActionKind.cancel)
            .validate(),
        'bulkOnboardingActionNoteRequired',
      );
    });

    test('process requires explicit confirmation', () {
      expect(
        const BulkOnboardingActionRequest(kind: BulkOnboardingActionKind.process)
            .validate(),
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
      expect(job.matchesFilter(BulkOnboardingListFilter.validationFailed), isFalse);
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
  });
}
