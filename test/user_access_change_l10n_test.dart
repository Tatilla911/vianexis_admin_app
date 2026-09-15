import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/admin_users/presentation/widgets/user_access_change_l10n.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<BuildContext> pumpLocale(WidgetTester tester, Locale locale) async {
    late BuildContext captured;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        locale: locale,
        home: Builder(
          builder: (context) {
            captured = context;
            return const SizedBox.shrink();
          },
        ),
      ),
    );
    await tester.pumpAndSettle();
    return captured;
  }

  testWidgets('localizes user access change validation in English', (
    tester,
  ) async {
    final context = await pumpLocale(tester, const Locale('en'));
    expect(userAccessChangeNoChangesSelected(context), 'No changes selected.');
    expect(
      userAccessChangeRequiredFields(context),
      'Reason, requested by and authorized by are required.',
    );
    expect(
      AppLocalizations.of(context).platformCompanyAmendAuthCustomerEmail,
      'Customer email approval',
    );
  });

  testWidgets('localizes user access change validation in Hungarian', (
    tester,
  ) async {
    final context = await pumpLocale(tester, const Locale('hu'));
    expect(
      userAccessChangeNoChangesSelected(context),
      'Nincs kiválasztott módosítás.',
    );
    expect(
      userAccessChangeRequiredFields(context),
      'Az indok, a kérelmező és a jóváhagyó megadása kötelező.',
    );
    expect(
      AppLocalizations.of(context).platformCompanyAmendAuthInternalApproval,
      'Belső jóváhagyás',
    );
  });
}
