import 'pricing_quote_adjustment_type.dart';
import 'pricing_quote_review_flag.dart';
import 'pricing_quote_status.dart';

class PricingQuoteListItem {
  const PricingQuoteListItem({
    required this.id,
    required this.publicReference,
    this.companyId,
    this.publicIntakeId,
    required this.status,
    required this.statusRaw,
    required this.questionnaireVersion,
    required this.pricingConfigVersion,
    this.recurringTotalNet,
    this.oneTimeTotalNet,
    this.confidence,
    this.reviewFlags = const [],
    required this.currentRevisionNumber,
    this.createdAt,
  });

  final int id;
  final String publicReference;
  final int? companyId;
  final int? publicIntakeId;
  final PricingQuoteStatus status;
  final String statusRaw;
  final String questionnaireVersion;
  final String pricingConfigVersion;
  final String? recurringTotalNet;
  final String? oneTimeTotalNet;
  final String? confidence;
  final List<String> reviewFlags;
  final int currentRevisionNumber;
  final DateTime? createdAt;

  bool get hasProviderValidationPending =>
      reviewFlags.contains(
        PricingQuoteReviewFlag.providerValidationPending.backendValue,
      );

  bool get canApprove =>
      PricingQuoteReviewFlag.canApproveWithFlags(reviewFlags);

  List<String> get importantReviewFlags => reviewFlags
      .where((flag) {
        final parsed = PricingQuoteReviewFlag.fromBackendValue(flag);
        return parsed?.isImportant ?? true;
      })
      .toList(growable: false);

  factory PricingQuoteListItem.fromJson(Map<String, dynamic> json) {
    return PricingQuoteListItem(
      id: _parseInt(json['id']) ?? 0,
      publicReference: json['publicReference']?.toString() ?? '',
      companyId: _parseInt(json['companyId']),
      publicIntakeId: _parseInt(json['publicIntakeId']),
      status: PricingQuoteStatus.fromBackendValue(json['status']?.toString()),
      statusRaw: json['status']?.toString() ?? '',
      questionnaireVersion: json['questionnaireVersion']?.toString() ?? '',
      pricingConfigVersion: json['pricingConfigVersion']?.toString() ?? '',
      recurringTotalNet: json['recurringTotalNet']?.toString(),
      oneTimeTotalNet: json['oneTimeTotalNet']?.toString(),
      confidence: json['confidence']?.toString(),
      reviewFlags: _parseStringList(json['reviewFlags']),
      currentRevisionNumber: _parseInt(json['currentRevisionNumber']) ?? 0,
      createdAt: _parseDate(json['createdAt']),
    );
  }
}

class PricingQuoteRevision {
  const PricingQuoteRevision({
    required this.id,
    required this.revisionNumber,
    required this.pricingConfigVersion,
    required this.questionnaireVersion,
    this.calculatedAt,
    this.reason,
    this.calculation = const {},
    this.reviewFlags = const [],
  });

  final int id;
  final int revisionNumber;
  final String pricingConfigVersion;
  final String questionnaireVersion;
  final DateTime? calculatedAt;
  final String? reason;
  final Map<String, dynamic> calculation;
  final List<String> reviewFlags;

  factory PricingQuoteRevision.fromJson(Map<String, dynamic> json) {
    return PricingQuoteRevision(
      id: _parseInt(json['id']) ?? 0,
      revisionNumber: _parseInt(json['revisionNumber']) ?? 0,
      pricingConfigVersion: json['pricingConfigVersion']?.toString() ?? '',
      questionnaireVersion: json['questionnaireVersion']?.toString() ?? '',
      calculatedAt: _parseDate(json['calculatedAt']),
      reason: json['reason']?.toString(),
      calculation: _parseMap(json['calculationResultJson']),
      reviewFlags: _parseStringList(json['reviewFlags']),
    );
  }
}

class PricingQuoteAdjustment {
  const PricingQuoteAdjustment({
    required this.id,
    required this.type,
    required this.typeRaw,
    this.percent,
    this.amountNet,
    required this.reason,
    this.approvalRequired = false,
    this.totalsSnapshot = const {},
    this.createdAt,
  });

  final int id;
  final PricingQuoteAdjustmentType type;
  final String typeRaw;
  final double? percent;
  final double? amountNet;
  final String reason;
  final bool approvalRequired;
  final Map<String, dynamic> totalsSnapshot;
  final DateTime? createdAt;

  factory PricingQuoteAdjustment.fromJson(Map<String, dynamic> json) {
    return PricingQuoteAdjustment(
      id: _parseInt(json['id']) ?? 0,
      type: PricingQuoteAdjustmentType.fromBackendValue(
        json['type']?.toString(),
      ),
      typeRaw: json['type']?.toString() ?? '',
      percent: _parseDouble(json['percent']),
      amountNet: _parseDouble(json['amountNet']),
      reason: json['reason']?.toString() ?? '',
      approvalRequired: json['approvalRequired'] == true,
      totalsSnapshot: _parseMap(json['totalsSnapshotJson']),
      createdAt: _parseDate(json['createdAt']),
    );
  }
}

class PricingQuoteDetail extends PricingQuoteListItem {
  const PricingQuoteDetail({
    required super.id,
    required super.publicReference,
    super.companyId,
    super.publicIntakeId,
    required super.status,
    required super.statusRaw,
    required super.questionnaireVersion,
    required super.pricingConfigVersion,
    super.recurringTotalNet,
    super.oneTimeTotalNet,
    super.confidence,
    super.reviewFlags,
    required super.currentRevisionNumber,
    super.createdAt,
    this.internalNotes,
    this.revisions = const [],
    this.adjustments = const [],
  });

  final String? internalNotes;
  final List<PricingQuoteRevision> revisions;
  final List<PricingQuoteAdjustment> adjustments;

  PricingQuoteRevision? get currentRevision {
    if (revisions.isEmpty) return null;
    for (final revision in revisions) {
      if (revision.revisionNumber == currentRevisionNumber) return revision;
    }
    return revisions.last;
  }

  Map<String, dynamic> get currentCalculation =>
      currentRevision?.calculation ?? const {};

  factory PricingQuoteDetail.fromJson(Map<String, dynamic> json) {
    final revisionsRaw = json['revisions'];
    final adjustmentsRaw = json['adjustments'];
    return PricingQuoteDetail(
      id: _parseInt(json['id']) ?? 0,
      publicReference: json['publicReference']?.toString() ?? '',
      companyId: _parseInt(json['companyId']),
      publicIntakeId: _parseInt(json['publicIntakeId']),
      status: PricingQuoteStatus.fromBackendValue(json['status']?.toString()),
      statusRaw: json['status']?.toString() ?? '',
      questionnaireVersion: json['questionnaireVersion']?.toString() ?? '',
      pricingConfigVersion: json['pricingConfigVersion']?.toString() ?? '',
      recurringTotalNet: json['recurringTotalNet']?.toString(),
      oneTimeTotalNet: json['oneTimeTotalNet']?.toString(),
      confidence: json['confidence']?.toString(),
      reviewFlags: _parseStringList(json['reviewFlags']),
      currentRevisionNumber: _parseInt(json['currentRevisionNumber']) ?? 0,
      createdAt: _parseDate(json['createdAt']),
      internalNotes: json['internalNotes']?.toString(),
      revisions: revisionsRaw is List
          ? revisionsRaw
                .whereType<Map>()
                .map(
                  (item) => PricingQuoteRevision.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false)
          : const [],
      adjustments: adjustmentsRaw is List
          ? adjustmentsRaw
                .whereType<Map>()
                .map(
                  (item) => PricingQuoteAdjustment.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false)
          : const [],
    );
  }
}

class PricingQuoteAdjustmentRequest {
  const PricingQuoteAdjustmentRequest({
    required this.type,
    this.percent,
    this.amountNet,
    required this.reason,
  });

  final PricingQuoteAdjustmentType type;
  final double? percent;
  final double? amountNet;
  final String reason;

  Map<String, dynamic> toJson() {
    return {
      'type': type.backendValue,
      if (percent != null) 'percent': percent,
      if (amountNet != null) 'amountNet': amountNet,
      'reason': reason,
    };
  }
}

int? _parseInt(Object? raw) {
  if (raw == null) return null;
  if (raw is int) return raw;
  return int.tryParse(raw.toString());
}

double? _parseDouble(Object? raw) {
  if (raw == null) return null;
  if (raw is num) return raw.toDouble();
  return double.tryParse(raw.toString());
}

DateTime? _parseDate(Object? raw) {
  if (raw == null) return null;
  return DateTime.tryParse(raw.toString());
}

List<String> _parseStringList(Object? raw) {
  if (raw is List) {
    return raw.map((item) => item.toString()).toList(growable: false);
  }
  return const [];
}

Map<String, dynamic> _parseMap(Object? raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return const {};
}
