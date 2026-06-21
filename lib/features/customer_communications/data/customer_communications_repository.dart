import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/customer_agreement_snapshot.dart';
import '../domain/customer_communication_message.dart';
import '../domain/customer_communication_thread.dart';
import '../domain/customer_communication_thread_detail.dart';
import '../domain/customer_evidence_package.dart';
import '../domain/customer_delivery_models.dart';
import '../domain/evidence_package_request.dart';
import '../domain/customer_message_delivery.dart';
import '../domain/send_reply_request.dart';
import 'customer_communications_api.dart';

abstract class CustomerCommunicationsRepository {
  Future<List<CustomerCommunicationThread>> fetchThreads();

  Future<CustomerCommunicationThreadDetail> fetchThreadDetail(String id);

  Future<CustomerEvidencePackage> generateEvidencePackage({
    required String threadId,
    required EvidencePackageRequest request,
  });

  Future<List<int>> downloadEvidencePackagePdf({
    required String threadId,
    required String packageId,
  });

  Future<CustomerCommunicationThread> markDisputed({
    required String threadId,
    required MarkCustomerDisputeRequest request,
  });

  Future<SendCustomerReplyResult> sendReply({
    required String threadId,
    required SendCustomerReplyRequest request,
  });

  Future<SendCustomerReplyResult> resendReply({
    required String threadId,
    required String messageId,
    required ResendCustomerReplyRequest request,
  });

  Future<CustomerDeliveryListResult> listDeliveries({
    required String threadId,
    CustomerDeliveryHistoryFilter filter = CustomerDeliveryHistoryFilter.all,
  });

  Future<CustomerDeliveryDetail> getDeliveryDetail({
    required String threadId,
    required String deliveryId,
  });

  Future<SendCustomerReplyResult> resendByDeliveryId({
    required String threadId,
    required String deliveryId,
    required ResendCustomerReplyRequest request,
  });

  bool get usesMockData;
}

class LiveCustomerCommunicationsRepository
    implements CustomerCommunicationsRepository {
  LiveCustomerCommunicationsRepository(this._api);

  final CustomerCommunicationsApi _api;
  List<CustomerCommunicationThread>? _cachedThreads;

  @override
  bool get usesMockData => false;

  @override
  Future<List<CustomerCommunicationThread>> fetchThreads() async {
    final threads = await _api.listThreads();
    _cachedThreads = threads;
    return threads;
  }

  @override
  Future<CustomerCommunicationThreadDetail> fetchThreadDetail(String id) async {
    try {
      return await _api.getThread(id);
    } on ApiException catch (error) {
      if (error.kind != ApiExceptionKind.notFound) rethrow;
      final cached = _cachedThreads;
      if (cached != null) {
        for (final thread in cached) {
          if (thread.id == id) {
            return CustomerCommunicationThreadDetail(
              thread: thread,
              messages: const [],
              agreementSnapshots: const [],
              evidencePackages: const [],
              metadataOnly: true,
            );
          }
        }
      }
      rethrow;
    }
  }

  @override
  Future<CustomerEvidencePackage> generateEvidencePackage({
    required String threadId,
    required EvidencePackageRequest request,
  }) {
    return _api.generateEvidencePackage(threadId: threadId, request: request);
  }

  @override
  Future<List<int>> downloadEvidencePackagePdf({
    required String threadId,
    required String packageId,
  }) {
    return _api.downloadEvidencePackagePdf(
      threadId: threadId,
      packageId: packageId,
    );
  }

  @override
  Future<CustomerCommunicationThread> markDisputed({
    required String threadId,
    required MarkCustomerDisputeRequest request,
  }) {
    return _api.markDisputed(threadId: threadId, request: request);
  }

  @override
  Future<SendCustomerReplyResult> sendReply({
    required String threadId,
    required SendCustomerReplyRequest request,
  }) {
    return _api.sendReply(threadId: threadId, request: request);
  }

  @override
  Future<SendCustomerReplyResult> resendReply({
    required String threadId,
    required String messageId,
    required ResendCustomerReplyRequest request,
  }) {
    return _api.resendReply(
      threadId: threadId,
      messageId: messageId,
      request: request,
    );
  }

  @override
  Future<CustomerDeliveryListResult> listDeliveries({
    required String threadId,
    CustomerDeliveryHistoryFilter filter = CustomerDeliveryHistoryFilter.all,
  }) {
    return _api.listDeliveries(threadId: threadId, filter: filter);
  }

  @override
  Future<CustomerDeliveryDetail> getDeliveryDetail({
    required String threadId,
    required String deliveryId,
  }) {
    return _api.getDeliveryDetail(threadId: threadId, deliveryId: deliveryId);
  }

  @override
  Future<SendCustomerReplyResult> resendByDeliveryId({
    required String threadId,
    required String deliveryId,
    required ResendCustomerReplyRequest request,
  }) {
    return _api.resendByDeliveryId(
      threadId: threadId,
      deliveryId: deliveryId,
      request: request,
    );
  }
}

class MockCustomerCommunicationsRepository
    implements CustomerCommunicationsRepository {
  MockCustomerCommunicationsRepository();

  late List<CustomerCommunicationThread> _threads = _buildThreads();
  late final Map<String, CustomerCommunicationThreadDetail> _details =
      _buildDetails(_threads);

  @override
  bool get usesMockData => true;

  @override
  Future<List<CustomerCommunicationThread>> fetchThreads() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return _threads;
  }

  @override
  Future<CustomerCommunicationThreadDetail> fetchThreadDetail(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final detail = _details[id];
    if (detail == null) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }
    return detail;
  }

  @override
  Future<CustomerEvidencePackage> generateEvidencePackage({
    required String threadId,
    required EvidencePackageRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    if (request.reason.trim().length < 5) {
      throw const ApiException(
        messageKey: LocalizationKeys.customerCommunicationActionError,
        kind: ApiExceptionKind.validation,
      );
    }

    final existing = _details[threadId];
    final pkg = CustomerEvidencePackage(
      id: '${700 + (existing?.evidencePackages.length ?? 0)}',
      threadId: threadId,
      companyId: existing?.thread.companyId,
      packageType: request.packageType,
      status: CustomerEvidencePackageStatus.generated,
      generatedByUserId: '1',
      generatedAt: DateTime.now().toUtc(),
      generationReason: request.reason.trim(),
      summaryJson: const {
        'header': 'ViaNexis Customer Communication Evidence Package',
        'pdfRendererPending': false,
      },
      fileUrl:
          '/platform-admin/customer-communications/$threadId/evidence-packages/mock/download',
      fileHash: 'mock-pdf-hash',
      pdfRendererPending: false,
      pdfReady: true,
      sizeBytes: 4096,
    );

    if (existing != null) {
      _details[threadId] = CustomerCommunicationThreadDetail(
        thread: existing.thread,
        messages: existing.messages,
        agreementSnapshots: existing.agreementSnapshots,
        evidencePackages: [pkg, ...existing.evidencePackages],
      );
    }
    return pkg;
  }

  @override
  Future<List<int>> downloadEvidencePackagePdf({
    required String threadId,
    required String packageId,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));
    return [0x25, 0x50, 0x44, 0x46, 0x2D, 0x31, 0x2E, 0x34];
  }

  @override
  Future<SendCustomerReplyResult> sendReply({
    required String threadId,
    required SendCustomerReplyRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    if (!request.humanConfirmed) {
      throw const ApiException(
        messageKey: LocalizationKeys.customerCommunicationActionError,
        kind: ApiExceptionKind.validation,
      );
    }
    return SendCustomerReplyResult(
      messageId: '801',
      delivery: CustomerMessageDelivery(
        id: '901',
        threadId: threadId,
        messageId: '801',
        deliveryChannel: CustomerMessageDeliveryChannel.email,
        deliveryProvider: 'noop',
        deliveryStatus: CustomerMessageDeliveryStatus.skipped,
        humanConfirmed: true,
        translationApproved: request.useTranslatedText,
      ),
      deliveryStatus: 'skipped',
      providerNoopMode: true,
    );
  }

  @override
  Future<SendCustomerReplyResult> resendReply({
    required String threadId,
    required String messageId,
    required ResendCustomerReplyRequest request,
  }) async {
    if (request.reason.trim().length < 5) {
      throw const ApiException(
        messageKey: LocalizationKeys.customerCommunicationActionError,
        kind: ApiExceptionKind.validation,
      );
    }
    return SendCustomerReplyResult(
      messageId: messageId,
      delivery: CustomerMessageDelivery(
        id: '902',
        threadId: threadId,
        messageId: messageId,
        deliveryChannel: CustomerMessageDeliveryChannel.email,
        deliveryProvider: 'noop',
        deliveryStatus: CustomerMessageDeliveryStatus.skipped,
        humanConfirmed: true,
        resendOfDeliveryId: '901',
      ),
      deliveryStatus: 'skipped',
      providerNoopMode: true,
    );
  }

  @override
  Future<CustomerDeliveryListResult> listDeliveries({
    required String threadId,
    CustomerDeliveryHistoryFilter filter = CustomerDeliveryHistoryFilter.all,
  }) async {
    final detail = _details[threadId];
    final items = detail?.deliveries ?? const [];
    final status = filter.backendStatusValue();
    final filtered = status == null
        ? items
        : items
            .where((item) => item.deliveryStatus.name == status)
            .toList(growable: false);
    return CustomerDeliveryListResult(items: filtered, total: filtered.length);
  }

  @override
  Future<CustomerDeliveryDetail> getDeliveryDetail({
    required String threadId,
    required String deliveryId,
  }) async {
    final items = await listDeliveries(threadId: threadId);
    final delivery = items.items.firstWhere(
      (item) => item.id == deliveryId,
      orElse: () => CustomerMessageDelivery(
        id: deliveryId,
        threadId: threadId,
        deliveryChannel: CustomerMessageDeliveryChannel.email,
        deliveryProvider: 'noop',
        deliveryStatus: CustomerMessageDeliveryStatus.skipped,
      ),
    );
    return CustomerDeliveryDetail(delivery: delivery);
  }

  @override
  Future<SendCustomerReplyResult> resendByDeliveryId({
    required String threadId,
    required String deliveryId,
    required ResendCustomerReplyRequest request,
  }) {
    return resendReply(
      threadId: threadId,
      messageId: '801',
      request: request,
    );
  }

  @override
  Future<CustomerCommunicationThread> markDisputed({
    required String threadId,
    required MarkCustomerDisputeRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    final index = _threads.indexWhere((thread) => thread.id == threadId);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }

    final updated = _threads[index].copyWith(
      status: CustomerCommunicationThreadStatus.disputed,
      disputed: true,
      disputeReason: request.reason.trim(),
      disputedAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
    );
    final next = [..._threads];
    next[index] = updated;
    _threads = next;

    final detail = _details[threadId];
    if (detail != null) {
      _details[threadId] = CustomerCommunicationThreadDetail(
        thread: updated,
        messages: detail.messages,
        agreementSnapshots: detail.agreementSnapshots,
        evidencePackages: detail.evidencePackages,
      );
    }
    return updated;
  }

  static List<CustomerCommunicationThread> _buildThreads() {
    return [
      CustomerCommunicationThread(
        id: '101',
        companyId: '12',
        subscriptionId: '55',
        customerEmailDomain: 'nordtrans.example',
        customerEmailHash: 'hash-anna',
        customerDisplayName: 'Anna Kovács',
        status: CustomerCommunicationThreadStatus.disputed,
        source: CustomerCommunicationSource.publicSite,
        disputed: true,
        disputeReason: 'Customer denies subscribing to larger package.',
        disputedAt: DateTime.utc(2026, 6, 18, 10, 0),
        createdAt: DateTime.utc(2026, 6, 10, 8, 0),
        updatedAt: DateTime.utc(2026, 6, 18, 10, 0),
      ),
      CustomerCommunicationThread(
        id: '102',
        companyId: '15',
        pricingIntakeId: '88',
        customerEmailDomain: 'baltic.example',
        customerDisplayName: 'Marko Tamm',
        status: CustomerCommunicationThreadStatus.open,
        source: CustomerCommunicationSource.email,
        createdAt: DateTime.utc(2026, 6, 17, 14, 0),
        updatedAt: DateTime.utc(2026, 6, 17, 16, 0),
      ),
    ];
  }

  static Map<String, CustomerCommunicationThreadDetail> _buildDetails(
    List<CustomerCommunicationThread> threads,
  ) {
    final thread101 = threads.first;
    return {
      '101': CustomerCommunicationThreadDetail(
        thread: thread101,
        messages: [
          CustomerCommunicationMessage(
            id: '1001',
            threadId: '101',
            direction: CustomerCommunicationDirection.inbound,
            senderType: CustomerCommunicationSenderType.customer,
            originalText: 'I want the larger logistics package.',
            originalLanguage: 'hu',
            translatedText: 'I want the larger logistics package.',
            translatedLanguage: 'en',
            humanReviewedTranslation: true,
            sentAt: DateTime.utc(2026, 6, 10, 8, 5),
          ),
          CustomerCommunicationMessage(
            id: '1002',
            threadId: '101',
            direction: CustomerCommunicationDirection.outbound,
            senderType: CustomerCommunicationSenderType.platformAdmin,
            originalText: 'Confirmed Enterprise Plus selection.',
            originalLanguage: 'en',
            translatedText: 'Megerősítve: Enterprise Plus csomag.',
            translatedLanguage: 'hu',
            humanReviewedTranslation: true,
            sentAt: DateTime.utc(2026, 6, 10, 9, 0),
          ),
        ],
        agreementSnapshots: [
          CustomerAgreementSnapshot(
            id: '501',
            threadId: '101',
            companyId: '12',
            subscriptionId: '55',
            planName: 'Enterprise Plus',
            planCode: 'enterprise_plus',
            planVersion: '2026.06',
            priceAmount: '499',
            currency: 'EUR',
            billingCycle: 'monthly',
            selectedModules: const ['fleet', 'billing'],
            termsVersion: '2026.06',
            privacyVersion: '2026.06',
            acceptanceSource: 'public_site',
            acceptedAt: DateTime.utc(2026, 6, 10, 8, 30),
          ),
        ],
        evidencePackages: const [
          CustomerEvidencePackage(
            id: '701',
            threadId: '101',
            companyId: '12',
            packageType: CustomerEvidencePackageType.subscriptionDispute,
            status: CustomerEvidencePackageStatus.generated,
            fileUrl: null,
            pdfRendererPending: true,
            generationReason: 'Initial dispute review',
          ),
        ],
      ),
      '102': CustomerCommunicationThreadDetail(
        thread: threads[1],
        messages: [
          CustomerCommunicationMessage(
            id: '2001',
            threadId: '102',
            direction: CustomerCommunicationDirection.inbound,
            senderType: CustomerCommunicationSenderType.customer,
            originalText: 'Please send updated pricing.',
            originalLanguage: 'en',
            sentAt: DateTime.utc(2026, 6, 17, 14, 5),
          ),
        ],
        agreementSnapshots: const [],
        evidencePackages: const [],
      ),
    };
  }
}

final customerCommunicationsRepositoryProvider =
    Provider<CustomerCommunicationsRepository>((ref) {
  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveCustomerCommunicationsRepository(
      ref.watch(customerCommunicationsApiProvider),
    );
  }
  return MockCustomerCommunicationsRepository();
});
