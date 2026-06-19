import 'system_health_severity.dart';

enum SystemHealthServiceKey {
  backendApi,
  database,
  documentStorage,
  backgroundWorkers,
  aiOcrWorkers,
  translationService,
  emailService,
  pushNotificationService,
  queueSystem,
  authService;

  static SystemHealthServiceKey? fromBackendComponent(String? raw) {
    if (raw == null) return null;
    return switch (raw.trim().toLowerCase()) {
      'api' => backendApi,
      'database' => database,
      'storage' => documentStorage,
      'worker' => backgroundWorkers,
      'email' => emailService,
      'messaging' => pushNotificationService,
      'integration' => aiOcrWorkers,
      _ => null,
    };
  }

  String localizationKey() {
    return switch (this) {
      SystemHealthServiceKey.backendApi => 'systemHealthServiceBackendApi',
      SystemHealthServiceKey.database => 'systemHealthServiceDatabase',
      SystemHealthServiceKey.documentStorage => 'systemHealthServiceDocumentStorage',
      SystemHealthServiceKey.backgroundWorkers => 'systemHealthServiceBackgroundWorkers',
      SystemHealthServiceKey.aiOcrWorkers => 'systemHealthServiceAiOcrWorkers',
      SystemHealthServiceKey.translationService => 'systemHealthServiceTranslationService',
      SystemHealthServiceKey.emailService => 'systemHealthServiceEmailService',
      SystemHealthServiceKey.pushNotificationService =>
        'systemHealthServicePushNotificationService',
      SystemHealthServiceKey.queueSystem => 'systemHealthServiceQueueSystem',
      SystemHealthServiceKey.authService => 'systemHealthServiceAuthService',
    };
  }

  static List<SystemHealthServiceKey> get dashboardServices =>
      SystemHealthServiceKey.values;
}

class SystemHealthServiceStatus {
  const SystemHealthServiceStatus({
    required this.serviceKey,
    required this.severity,
    this.summary,
    this.messageKey,
    this.lastCheckedAt,
  });

  final SystemHealthServiceKey serviceKey;
  final SystemHealthSeverity severity;
  final String? summary;
  final String? messageKey;
  final DateTime? lastCheckedAt;

  bool get isHealthy => severity == SystemHealthSeverity.info;

  factory SystemHealthServiceStatus.fromJson(Map<String, dynamic> json) {
    final component = json['component']?.toString();
    final serviceKey =
        SystemHealthServiceKey.fromBackendComponent(component) ??
        SystemHealthServiceKey.backendApi;

    return SystemHealthServiceStatus(
      serviceKey: serviceKey,
      severity: SystemHealthSeverity.fromBackendValue(json['severity']?.toString()),
      summary: json['detailSummary']?.toString(),
      messageKey: json['messageKey']?.toString(),
      lastCheckedAt: _parseDate(json['lastEventAt'] ?? json['lastCheckedAt']),
    );
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}
