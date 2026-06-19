import 'platform_company_status.dart';

class PlatformCompany {
  const PlatformCompany({
    required this.id,
    required this.name,
    this.country,
    this.vatNumber,
    this.registrationNumber,
    required this.status,
    this.planName,
    this.subscriptionStatus,
    required this.createdAt,
    this.updatedAt,
    required this.activeUsersCount,
    required this.driversCount,
    required this.vehiclesCount,
    required this.trailersCount,
    required this.openSupportTicketsCount,
    required this.activeSupportAccessGrantsCount,
    required this.pendingRegistrationApplicationsCount,
    required this.pendingBulkOnboardingJobsCount,
    this.lastAdminActivityAt,
    this.metadataOnly = true,
  });

  final String id;
  final String name;
  final String? country;
  final String? vatNumber;
  final String? registrationNumber;
  final PlatformCompanyStatus status;
  final String? planName;
  final String? subscriptionStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final int activeUsersCount;
  final int driversCount;
  final int vehiclesCount;
  final int trailersCount;
  final int openSupportTicketsCount;
  final int activeSupportAccessGrantsCount;
  final int pendingRegistrationApplicationsCount;
  final int pendingBulkOnboardingJobsCount;
  final DateTime? lastAdminActivityAt;
  final bool metadataOnly;

  factory PlatformCompany.fromJson(Map<String, dynamic> json) {
    return PlatformCompany(
      id: (json['id'] ?? json['companyId'])?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      country: json['country']?.toString(),
      vatNumber: json['vatNumber']?.toString(),
      registrationNumber: json['registrationNumber']?.toString(),
      status: PlatformCompanyStatus.fromBackendValue(json['status']?.toString()),
      planName: json['planName']?.toString(),
      subscriptionStatus: json['subscriptionStatus']?.toString(),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      activeUsersCount: _parseInt(json['activeUsersCount'] ?? json['userCount']),
      driversCount: _parseInt(json['driversCount']),
      vehiclesCount: _parseInt(json['vehiclesCount'] ?? json['truckCount']),
      trailersCount: _parseInt(json['trailersCount'] ?? json['trailerCount']),
      openSupportTicketsCount: _parseInt(json['openSupportTicketsCount']),
      activeSupportAccessGrantsCount: _parseInt(
        json['activeSupportAccessGrantsCount'] ?? json['activeSupportGrantCount'],
      ),
      pendingRegistrationApplicationsCount: _parseInt(
        json['pendingRegistrationApplicationsCount'],
      ),
      pendingBulkOnboardingJobsCount: _parseInt(
        json['pendingBulkOnboardingJobsCount'],
      ),
      lastAdminActivityAt: _parseDate(json['lastAdminActivityAt']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  bool matchesSearch(String query) {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return true;
    final haystack = [
      name,
      country,
      vatNumber,
      registrationNumber,
    ].whereType<String>().join(' ').toLowerCase();
    return haystack.contains(term);
  }

  bool matchesFilter(PlatformCompanyListFilter filter) {
    return switch (filter) {
      PlatformCompanyListFilter.all => true,
      PlatformCompanyListFilter.active =>
        status == PlatformCompanyStatus.active,
      PlatformCompanyListFilter.pendingReview =>
        status == PlatformCompanyStatus.pendingReview,
      PlatformCompanyListFilter.suspended =>
        status == PlatformCompanyStatus.suspended,
      PlatformCompanyListFilter.disabled =>
        status == PlatformCompanyStatus.disabled ||
            status == PlatformCompanyStatus.inactive,
    };
  }
}

enum PlatformCompanyListFilter {
  all,
  active,
  pendingReview,
  suspended,
  disabled,
}

class PlatformCompaniesPage {
  const PlatformCompaniesPage({
    required this.items,
    required this.total,
    this.metadataOnly = true,
  });

  final List<PlatformCompany> items;
  final int total;
  final bool metadataOnly;

  factory PlatformCompaniesPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(PlatformCompany.fromJson)
            .toList(growable: false)
        : const <PlatformCompany>[];
    return PlatformCompaniesPage(
      items: items,
      total: _parseInt(json['total']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString());
}

int _parseInt(Object? raw) {
  if (raw is int) return raw;
  return int.tryParse(raw?.toString() ?? '') ?? 0;
}
