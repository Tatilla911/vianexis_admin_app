import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/api_exception.dart';
import '../localization/localization_keys.dart';
import 'admin_auth_session.dart';
import 'admin_user.dart';
import 'auth_token_bundle.dart';

class AuthLoginResult {
  const AuthLoginResult({required this.bundle, this.user});

  final AuthTokenBundle bundle;
  final AdminUser? user;
}

class AdminAuthApi {
  AdminAuthApi(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthLoginResult> login({
    required String email,
    required String password,
    required bool rememberDevice,
    required String deviceId,
    required String deviceName,
    required String platform,
    required String appType,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email.trim(),
        'password': password,
        'rememberDevice': rememberDevice,
        'deviceId': deviceId,
        'deviceName': deviceName,
        'platform': platform,
        'appType': appType,
      },
      options: ApiClient.skipRefreshOptions,
    );

    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.authServerError,
        kind: ApiExceptionKind.server,
      );
    }

    final bundle = AuthTokenBundle.fromResponse(data);
    AdminUser? user;
    final userJson = data['user'];
    if (userJson is Map<String, dynamic>) {
      user = AdminUser.fromAuthJson(userJson);
    } else if (userJson is Map) {
      user = AdminUser.fromAuthJson(Map<String, dynamic>.from(userJson));
    }

    return AuthLoginResult(bundle: bundle, user: user);
  }

  Future<AuthTokenBundle> refreshTokens({
    required String refreshToken,
    String? sessionId,
    required String platform,
    required String deviceName,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/refresh',
      data: {
        'refresh_token': refreshToken,
        if (sessionId != null && sessionId.isNotEmpty) 'sessionId': sessionId,
        'platform': platform,
        'deviceName': deviceName,
      },
      options: ApiClient.skipRefreshOptions,
    );

    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.authServerError,
        kind: ApiExceptionKind.server,
      );
    }
    return AuthTokenBundle.fromResponse(data);
  }

  Future<AdminUser> fetchCurrentUser() async {
    final response = await _apiClient.get<Map<String, dynamic>>('/auth/me');
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.authServerError,
        kind: ApiExceptionKind.server,
      );
    }
    return AdminUser.fromAuthJson(data);
  }

  Future<void> logoutRemote({required String refreshToken}) async {
    await _apiClient.post<void>(
      '/auth/logout',
      data: {'refresh_token': refreshToken},
      options: ApiClient.skipRefreshOptions,
    );
  }

  Future<void> logoutAllOtherDevices({required String refreshToken}) async {
    await _apiClient.post<void>(
      '/auth/logout-all',
      data: {'keepCurrent': true, 'refresh_token': refreshToken},
    );
  }

  Future<List<AdminAuthSession>> listSessions() async {
    final response = await _apiClient.get<List<dynamic>>('/auth/sessions');
    final data = response.data;
    if (data == null) return const [];
    return data
        .whereType<Map>()
        .map(
          (item) => AdminAuthSession.fromJson(Map<String, dynamic>.from(item)),
        )
        .where((session) => session.id.isNotEmpty)
        .toList(growable: false);
  }

  Future<void> revokeSession(String sessionId) async {
    await _apiClient.delete<void>('/auth/sessions/$sessionId');
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.patch<void>(
      '/auth/me/password',
      data: {'currentPassword': currentPassword, 'newPassword': newPassword},
    );
  }
}

final adminAuthApiProvider = Provider<AdminAuthApi>((ref) {
  return AdminAuthApi(ref.watch(apiClientProvider));
});
