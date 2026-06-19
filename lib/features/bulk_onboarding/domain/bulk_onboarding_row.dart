import 'bulk_onboarding_row_status.dart';

class BulkOnboardingRowsPage {
  const BulkOnboardingRowsPage({
    required this.items,
    required this.total,
    this.metadataOnly = true,
  });

  final List<BulkOnboardingRow> items;
  final int total;
  final bool metadataOnly;

  factory BulkOnboardingRowsPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(BulkOnboardingRow.fromJson)
            .toList(growable: false)
        : const <BulkOnboardingRow>[];
    return BulkOnboardingRowsPage(
      items: items,
      total: _parseInt(json['total']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

class BulkOnboardingRow {
  const BulkOnboardingRow({
    required this.id,
    required this.jobId,
    required this.rowIndex,
    required this.type,
    required this.status,
    this.displayLabel,
    this.name,
    this.email,
    this.phone,
    this.country,
    this.role,
    this.vehiclePlate,
    this.trailerPlate,
    this.duplicateReason,
    this.validationErrors = const [],
    this.validationWarnings = const [],
    this.aiFlags = const [],
    this.processedEntityType,
    this.processedEntityId,
    this.metadataOnly = true,
  });

  final String id;
  final String jobId;
  final int rowIndex;
  final String type;
  final BulkOnboardingRowStatus status;
  final String? displayLabel;
  final String? name;
  final String? email;
  final String? phone;
  final String? country;
  final String? role;
  final String? vehiclePlate;
  final String? trailerPlate;
  final String? duplicateReason;
  final List<String> validationErrors;
  final List<String> validationWarnings;
  final List<String> aiFlags;
  final String? processedEntityType;
  final int? processedEntityId;
  final bool metadataOnly;

  factory BulkOnboardingRow.fromJson(Map<String, dynamic> json) {
    return BulkOnboardingRow(
      id: json['id']?.toString() ?? '',
      jobId: json['jobId']?.toString() ?? '',
      rowIndex: _parseInt(json['rowIndex']),
      type: json['type']?.toString() ?? 'unknown',
      status: BulkOnboardingRowStatus.fromBackendValue(json['status']?.toString()),
      displayLabel: json['displayLabel']?.toString(),
      name: json['name']?.toString(),
      email: json['email']?.toString(),
      phone: json['phone']?.toString(),
      country: json['country']?.toString(),
      role: json['role']?.toString(),
      vehiclePlate: json['vehiclePlate']?.toString(),
      trailerPlate: json['trailerPlate']?.toString(),
      duplicateReason: json['duplicateReason']?.toString(),
      validationErrors: _parseStringList(json['validationErrors']),
      validationWarnings: _parseStringList(json['validationWarnings']),
      aiFlags: _parseStringList(json['aiFlags']),
      processedEntityType: json['processedEntityType']?.toString(),
      processedEntityId: _parseNullableInt(json['processedEntityId']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  bool matchesFilter(BulkOnboardingRowListFilter filter) {
    return switch (filter) {
      BulkOnboardingRowListFilter.all => true,
      BulkOnboardingRowListFilter.valid =>
        status == BulkOnboardingRowStatus.valid,
      BulkOnboardingRowListFilter.invalid =>
        status == BulkOnboardingRowStatus.invalid,
      BulkOnboardingRowListFilter.warning =>
        status == BulkOnboardingRowStatus.warning,
      BulkOnboardingRowListFilter.duplicate =>
        status == BulkOnboardingRowStatus.duplicate,
      BulkOnboardingRowListFilter.processed =>
        status == BulkOnboardingRowStatus.processed,
      BulkOnboardingRowListFilter.failed =>
        status == BulkOnboardingRowStatus.failed,
    };
  }

  bool matchesSearch(String query) {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return true;
    final haystack = [
      displayLabel,
      name,
      email,
      phone,
      vehiclePlate,
      trailerPlate,
      duplicateReason,
    ].whereType<String>().join(' ').toLowerCase();
    return haystack.contains(term);
  }
}

enum BulkOnboardingRowListFilter {
  all,
  valid,
  invalid,
  warning,
  duplicate,
  processed,
  failed,
}

List<String> _parseStringList(Object? raw) {
  if (raw is List) {
    return raw.map((item) => item.toString()).toList(growable: false);
  }
  return const [];
}

int _parseInt(Object? raw) {
  if (raw is int) return raw;
  return int.tryParse(raw?.toString() ?? '') ?? 0;
}

int? _parseNullableInt(Object? raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  return int.tryParse(raw.toString());
}
