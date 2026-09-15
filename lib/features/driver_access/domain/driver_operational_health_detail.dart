import 'driver_access_profile.dart';

class DriverOperationalHealthIssueView {
  const DriverOperationalHealthIssueView({
    required this.id,
    required this.category,
    required this.code,
    required this.severity,
    required this.status,
    required this.attemptCount,
    this.lastAttemptedAt,
    this.safeErrorCode,
    this.appVersion,
    this.deviceLabel,
    this.source,
  });

  final String id;
  final String category;
  final String code;
  final String severity;
  final String status;
  final int attemptCount;
  final DateTime? lastAttemptedAt;
  final String? safeErrorCode;
  final String? appVersion;
  final String? deviceLabel;
  final String? source;

  factory DriverOperationalHealthIssueView.fromJson(Map<String, dynamic> json) {
    return DriverOperationalHealthIssueView(
      id: json['id']?.toString() ?? '',
      category: json['category']?.toString() ?? 'other',
      code: json['code']?.toString() ?? '',
      severity: json['severity']?.toString() ?? 'yellow',
      status: json['status']?.toString() ?? 'active',
      attemptCount: int.tryParse(json['attemptCount']?.toString() ?? '') ?? 0,
      lastAttemptedAt: DateTime.tryParse(
        json['lastAttemptedAt']?.toString() ?? '',
      ),
      safeErrorCode: json['safeErrorCode']?.toString(),
      appVersion: json['appVersion']?.toString(),
      deviceLabel: json['deviceLabel']?.toString(),
      source: json['source']?.toString(),
    );
  }
}

class DriverOperationalHealthDetail {
  const DriverOperationalHealthDetail({
    required this.overallLevel,
    required this.activeIssueCount,
    required this.issues,
    this.remoteRetryPossible = false,
    this.remoteRetryHintKey = 'driverHealthRetryOnDevice',
  });

  final DriverOperationalHealthLevel overallLevel;
  final int activeIssueCount;
  final List<DriverOperationalHealthIssueView> issues;
  final bool remoteRetryPossible;
  final String remoteRetryHintKey;

  factory DriverOperationalHealthDetail.fromJson(Map<String, dynamic> json) {
    final rawIssues = json['issues'];
    final issues = rawIssues is List
        ? rawIssues
              .whereType<Map>()
              .map(
                (e) => DriverOperationalHealthIssueView.fromJson(
                  Map<String, dynamic>.from(e),
                ),
              )
              .toList(growable: false)
        : const <DriverOperationalHealthIssueView>[];
    return DriverOperationalHealthDetail(
      overallLevel: DriverOperationalHealthLevel.fromBackend(
        json['overallLevel']?.toString(),
      ),
      activeIssueCount:
          int.tryParse(json['activeIssueCount']?.toString() ?? '') ??
          issues.length,
      issues: issues,
      remoteRetryPossible: json['remoteRetryPossible'] == true,
      remoteRetryHintKey:
          json['remoteRetryHintKey']?.toString() ?? 'driverHealthRetryOnDevice',
    );
  }
}
