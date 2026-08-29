import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/pricing_quote.dart';
import '../domain/pricing_quote_status.dart';

class PricingQuotesApi {
  PricingQuotesApi(this._apiClient);

  final ApiClient _apiClient;

  Future<List<PricingQuoteListItem>> listQuotes() async {
    final response = await _apiClient.get<dynamic>(
      '/platform-admin/pricing-quotes',
    );
    return _parseList(response.data);
  }

  Future<PricingQuoteDetail> getQuote(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/pricing-quotes/$id',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty pricing quote response');
    }
    return PricingQuoteDetail.fromJson(data);
  }

  Future<PricingQuoteListItem> createFromIntake({
    required int publicIntakeId,
    String? reason,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/pricing-quotes/from-intake/$publicIntakeId',
      data: {if (reason != null && reason.trim().isNotEmpty) 'reason': reason},
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty create-from-intake response');
    }
    return PricingQuoteListItem.fromJson(data);
  }

  Future<PricingQuoteListItem> recalculate({
    required int id,
    required String reason,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/pricing-quotes/$id/recalculate',
      data: {'reason': reason},
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty recalculate response');
    }
    return PricingQuoteListItem.fromJson(data);
  }

  Future<PricingQuoteListItem> applyAdjustment({
    required int id,
    required PricingQuoteAdjustmentRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/pricing-quotes/$id/adjustments',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty adjustment response');
    }
    return PricingQuoteListItem.fromJson(data);
  }

  Future<PricingQuoteListItem> approve(int id) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/pricing-quotes/$id/approve',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty approve response');
    }
    return PricingQuoteListItem.fromJson(data);
  }

  Future<PricingQuoteListItem> updateStatus({
    required int id,
    required PricingQuoteStatus status,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/pricing-quotes/$id/status',
      data: {'status': status.backendValue},
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty status response');
    }
    return PricingQuoteListItem.fromJson(data);
  }

  List<PricingQuoteListItem> _parseList(Object? data) {
    if (data is List) {
      return data
          .whereType<Map>()
          .map(
            (item) =>
                PricingQuoteListItem.fromJson(Map<String, dynamic>.from(item)),
          )
          .toList(growable: false);
    }
    if (data is Map) {
      final items = data['items'];
      if (items is List) {
        return items
            .whereType<Map>()
            .map(
              (item) => PricingQuoteListItem.fromJson(
                Map<String, dynamic>.from(item),
              ),
            )
            .toList(growable: false);
      }
    }
    if (data == null) return const [];
    throw StateError('Unexpected pricing quotes list response');
  }
}

final pricingQuotesApiProvider = Provider<PricingQuotesApi>(
  (ref) => PricingQuotesApi(ref.watch(apiClientProvider)),
);
