import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/admin_device_registration.dart';
import '../domain/admin_notification.dart';
import '../domain/notification_events_result.dart';
import '../domain/notification_preferences.dart';
import '../domain/push_provider_status.dart';

class NotificationsApi {
  NotificationsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<List<AdminNotification>> listNotifications() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/notifications',
    );
    final data = response.data;
    if (data == null) return const [];
    final items = data['items'];
    if (items is! List) return const [];
    return items
        .whereType<Map<String, dynamic>>()
        .map(AdminNotification.fromJson)
        .toList(growable: false);
  }

  Future<void> markRead(String id) async {
    await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/notifications/$id/read',
    );
  }

  Future<void> markAllRead() async {
    await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/notifications/read-all',
    );
  }

  Future<NotificationPreferences> getPreferences() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/notification-preferences',
    );
    return NotificationPreferences.fromJson(response.data ?? const {});
  }

  Future<NotificationPreferences> updatePreferences(
    NotificationPreferences preferences,
  ) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/notification-preferences',
      data: preferences.toJson(),
    );
    return NotificationPreferences.fromJson(response.data ?? preferences.toJson());
  }

  Future<void> registerDevice(AdminDeviceRegistration registration) async {
    await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/devices/register',
      data: registration.toJson(),
    );
  }

  Future<PushProviderStatus> getProviderStatus() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/notifications/provider-status',
    );
    return PushProviderStatus.fromJson(response.data ?? const {});
  }

  Future<NotificationEventsResult> listNotificationEvents({
    int limit = 20,
    int offset = 0,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/notification-events',
      queryParameters: {'limit': limit, 'offset': offset},
    );
    return NotificationEventsResult.fromJson(response.data ?? const {});
  }
}

final notificationsApiProvider = Provider<NotificationsApi>(
  (ref) => NotificationsApi(ref.watch(apiClientProvider)),
);
