import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/data/bulk_onboarding_api.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/data/bulk_onboarding_repository.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_action_request.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_execution.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_status.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_row_action.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_row_status.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_type.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('LiveBulkOnboardingRepository', () {
    late Dio dio;
    late LiveBulkOnboardingRepository repo;

    setUp(() {
      dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      final apiClient = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      repo = LiveBulkOnboardingRepository(BulkOnboardingApi(apiClient));

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/platform-admin/bulk-onboarding/jobs') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'total': 1,
                    'items': [
                      {
                        'id': 11,
                        'companyName': 'Live Co',
                        'submittedByUserId': 1,
                        'type': 'company_users',
                        'status': 'ready_for_review',
                        'totalRows': 2,
                        'validRows': 2,
                        'warningRows': 0,
                        'invalidRows': 0,
                        'duplicateRows': 0,
                        'processedRows': 0,
                        'failedRows': 0,
                        'riskLevel': 'low',
                        'processingAvailable': false,
                        'metadataOnly': true,
                      },
                    ],
                    'metadataOnly': true,
                  },
                ),
              );
              return;
            }
            if (options.path ==
                '/platform-admin/bulk-onboarding/jobs/11/process') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 201,
                  data: {
                    'job': {
                      'id': 11,
                      'companyName': 'Live Co',
                      'submittedByUserId': 1,
                      'type': 'company_users',
                      'status': 'completed',
                      'totalRows': 2,
                      'validRows': 2,
                      'warningRows': 0,
                      'invalidRows': 0,
                      'duplicateRows': 0,
                      'processedRows': 2,
                      'failedRows': 0,
                      'riskLevel': 'low',
                      'processingAvailable': false,
                    },
                  },
                ),
              );
              return;
            }
            if (options.path ==
                '/platform-admin/bulk-onboarding/jobs/11/dry-run') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'job': {
                      'id': 11,
                      'companyName': 'Live Co',
                      'submittedByUserId': 1,
                      'type': 'company_users',
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
                      'provisioned': 0,
                    },
                    'rows': [
                      {'rowId': '100', 'rowIndex': 1, 'status': 'valid'},
                    ],
                  },
                ),
              );
              return;
            }
            if (options.path ==
                '/platform-admin/bulk-onboarding/jobs/11/execute') {
              if ((options.data as Map<String, dynamic>)['reason'] ==
                  'blocked') {
                handler.reject(
                  DioException(
                    requestOptions: options,
                    response: Response(
                      requestOptions: options,
                      statusCode: 409,
                      data: {'code': 'policy_blocked'},
                    ),
                    type: DioExceptionType.badResponse,
                  ),
                );
                return;
              }
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'job': {
                      'id': 11,
                      'companyName': 'Live Co',
                      'submittedByUserId': 1,
                      'type': 'company_users',
                      'status': 'completed',
                      'totalRows': 2,
                      'validRows': 2,
                      'warningRows': 0,
                      'invalidRows': 0,
                      'duplicateRows': 0,
                      'processedRows': 2,
                      'failedRows': 0,
                      'riskLevel': 'low',
                      'processingAvailable': false,
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
                      {'rowId': '100', 'rowIndex': 1, 'status': 'processed'},
                      {'rowId': '101', 'rowIndex': 2, 'status': 'processed'},
                    ],
                  },
                ),
              );
              return;
            }
            if (options.path == '/platform-admin/bulk-onboarding/jobs/upload') {
              expect(options.method, 'POST');
              expect(options.data, isA<FormData>());
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 201,
                  data: {
                    'job': {
                      'id': 88,
                      'companyName': 'Upload Co',
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
                      'riskLevel': 'low',
                      'processingAvailable': false,
                    },
                    'summary': {
                      'totalRows': 1,
                      'validRows': 1,
                      'warningRows': 0,
                      'invalidRows': 0,
                      'duplicateRows': 0,
                    },
                    'processingAvailable': false,
                    'metadataOnly': true,
                  },
                ),
              );
              return;
            }
            if (options.path ==
                '/platform-admin/bulk-onboarding/templates/drivers.csv') {
              handler.resolve(
                Response<String>(
                  requestOptions: options,
                  statusCode: 200,
                  data: 'name,email,phone,country,role\n',
                ),
              );
              return;
            }
            if (options.path ==
                '/platform-admin/bulk-onboarding/jobs/11/export-validation-report.csv') {
              handler.resolve(
                Response<String>(
                  requestOptions: options,
                  statusCode: 200,
                  data:
                      'rowIndex,status,displayLabel,name,email,phone,role,vehiclePlate,trailerPlate,validationErrors,validationWarnings,duplicateReason\n1,valid,Row 1,Test,test@example.com,,driver,,,,\n',
                ),
              );
              return;
            }
            if (options.path ==
                '/platform-admin/bulk-onboarding/jobs/11/cancel') {
              expect(options.method, 'PATCH');
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'job': {
                      'id': 11,
                      'companyName': 'Live Co',
                      'submittedByUserId': 1,
                      'type': 'company_users',
                      'status': 'cancelled',
                      'totalRows': 2,
                      'validRows': 2,
                      'warningRows': 0,
                      'invalidRows': 0,
                      'duplicateRows': 0,
                      'processedRows': 0,
                      'failedRows': 0,
                      'riskLevel': 'low',
                      'processingAvailable': false,
                    },
                  },
                ),
              );
              return;
            }
            if (options.path ==
                '/platform-admin/bulk-onboarding/jobs/11/rows/100/correct') {
              expect(options.method, 'PATCH');
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'row': {
                      'id': 100,
                      'jobId': 11,
                      'rowIndex': 1,
                      'type': 'company_user',
                      'status': 'valid',
                      'email': 'fixed@example.com',
                      'originalValues': {'email': 'bad'},
                      'correctedValues': {'email': 'fixed@example.com'},
                    },
                    'job': {
                      'id': 11,
                      'companyName': 'Live Co',
                      'submittedByUserId': 1,
                      'type': 'company_users',
                      'status': 'ready_for_review',
                      'totalRows': 2,
                      'validRows': 2,
                      'warningRows': 0,
                      'invalidRows': 0,
                      'duplicateRows': 0,
                      'processedRows': 0,
                      'failedRows': 0,
                      'skippedRows': 0,
                      'riskLevel': 'low',
                      'processingAvailable': false,
                    },
                  },
                ),
              );
              return;
            }
            if (options.path ==
                '/platform-admin/bulk-onboarding/jobs/11/revalidate') {
              expect(options.method, 'POST');
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'job': {
                      'id': 11,
                      'companyName': 'Live Co',
                      'submittedByUserId': 1,
                      'type': 'company_users',
                      'status': 'ready_for_review',
                      'totalRows': 2,
                      'validRows': 2,
                      'warningRows': 0,
                      'invalidRows': 0,
                      'duplicateRows': 0,
                      'processedRows': 0,
                      'failedRows': 0,
                      'skippedRows': 0,
                      'riskLevel': 'low',
                      'processingAvailable': false,
                      'lastValidatedAt': '2026-06-19T12:00:00.000Z',
                    },
                  },
                ),
              );
              return;
            }
            handler.reject(
              DioException(requestOptions: options, message: 'Unexpected path'),
            );
          },
        ),
      );
    });

    test('fetches jobs from live API', () async {
      final jobs = await repo.fetchJobs();
      expect(jobs, hasLength(1));
      expect(jobs.first.companyName, 'Live Co');
      expect(repo.usesMockData, isFalse);
    });

    test('submits process action', () async {
      final result = await repo.submitAction(
        jobId: '11',
        request: const BulkOnboardingActionRequest(
          kind: BulkOnboardingActionKind.process,
          confirm: true,
        ),
      );
      expect(result.status, BulkOnboardingJobStatus.completed);
      expect(result.processingAvailable, isFalse);
    });

    test('dry run parses summary and rows', () async {
      final result = await repo.dryRunJob('11');
      expect(result.summary.dryRunOk, 2);
      expect(result.rows.first.rowIndex, 1);
    });

    test('execute maps backend rejection to user-friendly error', () async {
      expect(
        () => repo.executeJob(
          '11',
          const BulkOnboardingExecutionRequest(
            reason: 'blocked',
            confirm: true,
          ),
        ),
        throwsA(
          isA<ApiException>().having(
            (error) => error.messageKey,
            'message key',
            'bulkOnboardingExecuteRejectedPolicy',
          ),
        ),
      );
    });

    test('submits cancel action on correct path', () async {
      final result = await repo.submitAction(
        jobId: '11',
        request: const BulkOnboardingActionRequest(
          kind: BulkOnboardingActionKind.cancel,
          note: 'No longer needed',
        ),
      );
      expect(result.status, BulkOnboardingJobStatus.cancelled);
    });

    test('uploadCsv uses multipart upload endpoint', () async {
      final result = await repo.uploadCsv(
        bytes: [110, 97, 109, 101, 44, 101, 109, 97, 105, 108],
        fileName: 'drivers.csv',
        type: BulkOnboardingJobType.drivers,
        companyName: 'Upload Co',
      );
      expect(result.job.id, '88');
      expect(result.processingAvailable, isFalse);
    });

    test('downloadTemplate hits template endpoint', () async {
      final template = await repo.downloadTemplate(
        BulkOnboardingJobType.drivers,
      );
      expect(template, contains('name,email'));
    });

    test('downloadValidationReport hits export endpoint', () async {
      final report = await repo.downloadValidationReport('11');
      expect(report, contains('rowIndex,status,displayLabel'));
      expect(report, contains('validationErrors'));
    });

    test('correctRow hits correction endpoint', () async {
      final result = await repo.correctRow(
        jobId: '11',
        rowId: '100',
        request: const BulkOnboardingRowCorrectionRequest(
          email: 'fixed@example.com',
        ),
      );
      expect(result.row.status, BulkOnboardingRowStatus.valid);
      expect(result.row.originalValues?['email'], 'bad');
    });

    test('revalidateJob hits job revalidate endpoint', () async {
      final job = await repo.revalidateJob('11');
      expect(job.lastValidatedAt, isNotNull);
    });
  });

  group('MockBulkOnboardingRepository', () {
    test('returns mock jobs and respects processingAvailable flag', () async {
      final repo = MockBulkOnboardingRepository();
      final jobs = await repo.fetchJobs();
      expect(repo.usesMockData, isTrue);
      expect(jobs.any((job) => job.processingAvailable), isTrue);
      expect(jobs.any((job) => !job.processingAvailable), isTrue);
    });

    test('mock process disables processingAvailable', () async {
      final repo = MockBulkOnboardingRepository();
      final approved = (await repo.fetchJobs()).firstWhere(
        (job) => job.processingAvailable,
      );
      final processed = await repo.submitAction(
        jobId: approved.id,
        request: const BulkOnboardingActionRequest(
          kind: BulkOnboardingActionKind.process,
          confirm: true,
        ),
      );
      expect(processed.processingAvailable, isFalse);
    });

    test('mock upload keeps processingAvailable false', () async {
      final repo = MockBulkOnboardingRepository();
      final result = await repo.uploadCsv(
        bytes: const [1, 2, 3],
        fileName: 'mock.csv',
        type: BulkOnboardingJobType.drivers,
      );
      expect(result.processingAvailable, isFalse);
      expect(result.metadataOnly, isTrue);
    });

    test('mock validation report csv contains metadata headers', () async {
      final repo = MockBulkOnboardingRepository();
      final report = await repo.downloadValidationReport('502');
      expect(report, contains('rowIndex,status,displayLabel'));
      expect(report, contains('validationErrors'));
    });

    test(
      'mock correct invalid row to valid and preserves original values',
      () async {
        final repo = MockBulkOnboardingRepository();
        final result = await repo.correctRow(
          jobId: '502',
          rowId: '9102',
          request: const BulkOnboardingRowCorrectionRequest(
            email: 'fixed@alpine.example',
          ),
        );
        expect(result.row.status, BulkOnboardingRowStatus.valid);
        expect(result.row.originalValues?['email'], 'bad-email');
        expect(result.job.invalidRows, 0);
      },
    );

    test('mock skip row requires summary update', () async {
      final repo = MockBulkOnboardingRepository();
      final result = await repo.skipRow(
        jobId: '502',
        rowId: '9103',
        request: const BulkOnboardingRowSkipRequest(
          reason: 'Already onboarded',
        ),
      );
      expect(result.row.status, BulkOnboardingRowStatus.skipped);
      expect(result.job.skippedRows, 1);
    });

    test('mock revalidate row refreshes status', () async {
      final repo = MockBulkOnboardingRepository();
      await repo.correctRow(
        jobId: '502',
        rowId: '9102',
        request: const BulkOnboardingRowCorrectionRequest(email: 'still-bad'),
      );
      final result = await repo.revalidateRow(jobId: '502', rowId: '9102');
      expect(result.row.status, BulkOnboardingRowStatus.invalid);
    });

    test('mock dry run and execute use policy checks', () async {
      final repo = MockBulkOnboardingRepository();
      final dryRun = await repo.dryRunJob('503');
      expect(dryRun.policy.enabled, isTrue);

      final result = await repo.executeJob(
        '503',
        const BulkOnboardingExecutionRequest(reason: 'Approved', confirm: true),
      );
      expect(result.summary.provisioned, result.summary.dryRunOk);
    });
  });
}
