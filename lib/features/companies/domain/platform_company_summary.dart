class PlatformCompanyUsersSummary {
  const PlatformCompanyUsersSummary({
    required this.companyId,
    required this.activeUsersCount,
    required this.invitedUsersCount,
    required this.suspendedUsersCount,
    required this.totalUsersCount,
    required this.driversCount,
    required this.usersByRole,
    required this.usersByStatus,
    this.metadataOnly = true,
  });

  final String companyId;
  final int activeUsersCount;
  final int invitedUsersCount;
  final int suspendedUsersCount;
  final int totalUsersCount;
  final int driversCount;
  final Map<String, int> usersByRole;
  final Map<String, int> usersByStatus;
  final bool metadataOnly;

  factory PlatformCompanyUsersSummary.fromJson(Map<String, dynamic> json) {
    return PlatformCompanyUsersSummary(
      companyId: json['companyId']?.toString() ?? '',
      activeUsersCount: _parseInt(json['activeUsersCount']),
      invitedUsersCount: _parseInt(json['invitedUsersCount']),
      suspendedUsersCount: _parseInt(json['suspendedUsersCount']),
      totalUsersCount: _parseInt(json['totalUsersCount']),
      driversCount: _parseInt(json['driversCount']),
      usersByRole: _parseCountMap(json['usersByRole']),
      usersByStatus: _parseCountMap(json['usersByStatus']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class PlatformCompanySystemSummary {
  const PlatformCompanySystemSummary({
    required this.companyId,
    required this.vehiclesCount,
    required this.trailersCount,
    required this.openSupportTicketsCount,
    required this.activeSupportAccessGrantsCount,
    required this.departmentsCount,
    required this.contactCardsCount,
    required this.documentsCount,
    required this.packagesCount,
    this.metadataOnly = true,
  });

  final String companyId;
  final int vehiclesCount;
  final int trailersCount;
  final int openSupportTicketsCount;
  final int activeSupportAccessGrantsCount;
  final int departmentsCount;
  final int contactCardsCount;
  final int documentsCount;
  final int packagesCount;
  final bool metadataOnly;

  factory PlatformCompanySystemSummary.fromJson(Map<String, dynamic> json) {
    return PlatformCompanySystemSummary(
      companyId: json['companyId']?.toString() ?? '',
      vehiclesCount: _parseInt(json['vehiclesCount']),
      trailersCount: _parseInt(json['trailersCount']),
      openSupportTicketsCount: _parseInt(json['openSupportTicketsCount']),
      activeSupportAccessGrantsCount: _parseInt(
        json['activeSupportAccessGrantsCount'],
      ),
      departmentsCount: _parseInt(json['departmentsCount']),
      contactCardsCount: _parseInt(json['contactCardsCount']),
      documentsCount: _parseInt(json['documentsCount']),
      packagesCount: _parseInt(json['packagesCount']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class PlatformCompanyOnboardingSummary {
  const PlatformCompanyOnboardingSummary({
    required this.companyId,
    required this.pendingRegistrationApplicationsCount,
    required this.pendingBulkOnboardingJobsCount,
    required this.pendingPricingIntakeCount,
    required this.pricingIntakesNeedingReview,
    this.latestPricingIntakeStatus,
    this.metadataOnly = true,
  });

  final String companyId;
  final int pendingRegistrationApplicationsCount;
  final int pendingBulkOnboardingJobsCount;
  final int pendingPricingIntakeCount;
  final int pricingIntakesNeedingReview;
  final String? latestPricingIntakeStatus;
  final bool metadataOnly;

  factory PlatformCompanyOnboardingSummary.fromJson(Map<String, dynamic> json) {
    return PlatformCompanyOnboardingSummary(
      companyId: json['companyId']?.toString() ?? '',
      pendingRegistrationApplicationsCount: _parseInt(
        json['pendingRegistrationApplicationsCount'],
      ),
      pendingBulkOnboardingJobsCount: _parseInt(
        json['pendingBulkOnboardingJobsCount'],
      ),
      pendingPricingIntakeCount: _parseInt(json['pendingPricingIntakeCount']),
      pricingIntakesNeedingReview: _parseInt(json['pricingIntakesNeedingReview']),
      latestPricingIntakeStatus: json['latestPricingIntakeStatus']?.toString(),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class PlatformCompanyDashboardSummary {
  const PlatformCompanyDashboardSummary({
    required this.activeCompanies,
    required this.pendingReviewCompanies,
    required this.suspendedCompanies,
    required this.companiesWithOpenSupportIssues,
    required this.companiesWithPendingOnboarding,
  });

  factory PlatformCompanyDashboardSummary.fromJson(Map<String, dynamic> json) {
    final companies = json['companies'];
    if (companies is! Map<String, dynamic>) {
      return const PlatformCompanyDashboardSummary(
        activeCompanies: 0,
        pendingReviewCompanies: 0,
        suspendedCompanies: 0,
        companiesWithOpenSupportIssues: 0,
        companiesWithPendingOnboarding: 0,
      );
    }
    return PlatformCompanyDashboardSummary(
      activeCompanies: _parseInt(companies['active']),
      pendingReviewCompanies: _parseInt(companies['pendingReview']),
      suspendedCompanies: _parseInt(companies['suspended']),
      companiesWithOpenSupportIssues: _parseInt(companies['withOpenSupportIssues']),
      companiesWithPendingOnboarding: _parseInt(companies['withPendingOnboarding']),
    );
  }

  final int activeCompanies;
  final int pendingReviewCompanies;
  final int suspendedCompanies;
  final int companiesWithOpenSupportIssues;
  final int companiesWithPendingOnboarding;
}

int _parseInt(Object? raw) {
  if (raw is int) return raw;
  return int.tryParse(raw?.toString() ?? '') ?? 0;
}

Map<String, int> _parseCountMap(Object? raw) {
  if (raw is! Map) return const {};
  return raw.map(
    (key, value) => MapEntry(key.toString(), _parseInt(value)),
  );
}
