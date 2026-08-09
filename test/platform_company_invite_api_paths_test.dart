import 'dart:io';

import 'package:flutter_test/flutter_test.dart';

/// Locks the Admin App → staging contract that previously 404'd.
void main() {
  test('company dossier invite/password-setup use canonical platform routes', () {
    final apiSource =
        File('lib/features/companies/data/platform_companies_api.dart')
            .readAsStringSync();
    expect(
      apiSource,
      contains("'/platform-admin/companies/\$id/resend-invite'"),
    );
    expect(
      apiSource,
      contains("'/platform-admin/companies/\$id/send-password-setup'"),
    );
  });

  test('ops section disables buttons while busy and uses delivery feedback', () {
    final opsSource = File(
      'lib/features/companies/presentation/widgets/company_dossier_ops_section.dart',
    ).readAsStringSync();
    expect(opsSource, contains('_busy'));
    expect(opsSource, contains('expectEmailDelivery: true'));
    expect(opsSource, contains('showAdminOpsFailureSnackBar'));
    expect(opsSource, contains('platformCompanyOpsEndpointMissing'));
  });
}
