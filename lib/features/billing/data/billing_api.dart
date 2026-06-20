import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/billing_action_request.dart';
import '../domain/billing_overview.dart';
import '../domain/platform_subscription.dart';
import '../domain/pricing_intake.dart';
import '../domain/quote_request.dart';
import '../domain/subscription_status.dart';

class BillingApi {
  BillingApi(this._apiClient);

  final ApiClient _apiClient;

  Future<BillingOverview> getOverview() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/billing/overview',
    );
    final data = response.data;
    if (data == null) {
      return const BillingOverview(
        activeSubscriptions: 0,
        trialSubscriptions: 0,
        pastDueSubscriptions: 0,
        suspendedSubscriptions: 0,
        pricingIntakesNew: 0,
        quoteRequestsPending: 0,
      );
    }
    return BillingOverview.fromJson(data);
  }

  Future<PlatformSubscriptionsPage> listSubscriptions({
    SubscriptionStatus? status,
    String? companyId,
    int limit = 100,
    int offset = 0,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/subscriptions',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        if (status != null && status != SubscriptionStatus.unknown)
          'status': status.backendValue,
        if (companyId != null && companyId.trim().isNotEmpty)
          'companyId': companyId.trim(),
      },
    );
    final data = response.data;
    if (data == null) {
      return const PlatformSubscriptionsPage(items: [], total: 0);
    }
    return PlatformSubscriptionsPage.fromJson(data);
  }

  Future<PlatformSubscription> getSubscription(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/subscriptions/$id',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty subscription response');
    }
    return PlatformSubscription.fromJson(data);
  }

  Future<PlatformSubscription> updateSubscriptionStatus({
    required String id,
    required BillingSubscriptionStatusRequest request,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/subscriptions/$id/status',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty subscription status response');
    }
    return PlatformSubscription.fromJson(data);
  }

  Future<PricingIntakesPage> listPricingIntakes({
    int limit = 100,
    int offset = 0,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/pricing-intakes',
      queryParameters: {
        'limit': limit,
        'offset': offset,
      },
    );
    final data = response.data;
    if (data == null) {
      return const PricingIntakesPage(items: [], total: 0);
    }
    return PricingIntakesPage.fromJson(data);
  }

  Future<PricingIntake> getPricingIntake(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/pricing-intakes/$id',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty pricing intake response');
    }
    return PricingIntake.fromJson(data);
  }

  Future<PricingIntake> updatePricingIntakeStatus({
    required String id,
    required BillingPricingIntakeStatusRequest request,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/pricing-intakes/$id/status',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty pricing intake status response');
    }
    return PricingIntake.fromJson(data);
  }

  Future<List<QuoteRequest>> listQuoteRequests() async {
    final response = await _apiClient.get<List<dynamic>>(
      '/platform-admin/quote-requests',
    );
    final data = response.data;
    if (data == null) {
      return const [];
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(QuoteRequest.fromJson)
        .toList(growable: false);
  }

  Future<QuoteRequest> getQuoteRequest(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/quote-requests/$id',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty quote request response');
    }
    return QuoteRequest.fromJson(data);
  }

  Future<QuoteRequest> updateQuoteRequestStatus({
    required String id,
    required BillingQuoteRequestStatusRequest request,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/quote-requests/$id/status',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty quote request status response');
    }
    return QuoteRequest.fromJson(data);
  }
}

final billingApiProvider = Provider<BillingApi>(
  (ref) => BillingApi(ref.watch(apiClientProvider)),
);
