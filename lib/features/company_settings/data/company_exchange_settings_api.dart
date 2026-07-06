import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/company_exchange_settings.dart';

class CompanyExchangeSettingsApi {
  CompanyExchangeSettingsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<CompanyExchangeSettings> getSettings(String companyId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/companies/$companyId/exchange-settings',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty exchange settings response');
    }
    final settings = CompanyExchangeSettings.fromJson(data);
    return _mergePackagingItems(companyId, settings);
  }

  Future<CompanyExchangeSettings> patchSettings({
    required String companyId,
    required CompanyExchangeSettingsPatch patch,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/companies/$companyId/exchange-settings',
      data: patch.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty exchange settings patch response');
    }
    final settings = CompanyExchangeSettings.fromJson(data);
    return _mergePackagingItems(companyId, settings);
  }

  Future<CompanyExchangeSettings> _mergePackagingItems(
    String companyId,
    CompanyExchangeSettings settings,
  ) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/companies/$companyId/packaging-items',
      queryParameters: const {'includeInactive': true},
    );
    final rawItems = response.data?['items'];
    if (rawItems is! List) {
      return settings;
    }

    final items = rawItems
        .whereType<Map<String, dynamic>>()
        .map(DefaultPackagingItem.fromJson)
        .toList(growable: false);

    return settings.copyWith(defaultPackagingItems: items);
  }
}

final companyExchangeSettingsApiProvider = Provider<CompanyExchangeSettingsApi>(
  (ref) => CompanyExchangeSettingsApi(ref.watch(apiClientProvider)),
);
