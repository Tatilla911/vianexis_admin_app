import 'dart:convert';

import 'bulk_onboarding_risk_level.dart';
import 'bulk_onboarding_status.dart';
import 'bulk_onboarding_type.dart';

class BulkOnboardingJobsPage {
  const BulkOnboardingJobsPage({
    required this.items,
    required this.total,
    this.privacyNoteKey,
    this.metadataOnly = true,
  });

  final List<BulkOnboardingJob> items;
  final int total;
  final String? privacyNoteKey;
  final bool metadataOnly;

  factory BulkOnboardingJobsPage.fromJson(Map<String, dynamic> json) {
    final rawItems = json['items'];
    final items = rawItems is List
        ? rawItems
            .whereType<Map<String, dynamic>>()
            .map(BulkOnboardingJob.fromJson)
            .toList(growable: false)
        : const <BulkOnboardingJob>[];
    return BulkOnboardingJobsPage(
      items: items,
      total: _parseInt(json['total']),
      privacyNoteKey: json['privacyNoteKey']?.toString(),
      metadataOnly: json['metadataOnly'] == true,
    );
  }
}

class BulkOnboardingJob {
  const BulkOnboardingJob({
    required this.id,
    this.companyId,
    required this.companyName,
    required this.submittedByUserId,
    this.submittedByName,
    this.sourceFileName,
    this.sourceFileMimeType,
    this.sourceFileSizeBytes,
    required this.type,
    required this.status,
    required this.totalRows,
    required this.validRows,
    required this.warningRows,
    required this.invalidRows,
    required this.duplicateRows,
    required this.processedRows,
    required this.failedRows,
    this.aiSummary,
    required this.riskLevel,
    this.validationSummary,
    required this.processingAvailable,
    this.createdAt,
    this.updatedAt,
    this.approvedAt,
    this.approvedByUserId,
    this.processedAt,
    this.lastErrorSummary,
    this.messageKey,
    this.metadataOnly = true,
  });

  final String id;
  final int? companyId;
  final String companyName;
  final int submittedByUserId;
  final String? submittedByName;
  final String? sourceFileName;
  final String? sourceFileMimeType;
  final int? sourceFileSizeBytes;
  final BulkOnboardingJobType type;
  final BulkOnboardingJobStatus status;
  final int totalRows;
  final int validRows;
  final int warningRows;
  final int invalidRows;
  final int duplicateRows;
  final int processedRows;
  final int failedRows;
  final String? aiSummary;
  final BulkOnboardingRiskLevel riskLevel;
  final String? validationSummary;
  final bool processingAvailable;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? approvedAt;
  final int? approvedByUserId;
  final DateTime? processedAt;
  final String? lastErrorSummary;
  final String? messageKey;
  final bool metadataOnly;

  String? get recommendedAction {
    if (validationSummary == null || validationSummary!.trim().isEmpty) {
      return null;
    }
    try {
      final decoded = _decodeSummary(validationSummary!);
      return decoded['recommendedAction']?.toString();
    } catch (_) {
      return null;
    }
  }

  static BulkOnboardingJob fromJson(Map<String, dynamic> json) {
    return BulkOnboardingJob(
      id: json['id']?.toString() ?? '',
      companyId: _parseNullableInt(json['companyId']),
      companyName: json['companyName']?.toString() ??
          json['name']?.toString() ??
          '—',
      submittedByUserId: _parseInt(json['submittedByUserId'] ?? json['createdByUserId']),
      submittedByName: json['submittedByName']?.toString(),
      sourceFileName: json['sourceFileName']?.toString(),
      sourceFileMimeType: json['sourceFileMimeType']?.toString(),
      sourceFileSizeBytes: _parseNullableInt(json['sourceFileSizeBytes']),
      type: BulkOnboardingJobType.fromBackendValue(json['type']?.toString()),
      status: BulkOnboardingJobStatus.fromBackendValue(json['status']?.toString()),
      totalRows: _parseInt(json['totalRows']),
      validRows: _parseInt(json['validRows']),
      warningRows: _parseInt(json['warningRows']),
      invalidRows: _parseInt(json['invalidRows']),
      duplicateRows: _parseInt(json['duplicateRows']),
      processedRows: _parseInt(json['processedRows']),
      failedRows: _parseInt(json['failedRows']),
      aiSummary: json['aiSummary']?.toString(),
      riskLevel: BulkOnboardingRiskLevel.fromBackendValue(json['riskLevel']?.toString()),
      validationSummary: json['validationSummary']?.toString(),
      processingAvailable: json['processingAvailable'] == true,
      createdAt: parseDate(json['createdAt']),
      updatedAt: parseDate(json['updatedAt']),
      approvedAt: parseDate(json['approvedAt']),
      approvedByUserId: _parseNullableInt(json['approvedByUserId']),
      processedAt: parseDate(json['processedAt']),
      lastErrorSummary: json['lastErrorSummary']?.toString(),
      messageKey: json['messageKey']?.toString(),
      metadataOnly: json['metadataOnly'] != false,
    );
  }

  factory BulkOnboardingJob.fromDetailResponseJson(Map<String, dynamic> json) {
    final job = json['job'];
    if (job is Map<String, dynamic>) {
      return BulkOnboardingJob.fromJson(job);
    }
    return BulkOnboardingJob.fromJson(json);
  }

  static DateTime? parseDate(Object? raw) {
    if (raw == null) return null;
    return DateTime.tryParse(raw.toString());
  }

  bool matchesSearch(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return companyName.toLowerCase().contains(normalized) ||
        id.contains(normalized) ||
        (sourceFileName?.toLowerCase().contains(normalized) ?? false) ||
        status.backendValue.contains(normalized);
  }

  bool matchesFilter(BulkOnboardingListFilter filter) {
    return switch (filter) {
      BulkOnboardingListFilter.all => true,
      BulkOnboardingListFilter.readyForReview =>
        status == BulkOnboardingJobStatus.readyForReview,
      BulkOnboardingListFilter.validationFailed =>
        status == BulkOnboardingJobStatus.validationFailed,
      BulkOnboardingListFilter.processing =>
        status == BulkOnboardingJobStatus.processing ||
        status == BulkOnboardingJobStatus.approvedForProcessing,
      BulkOnboardingListFilter.completed =>
        status == BulkOnboardingJobStatus.completed ||
        status == BulkOnboardingJobStatus.partiallyCompleted,
      BulkOnboardingListFilter.rejected =>
        status == BulkOnboardingJobStatus.rejected,
      BulkOnboardingListFilter.highRisk =>
        riskLevel == BulkOnboardingRiskLevel.high,
    };
  }
}

enum BulkOnboardingListFilter {
  all,
  readyForReview,
  validationFailed,
  processing,
  completed,
  rejected,
  highRisk,
}

Map<String, dynamic> _decodeSummary(String raw) {
  final trimmed = raw.trim();
  if (trimmed.startsWith('{')) {
    return Map<String, dynamic>.from(jsonDecode(trimmed) as Map);
  }
  return {};
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
