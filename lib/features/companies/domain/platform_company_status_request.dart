import 'platform_company_status.dart';

class PlatformCompanyStatusRequest {
  const PlatformCompanyStatusRequest({
    required this.status,
    this.reason,
  });

  final PlatformCompanyStatus status;
  final String? reason;

  Map<String, dynamic> toJson() {
    return {
      'status': status.backendValue,
      if (reason != null && reason!.trim().isNotEmpty) 'reason': reason!.trim(),
    };
  }

  String? validate() {
    if (status.isRestrictive && (reason == null || reason!.trim().isEmpty)) {
      return 'platformCompanyStatusReasonRequired';
    }
    return null;
  }
}
