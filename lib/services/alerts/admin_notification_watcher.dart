import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/auth/admin_auth_state.dart';
import '../../features/notifications/data/notifications_repository.dart';
import '../../features/notifications/domain/admin_notification.dart';
import 'admin_local_notification_service.dart';
import 'admin_push_dedupe.dart';

/// Polls platform-admin notifications and raises audible + on-screen alerts.
class AdminNotificationWatcher {
  AdminNotificationWatcher({
    required NotificationsRepository repository,
    AdminLocalNotificationService? localNotifications,
    this.pollInterval = const Duration(seconds: 20),
  }) : _repository = repository,
       _local = localNotifications ?? AdminLocalNotificationService.instance;

  final NotificationsRepository _repository;
  final AdminLocalNotificationService _local;
  final Duration pollInterval;

  Timer? _timer;
  bool _running = false;
  bool _seeded = false;
  final Set<String> _knownIds = <String>{};
  bool _tickInFlight = false;

  bool get isRunning => _running;

  Future<void> start() async {
    if (_running) return;
    _running = true;
    try {
      await _local.initialize();
      await _local.requestPermission();
      await _tick(seedOnly: true);
      _timer?.cancel();
      _timer = Timer.periodic(pollInterval, (_) {
        unawaited(_tick());
      });
    } catch (error, stack) {
      _running = false;
      if (kDebugMode) {
        debugPrint('[admin-alerts] start failed error=$error\n$stack');
      }
    }
  }

  Future<void> stop() async {
    _running = false;
    _timer?.cancel();
    _timer = null;
    _seeded = false;
    _knownIds.clear();
  }

  Future<void> refreshNow() => _tick();

  Future<void> _tick({bool seedOnly = false}) async {
    if (!_running || _tickInFlight) return;
    _tickInFlight = true;
    try {
      final items = await _repository.listNotifications();
      if (!_seeded || seedOnly) {
        _knownIds
          ..clear()
          ..addAll(items.map((item) => item.id));
        _seeded = true;
        return;
      }

      final fresh = <AdminNotification>[];
      for (final item in items) {
        if (_knownIds.contains(item.id)) continue;
        if (AdminPushDedupe.instance.wasSeen(item.id)) {
          _knownIds.add(item.id);
          continue;
        }
        if (item.isRead) {
          _knownIds.add(item.id);
          continue;
        }
        fresh.add(item);
        _knownIds.add(item.id);
        AdminPushDedupe.instance.markSeen(item.id);
      }

      // Newest first for audible priority.
      fresh.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      for (final item in fresh) {
        try {
          await _local.showAdminNotification(item);
        } catch (error, stack) {
          if (kDebugMode) {
            debugPrint(
              '[admin-alerts] show failed id=${item.id} error=$error\n$stack',
            );
          }
        }
      }
    } catch (error, stack) {
      if (kDebugMode) {
        debugPrint('[admin-alerts] poll failed error=$error\n$stack');
      }
    } finally {
      _tickInFlight = false;
    }
  }
}

final adminNotificationWatcherProvider = Provider<AdminNotificationWatcher>((
  ref,
) {
  final watcher = AdminNotificationWatcher(
    repository: ref.watch(notificationsRepositoryProvider),
  );
  ref.onDispose(() {
    unawaited(watcher.stop());
  });
  return watcher;
});

/// Starts/stops the watcher with auth and refreshes the inbox when auth is ready.
final adminAlertBootstrapProvider = Provider<void>((ref) {
  final auth = ref.watch(adminAuthProvider);
  final watcher = ref.watch(adminNotificationWatcherProvider);

  if (auth.isAuthenticated && !auth.requiresPinUnlock) {
    unawaited(watcher.start());
  } else {
    unawaited(watcher.stop());
  }

  ref.listen<AdminAuthState>(adminAuthProvider, (previous, next) {
    if (next.isAuthenticated && !next.requiresPinUnlock) {
      unawaited(watcher.start());
      // Keep the in-app inbox in sync when session becomes ready.
      unawaited(ref.read(notificationsProvider.notifier).refresh());
    } else if (previous?.isAuthenticated == true && !next.isAuthenticated) {
      unawaited(watcher.stop());
      AdminPushDedupe.instance.clear();
    }
  });
});
