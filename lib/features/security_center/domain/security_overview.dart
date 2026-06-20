class SecurityOverview {
  const SecurityOverview({
    required this.failedLoginCount,
    required this.permissionDeniedCount,
    required this.activeSupportGrantsCount,
    required this.expiringSupportGrantsCount,
    required this.highRiskAiReviewsCount,
    required this.criticalSystemHealthEventsCount,
    required this.suspiciousBulkOnboardingJobsCount,
    required this.adminRoleChangesCount,
    this.lastCriticalSecurityEventAt,
    this.metadataOnly = true,
  });

  final int failedLoginCount;
  final int permissionDeniedCount;
  final int activeSupportGrantsCount;
  final int expiringSupportGrantsCount;
  final int highRiskAiReviewsCount;
  final int criticalSystemHealthEventsCount;
  final int suspiciousBulkOnboardingJobsCount;
  final int adminRoleChangesCount;
  final DateTime? lastCriticalSecurityEventAt;
  final bool metadataOnly;

  int get criticalSecurityEventsCount =>
      criticalSystemHealthEventsCount + adminRoleChangesCount + highRiskAiReviewsCount;

  factory SecurityOverview.fromJson(Map<String, dynamic> json) {
    return SecurityOverview(
      failedLoginCount: _parseInt(json['failedLoginCount']),
      permissionDeniedCount: _parseInt(json['permissionDeniedCount']),
      activeSupportGrantsCount: _parseInt(json['activeSupportGrantsCount']),
      expiringSupportGrantsCount: _parseInt(json['expiringSupportGrantsCount']),
      highRiskAiReviewsCount: _parseInt(json['highRiskAiReviewsCount']),
      criticalSystemHealthEventsCount:
          _parseInt(json['criticalSystemHealthEventsCount']),
      suspiciousBulkOnboardingJobsCount:
          _parseInt(json['suspiciousBulkOnboardingJobsCount']),
      adminRoleChangesCount: _parseInt(json['adminRoleChangesCount']),
      lastCriticalSecurityEventAt: _parseDate(json['lastCriticalSecurityEventAt']),
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
