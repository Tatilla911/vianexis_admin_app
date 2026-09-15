import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/features/companies/data/platform_companies_repository.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_status.dart';
import 'package:vianexis_admin_app/features/companies/presentation/widgets/company_dossier_ops_section.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

class _ArchiveRepo extends MockPlatformCompaniesRepository {
  int softDeleteCalls = 0;
  bool fail = false;
  bool networkFail = false;
  Duration delay = Duration.zero;

  @override
  Future<Map<String, dynamic>> softDelete({
    required String id,
    required String reason,
  }) async {
    if (delay > Duration.zero) {
      await Future<void>.delayed(delay);
    }
    softDeleteCalls += 1;
    if (fail) {
      throw const ApiException(
        kind: ApiExceptionKind.server,
        statusCode: 500,
        errorCode: 'ADMIN_ACTION_FAILED',
        messageKey: 'errorGenericBody',
        backendMessage: 'archive failed',
      );
    }
    if (networkFail) {
      throw const ApiException(
        kind: ApiExceptionKind.network,
        messageKey: 'errorNetworkBody',
        backendMessage: 'network unreachable',
      );
    }
    return super.softDelete(id: id, reason: reason);
  }
}

Widget _app({
  required PlatformCompaniesRepository repo,
  required Widget home,
}) {
  return ProviderScope(
    overrides: [
      platformCompaniesRepositoryProvider.overrideWithValue(repo),
    ],
    child: MaterialApp(
      locale: const Locale('en'),
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: home,
    ),
  );
}

Future<void> _confirmArchive(
  WidgetTester tester, {
  required String reason,
}) async {
  await tester.tap(find.widgetWithText(OutlinedButton, 'Archive company'));
  await tester.pump();
  await tester.enterText(find.byType(TextField), reason);
  await tester.tap(find.widgetWithText(FilledButton, 'Archive company'));
  await tester.pump();
}

void main() {
  testWidgets('archive success shows snackbar and archives without crash', (
    tester,
  ) async {
    final repo = _ArchiveRepo();

    await tester.pumpWidget(
      _app(
        repo: repo,
        home: const Scaffold(
          body: CompanyDossierOpsSection(
            companyId: '1',
            canInviteOps: false,
            canArchive: true,
          ),
        ),
      ),
    );
    await tester.pump();

    await _confirmArchive(tester, reason: 'UAT archive reason');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(milliseconds: 250));

    expect(tester.takeException(), isNull);
    expect(repo.softDeleteCalls, 1);
    expect(find.byType(CompanyDossierOpsSection), findsOneWidget);
    expect(find.textContaining('Company archived'), findsWidgets);

    final archived = await tester.runAsync(
      () => repo.fetchCompany('1'),
    );
    expect(archived!.status, PlatformCompanyStatus.archived);
  });

  testWidgets('archive API failure keeps detail and shows controlled error', (
    tester,
  ) async {
    final repo = _ArchiveRepo()..fail = true;

    await tester.pumpWidget(
      _app(
        repo: repo,
        home: const Scaffold(
          body: CompanyDossierOpsSection(
            companyId: '1',
            canInviteOps: false,
            canArchive: true,
          ),
        ),
      ),
    );
    await tester.pump();
    await _confirmArchive(tester, reason: 'fail reason here');
    await tester.pump(const Duration(milliseconds: 50));

    expect(tester.takeException(), isNull);
    expect(find.byType(CompanyDossierOpsSection), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);
    expect(find.textContaining('Company archived'), findsNothing);
  });

  testWidgets('archive confirmation cancel does nothing', (tester) async {
    final repo = _ArchiveRepo();

    await tester.pumpWidget(
      _app(
        repo: repo,
        home: const Scaffold(
          body: CompanyDossierOpsSection(
            companyId: '1',
            canInviteOps: false,
            canArchive: true,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Archive company'));
    await tester.pump();
    await tester.tap(find.text('Cancel'));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(repo.softDeleteCalls, 0);
    expect(find.byType(CompanyDossierOpsSection), findsOneWidget);
    expect(find.byType(SnackBar), findsNothing);
  });

  testWidgets('archive network error keeps detail and allows retry', (
    tester,
  ) async {
    final repo = _ArchiveRepo()..networkFail = true;

    await tester.pumpWidget(
      _app(
        repo: repo,
        home: const Scaffold(
          body: CompanyDossierOpsSection(
            companyId: '1',
            canInviteOps: false,
            canArchive: true,
          ),
        ),
      ),
    );
    await tester.pump();
    await _confirmArchive(tester, reason: 'network fail reason');
    await tester.pump(const Duration(milliseconds: 50));

    expect(tester.takeException(), isNull);
    expect(find.byType(CompanyDossierOpsSection), findsOneWidget);
    expect(find.byType(SnackBar), findsOneWidget);

    repo.networkFail = false;
    await tester.tap(find.widgetWithText(OutlinedButton, 'Archive company'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'retry archive ok');
    await tester.tap(find.widgetWithText(FilledButton, 'Archive company'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(milliseconds: 250));

    expect(tester.takeException(), isNull);
    expect(repo.softDeleteCalls, 2);
  });

  testWidgets('rapid double confirm only archives once', (tester) async {
    final repo = _ArchiveRepo()..delay = const Duration(milliseconds: 200);

    await tester.pumpWidget(
      _app(
        repo: repo,
        home: const Scaffold(
          body: CompanyDossierOpsSection(
            companyId: '1',
            canInviteOps: false,
            canArchive: true,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Archive company'));
    await tester.pump();
    await tester.enterText(find.byType(TextField), 'double tap guard');
    await tester.tap(find.widgetWithText(FilledButton, 'Archive company'));
    await tester.pump();
    await tester.tap(
      find.widgetWithText(OutlinedButton, 'Archive company'),
      warnIfMissed: false,
    );
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(milliseconds: 250));

    expect(tester.takeException(), isNull);
    expect(repo.softDeleteCalls, 1);
  });

  testWidgets('authorized archive tap opens confirmation dialog', (
    tester,
  ) async {
    final repo = _ArchiveRepo();

    await tester.pumpWidget(
      _app(
        repo: repo,
        home: const Scaffold(
          body: CompanyDossierOpsSection(
            companyId: '1',
            canInviteOps: false,
            canArchive: true,
          ),
        ),
      ),
    );
    await tester.pump();
    await tester.tap(find.widgetWithText(OutlinedButton, 'Archive company'));
    await tester.pump();

    expect(tester.takeException(), isNull);
    expect(find.byType(AlertDialog), findsOneWidget);
    expect(find.byType(TextField), findsOneWidget);
    expect(repo.softDeleteCalls, 0);
  });

  testWidgets('archive busy clears so retry works on the same page', (
    tester,
  ) async {
    final repo = _ArchiveRepo();

    await tester.pumpWidget(
      _app(
        repo: repo,
        home: const Scaffold(
          body: CompanyDossierOpsSection(
            companyId: '1',
            canInviteOps: false,
            canArchive: true,
          ),
        ),
      ),
    );
    await tester.pump();
    await _confirmArchive(tester, reason: 'no pop stack reason');
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 250));
    await tester.pump(const Duration(milliseconds: 250));

    expect(tester.takeException(), isNull);
    expect(repo.softDeleteCalls, 1);

    final button = tester.widget<OutlinedButton>(
      find.widgetWithText(OutlinedButton, 'Archive company'),
    );
    expect(button.onPressed, isNotNull);

    await tester.tap(find.widgetWithText(OutlinedButton, 'Archive company'));
    await tester.pump();
    expect(find.byType(AlertDialog), findsOneWidget);
  });

  testWidgets('unauthorized archive section is hidden', (tester) async {
    await tester.pumpWidget(
      _app(
        repo: _ArchiveRepo(),
        home: const Scaffold(
          body: CompanyDossierOpsSection(
            companyId: '1',
            canInviteOps: false,
            canArchive: false,
          ),
        ),
      ),
    );
    await tester.pump();
    expect(find.text('Archive company'), findsNothing);
  });
}
