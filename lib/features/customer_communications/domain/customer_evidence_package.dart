enum CustomerEvidencePackageType {
  communicationEvidence,
  subscriptionDispute,
  registrationEvidence,
  pricingEvidence,
  unknown;

  static CustomerEvidencePackageType fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'communication_evidence' => communicationEvidence,
      'subscription_dispute' => subscriptionDispute,
      'registration_evidence' => registrationEvidence,
      'pricing_evidence' => pricingEvidence,
      _ => unknown,
    };
  }

  String backendValue() {
    return switch (this) {
      CustomerEvidencePackageType.communicationEvidence =>
        'communication_evidence',
      CustomerEvidencePackageType.subscriptionDispute => 'subscription_dispute',
      CustomerEvidencePackageType.registrationEvidence =>
        'registration_evidence',
      CustomerEvidencePackageType.pricingEvidence => 'pricing_evidence',
      CustomerEvidencePackageType.unknown => 'communication_evidence',
    };
  }

  String localizationKey() {
    return switch (this) {
      CustomerEvidencePackageType.communicationEvidence =>
        'customerCommunicationPackageTypeCommunicationEvidence',
      CustomerEvidencePackageType.subscriptionDispute =>
        'customerCommunicationPackageTypeSubscriptionDispute',
      CustomerEvidencePackageType.registrationEvidence =>
        'customerCommunicationPackageTypeRegistrationEvidence',
      CustomerEvidencePackageType.pricingEvidence =>
        'customerCommunicationPackageTypePricingEvidence',
      CustomerEvidencePackageType.unknown =>
        'customerCommunicationPackageTypeUnknown',
    };
  }
}

enum CustomerEvidencePackageStatus {
  generated,
  failed,
  unknown;

  static CustomerEvidencePackageStatus fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return unknown;
    return switch (raw.trim().toLowerCase()) {
      'generated' => generated,
      'failed' => failed,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      CustomerEvidencePackageStatus.generated =>
        'customerCommunicationPackageStatusGenerated',
      CustomerEvidencePackageStatus.failed =>
        'customerCommunicationPackageStatusFailed',
      CustomerEvidencePackageStatus.unknown =>
        'customerCommunicationPackageStatusUnknown',
    };
  }
}

class CustomerEvidencePackage {
  const CustomerEvidencePackage({
    required this.id,
    required this.threadId,
    this.companyId,
    required this.packageType,
    required this.status,
    this.generatedByUserId,
    this.generatedAt,
    this.dateFrom,
    this.dateTo,
    this.generationReason,
    this.summaryJson,
    this.fileUrl,
    this.fileHash,
    this.pdfRendererPending = false,
    this.pdfReady = false,
    this.sizeBytes,
    this.metadataOnly = true,
  });

  final String id;
  final String threadId;
  final String? companyId;
  final CustomerEvidencePackageType packageType;
  final CustomerEvidencePackageStatus status;
  final String? generatedByUserId;
  final DateTime? generatedAt;
  final DateTime? dateFrom;
  final DateTime? dateTo;
  final String? generationReason;
  final Map<String, dynamic>? summaryJson;
  final String? fileUrl;
  final String? fileHash;
  final bool pdfRendererPending;
  final bool pdfReady;
  final int? sizeBytes;
  final bool metadataOnly;

  bool get isPdfReady =>
      pdfReady ||
      (fileUrl != null &&
          !pdfRendererPending &&
          status == CustomerEvidencePackageStatus.generated);

  bool get isPdfFailed =>
      status == CustomerEvidencePackageStatus.failed && !isPdfReady;

  bool get isPdfPending => !isPdfReady && !isPdfFailed;

  bool get canDownload => isPdfReady && fileUrl != null && fileUrl!.isNotEmpty;

  factory CustomerEvidencePackage.fromJson(Map<String, dynamic> json) {
    final pdfReady = json['pdfReady'] == true;
    return CustomerEvidencePackage(
      id: json['id']?.toString() ?? '',
      threadId: json['threadId']?.toString() ?? '',
      companyId: json['companyId']?.toString(),
      packageType: CustomerEvidencePackageType.fromBackendValue(
        json['packageType']?.toString(),
      ),
      status: CustomerEvidencePackageStatus.fromBackendValue(
        json['status']?.toString(),
      ),
      generatedByUserId: json['generatedByUserId']?.toString(),
      generatedAt: _parseDate(json['generatedAt']),
      dateFrom: _parseDate(json['dateFrom']),
      dateTo: _parseDate(json['dateTo']),
      generationReason: json['generationReason']?.toString(),
      summaryJson: _asMap(json['summaryJson']),
      fileUrl: json['fileUrl']?.toString(),
      fileHash: json['fileHash']?.toString(),
      pdfRendererPending:
          json['pdfRendererPending'] == true ||
          (!pdfReady && json['fileUrl'] == null),
      pdfReady: pdfReady,
      sizeBytes: json['sizeBytes'] is num
          ? (json['sizeBytes'] as num).toInt()
          : int.tryParse(json['sizeBytes']?.toString() ?? ''),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  static Map<String, dynamic>? _asMap(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return null;
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}
