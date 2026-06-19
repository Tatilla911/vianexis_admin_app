enum SupportAccessGrantStatus {
  pending,
  active,
  expired,
  revoked,
  denied,
  unknown;

  static SupportAccessGrantStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'pending' => pending,
      'active' => active,
      'expired' => expired,
      'revoked' => revoked,
      'denied' => denied,
      _ => unknown,
    };
  }

  static SupportAccessGrantStatus derive({
    String? explicitStatus,
    DateTime? revokedAt,
    required DateTime expiresAt,
    required bool isActive,
  }) {
    if (explicitStatus != null && explicitStatus.trim().isNotEmpty) {
      final parsed = fromBackendValue(explicitStatus);
      if (parsed != unknown) return parsed;
    }
    if (revokedAt != null) return revoked;
    if (DateTime.now().toUtc().isAfter(expiresAt.toUtc())) return expired;
    if (isActive) return active;
    return pending;
  }

  String localizationKey() {
    return switch (this) {
      SupportAccessGrantStatus.pending => 'supportGrantStatusPending',
      SupportAccessGrantStatus.active => 'supportGrantStatusActive',
      SupportAccessGrantStatus.expired => 'supportGrantStatusExpired',
      SupportAccessGrantStatus.revoked => 'supportGrantStatusRevoked',
      SupportAccessGrantStatus.denied => 'supportGrantStatusDenied',
      SupportAccessGrantStatus.unknown => 'supportGrantStatusUnknown',
    };
  }
}
