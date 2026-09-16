import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  test('dashboard and operations copy is system-oversight, not dispatch', () {
    final en = lookupAppLocalizations(const Locale('en'));
    final hu = lookupAppLocalizations(const Locale('hu'));

    expect(en.dashboardOperationalOverviewTitle, isNot('Operational overview'));
    expect(en.navOperations, isNot('Operations overview'));
    expect(en.operationsTitle, isNot('Operations overview'));
    expect(en.brandOperationalControlCenter, isNot('Operational Control Center'));
    expect(en.tripsOverviewTitle, isNot('Trips overview'));
    expect(en.operationsActiveTrips, isNot('Active trips'));
    expect(en.dashboardOperationalOverviewTitle.toLowerCase(), contains('system'));
    expect(en.operationsTitle.toLowerCase(), contains('platform'));

    expect(hu.dashboardOperationalOverviewTitle, isNot('Operatív áttekintés'));
    expect(hu.navOperations, isNot('Műveleti áttekintés'));
    expect(hu.operationsTitle, isNot(en.operationsTitle));
  });
}
