class CustomerAgreementSnapshot {
  const CustomerAgreementSnapshot({
    required this.id,
    this.threadId,
    this.companyId,
    this.subscriptionId,
    this.pricingIntakeId,
    this.quoteRequestId,
    required this.planName,
    required this.planCode,
    this.planVersion,
    this.priceAmount,
    this.currency,
    this.billingCycle,
    this.selectedModules = const [],
    this.selectedAddOns = const [],
    this.termsVersion,
    this.privacyVersion,
    this.acceptedAt,
    this.acceptedByUserId,
    this.acceptedByEmailHash,
    this.acceptanceSource,
    this.metadataOnly = true,
  });

  final String id;
  final String? threadId;
  final String? companyId;
  final String? subscriptionId;
  final String? pricingIntakeId;
  final String? quoteRequestId;
  final String planName;
  final String planCode;
  final String? planVersion;
  final String? priceAmount;
  final String? currency;
  final String? billingCycle;
  final List<String> selectedModules;
  final List<String> selectedAddOns;
  final String? termsVersion;
  final String? privacyVersion;
  final DateTime? acceptedAt;
  final String? acceptedByUserId;
  final String? acceptedByEmailHash;
  final String? acceptanceSource;
  final bool metadataOnly;

  factory CustomerAgreementSnapshot.fromJson(Map<String, dynamic> json) {
    return CustomerAgreementSnapshot(
      id: json['id']?.toString() ?? '',
      threadId: json['threadId']?.toString(),
      companyId: json['companyId']?.toString(),
      subscriptionId: json['subscriptionId']?.toString(),
      pricingIntakeId: json['pricingIntakeId']?.toString(),
      quoteRequestId: json['quoteRequestId']?.toString(),
      planName: json['planName']?.toString() ?? '—',
      planCode: json['planCode']?.toString() ?? '—',
      planVersion: json['planVersion']?.toString(),
      priceAmount: json['priceAmount']?.toString(),
      currency: json['currency']?.toString(),
      billingCycle: json['billingCycle']?.toString(),
      selectedModules: _stringList(json['selectedModules']),
      selectedAddOns: _stringList(json['selectedAddOns']),
      termsVersion: json['termsVersion']?.toString(),
      privacyVersion: json['privacyVersion']?.toString(),
      acceptedAt: _parseDate(json['acceptedAt']),
      acceptedByUserId: json['acceptedByUserId']?.toString(),
      acceptedByEmailHash: json['acceptedByEmailHash']?.toString(),
      acceptanceSource: json['acceptanceSource']?.toString(),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  static List<String> _stringList(Object? raw) {
    if (raw is List) {
      return raw.map((item) => item.toString()).toList(growable: false);
    }
    return const [];
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}
