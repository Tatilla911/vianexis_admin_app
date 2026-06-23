import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/api_exception.dart';
import '../localization/localization_keys.dart';
import 'admin_user.dart';

class AuthLoginResult {
  const AuthLoginResult({
    required this.accessToken,
    required this.refreshToken,
    this.user,
  });

  final String accessToken;
  final String refreshToken;
  final AdminUser? user;
}

class AdminAuthApi {
  AdminAuthApi(this._apiClient);

  final ApiClient _apiClient;

  Future<AuthLoginResult> login({
    required String email,
    required String password,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/auth/login',
      data: {
        'email': email.trim(),
        'password': password,
        'deviceName': 'ViaNexis Admin',
        'deviceType': 'mobile_admin',
      },
    );

    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.authServerError,
        kind: ApiExceptionKind.server,
      );
    }

    final accessToken = _readToken(data, 'access_token', 'accessToken');
    final refreshToken = _readToken(data, 'refresh_token', 'refreshToken');

    if (accessToken == null || refreshToken == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.authServerError,
        kind: ApiExceptionKind.server,
      );
    }

    AdminUser? user;
    final userJson = data['user'];
    if (userJson is Map<String, dynamic>) {
      user = AdminUser.fromAuthJson(userJson);
    } else if (userJson is Map) {
      user = AdminUser.fromAuthJson(Map<String, dynamic>.from(userJson));
    }

    return AuthLoginResult(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );
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
    );
  }

  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await _apiClient.patch<void>(
      '/auth/me/password',
      data: {
        'currentPassword': currentPassword,
        'newPassword': newPassword,
      },
    );
  }

  String? _readToken(
    Map<String, dynamic> json,
    String snakeCase,
    String camelCase,
  ) {
    final value = json[snakeCase] ?? json[camelCase];
    if (value == null) return null;
    final token = value.toString().trim();
    return token.isEmpty ? null : token;
  }
}

final adminAuthApiProvider = Provider<AdminAuthApi>((ref) {
  return AdminAuthApi(ref.watch(apiClientProvider));
});
