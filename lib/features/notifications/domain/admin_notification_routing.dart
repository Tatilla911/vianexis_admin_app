import '../../../app/app_router.dart';
import 'admin_notification.dart';
import 'notification_type.dart';

/// Backend public-application locators (`/applications/:id`) open the canonical
/// applications review screen. Router authz still applies after tap.
const _allowedDeepLinkPrefixes = [
  AdminRoutes.registrations,
  AdminRoutes.applications,
  AdminRoutes.notifications,
  AdminRoutes.drivers,
  AdminRoutes.driverAccess,
];

bool isSafeAdminDeepLink(String path) {
  if (!path.startsWith('/') || path.contains('://') || path.contains('..')) {
    return false;
  }
  return _allowedDeepLinkPrefixes.any(
    (prefix) => path == prefix || path.startsWith('$prefix/'),
  );
}

String? sanitizeAdminDeepLink(String? raw) {
  final value = raw?.trim();
  if (value == null || value.isEmpty) return null;
  return isSafeAdminDeepLink(value) ? value : null;
}

/// Selects a location only. Does not grant permission — GoRouter redirect
/// and the destination APIs still authorize the signed-in admin.
String resolveAdminNotificationDestination(AdminNotification? notification) {
  if (notification == null) {
    return AdminRoutes.notifications;
  }

  final deepLink = sanitizeAdminDeepLink(notification.deepLink);
  if (deepLink != null) {
    return deepLink;
  }

  final applicationId = notification.applicationId;
  if (applicationId != null && applicationId.isNotEmpty) {
    return AdminRoutes.applicationDetail(applicationId);
  }

  if (notification.type.isRegistrationReview) {
    return AdminRoutes.applications;
  }

  return AdminRoutes.notificationDetail(notification.id);
}
