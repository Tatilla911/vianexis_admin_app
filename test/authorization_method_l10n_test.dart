import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/companies/domain/authorization_method_l10n.dart';

void main() {
  group('authorizationMethodL10nKey', () {
    test('maps canonical methods', () {
      expect(
        authorizationMethodL10nKey('customer_email'),
        'platformCompanyAmendAuthCustomerEmail',
      );
      expect(
        authorizationMethodL10nKey('customer_phone'),
        'platformCompanyAmendAuthCustomerPhone',
      );
      expect(
        authorizationMethodL10nKey('customer_document'),
        'platformCompanyAmendAuthCustomerDocument',
      );
      expect(
        authorizationMethodL10nKey('internal_approval'),
        'platformCompanyAmendAuthInternalApproval',
      );
      expect(
        authorizationMethodL10nKey('contract'),
        'platformCompanyAmendAuthContract',
      );
      expect(
        authorizationMethodL10nKey('official_registry'),
        'platformCompanyAmendAuthOfficialRegistry',
      );
      expect(
        authorizationMethodL10nKey('other'),
        'platformCompanyAmendAuthOther',
      );
    });

    test('maps legacy methods', () {
      expect(
        authorizationMethodL10nKey('customer_call'),
        'platformCompanyAmendAuthCustomerCall',
      );
      expect(
        authorizationMethodL10nKey('customer_ticket'),
        'platformCompanyAmendAuthCustomerTicket',
      );
      expect(
        authorizationMethodL10nKey('internal_policy'),
        'platformCompanyAmendAuthInternalPolicy',
      );
      expect(
        authorizationMethodL10nKey('legal_document'),
        'platformCompanyAmendAuthLegalDocument',
      );
    });

    test('falls back unknown methods to other', () {
      expect(
        authorizationMethodL10nKey('unknown_method'),
        'platformCompanyAmendAuthOther',
      );
    });
  });

  test('canonicalAuthorizationMethods lists UI dropdown values', () {
    expect(canonicalAuthorizationMethods, [
      'customer_email',
      'customer_phone',
      'customer_document',
      'internal_approval',
      'contract',
      'official_registry',
      'other',
    ]);
  });
}
