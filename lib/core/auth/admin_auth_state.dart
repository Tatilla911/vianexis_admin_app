import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/api_exception.dart';
import '../api/auth_token_storage.dart';
import '../device/admin_device_identity_service.dart';
import '../localization/localization_keys.dart';
import '../security/admin_device_pin_service.dart';
import 'admin_auth_api.dart';
import 'admin_auth_repository.dart';
import 'admin_user.dart';
import 'auth_refresh_coordinator.dart';

class AdminAuthState {
  const AdminAuthState({
    this.user,
    this.isLoading = false,
    this.isRestoringSession = false,
    this.isPinLocked = false,
    this.offlineSessionRestorePending = false,
    this.errorMessageKey,
  });

  const AdminAuthState.unauthenticated()
    : user = null,
      isLoading = false,
      isRestoringSession = false,
      isPinLocked = false,
      offlineSessionRestorePending = false,
      errorMessageKey = null;

  final AdminUser? user;
  final bool isLoading;
  final bool isRestoringSession;
  final bool isPinLocked;
  final bool offlineSessionRestorePending;
  final String? errorMessageKey;

  bool get isAuthenticated => user != null;

  bool get requiresPinUnlock => isPinLocked && user != null;

  AdminAuthState copyWith({
    AdminUser? user,
    bool clearUser = false,
    bool? isLoading,
    bool? isRestoringSession,
    bool? isPinLocked,
    bool? offlineSessionRestorePending,
    String? errorMessageKey,
    bool clearError = false,
  }) {
    return AdminAuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      isRestoringSession: isRestoringSession ?? this.isRestoringSession,
      isPinLocked: isPinLocked ?? this.isPinLocked,
      offlineSessionRestorePending:
          offlineSessionRestorePending ?? this.offlineSessionRestorePending,
      errorMessageKey: clearError
          ? null
          : (errorMessageKey ?? this.errorMessageKey),
    );
  }
}

final adminAuthRepositoryProvider = Provider<AdminAuthRepository>((ref) {
  return AdminAuthRepository(
    apiClient: ref.watch(apiClientProvider),
    tokenStorage: ref.watch(authTokenStorageProvider),
    authApi: ref.watch(adminAuthApiProvider),
    deviceIdentity: ref.watch(adminDeviceIdentityServiceProvider),
    refreshCoordinator: ref.watch(authRefreshCoordinatorProvider),
  );
});

class AdminAuthNotifier extends Notifier<AdminAuthState> {
  late final AdminAuthRepository _repository;

  @override
  AdminAuthState build() {
    _repository = ref.watch(adminAuthRepositoryProvider);
    Future.microtask(_restoreSession);
    return const AdminAuthState(isRestoringSession: true);
  }

  Future<void> _restoreSession() async {
    try {
      final result = await _repository.restoreSession();
      final pinLocked = await _requiresPinLock();

      switch (result.outcome) {
        case SessionRestoreOutcome.success:
          state = AdminAuthState(user: result.user, isPinLocked: pinLocked);
        case SessionRestoreOutcome.networkPending:
          state = AdminAuthState(
            user: result.user,
            isPinLocked: pinLocked,
            offlineSessionRestorePending: true,
            errorMessageKey: result.user == null
                ? LocalizationKeys.authOfflineSessionRestorePending
                : null,
          );
        case SessionRestoreOutcome.authInvalid:
          state = AdminAuthState(
            errorMessageKey: LocalizationKeys.authUnableToRestoreSession,
          );
        case SessionRestoreOutcome.unauthenticated:
          state = const AdminAuthState.unauthenticated();
      }
    } catch (_) {
      state = const AdminAuthState.unauthenticated();
    }
  }

  Future<bool> _requiresPinLock() async {
    return ref.read(adminDevicePinServiceProvider).hasPin();
  }

  Future<void> signIn({
    required String email,
    required String password,
    required bool rememberDevice,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.signIn(
        email: email,
        password: password,
        rememberDevice: rememberDevice,
      );
      final pinLocked = await _requiresPinLock();
      state = AdminAuthState(user: user, isPinLocked: pinLocked);
    } on ApiException catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessageKey: error.messageKey,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessageKey: LocalizationKeys.errorGenericBody,
      );
    }
  }

  Future<void> unlockPin() async {
    state = state.copyWith(isPinLocked: false);
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AdminAuthState.unauthenticated();
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      state = const AdminAuthState.unauthenticated();
      return true;
    } on ApiException catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessageKey: error.messageKey,
      );
      return false;
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessageKey: LocalizationKeys.errorGenericBody,
      );
      return false;
    }
  }

  Future<void> handleSessionExpired() async {
    await _repository.signOut();
    state = AdminAuthState(
      errorMessageKey: LocalizationKeys.authSessionExpired,
    );
  }

  void setAuthenticatedUser(AdminUser user) {
    state = AdminAuthState(user: user);
  }
}

final adminAuthProvider = NotifierProvider<AdminAuthNotifier, AdminAuthState>(
  AdminAuthNotifier.new,
);
