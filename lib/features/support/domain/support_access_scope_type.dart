enum SupportAccessScopeType {
  companyMetadata,
  specificTrip,
  specificDocumentIssue,
  uploadQueueIssue,
  systemHealthIssue,
  integrationIssue,
  billingIssue,
  unknown;

  static SupportAccessScopeType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'company_metadata' => companyMetadata,
      'specific_trip' => specificTrip,
      'specific_document_issue' => specificDocumentIssue,
      'upload_queue_issue' => uploadQueueIssue,
      'system_health_issue' => systemHealthIssue,
      'integration_issue' => integrationIssue,
      'billing_issue' => billingIssue,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      SupportAccessScopeType.companyMetadata => 'supportScopeCompanyMetadata',
      SupportAccessScopeType.specificTrip => 'supportScopeSpecificTrip',
      SupportAccessScopeType.specificDocumentIssue => 'supportScopeSpecificDocumentIssue',
      SupportAccessScopeType.uploadQueueIssue => 'supportScopeUploadQueueIssue',
      SupportAccessScopeType.systemHealthIssue => 'supportScopeSystemHealthIssue',
      SupportAccessScopeType.integrationIssue => 'supportScopeIntegrationIssue',
      SupportAccessScopeType.billingIssue => 'supportScopeBillingIssue',
      SupportAccessScopeType.unknown => 'supportScopeUnknown',
    };
  }

  String backendValue() {
    return switch (this) {
      SupportAccessScopeType.companyMetadata => 'company_metadata',
      SupportAccessScopeType.specificTrip => 'specific_trip',
      SupportAccessScopeType.specificDocumentIssue => 'specific_document_issue',
      SupportAccessScopeType.uploadQueueIssue => 'upload_queue_issue',
      SupportAccessScopeType.systemHealthIssue => 'system_health_issue',
      SupportAccessScopeType.integrationIssue => 'integration_issue',
      SupportAccessScopeType.billingIssue => 'billing_issue',
      SupportAccessScopeType.unknown => 'unknown',
    };
  }

  bool get requiresScopeId =>
      this == specificTrip ||
      this == specificDocumentIssue ||
      this == uploadQueueIssue ||
      this == integrationIssue;

  bool get isBroadAccess => false;

  List<String> backendScopes({required bool documentsAllowed}) {
    if (documentsAllowed) {
      throw ArgumentError('documentsAllowed must remain false for scoped grants');
    }
    return switch (this) {
      SupportAccessScopeType.companyMetadata => const [
        'portal_dashboard',
        'company_settings',
      ],
      SupportAccessScopeType.specificTrip => const ['trip_groups'],
      SupportAccessScopeType.specificDocumentIssue => const ['workshop'],
      SupportAccessScopeType.uploadQueueIssue => const ['workshop'],
      SupportAccessScopeType.systemHealthIssue => const ['portal_dashboard', 'audit'],
      SupportAccessScopeType.integrationIssue => const ['organization'],
      SupportAccessScopeType.billingIssue => const ['company_settings'],
      SupportAccessScopeType.unknown => const ['portal_dashboard'],
    };
  }
}
