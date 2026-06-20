import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/billing/data/billing_api.dart';
import 'package:vianexis_admin_app/features/billing/data/billing_repository.dart';
import 'package:vianexis_admin_app/features/billing/domain/billing_action_request.dart';
import 'package:vianexis_admin_app/features/billing/domain/pricing_intake_status.dart';
import 'package:vianexis_admin_app/features/billing/domain/quote_request_status.dart';
import 'package:vianexis_admin_app/features/billing/domain/subscription_status.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('LiveBillingRepository', () {
    late LiveBillingRepository repo;

    setUp(() {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      final apiClient = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      repo = LiveBillingRepository(BillingApi(apiClient));

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/platform-admin/billing/overview') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'metadataOnly': true,
                    'activeSubscriptions': 2,
                    'trialSubscriptions': 1,
                    'pastDueSubscriptions': 0,
                    'suspendedSubscriptions': 1,
                    'pricingIntakesNew': 3,
                    'quoteRequestsPending': 2,
                    'lastUpdatedAt': '2026-06-18T10:00:00.000Z',
                  },
                ),
              );
              return;
            }
            if (options.path == '/platform-admin/subscriptions') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'total': 1,
                    'metadataOnly': true,
                    'items': [
                      {
                        'subscriptionId': 55,
                        'companyId': 9,
                        'companyName': 'Live Co',
                        'status': 'active',
                        'plan': {'name': 'Pro', 'tier': 'pro'},
                        'billingMode': 'manual_invoice',
                      },
                    ],
                  },
                ),
              );
              return;
            }
            if (options.path == '/platform-admin/subscriptions/55/status') {
              expect(options.method, 'PATCH');
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'metadataOnly': true,
                    'id': 55,
                    'companyId': 9,
                    'companyName': 'Live Co',
                    'status': 'suspended',
                    'planName': 'Pro',
                  },
                ),
              );
              return;
            }
            if (options.path == '/platform-admin/pricing-intakes') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'total': 1,
                    'items': [
                      {
                        'id': 12,
                        'companyId': 9,
                        'status': 'submitted',
                        'needsHumanReview': false,
                        'intakePayload': {'estimatedOwnedTrucks': 10},
                        'createdAt': '2026-06-01T00:00:00.000Z',
                      },
                    ],
                  },
                ),
              );
              return;
            }
            if (options.path == '/platform-admin/quote-requests') {
              handler.resolve(
                Response<List<dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: [
                    {
                      'id': 77,
                      'companyName': 'Quote Co',
                      'contactEmail': 'billing@quote.co',
                      'status': 'submitted',
                      'createdAt': '2026-06-02T00:00:00.000Z',
                    },
                  ],
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

    test('fetches billing overview metadata', () async {
      final overview = await repo.fetchOverview();
      expect(overview.metadataOnly, isTrue);
      expect(overview.activeSubscriptions, 2);
      expect(repo.usesMockData, isFalse);
    });

    test('fetches subscriptions list', () async {
      final subscriptions = await repo.fetchSubscriptions();
      expect(subscriptions, hasLength(1));
      expect(subscriptions.first.id, '55');
      expect(subscriptions.first.status, SubscriptionStatus.active);
    });

    test('updates subscription status via patch endpoint', () async {
      final updated = await repo.updateSubscriptionStatus(
        id: '55',
        request: const BillingSubscriptionStatusRequest(
          status: SubscriptionStatus.suspended,
          reason: 'Compliance hold',
        ),
      );
      expect(updated.status, SubscriptionStatus.suspended);
    });

    test('fetches pricing intakes and quote requests', () async {
      final intakes = await repo.fetchPricingIntakes();
      expect(intakes, hasLength(1));
      expect(intakes.first.status, PricingIntakeStatus.newIntake);

      final quotes = await repo.fetchQuoteRequests();
      expect(quotes, hasLength(1));
      expect(quotes.first.status, QuoteRequestStatus.submitted);
    });
  });

  group('MockBillingRepository', () {
    test('returns mock billing data and supports status updates', () async {
      final repo = MockBillingRepository();
      expect(repo.usesMockData, isTrue);

      final overview = await repo.fetchOverview();
      expect(overview.activeSubscriptions, greaterThan(0));

      final subscriptions = await repo.fetchSubscriptions();
      expect(subscriptions.length, greaterThanOrEqualTo(2));

      final updated = await repo.updateSubscriptionStatus(
        id: '101',
        request: const BillingSubscriptionStatusRequest(
          status: SubscriptionStatus.suspended,
          reason: 'Mock hold',
        ),
      );
      expect(updated.status, SubscriptionStatus.suspended);

      final filtered = await repo.fetchSubscriptions(status: SubscriptionStatus.active);
      expect(filtered.every((item) => item.status == SubscriptionStatus.active), isTrue);
    });

    test('mock pricing intake status update works', () async {
      final repo = MockBillingRepository();
      final updated = await repo.updatePricingIntakeStatus(
        id: '501',
        request: const BillingPricingIntakeStatusRequest(
          status: PricingIntakeStatus.rejected,
          reason: 'Incomplete intake',
        ),
      );
      expect(updated.status, PricingIntakeStatus.rejected);
    });
  });
}
