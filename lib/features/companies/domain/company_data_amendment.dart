class CompanyRegistrationSnapshot {
  const CompanyRegistrationSnapshot({
    required this.companyId,
    this.originalSubmitted,
    this.currentValid,
    this.differences = const [],
    this.registration,
    this.dataVersion = 1,
  });

  final String companyId;
  final Map<String, dynamic>? originalSubmitted;
  final Map<String, dynamic>? currentValid;
  final List<CompanyFieldDifference> differences;
  final CompanyRegistrationMeta? registration;
  final int dataVersion;

  factory CompanyRegistrationSnapshot.fromJson(Map<String, dynamic> json) {
    final diffs = (json['differences'] as List?)
            ?.whereType<Map>()
            .map(
              (e) => CompanyFieldDifference(
                field: e['field']?.toString() ?? '',
                original: e['original'],
                current: e['current'],
              ),
            )
            .toList(growable: false) ??
        const [];
    return CompanyRegistrationSnapshot(
      companyId: json['companyId']?.toString() ?? '',
      originalSubmitted: _asMap(json['originalSubmitted']),
      currentValid: _asMap(json['currentValid']),
      differences: diffs,
      registration: json['registration'] is Map
          ? CompanyRegistrationMeta.fromJson(
              Map<String, dynamic>.from(json['registration'] as Map),
            )
          : null,
      dataVersion: _asInt(json['dataVersion'], 1),
    );
  }
}

class CompanyFieldDifference {
  const CompanyFieldDifference({
    required this.field,
    this.original,
    this.current,
  });

  final String field;
  final Object? original;
  final Object? current;
}

class CompanyRegistrationMeta {
  const CompanyRegistrationMeta({
    required this.id,
    this.status,
    this.createdAt,
    this.reviewedAt,
    this.reviewedByUserId,
    this.reviewNotes,
    this.contactName,
    this.contactEmail,
    this.contactPhone,
    this.requestedAdminName,
    this.requestedAdminEmail,
    this.applicantNotes,
    this.preferredLanguage,
    this.sourceLocale,
    this.approvedCompanyId,
    this.readOnly = true,
  });

  final String id;
  final String? status;
  final DateTime? createdAt;
  final DateTime? reviewedAt;
  final int? reviewedByUserId;
  final String? reviewNotes;
  final String? contactName;
  final String? contactEmail;
  final String? contactPhone;
  final String? requestedAdminName;
  final String? requestedAdminEmail;
  final String? applicantNotes;
  final String? preferredLanguage;
  final String? sourceLocale;
  final String? approvedCompanyId;
  final bool readOnly;

  factory CompanyRegistrationMeta.fromJson(Map<String, dynamic> json) {
    return CompanyRegistrationMeta(
      id: json['id']?.toString() ?? '',
      status: json['status']?.toString(),
      createdAt: _parseDate(json['createdAt']),
      reviewedAt: _parseDate(json['reviewedAt']),
      reviewedByUserId: json['reviewedByUserId'] is int
          ? json['reviewedByUserId'] as int
          : int.tryParse('${json['reviewedByUserId'] ?? ''}'),
      reviewNotes: json['reviewNotes']?.toString(),
      contactName: json['contactName']?.toString(),
      contactEmail: json['contactEmail']?.toString(),
      contactPhone: json['contactPhone']?.toString(),
      requestedAdminName: json['requestedAdminName']?.toString(),
      requestedAdminEmail: json['requestedAdminEmail']?.toString(),
      applicantNotes: json['applicantNotes']?.toString(),
      preferredLanguage: json['preferredLanguage']?.toString(),
      sourceLocale: json['sourceLocale']?.toString(),
      approvedCompanyId: json['approvedCompanyId']?.toString(),
      readOnly: json['readOnly'] != false,
    );
  }
}

class CompanyDataAmendment {
  const CompanyDataAmendment({
    required this.id,
    required this.companyId,
    required this.fieldPath,
    required this.fieldLabelKey,
    this.oldValueJson,
    this.newValueJson,
    required this.reason,
    required this.requestedByUserId,
    required this.requestedByRole,
    required this.requestedAt,
    required this.authorizationSource,
    required this.authorizedByName,
    required this.authorizationMethod,
    this.authorizationReference,
    required this.internalComment,
    this.customerVisibleComment,
    required this.status,
    this.approvedByUserId,
    this.approvedAt,
    this.rejectedByUserId,
    this.rejectedAt,
    this.rejectionReason,
    this.appliedByUserId,
    this.appliedAt,
    this.revertedAt,
    this.revertedByUserId,
    required this.requestId,
    this.expectedDataVersion,
    this.revertsAmendmentId,
  });

  final String id;
  final String companyId;
  final String fieldPath;
  final String fieldLabelKey;
  final Object? oldValueJson;
  final Object? newValueJson;
  final String reason;
  final int requestedByUserId;
  final String requestedByRole;
  final DateTime requestedAt;
  final String authorizationSource;
  final String authorizedByName;
  final String authorizationMethod;
  final String? authorizationReference;
  final String internalComment;
  final String? customerVisibleComment;
  final String status;
  final int? approvedByUserId;
  final DateTime? approvedAt;
  final int? rejectedByUserId;
  final DateTime? rejectedAt;
  final String? rejectionReason;
  final int? appliedByUserId;
  final DateTime? appliedAt;
  final DateTime? revertedAt;
  final int? revertedByUserId;
  final String requestId;
  final int? expectedDataVersion;
  final int? revertsAmendmentId;

  factory CompanyDataAmendment.fromJson(Map<String, dynamic> json) {
    return CompanyDataAmendment(
      id: json['id']?.toString() ?? '',
      companyId: json['companyId']?.toString() ?? '',
      fieldPath: json['fieldPath']?.toString() ?? '',
      fieldLabelKey: json['fieldLabelKey']?.toString() ?? '',
      oldValueJson: json['oldValueJson'],
      newValueJson: json['newValueJson'],
      reason: json['reason']?.toString() ?? '',
      requestedByUserId: _asInt(json['requestedByUserId'], 0),
      requestedByRole: json['requestedByRole']?.toString() ?? '',
      requestedAt: _parseDate(json['requestedAt']) ?? DateTime.fromMillisecondsSinceEpoch(0),
      authorizationSource: json['authorizationSource']?.toString() ?? '',
      authorizedByName: json['authorizedByName']?.toString() ?? '',
      authorizationMethod: json['authorizationMethod']?.toString() ?? '',
      authorizationReference: json['authorizationReference']?.toString(),
      internalComment: json['internalComment']?.toString() ?? '',
      customerVisibleComment: json['customerVisibleComment']?.toString(),
      status: json['status']?.toString() ?? '',
      approvedByUserId: json['approvedByUserId'] is int
          ? json['approvedByUserId'] as int
          : int.tryParse('${json['approvedByUserId'] ?? ''}'),
      approvedAt: _parseDate(json['approvedAt']),
      rejectedByUserId: json['rejectedByUserId'] is int
          ? json['rejectedByUserId'] as int
          : int.tryParse('${json['rejectedByUserId'] ?? ''}'),
      rejectedAt: _parseDate(json['rejectedAt']),
      rejectionReason: json['rejectionReason']?.toString(),
      appliedByUserId: json['appliedByUserId'] is int
          ? json['appliedByUserId'] as int
          : int.tryParse('${json['appliedByUserId'] ?? ''}'),
      appliedAt: _parseDate(json['appliedAt']),
      revertedAt: _parseDate(json['revertedAt']),
      revertedByUserId: json['revertedByUserId'] is int
          ? json['revertedByUserId'] as int
          : int.tryParse('${json['revertedByUserId'] ?? ''}'),
      requestId: json['requestId']?.toString() ?? '',
      expectedDataVersion: json['expectedDataVersion'] is int
          ? json['expectedDataVersion'] as int
          : int.tryParse('${json['expectedDataVersion'] ?? ''}'),
      revertsAmendmentId: json['revertsAmendmentId'] is int
          ? json['revertsAmendmentId'] as int
          : int.tryParse('${json['revertsAmendmentId'] ?? ''}'),
    );
  }
}

class CompanyAmendmentFieldOption {
  const CompanyAmendmentFieldOption({
    required this.fieldPath,
    required this.fieldLabelKey,
    required this.valueType,
    required this.sensitive,
    this.superAdminOnly = false,
    this.enumValues,
  });

  final String fieldPath;
  final String fieldLabelKey;
  final String valueType;
  final bool sensitive;
  final bool superAdminOnly;
  final List<String>? enumValues;

  factory CompanyAmendmentFieldOption.fromJson(Map<String, dynamic> json) {
    final rawEnumValues = json['enumValues'];
    List<String>? enumValues;
    if (rawEnumValues is List) {
      enumValues = rawEnumValues
          .map((e) => e.toString())
          .where((e) => e.trim().isNotEmpty)
          .toList(growable: false);
      if (enumValues.isEmpty) enumValues = null;
    }
    return CompanyAmendmentFieldOption(
      fieldPath: json['fieldPath']?.toString() ?? '',
      fieldLabelKey: json['fieldLabelKey']?.toString() ?? '',
      valueType: json['valueType']?.toString() ?? 'string',
      sensitive: json['sensitive'] == true,
      superAdminOnly: json['superAdminOnly'] == true,
      enumValues: enumValues,
    );
  }
}

class CreateCompanyAmendmentRequest {
  const CreateCompanyAmendmentRequest({
    required this.fieldPath,
    required this.newValue,
    required this.reason,
    required this.authorizationSource,
    required this.authorizedByName,
    required this.authorizationMethod,
    this.authorizationReference,
    required this.internalComment,
    this.customerVisibleComment,
    this.expectedDataVersion,
  });

  final String fieldPath;
  final Object? newValue;
  final String reason;
  final String authorizationSource;
  final String authorizedByName;
  final String authorizationMethod;
  final String? authorizationReference;
  final String internalComment;
  final String? customerVisibleComment;
  final int? expectedDataVersion;

  Map<String, dynamic> toJson() => {
        'fieldPath': fieldPath,
        'newValue': newValue,
        'reason': reason,
        'authorizationSource': authorizationSource,
        'authorizedByName': authorizedByName,
        'authorizationMethod': authorizationMethod,
        if (authorizationReference != null &&
            authorizationReference!.trim().isNotEmpty)
          'authorizationReference': authorizationReference,
        'internalComment': internalComment,
        if (customerVisibleComment != null &&
            customerVisibleComment!.trim().isNotEmpty)
          'customerVisibleComment': customerVisibleComment,
        if (expectedDataVersion != null)
          'expectedDataVersion': expectedDataVersion,
      };
}

Map<String, dynamic>? _asMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
}

int _asInt(Object? value, int fallback) {
  if (value is int) return value;
  return int.tryParse('$value') ?? fallback;
}

DateTime? _parseDate(Object? value) {
  if (value == null) return null;
  return DateTime.tryParse(value.toString());
}
