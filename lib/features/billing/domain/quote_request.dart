import 'quote_request_status.dart';

class QuoteRequest {
  const QuoteRequest({
    required this.id,
    this.companyId,
    required this.companyName,
    required this.contactEmail,
    required this.status,
    this.fleetSize,
    this.officeUsers,
    this.driverUsers,
    this.createdAt,
    this.metadataOnly = true,
  });

  final String id;
  final String? companyId;
  final String companyName;
  final String contactEmail;
  final QuoteRequestStatus status;
  final int? fleetSize;
  final int? officeUsers;
  final int? driverUsers;
  final DateTime? createdAt;
  final bool metadataOnly;

  factory QuoteRequest.fromJson(Map<String, dynamic> json) {
    return QuoteRequest(
      id: json['id']?.toString() ?? '',
      companyId: json['companyId']?.toString(),
      companyName: json['companyName']?.toString() ?? '',
      contactEmail: json['contactEmail']?.toString() ?? '',
      status: QuoteRequestStatus.fromBackendValue(json['status']?.toString()),
      fleetSize: _parseNullableInt(json['fleetSize']),
      officeUsers: _parseNullableInt(json['officeUsers']),
      driverUsers: _parseNullableInt(json['driverUsers'] ?? json['driverApps']),
      createdAt: _parseDate(json['createdAt']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  bool matchesSearch(String query) {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return true;
    final haystack = [
      companyName,
      contactEmail,
      companyId,
      id,
    ].whereType<String>().join(' ').toLowerCase();
    return haystack.contains(term);
  }

  bool matchesFilter(QuoteRequestListFilter filter) {
    return switch (filter) {
      QuoteRequestListFilter.all => true,
      QuoteRequestListFilter.submitted => status == QuoteRequestStatus.submitted,
      QuoteRequestListFilter.underReview => status == QuoteRequestStatus.underReview,
      QuoteRequestListFilter.quoted => status == QuoteRequestStatus.quoted,
      QuoteRequestListFilter.accepted => status == QuoteRequestStatus.accepted,
      QuoteRequestListFilter.rejected => status == QuoteRequestStatus.rejected,
    };
  }
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString());
}

int? _parseNullableInt(Object? raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  return int.tryParse(raw.toString());
}
