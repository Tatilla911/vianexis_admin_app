import '../api/api_client.dart';
import '../api/api_exception.dart';
import '../api/auth_token_storage.dart';
import '../device/admin_device_identity_service.dart';
import '../localization/localization_keys.dart';
import 'admin_auth_api.dart';
import 'admin_auth_session.dart';
import 'admin_user.dart';
import 'auth_refresh_coordinator.dart';
import 'auth_refresh_result.dart';

enum SessionRestoreOutcome {
  success,
  unauthenticated,
  authInvalid,
  networkPending,
}

class AdminAuthRepository {
  AdminAuthRepository({
    required ApiClient apiClient,
    required AuthTokenStorage tokenStorage,
    required AdminAuthApi authApi,
    required AdminDeviceIdentityService deviceIdentity,
    required AuthRefreshCoordinator refreshCoordinator,
  }) : _apiClient = apiClient,
       _tokenStorage = tokenStorage,
       _authApi = authApi,
       _deviceIdentity = deviceIdentity,
       _refreshCoordinator = refreshCoordinator;

  final ApiClient _apiClient;
  final AuthTokenStorage _tokenStorage;
  final AdminAuthApi _authApi;
  final AdminDeviceIdentityService _deviceIdentity;
  final AuthRefreshCoordinator _refreshCoordinator;

  Future<AdminUser> signIn({
    required String email,
    required String password,
    required bool rememberDevice,
  }) async {
    _ensureConfigured();

    try {
      final deviceId = await _deviceIdentity.getOrCreateDeviceId();
      final login = await _authApi.login(
        email: email,
        password: password,
        rememberDevice: rememberDevice,
        deviceId: deviceId,
        deviceName: AdminDeviceIdentityService.deviceName,
        platform: _deviceIdentity.resolvePlatform(),
        appType: AdminDeviceIdentityService.appType,
      );
      await _tokenStorage.writeSessionBundle(
        login.bundle,
        rememberDevice: rememberDevice,
      );

      final user = login.user ?? await _authApi.fetchCurrentUser();
      _ensurePlatformAdmin(user);
      await _tokenStorage.writeCachedUser(user);
      return user;
    } on ApiException {
      await _tokenStorage.clearSessionSecrets();
      rethrow;
    } catch (_) {
      await _tokenStorage.clearSessionSecrets();
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.unknown,
      );
    }
  }

  Future<({SessionRestoreOutcome outcome, AdminUser? user})>
  restoreSession() async {
    if (!_apiClient.isConfigured) {
      return (outcome: SessionRestoreOutcome.unauthenticated, user: null);
    }

    final rememberDevice = await _tokenStorage.readRememberDevice();
    final refreshToken = await _tokenStorage.readRefreshToken();

    if (!rememberDevice || refreshToken == null || refreshToken.isEmpty) {
      await _tokenStorage.clearSessionSecrets();
      return (outcome: SessionRestoreOutcome.unauthenticated, user: null);
    }

    final refreshResult = await _refreshCoordinator.refreshOnce();
    switch (refreshResult) {
      case AuthRefreshResult.success:
        try {
          final user = await _authApi.fetchCurrentUser();
          _ensurePlatformAdmin(user);
          await _tokenStorage.writeCachedUser(user);
          return (outcome: SessionRestoreOutcome.success, user: user);
        } on ApiException catch (error) {
          if (_isTransientError(error)) {
            final cached = await _tokenStorage.readCachedUser();
            if (cached != null) {
              return (
                outcome: SessionRestoreOutcome.networkPending,
                user: cached,
              );
            }
            return (outcome: SessionRestoreOutcome.networkPending, user: null);
          }
          await _tokenStorage.clearSessionSecrets();
          return (outcome: SessionRestoreOutcome.authInvalid, user: null);
        } catch (_) {
          final cached = await _tokenStorage.readCachedUser();
          if (cached != null) {
            return (
              outcome: SessionRestoreOutcome.networkPending,
              user: cached,
            );
          }
          return (outcome: SessionRestoreOutcome.networkPending, user: null);
        }
      case AuthRefreshResult.authInvalid:
        await _tokenStorage.clearSessionSecrets();
        return (outcome: SessionRestoreOutcome.authInvalid, user: null);
      case AuthRefreshResult.transientFailure:
        final cached = await _tokenStorage.readCachedUser();
        return (outcome: SessionRestoreOutcome.networkPending, user: cached);
    }
  }

  Future<void> signOut() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken != null &&
        refreshToken.isNotEmpty &&
        _apiClient.isConfigured) {
      try {
        await _authApi.logoutRemote(refreshToken: refreshToken);
      } catch (_) {
        // Local sign-out must still succeed if remote logout fails.
      }
    }
    await _tokenStorage.clearSessionSecrets();
  }

  Future<List<AdminAuthSession>> listSessions() => _authApi.listSessions();

  Future<void> revokeSession(String sessionId) =>
      _authApi.revokeSession(sessionId);

  Future<void> logoutAllOtherDevices() async {
    final refreshToken = await _tokenStorage.readRefreshToken();
    if (refreshToken == null || refreshToken.isEmpty) {
      throw const ApiException(
        messageKey: LocalizationKeys.authSessionExpired,
        kind: ApiExceptionKind.unauthorized,
      );
    }
    await _authApi.logoutAllOtherDevices(refreshToken: refreshToken);
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _ensureConfigured();
    try {
      await _authApi.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
    } on ApiException {
      rethrow;
    } catch (_) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.unknown,
      );
    } finally {
      await _tokenStorage.clearSessionSecrets();
    }
  }

  Future<String> getDeviceId() => _deviceIdentity.getOrCreateDeviceId();

  void _ensureConfigured() {
    if (!_apiClient.isConfigured) {
      throw const ApiException(
        messageKey: LocalizationKeys.authBackendNotConfigured,
        kind: ApiExceptionKind.notConfigured,
      );
    }
  }

  void _ensurePlatformAdmin(AdminUser user) {
    if (!AdminRole.isPlatformAdminBackendRole(user.role.backendValue)) {
      throw const ApiException(
        messageKey: LocalizationKeys.authForbiddenRole,
        kind: ApiExceptionKind.forbidden,
      );
    }
  }

  bool _isTransientError(ApiException error) {
    return error.kind == ApiExceptionKind.network ||
        error.kind == ApiExceptionKind.timeout ||
        error.kind == ApiExceptionKind.server;
  }
}
