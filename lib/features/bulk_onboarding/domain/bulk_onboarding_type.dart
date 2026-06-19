enum BulkOnboardingJobType {
  companyUsers('company_users'),
  drivers('drivers'),
  vehicles('vehicles'),
  trailers('trailers'),
  mixedCompanyImport('mixed_company_import'),
  unknown('unknown');

  const BulkOnboardingJobType(this.backendValue);

  final String backendValue;

  static BulkOnboardingJobType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final type in BulkOnboardingJobType.values) {
      if (type.backendValue == raw) return type;
    }
    return unknown;
  }

  String localizationKey() {
    return switch (this) {
      companyUsers => 'bulkOnboardingTypeCompanyUsers',
      drivers => 'bulkOnboardingTypeDrivers',
      vehicles => 'bulkOnboardingTypeVehicles',
      trailers => 'bulkOnboardingTypeTrailers',
      mixedCompanyImport => 'bulkOnboardingTypeMixedCompanyImport',
      unknown => 'bulkOnboardingTypeUnknown',
    };
  }
}
