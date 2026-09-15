import 'dart:async';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../../core/device/admin_device_identity_service.dart';
import '../../features/notifications/data/notifications_api.dart';
import '../../features/notifications/domain/admin_device_registration.dart';
import 'admin_fcm_payload.dart';
import 'admin_fcm_tap_coordinator.dart';
import 'admin_local_notification_service.dart';
import 'admin_push_dedupe.dart';

@pragma('vm:entry-point')
Future<void> adminFcmBackgroundHandler(RemoteMessage message) async {
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp();
    }
  } catch (error) {
    if (kDebugMode) {
      debugPrint('[admin-fcm] background Firebase init skipped: $error');
    }
    return;
  }
  final payload = AdminFcmPayload.fromDataMap(
    message.data,
    titleText: message.notification?.title,
    bodyText: message.notification?.body,
  );
  if (payload == null) return;
  AdminPushDedupe.instance.markSeen(payload.notificationId);
  AdminFcmTapCoordinator.instance.stagePendingPayload(payload);
}

enum AdminFcmRegistrationState {
  unavailable,
  permissionMissing,
  pendingRegistration,
  registered,
  failed,
}

class AdminFcmService {
  AdminFcmService._({
    required AdminDeviceIdentityService deviceIdentity,
    required NotificationsApi notificationsApi,
  }) : _deviceIdentity = deviceIdentity,
       _notificationsApi = notificationsApi;

  static AdminFcmService? _instance;

  static Future<void> revokeOnLogoutIfConfigured() async {
    final existing = _instance;
    if (existing == null) return;
    await existing.onLogoutRevoke();
  }

  static bool get isConfigured => _instance != null;

  static AdminFcmService? get maybeInstance => _instance;

  static AdminFcmService get instance {
    final existing = _instance;
    if (existing == null) {
      throw StateError('AdminFcmService not configured');
    }
    return existing;
  }

  static void configure({
    required AdminDeviceIdentityService deviceIdentity,
    required NotificationsApi notificationsApi,
  }) {
    _instance = AdminFcmService._(
      deviceIdentity: deviceIdentity,
      notificationsApi: notificationsApi,
    );
  }

  final AdminDeviceIdentityService _deviceIdentity;
  final NotificationsApi _notificationsApi;

  bool _initialized = false;
  bool _firebaseAvailable = false;
  StreamSubscription<String>? _tokenRefreshSub;
  int? _backendDeviceRowId;

  bool get isFirebaseAvailable => _firebaseAvailable;

  Future<void> initialize() async {
    if (_initialized) return;
    try {
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp();
      }
      _firebaseAvailable = true;
      FirebaseMessaging.onBackgroundMessage(adminFcmBackgroundHandler);
      FirebaseMessaging.onMessage.listen(_onForegroundMessage);
      FirebaseMessaging.onMessageOpenedApp.listen(_onMessageOpenedApp);
      _tokenRefreshSub = FirebaseMessaging.instance.onTokenRefresh.listen((
        token,
      ) {
        unawaited(_registerToken(token));
      });
    } catch (error) {
      _firebaseAvailable = false;
      if (kDebugMode) {
        debugPrint('[admin-fcm] Firebase unavailable: $error');
      }
    }
    _initialized = true;
  }

  Future<void> dispose() async {
    await _tokenRefreshSub?.cancel();
    _tokenRefreshSub = null;
    _initialized = false;
  }

  Future<AdminFcmRegistrationState> syncOnSessionReady({
    required String appVersion,
    required String appBuild,
    required String environment,
  }) async {
    await initialize();
    if (!_firebaseAvailable) {
      return AdminFcmRegistrationState.unavailable;
    }

    final permissionGranted = await _requestPermission();
    if (!permissionGranted) {
      return AdminFcmRegistrationState.permissionMissing;
    }

    final token = await FirebaseMessaging.instance.getToken();
    if (token == null || token.isEmpty) {
      return AdminFcmRegistrationState.failed;
    }

    final registered = await _registerToken(
      token,
      appVersion: appVersion,
      appBuild: appBuild,
      environment: environment,
    );
    if (!registered) {
      return AdminFcmRegistrationState.failed;
    }

    final initial = await FirebaseMessaging.instance.getInitialMessage();
    if (initial != null) {
      _handleOpenedMessage(initial);
    }

    return AdminFcmRegistrationState.registered;
  }

  Future<void> onLogoutRevoke() async {
    final backendId = _backendDeviceRowId;
    if (backendId != null) {
      try {
        await _notificationsApi.disableDevice(backendId);
      } catch (_) {
        // best effort — never block logout
      }
    }
    _backendDeviceRowId = null;
    if (_firebaseAvailable) {
      try {
        await FirebaseMessaging.instance.deleteToken();
      } catch (_) {}
    }
    AdminPushDedupe.instance.clear();
    AdminFcmTapCoordinator.instance.clear();
  }

  @visibleForTesting
  static String redactTokenForLog(String? token) {
    if (token == null || token.isEmpty) return '[empty]';
    if (token.length <= 8) return '***';
    return '${token.substring(0, 4)}…${token.substring(token.length - 4)}';
  }

  Future<bool> _requestPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        badge: true,
        sound: true,
      );
      return settings.authorizationStatus == AuthorizationStatus.authorized ||
          settings.authorizationStatus == AuthorizationStatus.provisional;
    } catch (_) {
      return false;
    }
  }

  Future<bool> _registerToken(
    String token, {
    String? appVersion,
    String? appBuild,
    String? environment,
  }) async {
    if (token.isEmpty) return false;
    try {
      final deviceId = await _deviceIdentity.getOrCreateDeviceId();
      final platform = _deviceIdentity.resolvePlatform();
      if (platform == 'unknown') {
        return false;
      }
      final backendId = await _notificationsApi.registerDevice(
        AdminDeviceRegistration(
          deviceId: deviceId,
          platform: platform,
          environment: environment ?? 'unknown',
          appVersion: appVersion ?? '0.0.0',
          appBuild: appBuild ?? '0',
          pushProvider: 'fcm',
          pushToken: token,
          inAppOnly: false,
        ),
      );
      _backendDeviceRowId = backendId;
      if (kDebugMode) {
        debugPrint(
          '[admin-fcm] registered token=${redactTokenForLog(token)} deviceId=$deviceId',
        );
      }
      return true;
    } catch (error) {
      if (kDebugMode) {
        debugPrint('[admin-fcm] register failed: $error');
      }
      return false;
    }
  }

  void _onForegroundMessage(RemoteMessage message) {
    final payload = AdminFcmPayload.fromDataMap(
      message.data,
      titleText: message.notification?.title,
      bodyText: message.notification?.body,
    );
    if (payload == null) return;
    if (!AdminPushDedupe.instance.markSeen(payload.notificationId)) {
      return;
    }
    unawaited(
      AdminLocalNotificationService.instance.showAdminNotification(
        payload.toAdminNotification(),
        playForegroundSound: true,
      ),
    );
  }

  void _onMessageOpenedApp(RemoteMessage message) {
    _handleOpenedMessage(message);
  }

  void _handleOpenedMessage(RemoteMessage message) {
    final payload = AdminFcmPayload.fromDataMap(
      message.data,
      titleText: message.notification?.title,
      bodyText: message.notification?.body,
    );
    if (payload == null) return;
    AdminPushDedupe.instance.markSeen(payload.notificationId);
    AdminFcmTapCoordinator.instance.handlePayload(payload);
  }
}
