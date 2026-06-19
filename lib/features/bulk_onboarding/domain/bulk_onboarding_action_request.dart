enum BulkOnboardingActionKind {
  validate,
  approve,
  reject,
  cancel,
  process,
}

class BulkOnboardingActionRequest {
  const BulkOnboardingActionRequest({
    required this.kind,
    this.note,
    this.confirm = false,
  });

  final BulkOnboardingActionKind kind;
  final String? note;
  final bool confirm;

  String? validate() {
    switch (kind) {
      case BulkOnboardingActionKind.reject:
      case BulkOnboardingActionKind.cancel:
        if (note == null || note!.trim().isEmpty) {
          return 'bulkOnboardingActionNoteRequired';
        }
        return null;
      case BulkOnboardingActionKind.process:
        if (!confirm) {
          return 'bulkOnboardingActionConfirmRequired';
        }
        return null;
      case BulkOnboardingActionKind.validate:
      case BulkOnboardingActionKind.approve:
        return null;
    }
  }

  Map<String, dynamic> toJson() {
    return switch (kind) {
      BulkOnboardingActionKind.approve => {
        if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
      },
      BulkOnboardingActionKind.reject ||
      BulkOnboardingActionKind.cancel => {
        'reason': note!.trim(),
      },
      BulkOnboardingActionKind.process => {'confirm': confirm},
      BulkOnboardingActionKind.validate => const {},
    };
  }

  String endpointSuffix() {
    return switch (kind) {
      BulkOnboardingActionKind.validate => 'validate',
      BulkOnboardingActionKind.approve => 'approve',
      BulkOnboardingActionKind.reject => 'reject',
      BulkOnboardingActionKind.cancel => 'cancel',
      BulkOnboardingActionKind.process => 'process',
    };
  }

  String httpMethod() {
    return switch (kind) {
      BulkOnboardingActionKind.validate ||
      BulkOnboardingActionKind.process => 'POST',
      BulkOnboardingActionKind.approve ||
      BulkOnboardingActionKind.reject ||
      BulkOnboardingActionKind.cancel => 'PATCH',
    };
  }
}
