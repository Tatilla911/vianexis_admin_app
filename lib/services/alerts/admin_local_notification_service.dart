import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

import '../../audio/vn_sound_definition.dart';
import '../../audio/vn_sound_preferences.dart';
import '../../audio/vn_sound_router.dart';
import '../../features/notifications/domain/admin_notification.dart';
import '../../features/notifications/domain/notification_severity.dart';
import '../../features/notifications/domain/notification_type.dart';
import 'admin_alert_mapper.dart';
import 'admin_notification_channels.dart';

typedef AdminNotificationTapHandler = void Function(String notificationId);

@pragma('vm:entry-point')
void adminNotificationTapBackgroundHandler(NotificationResponse response) {
  final id = AdminLocalNotificationService.decodePayload(response.payload);
  if (id != null) {
    AdminLocalNotificationService.instance.stagePendingTap(id);
  }
}

/// System tray / lock-screen alerts for the Admin app.
class AdminLocalNotificationService {
  AdminLocalNotificationService._();

  static final AdminLocalNotificationService instance =
      AdminLocalNotificationService._();

  final FlutterLocalNotificationsPlugin _plugin =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;
  String? _pendingTapId;
  AdminNotificationTapHandler? onNotificationTap;

  bool get isInitialized => _initialized;

  Future<void> initialize() async {
    if (_initialized) return;

    const androidSettings = AndroidInitializationSettings(
      '@mipmap/ic_launcher',
    );
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
    );

    try {
      await _plugin.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationResponse,
        onDidReceiveBackgroundNotificationResponse:
            adminNotificationTapBackgroundHandler,
      );

      await _ensureAndroidChannels();
      _initialized = true;
      await _consumeLaunchNotification();
    } catch (_) {
      // Plugin platforms are unavailable in widget tests / unsupported hosts.
      // Keep alerts soft-disabled rather than crashing the app shell.
      _initialized = false;
    }
  }

  Future<void> _ensureAndroidChannels() async {
    final androidPlugin = _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >();
    if (androidPlugin == null) return;

    final soundPrefs = VnSoundPreferences();
    final alarmId = await soundPrefs.selectedSoundId(VnSoundCategory.alarm);
    final messageId = await soundPrefs.selectedSoundId(VnSoundCategory.message);
    final ringId = await soundPrefs.selectedSoundId(VnSoundCategory.ring);
    final signId = await soundPrefs.selectedSoundId(VnSoundCategory.sign);

    final channels = AdminNotificationChannels.androidChannels(
      alarmResource: AdminNotificationChannels.androidResourceForCategory(
        VnSoundCategory.alarm,
        alarmId,
      ),
      messageResource: AdminNotificationChannels.androidResourceForCategory(
        VnSoundCategory.message,
        messageId,
      ),
      ringResource: AdminNotificationChannels.androidResourceForCategory(
        VnSoundCategory.ring,
        ringId,
      ),
      signResource: AdminNotificationChannels.androidResourceForCategory(
        VnSoundCategory.sign,
        signId,
      ),
    );
    for (final channel in channels) {
      await androidPlugin.createNotificationChannel(channel);
    }
  }

  Future<bool> requestPermission() async {
    try {
      await initialize();
      if (!_initialized) return false;
      final android = _plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >();
      if (android != null) {
        final granted = await android.requestNotificationsPermission();
        return granted ?? true;
      }
      final ios = _plugin
          .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin
          >();
      if (ios != null) {
        final granted = await ios.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );
        return granted ?? false;
      }
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> _consumeLaunchNotification() async {
    final details = await _plugin.getNotificationAppLaunchDetails();
    if (details?.didNotificationLaunchApp != true) return;
    final id = decodePayload(details!.notificationResponse?.payload);
    if (id != null) stagePendingTap(id);
  }

  void _onNotificationResponse(NotificationResponse response) {
    final id = decodePayload(response.payload);
    if (id == null) return;
    final handler = onNotificationTap;
    if (handler != null) {
      handler(id);
    } else {
      stagePendingTap(id);
    }
  }

  void stagePendingTap(String notificationId) {
    _pendingTapId = notificationId;
  }

  String? consumePendingTap() {
    final id = _pendingTapId;
    _pendingTapId = null;
    return id;
  }

  static String encodePayload(String notificationId) {
    return jsonEncode({'notificationId': notificationId});
  }

  static String? decodePayload(String? raw) {
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is Map && decoded['notificationId'] != null) {
        final id = decoded['notificationId'].toString().trim();
        return id.isEmpty ? null : id;
      }
    } catch (_) {
      final trimmed = raw.trim();
      return trimmed.isEmpty ? null : trimmed;
    }
    return null;
  }

  Future<bool> showAdminNotification(
    AdminNotification notification, {
    bool playForegroundSound = true,
  }) async {
    await initialize();

    final category = AdminAlertMapper.categoryFor(notification);
    final eventId = AdminAlertMapper.eventIdFor(notification);
    final channelId = AdminNotificationChannels.channelIdFor(category);
    final channelName = AdminNotificationChannels.channelNameFor(channelId);
    final critical = AdminAlertMapper.isCritical(notification);

    final foreground =
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
    final shouldPlayForegroundSound = playForegroundSound && foreground;

    final details = NotificationDetails(
      android: AndroidNotificationDetails(
        channelId,
        channelName,
        channelDescription: 'Operational alerts for ViaNexis platform admins.',
        importance: critical ? Importance.max : Importance.high,
        priority: critical ? Priority.max : Priority.high,
        category: AndroidNotificationCategory.alarm,
        visibility: NotificationVisibility.private,
        // Avoid double audio when in-app just_audio already plays.
        playSound: !shouldPlayForegroundSound,
        enableVibration: true,
        fullScreenIntent: critical,
      ),
      iOS: DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: !shouldPlayForegroundSound,
      ),
    );

    await _plugin.show(
      _notificationIdFor(notification.id),
      notification.title,
      notification.body,
      details,
      payload: encodePayload(notification.id),
    );

    if (shouldPlayForegroundSound) {
      await VnSoundRouter.instance.play(
        eventId: eventId,
        occurrenceId: notification.id,
        deduplicationKey: notification.id,
        source: 'local_notification',
        eventCreatedAt: notification.createdAt,
      );
    } else if (playForegroundSound && !foreground) {
      // Background: channel/system sound handles audio; still route for
      // looping critical alarms while the process is alive.
      if (category == VnSoundCategory.alarm ||
          category == VnSoundCategory.ring) {
        await VnSoundRouter.instance.play(
          eventId: eventId,
          occurrenceId: notification.id,
          deduplicationKey: '${notification.id}:bg-loop',
          source: 'background_loop',
          eventCreatedAt: notification.createdAt,
        );
      }
    }
    return true;
  }

  Future<bool> showTestAlert({
    String title = 'ViaNexis Admin test alert',
    String body = 'Notification sound and banner test.',
  }) async {
    final now = DateTime.now().toUtc();
    final sample = AdminNotification(
      id: 'local-test-${now.millisecondsSinceEpoch}',
      title: title,
      body: body,
      type: NotificationType.systemHealth,
      severity: NotificationSeverity.critical,
      createdAt: now,
      metadata: const {'eventId': 'system_critical_state'},
      inAppOnly: false,
    );
    return showAdminNotification(sample);
  }

  int _notificationIdFor(String id) {
    return id.hashCode & 0x7fffffff;
  }
}
