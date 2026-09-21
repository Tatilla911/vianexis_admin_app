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
    this.lastErrorKind,
  });

  const AdminAuthState.unauthenticated()
    : user = null,
      isLoading = false,
      isRestoringSession = false,
      isPinLocked = false,
      offlineSessionRestorePending = false,
      errorMessageKey = null,
      lastErrorKind = null;

  final AdminUser? user;
  final bool isLoading;
  final bool isRestoringSession;
  final bool isPinLocked;
  final bool offlineSessionRestorePending;
  final String? errorMessageKey;
  final ApiExceptionKind? lastErrorKind;

  bool get isAuthenticated => user != null;

  bool get requiresPinUnlock => isPinLocked && user != null;

  /// Transient backend/network failures — never treat as invalid password.
  bool get isConnectionFailure =>
      lastErrorKind == ApiExceptionKind.network ||
      lastErrorKind == ApiExceptionKind.timeout ||
      lastErrorKind == ApiExceptionKind.server ||
      lastErrorKind == ApiExceptionKind.notConfigured;

  bool get canRetrySignIn => isConnectionFailure && !isLoading;

  AdminAuthState copyWith({
    AdminUser? user,
    bool clearUser = false,
    bool? isLoading,
    bool? isRestoringSession,
    bool? isPinLocked,
    bool? offlineSessionRestorePending,
    String? errorMessageKey,
    ApiExceptionKind? lastErrorKind,
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
      lastErrorKind: clearError ? null : (lastErrorKind ?? this.lastErrorKind),
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
        errorMessageKey: _signInMessageKey(error),
        lastErrorKind: error.kind,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessageKey: LocalizationKeys.authServerUnreachable,
        lastErrorKind: ApiExceptionKind.unknown,
      );
    }
  }

  String _signInMessageKey(ApiException error) {
    switch (error.kind) {
      case ApiExceptionKind.network:
      case ApiExceptionKind.timeout:
      case ApiExceptionKind.server:
        return LocalizationKeys.authServerUnreachable;
      case ApiExceptionKind.notConfigured:
        return LocalizationKeys.authBackendNotConfigured;
      case ApiExceptionKind.unauthorized:
        // Login 401 is invalid credentials; session-expired is for later.
        return error.messageKey == LocalizationKeys.authSessionExpired
            ? LocalizationKeys.authInvalidCredentials
            : error.messageKey;
      case ApiExceptionKind.forbidden:
        return LocalizationKeys.authForbiddenRole;
      case ApiExceptionKind.notFound:
        return LocalizationKeys.authLoginServiceUnavailable;
      case ApiExceptionKind.validation:
      case ApiExceptionKind.conflict:
      case ApiExceptionKind.unknown:
        return error.messageKey;
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
