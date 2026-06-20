import 'bulk_onboarding_job.dart';
import 'bulk_onboarding_row_status.dart';

class BulkOnboardingExecutionPolicy {
  const BulkOnboardingExecutionPolicy({
    required this.enabled,
    this.reason,
    this.maxRows,
    this.rowCount,
  });

  final bool enabled;
  final String? reason;
  final int? maxRows;
  final int? rowCount;

  factory BulkOnboardingExecutionPolicy.fromJson(Map<String, dynamic> json) {
    return BulkOnboardingExecutionPolicy(
      enabled: json['enabled'] == true,
      reason: json['reason']?.toString(),
      maxRows: _parseNullableInt(json['maxRows']),
      rowCount: _parseNullableInt(json['rowCount']),
    );
  }
}

class BulkOnboardingProvisioningSummary {
  const BulkOnboardingProvisioningSummary({
    this.dryRunOk = 0,
    this.blocked = 0,
    this.duplicates = 0,
    this.failed = 0,
    this.provisioned = 0,
  });

  final int dryRunOk;
  final int blocked;
  final int duplicates;
  final int failed;
  final int provisioned;

  factory BulkOnboardingProvisioningSummary.fromJson(
    Map<String, dynamic> json,
  ) {
    return BulkOnboardingProvisioningSummary(
      dryRunOk: _parseInt(json['dryRunOk'] ?? json['dry_run_ok']),
      blocked: _parseInt(json['blocked']),
      duplicates: _parseInt(json['duplicates']),
      failed: _parseInt(json['failed']),
      provisioned: _parseInt(json['provisioned']),
    );
  }
}

class BulkOnboardingExecutionRowStatus {
  const BulkOnboardingExecutionRowStatus({
    required this.rowId,
    required this.rowIndex,
    required this.status,
    this.reason,
  });

  final String rowId;
  final int rowIndex;
  final BulkOnboardingRowStatus status;
  final String? reason;

  factory BulkOnboardingExecutionRowStatus.fromJson(Map<String, dynamic> json) {
    return BulkOnboardingExecutionRowStatus(
      rowId: json['rowId']?.toString() ?? '',
      rowIndex: _parseInt(json['rowIndex']),
      status: BulkOnboardingRowStatus.fromBackendValue(
        json['status']?.toString(),
      ),
      reason: json['reason']?.toString(),
    );
  }
}

class BulkOnboardingExecutionResult {
  const BulkOnboardingExecutionResult({
    required this.job,
    required this.rows,
    required this.policy,
    required this.summary,
    this.rejectionCode,
  });

  final BulkOnboardingJob job;
  final List<BulkOnboardingExecutionRowStatus> rows;
  final BulkOnboardingExecutionPolicy policy;
  final BulkOnboardingProvisioningSummary summary;
  final String? rejectionCode;

  factory BulkOnboardingExecutionResult.fromJson(Map<String, dynamic> json) {
    final rawRows = json['rows'];
    final rows = rawRows is List
        ? rawRows
              .whereType<Map<String, dynamic>>()
              .map(BulkOnboardingExecutionRowStatus.fromJson)
              .toList(growable: false)
        : const <BulkOnboardingExecutionRowStatus>[];
    final policyJson = _asMap(json['policy']) ?? const <String, dynamic>{};
    final summaryJson = _asMap(json['summary']) ?? const <String, dynamic>{};
    return BulkOnboardingExecutionResult(
      job: BulkOnboardingJob.fromDetailResponseJson(json),
      rows: rows,
      policy: BulkOnboardingExecutionPolicy.fromJson(policyJson),
      summary: BulkOnboardingProvisioningSummary.fromJson(summaryJson),
      rejectionCode: json['rejectionCode']?.toString(),
    );
  }
}

class BulkOnboardingExecutionRequest {
  const BulkOnboardingExecutionRequest({
    required this.reason,
    required this.confirm,
  });

  final String reason;
  final bool confirm;

  String? validate() {
    if (reason.trim().isEmpty) {
      return 'bulkOnboardingExecuteReasonRequired';
    }
    if (!confirm) {
      return 'bulkOnboardingExecuteConfirmRequired';
    }
    return null;
  }

  Map<String, dynamic> toJson() {
    return {'reason': reason.trim(), 'confirm': confirm};
  }
}

Map<String, dynamic>? _asMap(Object? value) {
  if (value is Map<String, dynamic>) return value;
  if (value is Map) return Map<String, dynamic>.from(value);
  return null;
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
