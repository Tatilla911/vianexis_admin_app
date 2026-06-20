import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../domain/ai_review_item.dart';

class AiReviewsApi {
  AiReviewsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<List<AiReviewItem>> listReviews({int limit = 200}) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/ai-reviews',
      queryParameters: {'limit': limit},
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(messageKey: 'aiReviewLoadError');
    }

    final items = data['items'];
    if (items is! List) return const [];

    return items
        .whereType<Map>()
        .map((item) => AiReviewItem.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  Future<AiReviewItem> getReview(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/ai-reviews/$id',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(messageKey: 'aiReviewLoadError');
    }

    final reviewJson = data['review'] ?? data['item'] ?? data;
    if (reviewJson is Map<String, dynamic>) {
      return AiReviewItem.fromJson(reviewJson);
    }
    if (reviewJson is Map) {
      return AiReviewItem.fromJson(Map<String, dynamic>.from(reviewJson));
    }
    throw const ApiException(messageKey: 'aiReviewLoadError');
  }
}

final aiReviewsApiProvider = Provider<AiReviewsApi>((ref) {
  return AiReviewsApi(ref.watch(apiClientProvider));
});
