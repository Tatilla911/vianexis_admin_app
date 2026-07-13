import '../api/api_exception.dart';
import '../localization/localization_keys.dart';

/// Normalized auth token payload from login or refresh.
class AuthTokenBundle {
  const AuthTokenBundle({
    required this.accessToken,
    required this.refreshToken,
    required this.sessionId,
    this.expiresIn,
    this.refreshExpiresAt,
    this.tokenType,
  });

  final String accessToken;
  final String refreshToken;
  final String sessionId;
  final int? expiresIn;
  final String? refreshExpiresAt;
  final String? tokenType;

  factory AuthTokenBundle.fromResponse(Map<String, dynamic> json) {
    final access = _readToken(json, 'access_token', 'accessToken');
    final refresh = _readToken(json, 'refresh_token', 'refreshToken');
    final sessionId = _readSessionId(json);

    if (access == null || refresh == null || sessionId == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.authServerError,
        kind: ApiExceptionKind.server,
      );
    }

    return AuthTokenBundle(
      accessToken: access,
      refreshToken: refresh,
      sessionId: sessionId,
      expiresIn: _readInt(json['expires_in'] ?? json['expiresIn']),
      refreshExpiresAt:
          json['refresh_expires_at']?.toString() ??
          json['refreshExpiresAt']?.toString(),
      tokenType:
          json['token_type']?.toString() ?? json['tokenType']?.toString(),
    );
  }

  static String? _readToken(
    Map<String, dynamic> json,
    String snakeCase,
    String camelCase,
  ) {
    final value = json[snakeCase] ?? json[camelCase];
    if (value == null) return null;
    final token = value.toString().trim();
    return token.isEmpty ? null : token;
  }

  static String? _readSessionId(Map<String, dynamic> json) {
    final value = json['session_id'] ?? json['sessionId'];
    if (value == null) return null;
    final id = value.toString().trim();
    return id.isEmpty ? null : id;
  }

  static int? _readInt(dynamic value) {
    if (value is int) return value;
    return int.tryParse(value?.toString() ?? '');
  }
}
