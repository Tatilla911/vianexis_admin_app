import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/data/bulk_onboarding_api.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/data/bulk_onboarding_repository.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_action_request.dart';
import 'package:vianexis_admin_app/features/bulk_onboarding/domain/bulk_onboarding_status.dart';

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
            if (options.path == '/platform-admin/bulk-onboarding/jobs/11/process') {
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
            if (options.path == '/platform-admin/bulk-onboarding/jobs/11/cancel') {
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
  });
}
