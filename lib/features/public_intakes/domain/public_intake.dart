import 'public_intake_status.dart';
import 'public_intake_type.dart';

class PublicIntake {
  const PublicIntake({
    required this.id,
    required this.type,
    required this.sourceLocale,
    required this.preferredLanguage,
    required this.messageOriginalLanguage,
    required this.status,
    this.customerName,
    this.customerEmailDomain,
    this.companyName,
    this.country,
    this.messageOriginalText,
    this.detectedLanguage,
    this.fleetSize,
    this.officeUsers,
    this.driverApps,
    this.requestedModules = const [],
    this.requestedAiFeatures = const [],
    this.linkedCustomerCommunicationThreadId,
    this.linkedPricingIntakeId,
    this.linkedQuoteRequestId,
    this.consentMarketing,
    this.consentTerms,
    this.consentPrivacy,
    this.consentVersion,
    this.translationPending = false,
    this.translationProviderStatus,
    this.createdAt,
    this.updatedAt,
    this.metadataOnly = true,
  });

  final String id;
  final PublicIntakeType type;
  final String sourceLocale;
  final String preferredLanguage;
  final String messageOriginalLanguage;
  final PublicIntakeStatus status;
  final String? customerName;
  final String? customerEmailDomain;
  final String? companyName;
  final String? country;
  final String? messageOriginalText;
  final String? detectedLanguage;
  final int? fleetSize;
  final int? officeUsers;
  final int? driverApps;
  final List<String> requestedModules;
  final List<String> requestedAiFeatures;
  final String? linkedCustomerCommunicationThreadId;
  final String? linkedPricingIntakeId;
  final String? linkedQuoteRequestId;
  final bool? consentMarketing;
  final bool? consentTerms;
  final bool? consentPrivacy;
  final String? consentVersion;
  final bool translationPending;
  final String? translationProviderStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final bool metadataOnly;

  bool matchesSearch(String rawQuery) {
    final query = rawQuery.trim().toLowerCase();
    if (query.isEmpty) return true;
    return (customerName ?? '').toLowerCase().contains(query) ||
        (companyName ?? '').toLowerCase().contains(query) ||
        (customerEmailDomain ?? '').toLowerCase().contains(query) ||
        (country ?? '').toLowerCase().contains(query) ||
        preferredLanguage.toLowerCase().contains(query);
  }

  static DateTime? parseDate(Object? raw) {
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString());
  }

  factory PublicIntake.fromJson(Map<String, dynamic> json) {
    final modules = json['requestedModules'];
    final aiFeatures = json['requestedAiFeatures'];
    return PublicIntake(
      id: json['id']?.toString() ?? '',
      type: PublicIntakeType.fromBackendValue(json['intakeType']?.toString()),
      sourceLocale: json['sourceLocale']?.toString() ?? '',
      preferredLanguage: json['preferredLanguage']?.toString() ?? '',
      messageOriginalLanguage:
          json['messageOriginalLanguage']?.toString() ?? '',
      status: PublicIntakeStatus.fromBackendValue(json['status']?.toString()),
      customerName: json['customerName']?.toString(),
      customerEmailDomain: json['customerEmailDomain']?.toString(),
      companyName: json['companyName']?.toString(),
      country: json['country']?.toString(),
      messageOriginalText: json['messageOriginalText']?.toString(),
      detectedLanguage: json['detectedLanguage']?.toString(),
      fleetSize: _parseInt(json['fleetSize']),
      officeUsers: _parseInt(json['officeUsers']),
      driverApps: _parseInt(json['driverApps']),
      requestedModules: modules is List
          ? modules.map((e) => e.toString()).toList(growable: false)
          : const [],
      requestedAiFeatures: aiFeatures is List
          ? aiFeatures.map((e) => e.toString()).toList(growable: false)
          : const [],
      linkedCustomerCommunicationThreadId:
          json['linkedCustomerCommunicationThreadId']?.toString(),
      linkedPricingIntakeId: json['linkedPricingIntakeId']?.toString(),
      linkedQuoteRequestId: json['linkedQuoteRequestId']?.toString(),
      consentMarketing: json['consentMarketing'] as bool?,
      consentTerms: json['consentTerms'] as bool?,
      consentPrivacy: json['consentPrivacy'] as bool?,
      consentVersion: json['consentVersion']?.toString(),
      translationPending: json['translationPending'] == true,
      translationProviderStatus: json['translationProviderStatus']?.toString(),
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  factory PublicIntake.fromDetailResponseJson(Map<String, dynamic> json) {
    final intake = json['intake'];
    if (intake is Map<String, dynamic>) {
      return PublicIntake.fromJson(intake);
    }
    return PublicIntake.fromJson(json);
  }
}

class PublicIntakesPage {
  const PublicIntakesPage({
    required this.items,
    required this.total,
    this.metadataOnly = true,
  });

  final List<PublicIntake> items;
  final int total;
  final bool metadataOnly;

  factory PublicIntakesPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(PublicIntake.fromJson)
            .toList(growable: false)
        : const <PublicIntake>[];
    return PublicIntakesPage(
      items: items,
      total: _parseInt(json['total']) ?? items.length,
      metadataOnly: json['metadataOnly'] != false,
    );
  }
}

int? _parseInt(Object? raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  return int.tryParse(raw.toString());
}
