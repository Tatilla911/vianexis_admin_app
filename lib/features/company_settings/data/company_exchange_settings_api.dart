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
    return CompanyExchangeSettings.fromJson(data);
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
    return CompanyExchangeSettings.fromJson(data);
  }
}

final companyExchangeSettingsApiProvider = Provider<CompanyExchangeSettingsApi>(
  (ref) => CompanyExchangeSettingsApi(ref.watch(apiClientProvider)),
);
