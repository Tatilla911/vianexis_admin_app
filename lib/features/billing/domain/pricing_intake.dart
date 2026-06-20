import 'pricing_intake_status.dart';

class PricingIntake {
  const PricingIntake({
    required this.id,
    required this.companyId,
    this.companyName,
    this.contactName,
    this.contactEmail,
    this.country,
    this.fleetSize,
    this.officeUsers,
    this.driverApps,
    this.requestedModules = const [],
    this.requestedAiFeatures = const [],
    required this.status,
    this.riskLevel,
    this.needsHumanReview = false,
    this.createdAt,
    this.updatedAt,
    this.metadataOnly = true,
  });

  final String id;
  final String companyId;
  final String? companyName;
  final String? contactName;
  final String? contactEmail;
  final String? country;
  final int? fleetSize;
  final int? officeUsers;
  final int? driverApps;
  final List<String> requestedModules;
  final List<String> requestedAiFeatures;
  final PricingIntakeStatus status;
  final String? riskLevel;
  final bool needsHumanReview;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool metadataOnly;

  factory PricingIntake.fromJson(Map<String, dynamic> json) {
    final payload = json['intakePayload'];
    final payloadMap = payload is Map<String, dynamic> ? payload : null;

    final modules = _stringList(json['requestedModules']);
    final aiFeatures = _stringList(json['requestedAiFeatures']);

    return PricingIntake(
      id: json['id']?.toString() ?? '',
      companyId: json['companyId']?.toString() ?? '',
      companyName: json['companyName']?.toString() ??
          payloadMap?['companyDisplayName']?.toString(),
      contactName: json['contactName']?.toString(),
      contactEmail: json['contactEmail']?.toString(),
      country: json['country']?.toString() ?? payloadMap?['country']?.toString(),
      fleetSize: _parseNullableInt(
        json['fleetSize'] ?? payloadMap?['estimatedOwnedTrucks'],
      ),
      officeUsers: _parseNullableInt(
        json['officeUsers'] ?? payloadMap?['estimatedOfficeUsers'],
      ),
      driverApps: _parseNullableInt(
        json['driverApps'] ?? payloadMap?['estimatedDrivers'],
      ),
      requestedModules: modules.isNotEmpty
          ? modules
          : _modulesFromPayload(payloadMap),
      requestedAiFeatures: aiFeatures.isNotEmpty
          ? aiFeatures
          : _aiFeaturesFromPayload(payloadMap),
      status: PricingIntakeStatus.fromBackendValue(json['status']?.toString()),
      riskLevel: json['riskLevel']?.toString(),
      needsHumanReview: json['needsHumanReview'] == true,
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  bool matchesSearch(String query) {
    final term = query.trim().toLowerCase();
    if (term.isEmpty) return true;
    final haystack = [
      companyName,
      companyId,
      contactEmail,
      id,
    ].whereType<String>().join(' ').toLowerCase();
    return haystack.contains(term);
  }

  bool matchesFilter(PricingIntakeListFilter filter) {
    return switch (filter) {
      PricingIntakeListFilter.all => true,
      PricingIntakeListFilter.newIntake => status == PricingIntakeStatus.newIntake,
      PricingIntakeListFilter.reviewing => status == PricingIntakeStatus.reviewing,
      PricingIntakeListFilter.quoted => status == PricingIntakeStatus.quoted,
      PricingIntakeListFilter.accepted => status == PricingIntakeStatus.accepted,
      PricingIntakeListFilter.rejected => status == PricingIntakeStatus.rejected,
    };
  }
}

class PricingIntakesPage {
  const PricingIntakesPage({
    required this.items,
    required this.total,
    this.metadataOnly = true,
  });

  final List<PricingIntake> items;
  final int total;
  final bool metadataOnly;

  factory PricingIntakesPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(PricingIntake.fromJson)
            .toList(growable: false)
        : const <PricingIntake>[];
    return PricingIntakesPage(
      items: items,
      total: _parseInt(json['total']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

List<String> _stringList(Object? raw) {
  if (raw is! List) return const [];
  return raw.map((item) => item.toString()).toList(growable: false);
}

List<String> _modulesFromPayload(Map<String, dynamic>? payload) {
  if (payload == null) return const [];
  return [
    if (payload['needsWorkshopModule'] == true) 'workshop',
    if (payload['needsFleetMap'] == true) 'fleet_map',
    if (payload['needsExternalJobIntake'] == true) 'external_jobs',
  ];
}

List<String> _aiFeaturesFromPayload(Map<String, dynamic>? payload) {
  if (payload == null) return const [];
  return [
    if (payload['needsAiTranslation'] == true) 'ai_translation',
    if (payload['needsAiExtraction'] == true) 'ai_extraction',
  ];
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString());
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
