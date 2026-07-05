import 'package:flutter_test/flutter_test.dart';

import 'package:vianexis_admin_app/features/company_settings/domain/company_exchange_settings.dart';

void main() {
  group('CompanyExchangeSettings', () {
    test('fromJson applies defaults for missing flags', () {
      final settings = CompanyExchangeSettings.fromJson(const {});
      expect(settings.palletExchangeEnabled, isTrue);
      expect(settings.packagingExchangeEnabled, isTrue);
      expect(settings.allowDriverCustomPackagingItems, isTrue);
      expect(settings.defaultPalletTypes, isEmpty);
      expect(settings.defaultPackagingItems, isEmpty);
    });

    test('fromJson parses pallet types and packaging items', () {
      final settings = CompanyExchangeSettings.fromJson({
        'palletExchangeEnabled': false,
        'packagingExchangeEnabled': true,
        'allowDriverCustomPackagingItems': false,
        'defaultPalletTypes': ['EUR', 'EPAL'],
        'defaultPackagingItems': [
          {'id': 'box', 'name': 'Box', 'active': true},
        ],
      });

      expect(settings.palletExchangeEnabled, isFalse);
      expect(settings.allowDriverCustomPackagingItems, isFalse);
      expect(settings.defaultPalletTypes, ['EUR', 'EPAL']);
      expect(settings.defaultPackagingItems.single.name, 'Box');
    });

    test('patch serializes only set fields', () {
      const patch = CompanyExchangeSettingsPatch(
        palletExchangeEnabled: false,
      );
      expect(patch.toJson(), {'palletExchangeEnabled': false});
    });
  });
}
