import 'dart:io';
import 'dart:math';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../app/app_config.dart';
import '../domain/admin_device_registration.dart';
import '../domain/admin_notification.dart';
import '../domain/notification_severity.dart';
import '../domain/notification_preferences.dart';
import '../domain/push_provider_status.dart';
import '../domain/notification_type.dart';
import 'notifications_api.dart';

abstract class NotificationsRepository {
  Future<List<AdminNotification>> listNotifications();
  Future<void> markRead(String id);
  Future<void> markAllRead();
  Future<NotificationPreferences> getPreferences();
  Future<NotificationPreferences> updatePreferences(NotificationPreferences value);
  Future<void> registerCurrentDevice();
  Future<PushProviderStatus> fetchProviderStatus();
  bool get usesMockData;
  bool get inAppOnly;
}

class LiveNotificationsRepository implements NotificationsRepository {
  LiveNotificationsRepository(this._api);

  final NotificationsApi _api;

  @override
  bool get usesMockData => false;

  @override
  bool get inAppOnly => true;

  @override
  Future<List<AdminNotification>> listNotifications() => _api.listNotifications();

  @override
  Future<void> markRead(String id) => _api.markRead(id);

  @override
  Future<void> markAllRead() => _api.markAllRead();

  @override
  Future<NotificationPreferences> getPreferences() => _api.getPreferences();

  @override
  Future<NotificationPreferences> updatePreferences(NotificationPreferences value) {
    return _api.updatePreferences(value.copyWith(inAppOnly: true));
  }

  @override
  Future<void> registerCurrentDevice() async {
    final info = await PackageInfo.fromPlatform();
    await _api.registerDevice(
      AdminDeviceRegistration(
        deviceId: _deviceId,
        platform: Platform.operatingSystem,
        environment: AppConfig.instance.environmentName,
        appVersion: info.version,
        appBuild: info.buildNumber,
      ),
    );
  }

  @override
  Future<PushProviderStatus> fetchProviderStatus() => _api.getProviderStatus();
}

class MockNotificationsRepository implements NotificationsRepository {
  MockNotificationsRepository();

  static final String _mockDeviceId = _generateDeviceId();
  NotificationPreferences _preferences = const NotificationPreferences();
  final List<AdminNotification> _items = [
    AdminNotification(
      id: 'n-1001',
      title: 'Security alert acknowledged',
      body: 'Permission-denied spikes normalized for tenant metadata endpoints.',
      type: NotificationType.security,
      severity: NotificationSeverity.warning,
      createdAt: DateTime.utc(2026, 6, 20, 8, 15),
      metadata: {'source': 'security_center'},
    ),
    AdminNotification(
      id: 'n-1002',
      title: 'System health warning',
      body: 'Background workers exceeded warning queue threshold.',
      type: NotificationType.systemHealth,
      severity: NotificationSeverity.critical,
      createdAt: DateTime.utc(2026, 6, 20, 7, 35),
      metadata: {'source': 'system_health'},
    ),
  ];

  @override
  bool get usesMockData => true;

  @override
  bool get inAppOnly => true;

  @override
  Future<List<AdminNotification>> listNotifications() async {
    await Future<void>.delayed(const Duration(milliseconds: 120));
    return List<AdminNotification>.from(_items);
  }

  @override
  Future<void> markRead(String id) async {
    final index = _items.indexWhere((item) => item.id == id);
    if (index < 0) return;
    _items[index] = _items[index].copyWith(readAt: DateTime.now().toUtc());
  }

  @override
  Future<void> markAllRead() async {
    final now = DateTime.now().toUtc();
    for (var i = 0; i < _items.length; i++) {
      _items[i] = _items[i].copyWith(readAt: now);
    }
  }

  @override
  Future<NotificationPreferences> getPreferences() async => _preferences;

  @override
  Future<NotificationPreferences> updatePreferences(NotificationPreferences value) async {
    _preferences = value.copyWith(inAppOnly: true);
    return _preferences;
  }

  @override
  Future<void> registerCurrentDevice() async {
    final info = await PackageInfo.fromPlatform();
    final registration = AdminDeviceRegistration(
      deviceId: _mockDeviceId,
      platform: Platform.operatingSystem,
      environment: AppConfig.instance.environmentName,
      appVersion: info.version,
      appBuild: info.buildNumber,
    );
    registration.toJson();
  }

  @override
  Future<PushProviderStatus> fetchProviderStatus() async {
    await Future<void>.delayed(const Duration(milliseconds: 80));
    return const PushProviderStatus(
      provider: 'none',
      deliveryEnabled: false,
      configured: false,
      tokenStorageMode: 'hash_only',
    );
  }
}

final notificationsRepositoryProvider = Provider<NotificationsRepository>((ref) {
  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveNotificationsRepository(ref.watch(notificationsApiProvider));
  }
  return MockNotificationsRepository();
});

final notificationsProvider =
    AsyncNotifierProvider<NotificationsNotifier, List<AdminNotification>>(
      NotificationsNotifier.new,
    );

class NotificationsNotifier extends AsyncNotifier<List<AdminNotification>> {
  @override
  Future<List<AdminNotification>> build() async {
    await ref.read(notificationsRepositoryProvider).registerCurrentDevice();
    return ref.read(notificationsRepositoryProvider).listNotifications();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(
      () => ref.read(notificationsRepositoryProvider).listNotifications(),
    );
  }

  Future<void> markRead(String id) async {
    await ref.read(notificationsRepositoryProvider).markRead(id);
    await refresh();
  }

  Future<void> markAllRead() async {
    await ref.read(notificationsRepositoryProvider).markAllRead();
    await refresh();
  }
}

final notificationPreferencesProvider =
    AsyncNotifierProvider<NotificationPreferencesNotifier, NotificationPreferences>(
      NotificationPreferencesNotifier.new,
    );

class NotificationPreferencesNotifier
    extends AsyncNotifier<NotificationPreferences> {
  @override
  Future<NotificationPreferences> build() {
    return ref.read(notificationsRepositoryProvider).getPreferences();
  }

  Future<void> save(NotificationPreferences preferences) async {
    final error = preferences.validate();
    if (error != null) {
      throw StateError(error);
    }
    state = await AsyncValue.guard(
      () => ref.read(notificationsRepositoryProvider).updatePreferences(preferences),
    );
  }
}

final unreadNotificationCountProvider = Provider<int>((ref) {
  final asyncItems = ref.watch(notificationsProvider);
  return asyncItems.maybeWhen(
    data: (items) => items.where((item) => !item.isRead).length,
    orElse: () => 0,
  );
});

final pushProviderStatusProvider =
    FutureProvider.autoDispose<PushProviderStatus>((ref) {
      return ref.watch(notificationsRepositoryProvider).fetchProviderStatus();
    });

String get _deviceId => _cachedDeviceId ??= _generateDeviceId();
String? _cachedDeviceId;

String _generateDeviceId() {
  final random = Random();
  final value = List<int>.generate(20, (_) => random.nextInt(16))
      .map((v) => v.toRadixString(16))
      .join();
  return 'admin-$value';
}
