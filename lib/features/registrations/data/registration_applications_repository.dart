import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/registration_application.dart';
import '../domain/registration_application_status.dart';
import '../domain/registration_approval_outcome.dart';
import '../domain/registration_decision_request.dart';
import '../domain/registration_risk_level.dart';
import 'registration_applications_api.dart';

abstract class RegistrationApplicationsRepository {
  Future<List<RegistrationApplication>> fetchApplications();

  Future<RegistrationApplication> fetchApplication(String id);

  Future<RegistrationApprovalOutcome?> submitDecision({
    required String applicationId,
    required RegistrationDecisionRequest request,
  });

  Future<RegistrationApprovalOutcome> resendInvite(String applicationId);

  Future<Map<String, dynamic>> sendPasswordSetup(String applicationId);

  Future<Map<String, dynamic>> getInviteStatus(String applicationId);

  Future<void> revokeInvite(String applicationId);

  bool get usesMockData;
}

class LiveRegistrationApplicationsRepository
    implements RegistrationApplicationsRepository {
  LiveRegistrationApplicationsRepository(this._api);

  final RegistrationApplicationsApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<List<RegistrationApplication>> fetchApplications() async {
    final page = await _api.listApplications(limit: 200);
    return page.items;
  }

  @override
  Future<RegistrationApplication> fetchApplication(String id) {
    return _api.getApplication(id);
  }

  @override
  Future<RegistrationApprovalOutcome?> submitDecision({
    required String applicationId,
    required RegistrationDecisionRequest request,
  }) {
    return _api.submitDecision(applicationId: applicationId, request: request);
  }

  @override
  Future<RegistrationApprovalOutcome> resendInvite(String applicationId) {
    return _api.resendInvite(applicationId);
  }

  @override
  Future<Map<String, dynamic>> sendPasswordSetup(String applicationId) {
    return _api.sendPasswordSetup(applicationId);
  }

  @override
  Future<Map<String, dynamic>> getInviteStatus(String applicationId) {
    return _api.getInviteStatus(applicationId);
  }

  @override
  Future<void> revokeInvite(String applicationId) {
    return _api.revokeInvite(applicationId);
  }
}

/// Isolated fallback data for local development without a configured backend.
class MockRegistrationApplicationsRepository
    implements RegistrationApplicationsRepository {
  MockRegistrationApplicationsRepository();

  final List<RegistrationApplication> _items = [
    RegistrationApplication(
      id: '101',
      type: RegistrationApplicationType.company,
      companyName: 'NordTrans Kft.',
      country: 'HU',
      vatNumber: 'HU12345678',
      registrationNumber: '01-09-123456',
      contactName: 'Anna Kovács',
      contactEmail: 'anna@nordtrans.example',
      status: RegistrationApplicationStatus.pending,
      riskLevel: RegistrationRiskLevel.medium,
      aiRecommendation: 'request_info',
      aiSummary: 'VAT format valid; company registry lookup pending.',
      missingInformation: const ['registry_lookup'],
      duplicateWarnings: const [],
      submittedAt: DateTime.utc(2026, 6, 10, 9, 30),
      needsHumanReview: true,
      completenessScore: 0.72,
    ),
    RegistrationApplication(
      id: '102',
      type: RegistrationApplicationType.company,
      companyName: 'Alpine Logistics GmbH',
      country: 'AT',
      vatNumber: 'ATU99999999',
      registrationNumber: 'FN 123456a',
      contactName: 'Thomas Berger',
      contactEmail: 'thomas@alpine-logistics.example',
      status: RegistrationApplicationStatus.needsMoreInfo,
      riskLevel: RegistrationRiskLevel.high,
      aiRecommendation: 'reject_candidate',
      aiSummary: 'Potential duplicate company profile detected.',
      missingInformation: const ['contact_phone'],
      duplicateWarnings: const ['possible_duplicate_vat'],
      submittedAt: DateTime.utc(2026, 6, 8, 14, 15),
      needsHumanReview: true,
      completenessScore: 0.55,
      riskFlags: const {'level': 'high'},
    ),
  ];

  @override
  bool get usesMockData => true;

  @override
  Future<List<RegistrationApplication>> fetchApplications() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_items);
  }

  @override
  Future<RegistrationApplication> fetchApplication(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _items.firstWhere(
      (item) => item.id == id,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  @override
  Future<RegistrationApprovalOutcome?> submitDecision({
    required String applicationId,
    required RegistrationDecisionRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    final index = _items.indexWhere((item) => item.id == applicationId);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }

    final current = _items[index];
    final updatedStatus = switch (request.type) {
      RegistrationDecisionType.approve =>
        RegistrationApplicationStatus.approved,
      RegistrationDecisionType.reject => RegistrationApplicationStatus.rejected,
      RegistrationDecisionType.requestInfo =>
        RegistrationApplicationStatus.needsMoreInfo,
    };

    _items[index] = RegistrationApplication(
      id: current.id,
      type: current.type,
      companyName: current.companyName,
      country: current.country,
      vatNumber: current.vatNumber,
      registrationNumber: current.registrationNumber,
      contactName: current.contactName,
      contactEmail: current.contactEmail,
      status: updatedStatus,
      riskLevel: current.riskLevel,
      aiRecommendation: current.aiRecommendation,
      aiSummary: current.aiSummary,
      missingInformation: current.missingInformation,
      duplicateWarnings: current.duplicateWarnings,
      submittedAt: current.submittedAt,
      reviewedAt: DateTime.now().toUtc(),
      reviewedBy: 'mock-reviewer',
      reviewNotes: request.reviewNotes?.trim().isNotEmpty == true
          ? request.reviewNotes!.trim()
          : current.reviewNotes,
      documentMetadataOnly: current.documentMetadataOnly,
      needsHumanReview: false,
      completenessScore: current.completenessScore,
      riskFlags: current.riskFlags,
    );

    if (request.type != RegistrationDecisionType.approve) {
      return null;
    }
    return RegistrationApprovalOutcome(
      companyId: '9001',
      companyName: current.companyName,
      adminEmail: current.contactEmail,
      emailInviteSent: false,
      inviteDeliveryStatus: 'pending_or_failed',
      inviteExpiresAt: DateTime.now().toUtc().add(const Duration(hours: 24)),
      inviteTokenId: 'mock-invite-1',
    );
  }

  @override
  Future<RegistrationApprovalOutcome> resendInvite(String applicationId) async {
    if (AppConfig.instance.environment.isStaging ||
        AppConfig.instance.environment.isProduction ||
        !kDebugMode) {
      throw const ApiException(
        messageKey: LocalizationKeys.authBackendNotConfigured,
        kind: ApiExceptionKind.notConfigured,
        errorCode: 'MOCK_INVITE_SEND_FORBIDDEN',
        backendMessage:
            'Mock registration repository cannot send activation invites.',
      );
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
    final item = await fetchApplication(applicationId);
    return RegistrationApprovalOutcome(
      companyId: '9001',
      companyName: item.companyName,
      adminEmail: item.contactEmail,
      emailInviteSent: false,
      inviteDeliveryStatus: 'pending_or_failed',
      inviteExpiresAt: DateTime.now().toUtc().add(const Duration(hours: 24)),
      inviteTokenId: 'mock-invite-resent',
    );
  }

  @override
  Future<Map<String, dynamic>> sendPasswordSetup(String applicationId) async {
    if (AppConfig.instance.environment.isStaging ||
        AppConfig.instance.environment.isProduction ||
        !kDebugMode) {
      throw const ApiException(
        messageKey: LocalizationKeys.authBackendNotConfigured,
        kind: ApiExceptionKind.notConfigured,
        errorCode: 'MOCK_INVITE_SEND_FORBIDDEN',
        backendMessage:
            'Mock registration repository cannot send activation invites.',
      );
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return {
      'mode': 'invite',
      'emailSent': false,
      'emailDeliveryStatus': 'pending_or_failed',
      'adminEmail': (await fetchApplication(applicationId)).contactEmail,
    };
  }

  @override
  Future<Map<String, dynamic>> getInviteStatus(String applicationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 50));
    return {
      'status': 'pending_or_failed',
      'tokenId': 'mock-invite-1',
      'expiresAt': DateTime.now()
          .toUtc()
          .add(const Duration(hours: 24))
          .toIso8601String(),
      'emailInviteSent': false,
    };
  }

  @override
  Future<void> revokeInvite(String applicationId) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
}

final registrationApplicationsRepositoryProvider =
    Provider<RegistrationApplicationsRepository>((ref) {
      final config = AppConfig.instance;
      // Staging/production must never silently fall back to mock — invite
      // send/resend would show a local success without any HTTP request.
      final forceLive =
          config.environment.isStaging ||
          config.environment.isProduction ||
          config.shouldUseLiveRepositories;
      if (forceLive) {
        return LiveRegistrationApplicationsRepository(
          ref.watch(registrationApplicationsApiProvider),
        );
      }
      return MockRegistrationApplicationsRepository();
    });
