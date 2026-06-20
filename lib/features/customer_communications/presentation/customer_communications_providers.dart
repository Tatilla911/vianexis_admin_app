import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/customer_communications_repository.dart';
import '../domain/customer_communication_thread.dart';
import '../domain/customer_communication_thread_detail.dart';
import '../domain/customer_evidence_package.dart';
import '../domain/evidence_package_request.dart';

class CustomerCommunicationListQuery {
  const CustomerCommunicationListQuery({
    this.search = '',
    this.filter = CustomerCommunicationListFilter.all,
  });

  final String search;
  final CustomerCommunicationListFilter filter;

  CustomerCommunicationListQuery copyWith({
    String? search,
    CustomerCommunicationListFilter? filter,
  }) {
    return CustomerCommunicationListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }
}

final customerCommunicationListQueryProvider = NotifierProvider<
    CustomerCommunicationListQueryNotifier, CustomerCommunicationListQuery>(
  CustomerCommunicationListQueryNotifier.new,
);

class CustomerCommunicationListQueryNotifier
    extends Notifier<CustomerCommunicationListQuery> {
  @override
  CustomerCommunicationListQuery build() => const CustomerCommunicationListQuery();

  void setSearch(String value) => state = state.copyWith(search: value);

  void setFilter(CustomerCommunicationListFilter filter) =>
      state = state.copyWith(filter: filter);
}

final customerCommunicationsProvider = AsyncNotifierProvider<
    CustomerCommunicationsNotifier, List<CustomerCommunicationThread>>(
  CustomerCommunicationsNotifier.new,
);

class CustomerCommunicationsNotifier
    extends AsyncNotifier<List<CustomerCommunicationThread>> {
  @override
  Future<List<CustomerCommunicationThread>> build() => _load();

  Future<List<CustomerCommunicationThread>> _load() {
    return ref.read(customerCommunicationsRepositoryProvider).fetchThreads();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<CustomerCommunicationThread>>();
    state = await AsyncValue.guard(_load);
  }
}

List<CustomerCommunicationThread> filteredCustomerCommunications({
  required List<CustomerCommunicationThread> items,
  required CustomerCommunicationListQuery query,
}) {
  return items
      .where((item) => item.matchesFilter(query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredCustomerCommunicationsProvider =
    Provider<AsyncValue<List<CustomerCommunicationThread>>>((ref) {
  final query = ref.watch(customerCommunicationListQueryProvider);
  final threads = ref.watch(customerCommunicationsProvider);
  return threads.whenData(
    (items) => filteredCustomerCommunications(items: items, query: query),
  );
});

final customerCommunicationDetailProvider = FutureProvider.autoDispose
    .family<CustomerCommunicationThreadDetail, String>((ref, id) {
  return ref.read(customerCommunicationsRepositoryProvider).fetchThreadDetail(id);
});

final customerCommunicationSummaryProvider = AsyncNotifierProvider<
    CustomerCommunicationSummaryNotifier, CustomerCommunicationSummary>(
  CustomerCommunicationSummaryNotifier.new,
);

class CustomerCommunicationSummaryNotifier
    extends AsyncNotifier<CustomerCommunicationSummary> {
  @override
  Future<CustomerCommunicationSummary> build() => _load();

  Future<CustomerCommunicationSummary> _load() async {
    final threads =
        await ref.read(customerCommunicationsRepositoryProvider).fetchThreads();
    return CustomerCommunicationSummary.fromThreads(threads);
  }

  Future<void> refresh() async {
    state = const AsyncLoading<CustomerCommunicationSummary>();
    state = await AsyncValue.guard(_load);
  }
}

Future<void> refreshCustomerCommunicationDetail(WidgetRef ref, String id) async {
  ref.invalidate(customerCommunicationDetailProvider(id));
}

Future<CustomerEvidencePackage> generateCustomerEvidencePackage({
  required WidgetRef ref,
  required String threadId,
  required EvidencePackageRequest request,
}) async {
  final pkg = await ref
      .read(customerCommunicationsRepositoryProvider)
      .generateEvidencePackage(threadId: threadId, request: request);
  ref.invalidate(customerCommunicationDetailProvider(threadId));
  await ref.read(customerCommunicationsProvider.notifier).refresh();
  await ref.read(customerCommunicationSummaryProvider.notifier).refresh();
  return pkg;
}

Future<CustomerCommunicationThread> markCustomerCommunicationDisputed({
  required WidgetRef ref,
  required String threadId,
  required MarkCustomerDisputeRequest request,
}) async {
  final thread = await ref
      .read(customerCommunicationsRepositoryProvider)
      .markDisputed(threadId: threadId, request: request);
  ref.invalidate(customerCommunicationDetailProvider(threadId));
  await ref.read(customerCommunicationsProvider.notifier).refresh();
  await ref.read(customerCommunicationSummaryProvider.notifier).refresh();
  return thread;
}
