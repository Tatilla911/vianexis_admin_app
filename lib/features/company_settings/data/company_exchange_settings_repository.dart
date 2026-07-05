import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../domain/company_exchange_settings.dart';
import 'company_exchange_settings_api.dart';

abstract class CompanyExchangeSettingsRepository {
  Future<CompanyExchangeSettings> fetchSettings(String companyId);

  Future<CompanyExchangeSettings> saveSettings({
    required String companyId,
    required CompanyExchangeSettingsPatch patch,
  });

  bool get usesMockData;
}

class LiveCompanyExchangeSettingsRepository
    implements CompanyExchangeSettingsRepository {
  LiveCompanyExchangeSettingsRepository(this._api);

  final CompanyExchangeSettingsApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<CompanyExchangeSettings> fetchSettings(String companyId) {
    return _api.getSettings(companyId);
  }

  @override
  Future<CompanyExchangeSettings> saveSettings({
    required String companyId,
    required CompanyExchangeSettingsPatch patch,
  }) {
    return _api.patchSettings(companyId: companyId, patch: patch);
  }
}

class MockCompanyExchangeSettingsRepository
    implements CompanyExchangeSettingsRepository {
  MockCompanyExchangeSettingsRepository();

  CompanyExchangeSettings _settings = const CompanyExchangeSettings(
    palletExchangeEnabled: true,
    packagingExchangeEnabled: true,
    allowDriverCustomPackagingItems: true,
    defaultPalletTypes: ['EUR', 'EPAL', 'CHEP'],
    defaultPackagingItems: [
      DefaultPackagingItem(id: 'box', name: 'Doboz'),
      DefaultPackagingItem(id: 'carton', name: 'Karton'),
      DefaultPackagingItem(id: 'roll_cage', name: 'Roll cage'),
    ],
  );

  @override
  bool get usesMockData => true;

  @override
  Future<CompanyExchangeSettings> fetchSettings(String companyId) async {
    return _settings;
  }

  @override
  Future<CompanyExchangeSettings> saveSettings({
    required String companyId,
    required CompanyExchangeSettingsPatch patch,
  }) async {
    _settings = _settings.copyWith(
      palletExchangeEnabled: patch.palletExchangeEnabled,
      packagingExchangeEnabled: patch.packagingExchangeEnabled,
      allowDriverCustomPackagingItems: patch.allowDriverCustomPackagingItems,
    );
    return _settings;
  }
}

final companyExchangeSettingsRepositoryProvider =
    Provider<CompanyExchangeSettingsRepository>((ref) {
  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveCompanyExchangeSettingsRepository(
      ref.watch(companyExchangeSettingsApiProvider),
    );
  }
  return MockCompanyExchangeSettingsRepository();
});

final companyExchangeSettingsProvider =
    FutureProvider.autoDispose.family<CompanyExchangeSettings, String>(
  (ref, companyId) {
    return ref.watch(companyExchangeSettingsRepositoryProvider).fetchSettings(
          companyId,
        );
  },
);

Future<void> saveCompanyExchangeSettings(
  WidgetRef ref, {
  required String companyId,
  required CompanyExchangeSettingsPatch patch,
}) async {
  await ref.read(companyExchangeSettingsRepositoryProvider).saveSettings(
        companyId: companyId,
        patch: patch,
      );
  ref.invalidate(companyExchangeSettingsProvider(companyId));
}
