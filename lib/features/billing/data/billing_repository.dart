import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/billing_action_request.dart';
import '../domain/billing_overview.dart';
import '../domain/platform_subscription.dart';
import '../domain/pricing_intake.dart';
import '../domain/pricing_intake_status.dart';
import '../domain/quote_request.dart';
import '../domain/quote_request_status.dart';
import '../domain/subscription_status.dart';
import 'billing_api.dart';

abstract class BillingRepository {
  Future<BillingOverview> fetchOverview();

  Future<List<PlatformSubscription>> fetchSubscriptions({
    SubscriptionStatus? status,
    String? companyId,
  });

  Future<PlatformSubscription> fetchSubscription(String id);

  Future<PlatformSubscription> updateSubscriptionStatus({
    required String id,
    required BillingSubscriptionStatusRequest request,
  });

  Future<List<PricingIntake>> fetchPricingIntakes();

  Future<PricingIntake> fetchPricingIntake(String id);

  Future<PricingIntake> updatePricingIntakeStatus({
    required String id,
    required BillingPricingIntakeStatusRequest request,
  });

  Future<List<QuoteRequest>> fetchQuoteRequests();

  Future<QuoteRequest> fetchQuoteRequest(String id);

  Future<QuoteRequest> updateQuoteRequestStatus({
    required String id,
    required BillingQuoteRequestStatusRequest request,
  });

  bool get usesMockData;
}

class LiveBillingRepository implements BillingRepository {
  LiveBillingRepository(this._api);

  final BillingApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<BillingOverview> fetchOverview() => _api.getOverview();

  @override
  Future<List<PlatformSubscription>> fetchSubscriptions({
    SubscriptionStatus? status,
    String? companyId,
  }) async {
    final page = await _api.listSubscriptions(
      status: status,
      companyId: companyId,
      limit: 200,
    );
    return page.items;
  }

  @override
  Future<PlatformSubscription> fetchSubscription(String id) =>
      _api.getSubscription(id);

  @override
  Future<PlatformSubscription> updateSubscriptionStatus({
    required String id,
    required BillingSubscriptionStatusRequest request,
  }) {
    return _api.updateSubscriptionStatus(id: id, request: request);
  }

  @override
  Future<List<PricingIntake>> fetchPricingIntakes() async {
    final page = await _api.listPricingIntakes(limit: 200);
    return page.items;
  }

  @override
  Future<PricingIntake> fetchPricingIntake(String id) =>
      _api.getPricingIntake(id);

  @override
  Future<PricingIntake> updatePricingIntakeStatus({
    required String id,
    required BillingPricingIntakeStatusRequest request,
  }) {
    return _api.updatePricingIntakeStatus(id: id, request: request);
  }

  @override
  Future<List<QuoteRequest>> fetchQuoteRequests() => _api.listQuoteRequests();

  @override
  Future<QuoteRequest> fetchQuoteRequest(String id) => _api.getQuoteRequest(id);

  @override
  Future<QuoteRequest> updateQuoteRequestStatus({
    required String id,
    required BillingQuoteRequestStatusRequest request,
  }) {
    return _api.updateQuoteRequestStatus(id: id, request: request);
  }
}

class MockBillingRepository implements BillingRepository {
  MockBillingRepository();

  BillingOverview _overview = BillingOverview(
    activeSubscriptions: 2,
    trialSubscriptions: 1,
    pastDueSubscriptions: 1,
    suspendedSubscriptions: 1,
    pricingIntakesNew: 2,
    quoteRequestsPending: 1,
    lastUpdatedAt: DateTime.utc(2026, 6, 18, 10, 0),
  );

  final List<PlatformSubscription> _subscriptions = [
    PlatformSubscription(
      id: '101',
      companyId: '1',
      companyName: 'NordTrans Kft.',
      status: SubscriptionStatus.active,
      planName: 'Pro Fleet',
      planTier: 'pro',
      billingCycle: 'manual_invoice',
      currency: 'EUR',
      seatsIncluded: 12,
      seatsUsed: 10,
      driverAppsIncluded: 8,
      driverAppsUsed: 7,
      aiAddOnEnabled: true,
      startedAt: DateTime.utc(2025, 3, 1),
      renewsAt: DateTime.utc(2026, 7, 1),
      lastPaymentStatus: 'current',
      pricingSource: 'approved_quote',
      operatingModel: 'mixed_fleet',
    ),
    PlatformSubscription(
      id: '102',
      companyId: '2',
      companyName: 'Alpine Logistics GmbH',
      status: SubscriptionStatus.trial,
      planName: 'Trial',
      planTier: 'basic',
      billingCycle: 'manual_invoice',
      currency: 'EUR',
      seatsIncluded: 5,
      seatsUsed: 3,
      driverAppsIncluded: 4,
      driverAppsUsed: 2,
      aiAddOnEnabled: false,
      startedAt: DateTime.utc(2026, 5, 20),
      renewsAt: DateTime.utc(2026, 6, 20),
      lastPaymentStatus: 'unknown',
      pricingSource: 'catalog_plan',
      operatingModel: 'owner_operator',
    ),
    PlatformSubscription(
      id: '103',
      companyId: '3',
      companyName: 'Suspended Fleet Ltd.',
      status: SubscriptionStatus.suspended,
      planName: 'Enterprise',
      planTier: 'enterprise',
      billingCycle: 'custom_contract',
      currency: 'EUR',
      seatsIncluded: 20,
      seatsUsed: 0,
      driverAppsIncluded: 15,
      driverAppsUsed: 0,
      aiAddOnEnabled: false,
      startedAt: DateTime.utc(2024, 11, 5),
      cancelledAt: null,
      lastPaymentStatus: 'past_due',
      pricingSource: 'manual_admin',
      operatingModel: 'enterprise',
    ),
    PlatformSubscription(
      id: '104',
      companyId: '4',
      companyName: 'Danube Spedition Zrt.',
      status: SubscriptionStatus.pastDue,
      planName: 'Pro Fleet',
      planTier: 'pro',
      billingCycle: 'manual_invoice',
      currency: 'EUR',
      seatsIncluded: 8,
      seatsUsed: 8,
      driverAppsIncluded: 6,
      driverAppsUsed: 6,
      aiAddOnEnabled: true,
      startedAt: DateTime.utc(2025, 8, 12),
      renewsAt: DateTime.utc(2026, 6, 12),
      lastPaymentStatus: 'past_due',
      pricingSource: 'approved_quote',
      operatingModel: 'spedition_broker',
    ),
  ];

  final List<PricingIntake> _pricingIntakes = [
    PricingIntake(
      id: '501',
      companyId: '5',
      companyName: 'Baltic Freight OÜ',
      contactEmail: 'ops@balticfreight.ee',
      country: 'EE',
      fleetSize: 25,
      officeUsers: 6,
      driverApps: 20,
      requestedModules: const ['fleet_map', 'workshop'],
      requestedAiFeatures: const ['ai_translation'],
      status: PricingIntakeStatus.newIntake,
      riskLevel: 'normal',
      needsHumanReview: false,
      createdAt: DateTime.utc(2026, 6, 15),
      updatedAt: DateTime.utc(2026, 6, 15),
    ),
    PricingIntake(
      id: '502',
      companyId: '6',
      companyName: 'High Risk Cargo SRL',
      contactEmail: 'billing@highrisk.ro',
      country: 'RO',
      fleetSize: 40,
      officeUsers: 10,
      driverApps: 35,
      requestedModules: const ['external_jobs'],
      requestedAiFeatures: const ['ai_extraction', 'ai_translation'],
      status: PricingIntakeStatus.reviewing,
      riskLevel: 'high',
      needsHumanReview: true,
      createdAt: DateTime.utc(2026, 6, 10),
      updatedAt: DateTime.utc(2026, 6, 17),
    ),
    PricingIntake(
      id: '503',
      companyId: '7',
      companyName: 'Quoted Transport AG',
      contactEmail: 'admin@quoted.ch',
      country: 'CH',
      fleetSize: 12,
      officeUsers: 4,
      driverApps: 10,
      requestedModules: const ['workshop'],
      requestedAiFeatures: const [],
      status: PricingIntakeStatus.quoted,
      riskLevel: 'normal',
      needsHumanReview: false,
      createdAt: DateTime.utc(2026, 5, 28),
      updatedAt: DateTime.utc(2026, 6, 12),
    ),
  ];

  final List<QuoteRequest> _quoteRequests = [
    QuoteRequest(
      id: '701',
      companyName: 'Pending Quote Logistics',
      contactEmail: 'finance@pendingquote.hu',
      status: QuoteRequestStatus.submitted,
      fleetSize: 18,
      officeUsers: 5,
      driverUsers: 15,
      createdAt: DateTime.utc(2026, 6, 16),
    ),
    QuoteRequest(
      id: '702',
      companyId: '8',
      companyName: 'Review Queue Sped',
      contactEmail: 'ops@reviewqueue.de',
      status: QuoteRequestStatus.underReview,
      fleetSize: 30,
      officeUsers: 8,
      driverUsers: 25,
      createdAt: DateTime.utc(2026, 6, 8),
    ),
    QuoteRequest(
      id: '703',
      companyName: 'Accepted Fleet Co',
      contactEmail: 'billing@accepted.at',
      status: QuoteRequestStatus.accepted,
      fleetSize: 10,
      officeUsers: 3,
      driverUsers: 8,
      createdAt: DateTime.utc(2026, 5, 1),
    ),
  ];

  @override
  bool get usesMockData => true;

  @override
  Future<BillingOverview> fetchOverview() async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return _overview;
  }

  @override
  Future<List<PlatformSubscription>> fetchSubscriptions({
    SubscriptionStatus? status,
    String? companyId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _subscriptions
        .where((item) => status == null || item.status == status)
        .where((item) => companyId == null || item.companyId == companyId)
        .toList(growable: false);
  }

  @override
  Future<PlatformSubscription> fetchSubscription(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _subscriptions.firstWhere(
      (item) => item.id == id,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  @override
  Future<PlatformSubscription> updateSubscriptionStatus({
    required String id,
    required BillingSubscriptionStatusRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final index = _subscriptions.indexWhere((item) => item.id == id);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }
    final current = _subscriptions[index];
    final updated = PlatformSubscription(
      id: current.id,
      companyId: current.companyId,
      companyName: current.companyName,
      status: request.status,
      planName: current.planName,
      planTier: current.planTier,
      billingCycle: current.billingCycle,
      currency: current.currency,
      seatsIncluded: current.seatsIncluded,
      seatsUsed: current.seatsUsed,
      driverAppsIncluded: current.driverAppsIncluded,
      driverAppsUsed: current.driverAppsUsed,
      aiAddOnEnabled: current.aiAddOnEnabled,
      startedAt: current.startedAt,
      renewsAt: current.renewsAt,
      cancelledAt: request.status == SubscriptionStatus.cancelled
          ? DateTime.now().toUtc()
          : current.cancelledAt,
      lastPaymentStatus: request.status == SubscriptionStatus.pastDue
          ? 'past_due'
          : current.lastPaymentStatus,
      pricingSource: current.pricingSource,
      operatingModel: current.operatingModel,
    );
    _subscriptions[index] = updated;
    _refreshOverviewCounts();
    return updated;
  }

  @override
  Future<List<PricingIntake>> fetchPricingIntakes() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return List<PricingIntake>.from(_pricingIntakes);
  }

  @override
  Future<PricingIntake> fetchPricingIntake(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _pricingIntakes.firstWhere(
      (item) => item.id == id,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  @override
  Future<PricingIntake> updatePricingIntakeStatus({
    required String id,
    required BillingPricingIntakeStatusRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final index = _pricingIntakes.indexWhere((item) => item.id == id);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }
    final current = _pricingIntakes[index];
    final updated = PricingIntake(
      id: current.id,
      companyId: current.companyId,
      companyName: current.companyName,
      contactName: current.contactName,
      contactEmail: current.contactEmail,
      country: current.country,
      fleetSize: current.fleetSize,
      officeUsers: current.officeUsers,
      driverApps: current.driverApps,
      requestedModules: current.requestedModules,
      requestedAiFeatures: current.requestedAiFeatures,
      status: request.status,
      riskLevel: current.riskLevel,
      needsHumanReview: current.needsHumanReview,
      createdAt: current.createdAt,
      updatedAt: DateTime.now().toUtc(),
    );
    _pricingIntakes[index] = updated;
    _refreshOverviewCounts();
    return updated;
  }

  @override
  Future<List<QuoteRequest>> fetchQuoteRequests() async {
    await Future<void>.delayed(const Duration(milliseconds: 180));
    return List<QuoteRequest>.from(_quoteRequests);
  }

  @override
  Future<QuoteRequest> fetchQuoteRequest(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return _quoteRequests.firstWhere(
      (item) => item.id == id,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  @override
  Future<QuoteRequest> updateQuoteRequestStatus({
    required String id,
    required BillingQuoteRequestStatusRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final index = _quoteRequests.indexWhere((item) => item.id == id);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }
    final current = _quoteRequests[index];
    final updated = QuoteRequest(
      id: current.id,
      companyId: current.companyId,
      companyName: current.companyName,
      contactEmail: current.contactEmail,
      status: request.status,
      fleetSize: current.fleetSize,
      officeUsers: current.officeUsers,
      driverUsers: current.driverUsers,
      createdAt: current.createdAt,
    );
    _quoteRequests[index] = updated;
    _refreshOverviewCounts();
    return updated;
  }

  void _refreshOverviewCounts() {
    _overview = BillingOverview(
      activeSubscriptions: _subscriptions
          .where((s) => s.status == SubscriptionStatus.active)
          .length,
      trialSubscriptions: _subscriptions
          .where((s) => s.status == SubscriptionStatus.trial)
          .length,
      pastDueSubscriptions: _subscriptions
          .where((s) => s.status == SubscriptionStatus.pastDue)
          .length,
      suspendedSubscriptions: _subscriptions
          .where((s) => s.status == SubscriptionStatus.suspended)
          .length,
      pricingIntakesNew: _pricingIntakes
          .where(
            (i) =>
                i.status == PricingIntakeStatus.newIntake ||
                i.status == PricingIntakeStatus.reviewing,
          )
          .length,
      quoteRequestsPending: _quoteRequests
          .where(
            (q) =>
                q.status == QuoteRequestStatus.submitted ||
                q.status == QuoteRequestStatus.underReview,
          )
          .length,
      lastUpdatedAt: DateTime.now().toUtc(),
    );
  }
}

final billingRepositoryProvider = Provider<BillingRepository>((ref) {

  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveBillingRepository(ref.watch(billingApiProvider));
  }
  return MockBillingRepository();
});
