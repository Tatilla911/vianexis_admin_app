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
      // Backend "messaging" is websocket/redis fabric — not FCM/APNs push.
      'messaging' => queueSystem,
      'integration' => aiOcrWorkers,
      _ => null,
    };
  }

  String localizationKey() {
    return switch (this) {
      SystemHealthServiceKey.backendApi => 'systemHealthServiceBackendApi',
      SystemHealthServiceKey.database => 'systemHealthServiceDatabase',
      SystemHealthServiceKey.documentStorage =>
        'systemHealthServiceDocumentStorage',
      SystemHealthServiceKey.backgroundWorkers =>
        'systemHealthServiceBackgroundWorkers',
      SystemHealthServiceKey.aiOcrWorkers => 'systemHealthServiceAiOcrWorkers',
      SystemHealthServiceKey.translationService =>
        'systemHealthServiceTranslationService',
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
    this.lastSuccessAt,
    this.lastError,
    this.currentState,
    this.affectedPlatform,
    this.recommendedAction,
    this.detailFields = const {},
  });

  final SystemHealthServiceKey serviceKey;
  final SystemHealthSeverity severity;
  final String? summary;
  final String? messageKey;
  final DateTime? lastCheckedAt;
  final DateTime? lastSuccessAt;
  final String? lastError;
  final String? currentState;
  final String? affectedPlatform;
  final String? recommendedAction;
  final Map<String, String> detailFields;

  bool get isHealthy => severity == SystemHealthSeverity.info;

  bool get hasActionableDetail =>
      lastError != null ||
      recommendedAction != null ||
      detailFields.isNotEmpty ||
      currentState != null;

  factory SystemHealthServiceStatus.fromJson(Map<String, dynamic> json) {
    final component = json['component']?.toString();
    final serviceKey =
        SystemHealthServiceKey.fromBackendComponent(component) ??
        SystemHealthServiceKey.backendApi;

    return SystemHealthServiceStatus(
      serviceKey: serviceKey,
      severity: SystemHealthSeverity.fromBackendValue(
        json['severity']?.toString(),
      ),
      summary: json['detailSummary']?.toString(),
      messageKey: json['messageKey']?.toString(),
      lastCheckedAt: _parseDate(json['lastEventAt'] ?? json['lastCheckedAt']),
      currentState: json['severity']?.toString(),
    );
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}
