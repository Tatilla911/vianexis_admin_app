/// Tracks notification IDs already surfaced via FCM or the polling watcher
/// so the same event is not shown twice.
class AdminPushDedupe {
  AdminPushDedupe._();

  static final AdminPushDedupe instance = AdminPushDedupe._();

  final Set<String> _seenNotificationIds = <String>{};

  bool wasSeen(String notificationId) =>
      _seenNotificationIds.contains(notificationId.trim());

  bool markSeen(String notificationId) {
    final id = notificationId.trim();
    if (id.isEmpty) return false;
    return _seenNotificationIds.add(id);
  }

  void clear() => _seenNotificationIds.clear();
}
