import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

void main() {
  test('systemMonitoring keys exist in both EN and HU arb with parity', () {
    final en =
        jsonDecode(File('lib/l10n/app_en.arb').readAsStringSync())
            as Map<String, dynamic>;
    final hu =
        jsonDecode(File('lib/l10n/app_hu.arb').readAsStringSync())
            as Map<String, dynamic>;

    final enKeys = en.keys
        .where(
          (k) =>
              !k.startsWith('@') &&
              (k.startsWith('systemMonitoring') || k == 'navSystemMonitoring'),
        )
        .toSet();
    final huKeys = hu.keys
        .where(
          (k) =>
              !k.startsWith('@') &&
              (k.startsWith('systemMonitoring') || k == 'navSystemMonitoring'),
        )
        .toSet();

    expect(enKeys, isNotEmpty);
    expect(enKeys, huKeys);
    expect(enKeys.contains('systemMonitoringAiDisclaimer'), isTrue);
    expect(enKeys.contains('systemMonitoringOpenIncidentCenter'), isTrue);
    expect(hu['systemMonitoringTitle'], 'Rendszerfelügyelet');
  });
}
