import '../api/api_config.dart';
import '../api/api_exception.dart';
import '../api/auth_token_storage.dart';
import '../localization/localization_keys.dart';
import 'admin_user.dart';

class AdminAuthRepository {
  AdminAuthRepository({
    required ApiClient apiClient,
    required AuthTokenStorage tokenStorage,
  }) : _apiClient = apiClient,
       _tokenStorage = tokenStorage;

  final ApiClient _apiClient;
  final AuthTokenStorage _tokenStorage;

  Future<AdminUser> signIn({
    required String email,
    required String password,
  }) async {
    if (!_apiClient.config.isConfigured) {
      throw const ApiException(
        messageKey: LocalizationKeys.loginBackendNotConfigured,
        kind: ApiExceptionKind.notConfigured,
      );
    }

    // Backend integration will call POST /auth/login here.
    throw const ApiException(
      messageKey: LocalizationKeys.loginBackendNotConfigured,
      kind: ApiExceptionKind.notConfigured,
    );
  }

  Future<void> signOut() async {
    await _tokenStorage.clear();
  }

  /// Used by tests to validate shell navigation without a backend.
  Future<AdminUser> signInForTesting({
    required String email,
    required AdminRole role,
  }) async {
    return AdminUser(id: 'test-user', email: email, role: role);
  }
}
