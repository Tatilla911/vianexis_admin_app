import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/api/api_exception.dart';
import 'package:vianexis_admin_app/core/api/admin_ops_feedback.dart';
import 'package:vianexis_admin_app/l10n/app_localizations.dart';

void main() {
  testWidgets('404 missing route shows friendly copy without requestId/HTTP', (
    tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('hu'),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showAdminOpsFailureSnackBar(
                    context,
                    const ApiException(
                      messageKey: 'errorActionUnavailable',
                      kind: ApiExceptionKind.notFound,
                      statusCode: 404,
                      requestId: 'req-abc-123',
                      endpoint: '/platform-admin/companies/1/resend-invite',
                      errorCode: 'resource_not_found',
                      backendMessage:
                          'Cannot POST /platform-admin/companies/1/resend-invite',
                    ),
                    resolveKey: (ctx, key) => key,
                    fallbackKey: 'platformCompanyOpsFailed',
                    endpointMissingKey: 'platformCompanyOpsEndpointMissing',
                    actionLabel: 'Meghívó újraküldése',
                  );
                },
                child: const Text('go'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pump();

    expect(find.text('platformCompanyOpsEndpointMissing'), findsOneWidget);
    expect(find.textContaining('requestId'), findsNothing);
    expect(find.textContaining('resource_not_found'), findsNothing);
    expect(find.textContaining('HTTP 404'), findsNothing);
    expect(find.textContaining('Cannot POST'), findsNothing);
  });

  testWidgets('403 maps to permission denied key when provided', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        locale: const Locale('hu'),
        home: Scaffold(
          body: Builder(
            builder: (context) {
              return ElevatedButton(
                onPressed: () {
                  showAdminOpsFailureSnackBar(
                    context,
                    const ApiException(
                      messageKey: 'errorPermissionDenied',
                      kind: ApiExceptionKind.forbidden,
                      statusCode: 403,
                      requestId: 'req-forbidden',
                      errorCode: 'ADMIN_PERMISSION_DENIED',
                    ),
                    resolveKey: (ctx, key) => key,
                    fallbackKey: 'platformCompanyOpsFailed',
                    endpointMissingKey: 'platformCompanyOpsEndpointMissing',
                    permissionDeniedKey: 'platformCompanyOpsPermissionDenied',
                  );
                },
                child: const Text('go'),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.text('go'));
    await tester.pump();

    expect(find.text('platformCompanyOpsPermissionDenied'), findsOneWidget);
    expect(find.textContaining('requestId'), findsNothing);
  });
}
