import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/reply_translation_preview.dart';
import '../domain/translation_record.dart';
import '../domain/translation_request.dart';

class TranslationApi {
  TranslationApi(this._apiClient);

  final ApiClient _apiClient;

  Future<Map<String, dynamic>> fetchStatus() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/translations/status');
    return response.data ?? const {};
  }

  Future<TranslationOperationResult> translate(TranslationRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/translations/translate',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty translation response');
    }
    return TranslationOperationResult.fromJson(data);
  }

  Future<ReplyTranslationPreview> replyPreview({
    required String sourceType,
    required String sourceId,
    required String draftText,
    required String draftLanguage,
    required String targetLanguage,
    String? companyId,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/translations/reply-preview',
      data: {
        'sourceType': sourceType,
        'sourceId': sourceId,
        'draftText': draftText,
        'draftLanguage': draftLanguage,
        'targetLanguage': targetLanguage,
        if (companyId != null) 'companyId': int.tryParse(companyId) ?? companyId,
      },
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty reply preview response');
    }
    return ReplyTranslationPreview.fromJson(data);
  }

  Future<TranslationRecord> approve(String recordId) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/translations/$recordId/approve',
      data: const {},
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty approve response');
    }
    return TranslationRecord.fromJson(data);
  }
}

final translationApiProvider = Provider<TranslationApi>((ref) {
  return TranslationApi(ref.watch(apiClientProvider));
});
