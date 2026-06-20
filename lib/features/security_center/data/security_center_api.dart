import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/security_event.dart';
import '../domain/security_event_severity.dart';
import '../domain/security_event_type.dart';
import '../domain/security_overview.dart';

class SecurityCenterApi {
  SecurityCenterApi(this._apiClient);

  final ApiClient _apiClient;

  Future<SecurityOverview> getOverview() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/security/overview',
    );
    final data = response.data;
    if (data == null) {
      return const SecurityOverview(
        failedLoginCount: 0,
        permissionDeniedCount: 0,
        activeSupportGrantsCount: 0,
        expiringSupportGrantsCount: 0,
        highRiskAiReviewsCount: 0,
        criticalSystemHealthEventsCount: 0,
        suspiciousBulkOnboardingJobsCount: 0,
        adminRoleChangesCount: 0,
      );
    }
    return SecurityOverview.fromJson(data);
  }

  Future<SecurityEventsPage> listEvents({
    SecurityEventType? type,
    SecurityEventSeverity? severity,
    String? search,
    int limit = 100,
    int offset = 0,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/security/events',
      queryParameters: {
        'limit': limit,
        'offset': offset,
        if (type != null && type != SecurityEventType.unknown)
          'type': type.backendValue,
        if (severity != null && severity != SecurityEventSeverity.unknown)
          'severity': severity.backendValue,
        if (search != null && search.trim().isNotEmpty) 'search': search.trim(),
      },
    );
    final data = response.data;
    if (data == null) {
      return const SecurityEventsPage(items: []);
    }
    return SecurityEventsPage.fromJson(data);
  }
}

final securityCenterApiProvider = Provider<SecurityCenterApi>(
  (ref) => SecurityCenterApi(ref.watch(apiClientProvider)),
);
