import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../domain/pricing_quote.dart';
import '../domain/pricing_quote_status.dart';
import 'pricing_quotes_api.dart';

class PricingQuotesRepository {
  PricingQuotesRepository(this._api);

  final PricingQuotesApi _api;

  Future<List<PricingQuoteListItem>> fetchQuotes() => _api.listQuotes();

  Future<PricingQuoteDetail> fetchQuote(int id) => _api.getQuote(id);

  Future<PricingQuoteListItem> createFromIntake({
    required int publicIntakeId,
    String? reason,
  }) {
    return _api.createFromIntake(
      publicIntakeId: publicIntakeId,
      reason: reason,
    );
  }

  Future<PricingQuoteListItem> recalculate({
    required int id,
    required String reason,
  }) {
    return _api.recalculate(id: id, reason: reason);
  }

  Future<PricingQuoteListItem> applyAdjustment({
    required int id,
    required PricingQuoteAdjustmentRequest request,
  }) {
    return _api.applyAdjustment(id: id, request: request);
  }

  Future<PricingQuoteListItem> approve(int id) => _api.approve(id);

  Future<PricingQuoteListItem> updateStatus({
    required int id,
    required PricingQuoteStatus status,
  }) {
    return _api.updateStatus(id: id, status: status);
  }
}

final pricingQuotesRepositoryProvider = Provider<PricingQuotesRepository>((ref) {
  return PricingQuotesRepository(ref.watch(pricingQuotesApiProvider));
});
