/// Metadata-only platform operations counts from GET /platform-admin/dashboard.
class PlatformOperationsSnapshot {
  const PlatformOperationsSnapshot({
    required this.companiesTotal,
    required this.companiesActive,
    required this.usersActive,
    required this.usersInvited,
    required this.driversEstimate,
    required this.tripsTotal,
    required this.tripsActive,
    required this.tripsCompleted,
    required this.tripsParked,
    required this.activeSupportGrants,
    required this.expiringSupportGrants,
    required this.pendingPublicIntakes,
    required this.pendingRegistrations,
    required this.documentsTotal,
    required this.packagesGenerated,
    required this.privacyNote,
    this.exchangeRecordsAvailable = false,
    this.pendingSyncIssues,
  });

  final int companiesTotal;
  final int companiesActive;
  final int usersActive;
  final int usersInvited;
  final int driversEstimate;
  final int tripsTotal;
  final int tripsActive;
  final int tripsCompleted;
  final int tripsParked;
  final int activeSupportGrants;
  final int expiringSupportGrants;
  final int pendingPublicIntakes;
  final int pendingRegistrations;
  final int documentsTotal;
  final int packagesGenerated;
  final String privacyNote;
  final bool exchangeRecordsAvailable;
  final int? pendingSyncIssues;

  factory PlatformOperationsSnapshot.fromJson(Map<String, dynamic> json) {
    final companies = _map(json['companies']);
    final users = _map(json['users']);
    final trips = _map(json['trips']);
    final support = _map(json['support']);
    final pricing = _map(json['pricing']);
    final onboarding = _map(json['onboarding']);
    final documents = _map(json['documents']);
    final packages = _map(json['packages']);

    return PlatformOperationsSnapshot(
      companiesTotal: _int(companies['total']),
      companiesActive: _int(companies['active']),
      usersActive: _int(users['active']),
      usersInvited: _int(users['invited']),
      driversEstimate: _int(users['active']),
      tripsTotal: _int(trips['total']),
      tripsActive: _int(trips['active']),
      tripsCompleted: _int(trips['completed']),
      tripsParked: _int(trips['parked']),
      activeSupportGrants: _int(support['activeGrants']),
      expiringSupportGrants: _int(support['expiringSoon']),
      pendingPublicIntakes: _int(pricing['pendingIntakes']),
      pendingRegistrations: _int(onboarding['pendingRegistrations']),
      documentsTotal: _int(documents['total']),
      packagesGenerated: _int(packages['generated']),
      privacyNote: json['privacyNote']?.toString() ?? '',
      exchangeRecordsAvailable: false,
      pendingSyncIssues: null,
    );
  }

  static Map<String, dynamic> _map(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return raw.map((k, v) => MapEntry(k.toString(), v));
    return const {};
  }

  static int _int(Object? raw) {
    if (raw is int) return raw;
    return int.tryParse(raw?.toString() ?? '') ?? 0;
  }
}
