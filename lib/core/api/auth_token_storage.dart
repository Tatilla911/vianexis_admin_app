import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../auth/admin_user.dart';
import '../auth/auth_token_bundle.dart';
import '../device/admin_device_identity_service.dart';

/// Persists refresh session secrets and stable device identity in secure storage.
///
/// Access tokens are kept only for the active process lifetime — not restored
/// across cold starts without a successful refresh.
class AuthTokenStorage {
  AuthTokenStorage({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const accessTokenKey = 'vianexis_admin_access_token';
  static const refreshTokenKey = 'vianexis_admin_refresh_token';
  static const sessionIdKey = 'vianexis_admin_session_id';
  static const rememberDeviceKey = 'vianexis_admin_remember_device';
  static const refreshExpiresAtKey = 'vianexis_admin_refresh_expires_at';
  static const cachedUserKey = 'vianexis_admin_cached_user';

  final FlutterSecureStorage _storage;
  String? _accessTokenCache;

  Future<String?> readAccessToken() async {
    return _accessTokenCache ??= await _storage.read(key: accessTokenKey);
  }

  Future<String?> readRefreshToken() => _storage.read(key: refreshTokenKey);

  Future<String?> readSessionId() => _storage.read(key: sessionIdKey);

  Future<bool> readRememberDevice() async {
    final value = await _storage.read(key: rememberDeviceKey);
    return value == 'true';
  }

  Future<String?> readRefreshExpiresAt() =>
      _storage.read(key: refreshExpiresAtKey);

  Future<void> writeAccessToken(String accessToken) async {
    _accessTokenCache = accessToken;
    await _storage.write(key: accessTokenKey, value: accessToken);
  }

  Future<void> writeSessionBundle(
    AuthTokenBundle bundle, {
    required bool rememberDevice,
  }) async {
    _accessTokenCache = bundle.accessToken;
    await _storage.write(key: accessTokenKey, value: bundle.accessToken);
    await _storage.write(key: refreshTokenKey, value: bundle.refreshToken);
    await _storage.write(key: sessionIdKey, value: bundle.sessionId);
    await _storage.write(
      key: rememberDeviceKey,
      value: rememberDevice ? 'true' : 'false',
    );
    if (bundle.refreshExpiresAt != null &&
        bundle.refreshExpiresAt!.trim().isNotEmpty) {
      await _storage.write(
        key: refreshExpiresAtKey,
        value: bundle.refreshExpiresAt,
      );
    }
  }

  Future<void> writeCachedUser(AdminUser user) async {
    await _storage.write(
      key: cachedUserKey,
      value: jsonEncode({
        'id': user.id,
        'email': user.email,
        'role': user.role.backendValue,
        if (user.name != null) 'name': user.name,
      }),
    );
  }

  Future<AdminUser?> readCachedUser() async {
    final raw = await _storage.read(key: cachedUserKey);
    if (raw == null || raw.trim().isEmpty) return null;
    try {
      final json = jsonDecode(raw);
      if (json is! Map<String, dynamic>) return null;
      return AdminUser.fromAuthJson(json);
    } catch (_) {
      return null;
    }
  }

  Future<bool> hasRefreshSession() async {
    final refresh = await readRefreshToken();
    return refresh != null && refresh.isNotEmpty;
  }

  /// Clears auth/session secrets but keeps stable [AdminDeviceIdentityService.deviceIdKey].
  Future<void> clearSessionSecrets() async {
    _accessTokenCache = null;
    await _storage.delete(key: accessTokenKey);
    await _storage.delete(key: refreshTokenKey);
    await _storage.delete(key: sessionIdKey);
    await _storage.delete(key: rememberDeviceKey);
    await _storage.delete(key: refreshExpiresAtKey);
    await _storage.delete(key: cachedUserKey);
  }

  Future<void> clear() => clearSessionSecrets();

  @Deprecated('Use writeSessionBundle')
  Future<void> writeTokens({
    required String accessToken,
    required String refreshToken,
  }) async {
    await writeAccessToken(accessToken);
    await _storage.write(key: refreshTokenKey, value: refreshToken);
  }
}

final authTokenStorageProvider = Provider<AuthTokenStorage>(
  (ref) => AuthTokenStorage(),
);
