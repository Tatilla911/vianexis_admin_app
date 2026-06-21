import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/customer_agreement_snapshot.dart';
import '../domain/customer_communication_message.dart';
import '../domain/customer_communication_thread.dart';
import '../domain/customer_communication_thread_detail.dart';
import '../domain/customer_evidence_package.dart';
import '../domain/evidence_package_request.dart';

class CustomerCommunicationsApi {
  CustomerCommunicationsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<List<CustomerCommunicationThread>> listThreads({
    int limit = 200,
    String? emailDomain,
    String? status,
    bool? disputed,
    String? companyId,
    String? from,
    String? to,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/customer-communications',
      queryParameters: {
        'limit': limit,
        if (emailDomain != null && emailDomain.trim().isNotEmpty)
          'emailDomain': emailDomain.trim(),
        if (status != null && status.trim().isNotEmpty) 'status': status.trim(),
        if (disputed == true) 'disputed': 'true',
        if (companyId != null && companyId.trim().isNotEmpty)
          'companyId': companyId.trim(),
        if (from != null && from.trim().isNotEmpty) 'from': from.trim(),
        if (to != null && to.trim().isNotEmpty) 'to': to.trim(),
      },
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.customerCommunicationLoadError,
      );
    }

    final items = data['items'];
    if (items is! List) return const [];

    return items
        .whereType<Map>()
        .map((item) => CustomerCommunicationThread.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);
  }

  Future<CustomerCommunicationThreadDetail> getThread(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/customer-communications/$id',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.customerCommunicationLoadError,
      );
    }

    final threadJson = data['thread'];
    if (threadJson is! Map) {
      throw const ApiException(
        messageKey: LocalizationKeys.customerCommunicationLoadError,
      );
    }

    final messages = _parseMessages(data['messages']);
    final agreements = _parseAgreements(data['agreementSnapshots']);
    final packages = _parsePackages(data['evidencePackages']);

    return CustomerCommunicationThreadDetail(
      thread: CustomerCommunicationThread.fromJson(
        Map<String, dynamic>.from(threadJson),
      ),
      messages: messages,
      agreementSnapshots: agreements,
      evidencePackages: packages,
      metadataOnly: data['metadataOnly'] == true,
    );
  }

  Future<CustomerEvidencePackage> generateEvidencePackage({
    required String threadId,
    required EvidencePackageRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/customer-communications/$threadId/generate-evidence-package',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.customerCommunicationActionError,
      );
    }

    final packageJson = data['package'];
    if (packageJson is Map<String, dynamic>) {
      return CustomerEvidencePackage.fromJson(packageJson);
    }
    if (packageJson is Map) {
      return CustomerEvidencePackage.fromJson(
        Map<String, dynamic>.from(packageJson),
      );
    }
    throw const ApiException(
      messageKey: LocalizationKeys.customerCommunicationActionError,
    );
  }

  Future<List<int>> downloadEvidencePackagePdf({
    required String threadId,
    required String packageId,
  }) async {
    final response = await _apiClient.get<List<int>>(
      '/platform-admin/customer-communications/$threadId/evidence-packages/$packageId/download',
      options: Options(responseType: ResponseType.bytes),
    );
    return response.data ?? const [];
  }

  Future<CustomerCommunicationThread> markDisputed({
    required String threadId,
    required MarkCustomerDisputeRequest request,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/customer-communications/$threadId/mark-disputed',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.customerCommunicationActionError,
      );
    }

    final threadJson = data['thread'];
    if (threadJson is Map<String, dynamic>) {
      return CustomerCommunicationThread.fromJson(threadJson);
    }
    if (threadJson is Map) {
      return CustomerCommunicationThread.fromJson(
        Map<String, dynamic>.from(threadJson),
      );
    }
    throw const ApiException(
      messageKey: LocalizationKeys.customerCommunicationActionError,
    );
  }

  List<CustomerCommunicationMessage> _parseMessages(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => CustomerCommunicationMessage.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);
  }

  List<CustomerAgreementSnapshot> _parseAgreements(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => CustomerAgreementSnapshot.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);
  }

  List<CustomerEvidencePackage> _parsePackages(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((item) => CustomerEvidencePackage.fromJson(
              Map<String, dynamic>.from(item),
            ))
        .toList(growable: false);
  }
}

final customerCommunicationsApiProvider = Provider<CustomerCommunicationsApi>(
  (ref) => CustomerCommunicationsApi(ref.watch(apiClientProvider)),
);
