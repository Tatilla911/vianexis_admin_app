enum RegistrationDecisionType {
  approve,
  reject,
  requestInfo,
}

class RegistrationDecisionRequest {
  const RegistrationDecisionRequest({
    required this.type,
    this.reviewNotes,
    this.aiReviewId,
    this.aiReviewSummary,
  });

  final RegistrationDecisionType type;
  final String? reviewNotes;
  final int? aiReviewId;
  final String? aiReviewSummary;

  Map<String, dynamic> toJson() {
    return switch (type) {
      RegistrationDecisionType.approve => {
        if (reviewNotes != null && reviewNotes!.trim().isNotEmpty)
          'reviewNotes': reviewNotes!.trim(),
        if (aiReviewId != null) 'aiReviewId': aiReviewId,
      },
      RegistrationDecisionType.reject => {
        'reviewNotes': reviewNotes!.trim(),
        if (aiReviewId != null) 'aiReviewId': aiReviewId,
      },
      RegistrationDecisionType.requestInfo => {
        'reviewNotes': reviewNotes!.trim(),
        if (aiReviewSummary != null && aiReviewSummary!.trim().isNotEmpty)
          'aiReviewSummary': aiReviewSummary!.trim(),
      },
    };
  }

  String endpointSuffix() {
    return switch (type) {
      RegistrationDecisionType.approve => 'approve',
      RegistrationDecisionType.reject => 'reject',
      RegistrationDecisionType.requestInfo => 'request-info',
    };
  }
}
