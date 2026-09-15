import 'admin_fcm_payload.dart';

typedef AdminFcmTapHandler = void Function(AdminFcmPayload payload);

/// Stages FCM tap navigation until the app router is ready.
class AdminFcmTapCoordinator {
  AdminFcmTapCoordinator._();

  static final AdminFcmTapCoordinator instance = AdminFcmTapCoordinator._();

  AdminFcmPayload? _pendingPayload;
  AdminFcmTapHandler? onPayloadTap;

  void stagePendingPayload(AdminFcmPayload payload) {
    _pendingPayload = payload;
  }

  void handlePayload(AdminFcmPayload payload) {
    final handler = onPayloadTap;
    if (handler != null) {
      handler(payload);
      return;
    }
    _pendingPayload = payload;
  }

  AdminFcmPayload? consumePendingPayload() {
    final payload = _pendingPayload;
    _pendingPayload = null;
    return payload;
  }

  void clear() {
    _pendingPayload = null;
  }
}
