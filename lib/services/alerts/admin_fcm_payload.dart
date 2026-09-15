import 'dart:convert';

import '../../../app/app_router.dart';
import '../../features/notifications/domain/admin_notification.dart';
import '../../features/notifications/domain/admin_notification_routing.dart';
import '../../features/notifications/domain/notification_severity.dart';
import '../../features/notifications/domain/notification_type.dart';

/// Parsed safe navigation metadata from an admin FCM data payload.
/// Locators only — never authorization, email, or registration content.
class AdminFcmPayload {
  const AdminFcmPayload({
    required this.notificationId,
    required this.type,
    this.title,
    this.body,
    this.deepLink,
    this.applicationId,
  });

  final String notificationId;
  final NotificationType type;
  final String? title;
  final String? body;
  final String? deepLink;
  final String? applicationId;

  AdminNotification toAdminNotification() {
    final metadata = <String, String>{
      'deepLink': ?deepLink,
      'applicationId': ?applicationId,
    };
    return AdminNotification(
      id: notificationId,
      title: title ?? '',
      body: body ?? '',
      type: type,
      severity: NotificationSeverity.info,
      createdAt: DateTime.now().toUtc(),
      metadata: metadata,
      inAppOnly: false,
    );
  }

  static AdminFcmPayload? fromDataMap(
    Map<String, dynamic> data, {
    String? titleText,
    String? bodyText,
  }) {
    final notificationIdRaw =
        data['notificationId'] ?? data['notification_id'] ?? data['id'];
    if (notificationIdRaw == null) return null;
    final notificationId = notificationIdRaw.toString().trim();
    if (notificationId.isEmpty) return null;

    final type = NotificationType.fromBackendValue(
      (data['type'] ?? '').toString(),
    );
    final resourceType = data['resourceType']?.toString();
    final resourceId = data['resourceId']?.toString();
    final applicationId = _applicationId(data, resourceType, resourceId);
    final deepLink = sanitizeAdminDeepLink(
      _parseDeepLink(data, resourceType, resourceId, applicationId),
    );

    return AdminFcmPayload(
      notificationId: notificationId,
      type: type,
      title: titleText?.trim().isNotEmpty == true ? titleText!.trim() : null,
      body: bodyText?.trim().isNotEmpty == true ? bodyText!.trim() : null,
      deepLink: deepLink,
      applicationId: applicationId,
    );
  }

  static String? _applicationId(
    Map<String, dynamic> data,
    String? resourceType,
    String? resourceId,
  ) {
    if (resourceType == 'driver_registration' ||
        resourceType == 'company_registration' ||
        resourceType == 'public_application') {
      final id = resourceId?.trim();
      if (id != null && id.isNotEmpty) return id;
    }
    final fromData = data['applicationId']?.toString().trim();
    if (fromData != null && fromData.isNotEmpty) return fromData;
    return null;
  }

  static String? _parseDeepLink(
    Map<String, dynamic> data,
    String? resourceType,
    String? resourceId,
    String? applicationId,
  ) {
    final raw = data['deepLink'];
    if (raw is String && raw.trim().isNotEmpty) {
      final trimmed = raw.trim();
      if (trimmed.startsWith('/')) return trimmed;
      try {
        final decoded = jsonDecode(trimmed);
        if (decoded is Map && decoded['path'] is String) {
          return decoded['path'] as String;
        }
      } catch (_) {}
    }
    final locator = applicationId ?? resourceId;
    if (locator != null && locator.isNotEmpty) {
      return AdminRoutes.applicationDetail(locator);
    }
    return null;
  }
}
