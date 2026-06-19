import 'bulk_onboarding_job.dart';
import 'bulk_onboarding_row.dart';

class BulkOnboardingRowCorrectionRequest {
  const BulkOnboardingRowCorrectionRequest({
    this.name,
    this.email,
    this.phone,
    this.country,
    this.role,
    this.vehiclePlate,
    this.trailerPlate,
    this.note,
  });

  final String? name;
  final String? email;
  final String? phone;
  final String? country;
  final String? role;
  final String? vehiclePlate;
  final String? trailerPlate;
  final String? note;

  Map<String, dynamic> toJson() {
    return {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (country != null) 'country': country,
      if (role != null) 'role': role,
      if (vehiclePlate != null) 'vehiclePlate': vehiclePlate,
      if (trailerPlate != null) 'trailerPlate': trailerPlate,
      if (note != null && note!.trim().isNotEmpty) 'note': note!.trim(),
    };
  }

  bool get hasAnyField =>
      (name?.trim().isNotEmpty ?? false) ||
      (email?.trim().isNotEmpty ?? false) ||
      (phone?.trim().isNotEmpty ?? false) ||
      (country?.trim().isNotEmpty ?? false) ||
      (role?.trim().isNotEmpty ?? false) ||
      (vehiclePlate?.trim().isNotEmpty ?? false) ||
      (trailerPlate?.trim().isNotEmpty ?? false);

  String? validate() {
    if (!hasAnyField) return 'bulkOnboardingRowCorrectionFieldRequired';
    return null;
  }
}

class BulkOnboardingRowSkipRequest {
  const BulkOnboardingRowSkipRequest({required this.reason});

  final String reason;

  Map<String, dynamic> toJson() => {'reason': reason.trim()};

  bool get isValid => reason.trim().isNotEmpty;

  String? validate() {
    if (!isValid) return 'bulkOnboardingRowSkipReasonRequired';
    return null;
  }
}

class BulkOnboardingRowActionResult {
  const BulkOnboardingRowActionResult({
    required this.row,
    required this.job,
  });

  factory BulkOnboardingRowActionResult.fromJson(Map<String, dynamic> json) {
    return BulkOnboardingRowActionResult(
      row: BulkOnboardingRow.fromDetailResponseJson(json),
      job: BulkOnboardingJob.fromDetailResponseJson(json),
    );
  }

  final BulkOnboardingRow row;
  final BulkOnboardingJob job;
}
