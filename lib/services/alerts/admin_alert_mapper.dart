import '../../audio/vn_admin_sound_event_registry.dart';
import '../../audio/vn_sound_definition.dart';
import '../../audio/vn_sound_event_matrix.dart';
import '../../features/notifications/domain/admin_notification.dart';
import '../../features/notifications/domain/notification_severity.dart';
import '../../features/notifications/domain/notification_type.dart';

/// Maps backend admin notifications to local sound / channel events.
class AdminAlertMapper {
  AdminAlertMapper._();

  static String eventIdFor(AdminNotification notification) {
    final fromMetadata =
        notification.metadata['eventId']?.trim() ??
        notification.metadata['soundEventId']?.trim();
    if (fromMetadata != null &&
        fromMetadata.isNotEmpty &&
        VnAdminSoundEventRegistry.byId(fromMetadata) != null) {
      return fromMetadata;
    }

    if (notification.severity == NotificationSeverity.critical) {
      if (notification.type == NotificationType.security) {
        return 'audit_security_event';
      }
      return 'system_critical_state';
    }

    return switch (notification.type) {
      NotificationType.security => 'audit_security_event',
      NotificationType.systemHealth =>
        notification.severity == NotificationSeverity.warning
            ? 'system_critical_state'
            : 'support_ticket_new',
      NotificationType.support => 'support_ticket_new',
      NotificationType.billing => 'billing_problem',
      NotificationType.release => 'bulk_onboarding_done',
      NotificationType.driverApplicationSubmitted => 'driver_registration_new',
      NotificationType.companyApplicationSubmitted =>
        'company_registration_new',
      NotificationType.general ||
      NotificationType.unknown => _generalEventId(notification),
    };
  }

  static String _generalEventId(AdminNotification notification) {
    final haystack =
        '${notification.title} ${notification.body} ${notification.metadata}'
            .toLowerCase();
    if (haystack.contains('company') && haystack.contains('registr')) {
      return 'company_registration_new';
    }
    if (haystack.contains('driver') && haystack.contains('registr')) {
      return 'driver_registration_new';
    }
    if (haystack.contains('support access')) {
      return 'support_access_request_new';
    }
    if (haystack.contains('approv')) {
      return 'approval_success';
    }
    return 'support_ticket_new';
  }

  static VnSoundCategory categoryFor(AdminNotification notification) {
    final eventId = eventIdFor(notification);
    final fromMatrix = VnSoundEventMatrix.forEvent(eventId)?.category;
    if (fromMatrix != null) return fromMatrix;
    final def = VnAdminSoundEventRegistry.byId(eventId);
    return def?.defaultCategory ?? VnSoundCategory.message;
  }

  static bool isCritical(AdminNotification notification) {
    return notification.severity == NotificationSeverity.critical ||
        categoryFor(notification) == VnSoundCategory.alarm;
  }
}
