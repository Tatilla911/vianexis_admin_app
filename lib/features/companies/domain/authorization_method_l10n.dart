/// Canonical authorization methods shown in the amendment UI dropdown.
const List<String> canonicalAuthorizationMethods = [
  'customer_email',
  'customer_phone',
  'customer_document',
  'internal_approval',
  'contract',
  'official_registry',
  'other',
];

/// Maps API authorizationMethod values (canonical + legacy) to l10n keys.
String authorizationMethodL10nKey(String method) {
  return switch (method.trim()) {
    'customer_email' => 'platformCompanyAmendAuthCustomerEmail',
    'customer_phone' => 'platformCompanyAmendAuthCustomerPhone',
    'customer_document' => 'platformCompanyAmendAuthCustomerDocument',
    'internal_approval' => 'platformCompanyAmendAuthInternalApproval',
    'contract' => 'platformCompanyAmendAuthContract',
    'official_registry' => 'platformCompanyAmendAuthOfficialRegistry',
    'other' => 'platformCompanyAmendAuthOther',
    // Legacy values still returned by older amendments / APIs.
    'customer_call' => 'platformCompanyAmendAuthCustomerCall',
    'customer_ticket' => 'platformCompanyAmendAuthCustomerTicket',
    'internal_policy' => 'platformCompanyAmendAuthInternalPolicy',
    'legal_document' => 'platformCompanyAmendAuthLegalDocument',
    _ => 'platformCompanyAmendAuthOther',
  };
}
