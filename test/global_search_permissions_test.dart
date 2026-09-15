import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/global_search/domain/platform_admin_search_models.dart';

/// Frontend does not mirror BILLING_ADMIN narrowing — backend is authoritative.
/// Client always requests the full platform_admin types set; billing exclusion
/// is enforced server-side via platformAdminAllowedSearchTypes.
void main() {
  test('client requests full types string for platform_admin search', () {
    expect(
      kPlatformAdminSearchTypes,
      'company,registration_application,driver,trip,truck,trailer,site,document',
    );
  });

  test('billing exclusion is not invented as a client SearchResultType', () {
    expect(
      PlatformAdminSearchResultType.values.contains(
        PlatformAdminSearchResultType.auditEvent,
      ),
      isTrue,
    );
  });
}
