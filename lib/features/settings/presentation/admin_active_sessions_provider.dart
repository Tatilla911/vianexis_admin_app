import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/admin_auth_session.dart';
import '../../../core/auth/admin_auth_state.dart';

final adminActiveSessionsProvider =
    AsyncNotifierProvider<AdminActiveSessionsNotifier, List<AdminAuthSession>>(
      AdminActiveSessionsNotifier.new,
    );

class AdminActiveSessionsNotifier
    extends AsyncNotifier<List<AdminAuthSession>> {
  @override
  Future<List<AdminAuthSession>> build() async {
    final auth = ref.watch(adminAuthProvider);
    if (!auth.isAuthenticated) return const [];
    return ref.read(adminAuthRepositoryProvider).listSessions();
  }

  Future<void> refresh() async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      return ref.read(adminAuthRepositoryProvider).listSessions();
    });
  }

  Future<void> revokeSession(String sessionId) async {
    await ref.read(adminAuthRepositoryProvider).revokeSession(sessionId);
    await refresh();
  }

  Future<void> logoutAllOtherDevices() async {
    await ref.read(adminAuthRepositoryProvider).logoutAllOtherDevices();
    await refresh();
  }
}
