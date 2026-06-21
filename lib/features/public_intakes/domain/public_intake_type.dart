enum PublicIntakeType {
  contact('contact'),
  demoRequest('demo_request'),
  quoteRequest('quote_request'),
  registrationInterest('registration_interest'),
  supportRequest('support_request'),
  unknown('unknown');

  const PublicIntakeType(this.backendValue);

  final String backendValue;

  static PublicIntakeType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    for (final type in PublicIntakeType.values) {
      if (type.backendValue == raw) return type;
    }
    return unknown;
  }

  bool get isHighPriority =>
      this == demoRequest || this == quoteRequest;

  String localizationKey() {
    return switch (this) {
      PublicIntakeType.contact => 'publicIntakeTypeContact',
      PublicIntakeType.demoRequest => 'publicIntakeTypeDemoRequest',
      PublicIntakeType.quoteRequest => 'publicIntakeTypeQuoteRequest',
      PublicIntakeType.registrationInterest =>
        'publicIntakeTypeRegistrationInterest',
      PublicIntakeType.supportRequest => 'publicIntakeTypeSupportRequest',
      PublicIntakeType.unknown => 'publicIntakeTypeUnknown',
    };
  }
}
