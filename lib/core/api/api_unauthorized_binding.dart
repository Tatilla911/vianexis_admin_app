import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../auth/admin_auth_state.dart';
import 'api_client.dart';

/// Wires session-expiry handling into the shared API client without import cycles.
final apiUnauthorizedBindingProvider = Provider<void>((ref) {
  final client = ref.watch(apiClientProvider);
  client.bindUnauthorizedHandler(
    () => ref.read(adminAuthProvider.notifier).handleSessionExpired(),
  );
  ref.onDispose(() => client.bindUnauthorizedHandler(null));
});
