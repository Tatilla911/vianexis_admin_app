enum PushProviderUiState {
  inAppOnly,
  externalNotConfigured,
  configured,
}

class PushProviderStatus {
  const PushProviderStatus({
    required this.provider,
    required this.deliveryEnabled,
    required this.configured,
    required this.tokenStorageMode,
    this.lastAttemptAt,
    this.lastSuccessAt,
    this.lastFailureCode,
    this.metadataOnly = true,
  });

  final String provider;
  final bool deliveryEnabled;
  final bool configured;
  final String tokenStorageMode;
  final DateTime? lastAttemptAt;
  final DateTime? lastSuccessAt;
  final String? lastFailureCode;
  final bool metadataOnly;

  PushProviderUiState get uiState {
    if (configured) return PushProviderUiState.configured;
    if (provider == 'none') return PushProviderUiState.inAppOnly;
    return PushProviderUiState.externalNotConfigured;
  }

  factory PushProviderStatus.fromJson(Map<String, dynamic> json) {
    return PushProviderStatus(
      provider: json['provider']?.toString() ?? 'none',
      deliveryEnabled: json['deliveryEnabled'] == true,
      configured: json['configured'] == true,
      tokenStorageMode: json['tokenStorageMode']?.toString() ?? 'hash_only',
      lastAttemptAt: _parseDate(json['lastAttemptAt']),
      lastSuccessAt: _parseDate(json['lastSuccessAt']),
      lastFailureCode: json['lastFailureCode']?.toString(),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  /// Values rendered in notification preferences push status card.
  List<String> get safeDisplayValues => [
        provider,
        deliveryEnabled ? 'yes' : 'no',
        configured ? 'yes' : 'no',
        tokenStorageMode,
        ?lastFailureCode,
      ];
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString());
}
