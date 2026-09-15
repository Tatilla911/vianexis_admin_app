enum RegistrationCommercialPricingStatus {
  notCreated('NOT_CREATED'),
  needsInput('NEEDS_INPUT'),
  suggestionAvailable('SUGGESTION_AVAILABLE'),
  quoteLinked('QUOTE_LINKED'),
  reviewRequired('REVIEW_REQUIRED'),
  approved('APPROVED'),
  sent('SENT'),
  unknown('UNKNOWN');

  const RegistrationCommercialPricingStatus(this.backendValue);
  final String backendValue;

  static RegistrationCommercialPricingStatus fromBackend(String? raw) {
    final value = raw?.trim().toUpperCase();
    for (final item in RegistrationCommercialPricingStatus.values) {
      if (item.backendValue == value) return item;
    }
    return RegistrationCommercialPricingStatus.unknown;
  }

  String localizationKey() {
    return switch (this) {
      RegistrationCommercialPricingStatus.notCreated =>
        'registrationCommercialNotCreated',
      RegistrationCommercialPricingStatus.needsInput =>
        'registrationCommercialNeedsInput',
      RegistrationCommercialPricingStatus.suggestionAvailable =>
        'registrationCommercialSuggestionAvailable',
      RegistrationCommercialPricingStatus.quoteLinked =>
        'registrationCommercialQuoteLinked',
      RegistrationCommercialPricingStatus.reviewRequired =>
        'registrationCommercialReviewRequired',
      RegistrationCommercialPricingStatus.approved =>
        'registrationCommercialApproved',
      RegistrationCommercialPricingStatus.sent =>
        'registrationCommercialSent',
      RegistrationCommercialPricingStatus.unknown =>
        'registrationCommercialUnknown',
    };
  }
}

class RegistrationAssessmentSummary {
  const RegistrationAssessmentSummary({
    required this.id,
    required this.status,
    required this.version,
    required this.submittedAt,
    required this.approvalReady,
    required this.blockingReason,
    required this.sections,
  });

  final String? id;
  final String? status;
  final int? version;
  final DateTime? submittedAt;
  final bool approvalReady;
  final String? blockingReason;
  final List<String> sections;

  factory RegistrationAssessmentSummary.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const RegistrationAssessmentSummary(
        id: null,
        status: null,
        version: null,
        submittedAt: null,
        approvalReady: false,
        blockingReason: 'APPLICATION_DETAILED_INTAKE_REQUIRED',
        sections: [],
      );
    }
    return RegistrationAssessmentSummary(
      id: json['id']?.toString(),
      status: json['status']?.toString(),
      version: json['version'] is num ? (json['version'] as num).toInt() : null,
      submittedAt: DateTime.tryParse(json['submittedAt']?.toString() ?? ''),
      approvalReady: json['approvalReady'] == true,
      blockingReason: json['blockingReason']?.toString(),
      sections: (json['sections'] is List)
          ? (json['sections'] as List)
                .map((e) => e.toString())
                .toList(growable: false)
          : const [],
    );
  }
}

class RegistrationCommercialReview {
  const RegistrationCommercialReview({
    required this.pricingStatus,
    required this.assessmentId,
    required this.quoteId,
    required this.pricingIntakeId,
    required this.suggestion,
    required this.missingPricingFields,
    required this.engineQuoteLinked,
    required this.noteKey,
  });

  final RegistrationCommercialPricingStatus pricingStatus;
  final String? assessmentId;
  final String? quoteId;
  final String? pricingIntakeId;
  final Map<String, dynamic>? suggestion;
  final List<String> missingPricingFields;
  final bool engineQuoteLinked;
  final String? noteKey;

  factory RegistrationCommercialReview.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const RegistrationCommercialReview(
        pricingStatus: RegistrationCommercialPricingStatus.notCreated,
        assessmentId: null,
        quoteId: null,
        pricingIntakeId: null,
        suggestion: null,
        missingPricingFields: [],
        engineQuoteLinked: false,
        noteKey: null,
      );
    }
    final suggestionRaw = json['suggestion'];
    return RegistrationCommercialReview(
      pricingStatus: RegistrationCommercialPricingStatus.fromBackend(
        json['pricingStatus']?.toString(),
      ),
      assessmentId: json['assessmentId']?.toString(),
      quoteId: json['quoteId']?.toString(),
      pricingIntakeId: json['pricingIntakeId']?.toString(),
      suggestion: suggestionRaw is Map
          ? Map<String, dynamic>.from(suggestionRaw)
          : null,
      missingPricingFields: (json['missingPricingFields'] is List)
          ? (json['missingPricingFields'] as List)
                .map((e) => e.toString())
                .toList(growable: false)
          : const [],
      engineQuoteLinked: json['engineQuoteLinked'] == true,
      noteKey: json['noteKey']?.toString(),
    );
  }

  String? get monthlyNet {
    final monthly = suggestion?['monthly'];
    if (monthly is Map && monthly['net'] != null) {
      return monthly['net'].toString();
    }
    return null;
  }

  String? get setupNet {
    final oneTime = suggestion?['oneTime'];
    if (oneTime is Map && oneTime['net'] != null) {
      return oneTime['net'].toString();
    }
    return null;
  }

  String? get suggestedPackage => suggestion?['suggestedPackage']?.toString();

  List<String> get modules {
    final inputs = suggestion?['inputs'];
    if (inputs is Map && inputs['modules'] is List) {
      return (inputs['modules'] as List).map((e) => e.toString()).toList();
    }
    return const [];
  }
}

class RegistrationRiskResolution {
  const RegistrationRiskResolution({
    required this.status,
    required this.reasonCode,
    required this.reasonMessageKey,
  });

  final String status;
  final String? reasonCode;
  final String? reasonMessageKey;

  bool get isUnresolved => status.toUpperCase() == 'UNRESOLVED';

  factory RegistrationRiskResolution.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return const RegistrationRiskResolution(
        status: 'UNRESOLVED',
        reasonCode: 'AI_REVIEW_NOT_AVAILABLE',
        reasonMessageKey: 'registration.risk.notEvaluable',
      );
    }
    return RegistrationRiskResolution(
      status: json['status']?.toString() ?? 'UNRESOLVED',
      reasonCode: json['reasonCode']?.toString(),
      reasonMessageKey: json['reasonMessageKey']?.toString(),
    );
  }
}

class RegistrationApprovalBlocker {
  const RegistrationApprovalBlocker({
    required this.code,
    required this.messageKey,
  });

  final String code;
  final String messageKey;

  factory RegistrationApprovalBlocker.fromJson(Map<String, dynamic> json) {
    return RegistrationApprovalBlocker(
      code: json['code']?.toString() ?? 'UNKNOWN',
      messageKey:
          json['messageKey']?.toString() ?? 'registrationDecisionError',
    );
  }
}

class RegistrationApprovalEligibility {
  const RegistrationApprovalEligibility({
    required this.canApprove,
    required this.blockers,
    required this.existingCompanyId,
    required this.quoteRequiredForRegistrationApproval,
  });

  final bool canApprove;
  final List<RegistrationApprovalBlocker> blockers;
  final String? existingCompanyId;
  final bool quoteRequiredForRegistrationApproval;

  factory RegistrationApprovalEligibility.fromJson(
    Map<String, dynamic>? json,
  ) {
    if (json == null) {
      return const RegistrationApprovalEligibility(
        canApprove: true,
        blockers: [],
        existingCompanyId: null,
        quoteRequiredForRegistrationApproval: false,
      );
    }
    final rawBlockers = json['blockers'];
    return RegistrationApprovalEligibility(
      canApprove: json['canApprove'] != false,
      blockers: rawBlockers is List
          ? rawBlockers
                .whereType<Map>()
                .map(
                  (item) => RegistrationApprovalBlocker.fromJson(
                    Map<String, dynamic>.from(item),
                  ),
                )
                .toList(growable: false)
          : const [],
      existingCompanyId: json['existingCompanyId']?.toString(),
      quoteRequiredForRegistrationApproval:
          json['quoteRequiredForRegistrationApproval'] == true,
    );
  }
}
