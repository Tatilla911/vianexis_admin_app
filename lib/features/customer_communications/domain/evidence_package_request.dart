import 'customer_evidence_package.dart';

class EvidencePackageRequest {
  const EvidencePackageRequest({
    required this.packageType,
    required this.reason,
    this.dateFrom,
    this.dateTo,
  });

  final CustomerEvidencePackageType packageType;
  final String reason;
  final String? dateFrom;
  final String? dateTo;

  Map<String, dynamic> toJson() {
    return {
      'packageType': packageType.backendValue(),
      'reason': reason.trim(),
      if (dateFrom != null && dateFrom!.trim().isNotEmpty) 'dateFrom': dateFrom,
      if (dateTo != null && dateTo!.trim().isNotEmpty) 'dateTo': dateTo,
    };
  }
}

class MarkCustomerDisputeRequest {
  const MarkCustomerDisputeRequest({required this.reason});

  final String reason;

  Map<String, dynamic> toJson() => {'reason': reason.trim()};
}
