import 'support_access_scope_type.dart';

enum SupportAccessGrantActionType {
  create,
  revoke,
}

class SupportAccessGrantRequest {
  SupportAccessGrantRequest({
    required this.companyId,
    required this.scopeType,
    required this.reason,
    required this.expiresAt,
    this.scopeId,
    this.linkedTicketId,
    this.linkedSystemHealthEventId,
    this.documentsAllowed = false,
    this.aiDiagnosticsAllowed = false,
    this.type = SupportAccessGrantActionType.create,
  });

  final String companyId;
  final SupportAccessScopeType scopeType;
  final String? scopeId;
  final String reason;
  final DateTime expiresAt;
  final String? linkedTicketId;
  final String? linkedSystemHealthEventId;
  final bool documentsAllowed;
  final bool aiDiagnosticsAllowed;
  final SupportAccessGrantActionType type;

  static const maxExpiryDuration = Duration(hours: 24);
  static const defaultShortExpiry = Duration(hours: 2);

  bool get isValidExpiry {
    final now = DateTime.now().toUtc();
    final expiry = expiresAt.toUtc();
    if (!expiry.isAfter(now)) return false;
    return expiry.difference(now) <= maxExpiryDuration;
  }

  bool get hasRequiredScopeId {
    if (!scopeType.requiresScopeId) return true;
    return scopeId != null && scopeId!.trim().isNotEmpty;
  }

  String? validationErrorKey() {
    if (reason.trim().length < 3) return 'supportGrantReasonRequired';
    if (documentsAllowed) return 'supportGrantBroadAccessRejected';
    if (!hasRequiredScopeId) return 'supportGrantScopeIdRequired';
    if (!isValidExpiry) return 'supportGrantExpiryRequired';
    return null;
  }

  Map<String, dynamic> toJson() {
    return switch (type) {
      SupportAccessGrantActionType.create => {
        'companyId': int.tryParse(companyId) ?? companyId,
        'grantedToRole': 'support_admin',
        'accessLevel': 'read_only',
        'scope': scopeType.backendScopes(documentsAllowed: false),
        'documentsAllowed': false,
        'aiDiagnosticsAllowed': aiDiagnosticsAllowed,
        'reason': reason.trim(),
        'expiresAt': expiresAt.toUtc().toIso8601String(),
        'metadata': {
          'scopeType': scopeType.backendValue(),
          if (scopeId != null && scopeId!.trim().isNotEmpty) 'scopeId': scopeId!.trim(),
          if (linkedTicketId != null) 'linkedTicketId': linkedTicketId,
          if (linkedSystemHealthEventId != null)
            'linkedSystemHealthEventId': linkedSystemHealthEventId,
        },
      },
      SupportAccessGrantActionType.revoke => {
        'reason': reason.trim(),
      },
    };
  }

  String endpointSuffix() {
    return switch (type) {
      SupportAccessGrantActionType.create => '',
      SupportAccessGrantActionType.revoke => 'revoke',
    };
  }

  String httpMethod() {
    return switch (type) {
      SupportAccessGrantActionType.create => 'POST',
      SupportAccessGrantActionType.revoke => 'PATCH',
    };
  }
}
