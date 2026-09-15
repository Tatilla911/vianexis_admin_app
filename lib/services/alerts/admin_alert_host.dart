import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_router.dart';
import '../../features/notifications/data/notifications_repository.dart';
import '../../features/notifications/domain/admin_notification.dart';
import '../../features/notifications/domain/admin_notification_routing.dart';
import 'admin_local_notification_service.dart';
import 'admin_notification_watcher.dart';

/// Binds alert services to app lifecycle and notification taps.
class AdminAlertHost extends ConsumerStatefulWidget {
  const AdminAlertHost({super.key, required this.child});

  final Widget child;

  @override
  ConsumerState<AdminAlertHost> createState() => _AdminAlertHostState();
}

class _AdminAlertHostState extends ConsumerState<AdminAlertHost>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    AdminLocalNotificationService.instance.onNotificationTap = _handleTap;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _consumePendingTap();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    if (AdminLocalNotificationService.instance.onNotificationTap ==
        _handleTap) {
      AdminLocalNotificationService.instance.onNotificationTap = null;
    }
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      final watcher = ref.read(adminNotificationWatcherProvider);
      if (watcher.isRunning) {
        unawaitedRefresh(watcher);
      }
      _consumePendingTap();
    }
  }

  void unawaitedRefresh(AdminNotificationWatcher watcher) {
    watcher.refreshNow().then((_) {
      return ref.read(notificationsProvider.notifier).refresh();
    });
  }

  void _handleTap(String notificationId) {
    if (!mounted) {
      AdminLocalNotificationService.instance.stagePendingTap(notificationId);
      return;
    }
    final router = ref.read(appRouterProvider);
    final items = ref.read(notificationsProvider).asData?.value;
    AdminNotification? match;
    if (items != null) {
      for (final item in items) {
        if (item.id == notificationId) {
          match = item;
          break;
        }
      }
    }
    router.go(resolveAdminNotificationDestination(match));
  }

  void _consumePendingTap() {
    final id = AdminLocalNotificationService.instance.consumePendingTap();
    if (id == null) return;
    _handleTap(id);
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(adminAlertBootstrapProvider);
    return widget.child;
  }
}
