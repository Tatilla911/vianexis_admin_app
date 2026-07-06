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

  Future<void> createPackagingItem({
    required String companyId,
    required PackagingItemPatch patch,
  });

  Future<void> patchPackagingItem({
    required String companyId,
    required String itemId,
    required PackagingItemPatch patch,
  });

  Future<void> deactivatePackagingItem({
    required String companyId,
    required String itemId,
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

  @override
  Future<void> createPackagingItem({
    required String companyId,
    required PackagingItemPatch patch,
  }) async {
    await _api.createPackagingItem(companyId: companyId, patch: patch);
  }

  @override
  Future<void> patchPackagingItem({
    required String companyId,
    required String itemId,
    required PackagingItemPatch patch,
  }) async {
    await _api.patchPackagingItem(
      companyId: companyId,
      itemId: itemId,
      patch: patch,
    );
  }

  @override
  Future<void> deactivatePackagingItem({
    required String companyId,
    required String itemId,
  }) async {
    await _api.deactivatePackagingItem(companyId: companyId, itemId: itemId);
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

  @override
  Future<void> createPackagingItem({
    required String companyId,
    required PackagingItemPatch patch,
  }) async {
    final item = DefaultPackagingItem(
      id: 'mock-${DateTime.now().millisecondsSinceEpoch}',
      name: patch.name ?? 'Packaging item',
      sortOrder: patch.sortOrder ?? 0,
      active: patch.isActive ?? true,
      notes: patch.notes,
    );
    _settings = _settings.copyWith(
      defaultPackagingItems: [..._settings.defaultPackagingItems, item],
    );
  }

  @override
  Future<void> patchPackagingItem({
    required String companyId,
    required String itemId,
    required PackagingItemPatch patch,
  }) async {
    _settings = _settings.copyWith(
      defaultPackagingItems: [
        for (final item in _settings.defaultPackagingItems)
          if (item.id == itemId)
            DefaultPackagingItem(
              id: item.id,
              name: patch.name ?? item.name,
              localizedNameKey: item.localizedNameKey,
              localizedNames: patch.localizedNames ?? item.localizedNames,
              active: patch.isActive ?? item.active,
              sortOrder: patch.sortOrder ?? item.sortOrder,
              requiresReturn: item.requiresReturn,
              allowQuantity: item.allowQuantity,
              notes: patch.notes ?? item.notes,
            )
          else
            item,
      ],
    );
  }

  @override
  Future<void> deactivatePackagingItem({
    required String companyId,
    required String itemId,
  }) async {
    await patchPackagingItem(
      companyId: companyId,
      itemId: itemId,
      patch: const PackagingItemPatch(isActive: false),
    );
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

final companyExchangeSettingsProvider = FutureProvider.autoDispose
    .family<CompanyExchangeSettings, String>((ref, companyId) {
      return ref
          .watch(companyExchangeSettingsRepositoryProvider)
          .fetchSettings(companyId);
    });

Future<void> saveCompanyExchangeSettings(
  WidgetRef ref, {
  required String companyId,
  required CompanyExchangeSettingsPatch patch,
}) async {
  await ref
      .read(companyExchangeSettingsRepositoryProvider)
      .saveSettings(companyId: companyId, patch: patch);
  ref.invalidate(companyExchangeSettingsProvider(companyId));
}

Future<void> createCompanyPackagingItem(
  WidgetRef ref, {
  required String companyId,
  required PackagingItemPatch patch,
}) async {
  await ref
      .read(companyExchangeSettingsRepositoryProvider)
      .createPackagingItem(companyId: companyId, patch: patch);
  ref.invalidate(companyExchangeSettingsProvider(companyId));
}

Future<void> patchCompanyPackagingItem(
  WidgetRef ref, {
  required String companyId,
  required String itemId,
  required PackagingItemPatch patch,
}) async {
  await ref
      .read(companyExchangeSettingsRepositoryProvider)
      .patchPackagingItem(companyId: companyId, itemId: itemId, patch: patch);
  ref.invalidate(companyExchangeSettingsProvider(companyId));
}

Future<void> deactivateCompanyPackagingItem(
  WidgetRef ref, {
  required String companyId,
  required String itemId,
}) async {
  await ref
      .read(companyExchangeSettingsRepositoryProvider)
      .deactivatePackagingItem(companyId: companyId, itemId: itemId);
  ref.invalidate(companyExchangeSettingsProvider(companyId));
}
