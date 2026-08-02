import 'vn_sound_definition.dart';

/// Admin App event → sound category matrix (documentation + runtime helper).
class VnSoundEventSpec {
  const VnSoundEventSpec({
    required this.eventId,
    required this.category,
    required this.priority,
    this.loop = false,
    this.requiresAcknowledge = false,
    this.muteAllowed = true,
    this.foreground = true,
    this.background = true,
  });

  final String eventId;
  final VnSoundCategory? category;
  final String priority;
  final bool loop;
  final bool requiresAcknowledge;
  final bool muteAllowed;
  final bool foreground;
  final bool background;
}

class VnSoundEventMatrix {
  VnSoundEventMatrix._();

  static const List<VnSoundEventSpec> adminEvents = [
    VnSoundEventSpec(
      eventId: 'screen_opened',
      category: null,
      priority: 'normal',
    ),
    VnSoundEventSpec(
      eventId: 'company_registration_new',
      category: VnSoundCategory.message,
      priority: 'normal',
    ),
    VnSoundEventSpec(
      eventId: 'driver_registration_new',
      category: VnSoundCategory.message,
      priority: 'normal',
    ),
    VnSoundEventSpec(
      eventId: 'system_critical_state',
      category: VnSoundCategory.alarm,
      priority: 'critical',
      loop: true,
      requiresAcknowledge: true,
      muteAllowed: false,
    ),
    VnSoundEventSpec(
      eventId: 'support_ticket_new',
      category: VnSoundCategory.message,
      priority: 'normal',
    ),
    VnSoundEventSpec(
      eventId: 'support_access_request_new',
      category: VnSoundCategory.message,
      priority: 'high',
    ),
    VnSoundEventSpec(
      eventId: 'audit_security_event',
      category: VnSoundCategory.alarm,
      priority: 'critical',
      loop: false,
    ),
    VnSoundEventSpec(
      eventId: 'billing_problem',
      category: VnSoundCategory.message,
      priority: 'high',
    ),
    VnSoundEventSpec(
      eventId: 'bulk_onboarding_done',
      category: VnSoundCategory.sign,
      priority: 'normal',
      background: false,
    ),
    VnSoundEventSpec(
      eventId: 'approval_success',
      category: VnSoundCategory.sign,
      priority: 'normal',
      background: false,
    ),
    VnSoundEventSpec(
      eventId: 'rejection_success',
      category: VnSoundCategory.sign,
      priority: 'normal',
      background: false,
    ),
    VnSoundEventSpec(
      eventId: 'incoming_internal_call',
      category: VnSoundCategory.ring,
      priority: 'high',
      loop: true,
      requiresAcknowledge: true,
      foreground: true,
      background: false,
    ),
  ];

  static VnSoundEventSpec? forEvent(String eventId) {
    for (final spec in adminEvents) {
      if (spec.eventId == eventId) return spec;
    }
    return null;
  }

  static VnSoundCategory categoryForNotificationType(String typeName) {
    switch (typeName) {
      case 'systemCriticalState':
      case 'auditSecurityEvent':
        return VnSoundCategory.alarm;
      case 'bulkOnboardingDone':
      case 'approvalSuccess':
      case 'rejectionSuccess':
        return VnSoundCategory.sign;
      case 'incomingInternalCall':
        return VnSoundCategory.ring;
      case 'companyRegistrationNew':
      case 'driverRegistrationNew':
      case 'supportTicketNew':
      case 'supportAccessRequestNew':
      case 'billingProblem':
      default:
        return VnSoundCategory.message;
    }
  }
}
