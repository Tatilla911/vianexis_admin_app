import 'vn_sound_definition.dart';
import 'vn_sound_registry.dart';

/// Admin App configurable sound events.
enum VnAdminSoundEvent {
  screenOpened,
  companyRegistrationNew,
  driverRegistrationNew,
  supportTicketNew,
  supportAccessRequest,
  systemCriticalState,
  auditSecurityEvent,
  billingProblem,
  bulkOnboardingDone,
  approvalSuccess,
  incomingContact,
}

class VnAdminSoundEventDefinition {
  const VnAdminSoundEventDefinition({
    required this.event,
    required this.id,
    required this.localizationKey,
    required this.defaultCategory,
    required this.defaultSoundId,
    required this.allowedCategories,
    this.canBeMuted = true,
    this.playsSound = true,
    this.loopAllowed = false,
  });

  final VnAdminSoundEvent event;
  final String id;
  final String localizationKey;
  final VnSoundCategory? defaultCategory;
  final String? defaultSoundId;
  final Set<VnSoundCategory> allowedCategories;
  final bool canBeMuted;
  final bool playsSound;
  final bool loopAllowed;
}

class VnAdminSoundEventRegistry {
  VnAdminSoundEventRegistry._();

  static const List<VnAdminSoundEventDefinition> all = [
    VnAdminSoundEventDefinition(
      event: VnAdminSoundEvent.screenOpened,
      id: 'screen_opened',
      localizationKey: 'settingsSoundEventScreenOpened',
      defaultCategory: null,
      defaultSoundId: null,
      allowedCategories: {},
      playsSound: false,
    ),
    VnAdminSoundEventDefinition(
      event: VnAdminSoundEvent.companyRegistrationNew,
      id: 'company_registration_new',
      localizationKey: 'settingsSoundEventCompanyRegistration',
      defaultCategory: VnSoundCategory.message,
      defaultSoundId: 'message1',
      allowedCategories: {
        VnSoundCategory.message,
        VnSoundCategory.sign,
        VnSoundCategory.ring,
      },
    ),
    VnAdminSoundEventDefinition(
      event: VnAdminSoundEvent.driverRegistrationNew,
      id: 'driver_registration_new',
      localizationKey: 'settingsSoundEventDriverRegistration',
      defaultCategory: VnSoundCategory.message,
      defaultSoundId: 'message1',
      allowedCategories: {
        VnSoundCategory.message,
        VnSoundCategory.sign,
        VnSoundCategory.ring,
      },
    ),
    VnAdminSoundEventDefinition(
      event: VnAdminSoundEvent.supportTicketNew,
      id: 'support_ticket_new',
      localizationKey: 'settingsSoundEventSupportTicket',
      defaultCategory: VnSoundCategory.message,
      defaultSoundId: 'message2',
      allowedCategories: {
        VnSoundCategory.message,
        VnSoundCategory.sign,
        VnSoundCategory.ring,
      },
    ),
    VnAdminSoundEventDefinition(
      event: VnAdminSoundEvent.supportAccessRequest,
      id: 'support_access_request_new',
      localizationKey: 'settingsSoundEventSupportAccess',
      defaultCategory: VnSoundCategory.message,
      defaultSoundId: 'message2',
      allowedCategories: {
        VnSoundCategory.message,
        VnSoundCategory.sign,
        VnSoundCategory.ring,
      },
    ),
    VnAdminSoundEventDefinition(
      event: VnAdminSoundEvent.systemCriticalState,
      id: 'system_critical_state',
      localizationKey: 'settingsSoundEventSystemCritical',
      defaultCategory: VnSoundCategory.alarm,
      defaultSoundId: 'alarm1',
      allowedCategories: {VnSoundCategory.alarm},
      canBeMuted: false,
      loopAllowed: true,
    ),
    VnAdminSoundEventDefinition(
      event: VnAdminSoundEvent.auditSecurityEvent,
      id: 'audit_security_event',
      localizationKey: 'settingsSoundEventAuditSecurity',
      defaultCategory: VnSoundCategory.alarm,
      defaultSoundId: 'alarm2',
      allowedCategories: {VnSoundCategory.alarm},
      canBeMuted: false,
    ),
    VnAdminSoundEventDefinition(
      event: VnAdminSoundEvent.billingProblem,
      id: 'billing_problem',
      localizationKey: 'settingsSoundEventBilling',
      defaultCategory: VnSoundCategory.message,
      defaultSoundId: 'message3',
      allowedCategories: {
        VnSoundCategory.message,
        VnSoundCategory.alarm,
        VnSoundCategory.sign,
        VnSoundCategory.ring,
      },
    ),
    VnAdminSoundEventDefinition(
      event: VnAdminSoundEvent.bulkOnboardingDone,
      id: 'bulk_onboarding_done',
      localizationKey: 'settingsSoundEventBulkOnboarding',
      defaultCategory: VnSoundCategory.sign,
      defaultSoundId: 'sign1',
      allowedCategories: {
        VnSoundCategory.sign,
        VnSoundCategory.message,
        VnSoundCategory.ring,
      },
    ),
    VnAdminSoundEventDefinition(
      event: VnAdminSoundEvent.approvalSuccess,
      id: 'approval_success',
      localizationKey: 'settingsSoundEventApprovalSuccess',
      defaultCategory: VnSoundCategory.sign,
      defaultSoundId: 'sign2',
      allowedCategories: {
        VnSoundCategory.sign,
        VnSoundCategory.message,
        VnSoundCategory.ring,
      },
    ),
    VnAdminSoundEventDefinition(
      event: VnAdminSoundEvent.incomingContact,
      id: 'incoming_contact',
      localizationKey: 'settingsSoundEventIncomingContact',
      defaultCategory: VnSoundCategory.ring,
      defaultSoundId: 'ring1',
      allowedCategories: {
        VnSoundCategory.ring,
        VnSoundCategory.message,
        VnSoundCategory.sign,
      },
      loopAllowed: true,
    ),
  ];

  static VnAdminSoundEventDefinition? byId(String id) {
    for (final def in all) {
      if (def.id == id) return def;
    }
    return null;
  }

  static List<VnAdminSoundEventDefinition> configurable() =>
      all.where((d) => d.playsSound).toList();

  static List<VnSoundDefinition> allowedSounds(String eventId) {
    final event = byId(eventId);
    if (event == null || !event.playsSound) return const [];
    return VnSoundRegistry.all
        .where((s) => event.allowedCategories.contains(s.category))
        .toList(growable: false);
  }

  static bool isSoundAllowed(String eventId, String soundId) {
    final event = byId(eventId);
    if (event == null || !event.playsSound) return false;
    final cat = _categoryOf(soundId);
    return cat != null && event.allowedCategories.contains(cat);
  }

  static VnSoundCategory? _categoryOf(String soundId) {
    final id = soundId.trim().toLowerCase();
    if (id.startsWith('alarm')) return VnSoundCategory.alarm;
    if (id.startsWith('message')) return VnSoundCategory.message;
    if (id.startsWith('ring')) return VnSoundCategory.ring;
    if (id.startsWith('sign')) return VnSoundCategory.sign;
    return null;
  }
}
