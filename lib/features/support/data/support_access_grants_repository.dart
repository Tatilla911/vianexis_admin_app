import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/support_access_grant.dart';
import '../domain/support_access_grant_request.dart';
import '../domain/support_access_grant_status.dart';
import '../domain/support_access_scope_type.dart';
import 'support_api.dart';

abstract class SupportAccessGrantsRepository {
  Future<List<SupportAccessGrant>> fetchGrants();

  Future<SupportAccessGrant> fetchGrant(String id);

  Future<SupportAccessGrant> createGrant(SupportAccessGrantRequest request);

  Future<SupportAccessGrant> revokeGrant({
    required String grantId,
    required SupportAccessGrantRequest request,
  });

  bool get usesMockData;
}

class LiveSupportAccessGrantsRepository implements SupportAccessGrantsRepository {
  LiveSupportAccessGrantsRepository(this._api);

  final SupportApi _api;
  List<SupportAccessGrant>? _cachedGrants;

  @override
  bool get usesMockData => false;

  @override
  Future<List<SupportAccessGrant>> fetchGrants() async {
    final grants = await _api.listGrants();
    _cachedGrants = grants;
    return grants;
  }

  @override
  Future<SupportAccessGrant> fetchGrant(String id) async {
    try {
      return await _api.getGrant(id);
    } on ApiException catch (error) {
      if (error.kind != ApiExceptionKind.notFound) rethrow;
      final cached = _cachedGrants;
      if (cached != null) {
        return cached.firstWhere(
          (grant) => grant.id == id,
          orElse: () => throw error,
        );
      }
      rethrow;
    }
  }

  @override
  Future<SupportAccessGrant> createGrant(SupportAccessGrantRequest request) async {
    final validationKey = request.validationErrorKey();
    if (validationKey != null) {
      throw ApiException(messageKey: validationKey);
    }
    return _api.createGrant(request);
  }

  @override
  Future<SupportAccessGrant> revokeGrant({
    required String grantId,
    required SupportAccessGrantRequest request,
  }) async {
    if (request.reason.trim().length < 3) {
      throw const ApiException(messageKey: 'supportGrantReasonRequired');
    }

    try {
      await _api.revokeGrant(grantId: grantId, request: request);
    } on ApiException catch (error) {
      if (error.kind == ApiExceptionKind.notFound) {
        throw const ApiException(
          messageKey: LocalizationKeys.supportActionUnavailable,
          kind: ApiExceptionKind.notFound,
        );
      }
      rethrow;
    }

    final updated = await fetchGrant(grantId);
    return updated.copyWith(
      status: SupportAccessGrantStatus.revoked,
      revokedAt: DateTime.now().toUtc(),
    );
  }
}

class MockSupportAccessGrantsRepository implements SupportAccessGrantsRepository {
  MockSupportAccessGrantsRepository();

  late List<SupportAccessGrant> _grants = _buildGrants();

  @override
  bool get usesMockData => true;

  @override
  Future<List<SupportAccessGrant>> fetchGrants() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _grants;
  }

  @override
  Future<SupportAccessGrant> fetchGrant(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _grants.firstWhere(
      (grant) => grant.id == id,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  @override
  Future<SupportAccessGrant> createGrant(SupportAccessGrantRequest request) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final validationKey = request.validationErrorKey();
    if (validationKey != null) {
      throw ApiException(messageKey: validationKey);
    }

    final grant = SupportAccessGrant(
      id: '${910 + _grants.length}',
      companyId: request.companyId,
      companyName: 'Tenant ${request.companyId}',
      scopeType: request.scopeType,
      scopeId: request.scopeId,
      reason: request.reason.trim(),
      status: SupportAccessGrantStatus.active,
      allowedDataCategories: request.scopeType.backendScopes(documentsAllowed: false),
      excludesSensitiveDocuments: true,
      createdAt: DateTime.now().toUtc(),
      expiresAt: request.expiresAt.toUtc(),
      auditLogId: 'audit-${910 + _grants.length}',
      metadataOnly: {
        if (request.linkedTicketId != null) 'linkedTicketId': request.linkedTicketId,
        if (request.linkedSystemHealthEventId != null)
          'linkedSystemHealthEventId': request.linkedSystemHealthEventId,
      },
    );

    _grants = [grant, ..._grants];
    return grant;
  }

  @override
  Future<SupportAccessGrant> revokeGrant({
    required String grantId,
    required SupportAccessGrantRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (request.reason.trim().length < 3) {
      throw const ApiException(messageKey: 'supportGrantReasonRequired');
    }

    final index = _grants.indexWhere((grant) => grant.id == grantId);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }

    final updated = _grants[index].copyWith(
      status: SupportAccessGrantStatus.revoked,
      revokedAt: DateTime.now().toUtc(),
    );
    final next = [..._grants];
    next[index] = updated;
    _grants = next;
    return updated;
  }

  static List<SupportAccessGrant> _buildGrants() {
    return [
      SupportAccessGrant(
        id: '901',
        companyId: '12',
        companyName: 'NordTrans Kft.',
        approvedByUserId: '1',
        approvedByName: 'Platform Support',
        scopeType: SupportAccessScopeType.systemHealthIssue,
        scopeId: '501',
        reason: 'Investigate Redis queue health event metadata.',
        status: SupportAccessGrantStatus.active,
        allowedDataCategories: const ['portal_dashboard', 'audit'],
        excludesSensitiveDocuments: true,
        createdAt: DateTime.utc(2026, 6, 18, 8, 0),
        expiresAt: DateTime.utc(2026, 6, 18, 10, 0),
        auditLogId: 'audit-901',
        metadataOnly: const {'linkedEvent': '501'},
      ),
      SupportAccessGrant(
        id: '902',
        companyId: '15',
        companyName: 'Baltic Freight OÜ',
        approvedByUserId: '1',
        approvedByName: 'Platform Support',
        scopeType: SupportAccessScopeType.billingIssue,
        reason: 'Review billing entitlement metadata.',
        status: SupportAccessGrantStatus.pending,
        allowedDataCategories: const ['company_settings'],
        excludesSensitiveDocuments: true,
        createdAt: DateTime.utc(2026, 6, 18, 7, 0),
        expiresAt: DateTime.utc(2026, 6, 19, 7, 0),
        auditLogId: 'audit-902',
      ),
      SupportAccessGrant(
        id: '903',
        companyId: '12',
        companyName: 'NordTrans Kft.',
        approvedByUserId: '1',
        approvedByName: 'Platform Support',
        scopeType: SupportAccessScopeType.uploadQueueIssue,
        scopeId: 'upload-queue-7',
        reason: 'Resolved upload queue advisory.',
        status: SupportAccessGrantStatus.expired,
        allowedDataCategories: const ['workshop'],
        excludesSensitiveDocuments: true,
        createdAt: DateTime.utc(2026, 6, 17, 10, 0),
        expiresAt: DateTime.utc(2026, 6, 17, 12, 0),
        auditLogId: 'audit-903',
      ),
    ];
  }
}

final supportAccessGrantsRepositoryProvider =
    Provider<SupportAccessGrantsRepository>((ref) {
      final apiClient = ref.watch(apiClientProvider);
      if (apiClient.isConfigured) {
        return LiveSupportAccessGrantsRepository(ref.watch(supportApiProvider));
      }
      return MockSupportAccessGrantsRepository();
    });
