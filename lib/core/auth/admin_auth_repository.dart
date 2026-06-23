import '../api/api_client.dart';
import '../api/api_exception.dart';
import '../api/auth_token_storage.dart';
import '../localization/localization_keys.dart';
import 'admin_auth_api.dart';
import 'admin_user.dart';

class AdminAuthRepository {
  AdminAuthRepository({
    required ApiClient apiClient,
    required AuthTokenStorage tokenStorage,
    required AdminAuthApi authApi,
  }) : _apiClient = apiClient,
       _tokenStorage = tokenStorage,
       _authApi = authApi;

  final ApiClient _apiClient;
  final AuthTokenStorage _tokenStorage;
  final AdminAuthApi _authApi;

  Future<AdminUser> signIn({
    required String email,
    required String password,
  }) async {
    _ensureConfigured();

    try {
      final login = await _authApi.login(email: email, password: password);
      await _tokenStorage.writeTokens(
        accessToken: login.accessToken,
        refreshToken: login.refreshToken,
      );

      final user = login.user ?? await _authApi.fetchCurrentUser();
      _ensurePlatformAdmin(user);
      return user;
    } on ApiException {
      await _tokenStorage.clear();
      rethrow;
    } catch (_) {
      await _tokenStorage.clear();
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.unknown,
      );
    }
  }

  Future<AdminUser?> restoreSession() async {
    if (!_apiClient.isConfigured) return null;

    final accessToken = await _tokenStorage.readAccessToken();
    if (accessToken == null || accessToken.isEmpty) return null;

    try {
      final user = await _authApi.fetchCurrentUser();
      _ensurePlatformAdmin(user);
      return user;
    } on ApiException catch (error) {
      await _tokenStorage.clear();
      if (error.kind == ApiExceptionKind.forbidden ||
          error.kind == ApiExceptionKind.unauthorized) {
        rethrow;
      }
      return null;
    } catch (_) {
      await _tokenStorage.clear();
      return null;
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
    await _tokenStorage.clear();
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
      await _tokenStorage.clear();
    }
  }

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
}
