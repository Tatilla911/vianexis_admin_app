import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/features/companies/data/platform_companies_repository.dart';
import 'package:vianexis_admin_app/features/companies/presentation/platform_companies_providers.dart';
import 'package:vianexis_admin_app/features/companies/presentation/widgets/company_dossier_ops_section.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _ThrowingResendRepo extends MockPlatformCompaniesRepository {
  @override
  Future<Map<String, dynamic>> resendInvite(String id) async {
    throw const ApiException(
      kind: ApiExceptionKind.validation,
      statusCode: 400,
      errorCode: 'COMPANY_INVITE_RESEND_NOT_SUPPORTED',
      messageKey: 'platformControl.company.inviteResendNotSupported',
      backendMessage:
          'Company admin is not in invited status; use password setup instead',
      requestId: 'req-invite-active',
    );
  }
}

void main() {
  testWidgets(
    'invite resend maps already-active admin to explicit friendly copy',
    (tester) async {
      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            platformCompaniesRepositoryProvider.overrideWithValue(
              _ThrowingResendRepo(),
            ),
          ],
          child: MaterialApp(
            locale: const Locale('hu'),
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: const Scaffold(
              body: CompanyDossierOpsSection(
                companyId: '7',
                canInviteOps: true,
                canArchive: false,
              ),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();
      await tester.tap(find.text('Meghívó újraküldése'));
      await tester.pumpAndSettle();

      expect(
        find.textContaining('A cég adminisztrátori fiókja már aktív'),
        findsOneWidget,
      );
      expect(find.textContaining('requestId'), findsNothing);
      expect(
        find.textContaining('COMPANY_INVITE_RESEND_NOT_SUPPORTED'),
        findsNothing,
      );
      expect(
        find.textContaining('A művelet most nem sikerült'),
        findsNothing,
      );
    },
  );
}
