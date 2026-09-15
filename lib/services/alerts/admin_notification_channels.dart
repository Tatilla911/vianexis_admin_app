import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../audio/vn_sound_definition.dart';
import '../../audio/vn_sound_registry.dart';

/// Android notification channels for ViaNexis Admin alerts.
class AdminNotificationChannels {
  AdminNotificationChannels._();

  static const String criticalAlerts = 'vianexis_admin_critical_v1';
  static const String warnings = 'vianexis_admin_warnings_v1';
  static const String messages = 'vianexis_admin_messages_v1';
  static const String feedback = 'vianexis_admin_feedback_v1';
  static const String calls = 'vianexis_admin_calls_v1';

  static AndroidNotificationChannel _channel({
    required String id,
    required String name,
    required String description,
    required Importance importance,
    required String androidResourceName,
  }) {
    return AndroidNotificationChannel(
      id,
      name,
      description: description,
      importance: importance,
      playSound: true,
      enableVibration: true,
      sound: RawResourceAndroidNotificationSound(androidResourceName),
    );
  }

  static List<AndroidNotificationChannel> androidChannels({
    String alarmResource = 'vn_alarm_1',
    String messageResource = 'vn_message_1',
    String ringResource = 'vn_ring_1',
    String signResource = 'vn_sign_1',
  }) {
    return [
      _channel(
        id: criticalAlerts,
        name: 'ViaNexis critical alerts',
        description: 'Critical platform health and security alerts.',
        importance: Importance.max,
        androidResourceName: alarmResource,
      ),
      _channel(
        id: warnings,
        name: 'ViaNexis warnings',
        description: 'High-priority operational warnings.',
        importance: Importance.high,
        androidResourceName: messageResource,
      ),
      _channel(
        id: messages,
        name: 'ViaNexis admin messages',
        description: 'Registrations, support, billing, and release notices.',
        importance: Importance.high,
        androidResourceName: messageResource,
      ),
      _channel(
        id: feedback,
        name: 'ViaNexis feedback',
        description: 'Success and confirmation signals.',
        importance: Importance.defaultImportance,
        androidResourceName: signResource,
      ),
      _channel(
        id: calls,
        name: 'ViaNexis contact signals',
        description: 'Incoming support / contact requests.',
        importance: Importance.high,
        androidResourceName: ringResource,
      ),
    ];
  }

  static String channelIdFor(VnSoundCategory category) {
    return switch (category) {
      VnSoundCategory.alarm => criticalAlerts,
      VnSoundCategory.ring => calls,
      VnSoundCategory.sign => feedback,
      VnSoundCategory.message => messages,
    };
  }

  static String channelNameFor(String channelId) {
    for (final channel in androidChannels()) {
      if (channel.id == channelId) return channel.name;
    }
    return 'ViaNexis Admin';
  }

  static String androidResourceForCategory(
    VnSoundCategory category,
    String selectedSoundId,
  ) {
    return VnSoundRegistry.resolve(
      category: category,
      selectedId: selectedSoundId,
    ).androidResourceName;
  }
}
