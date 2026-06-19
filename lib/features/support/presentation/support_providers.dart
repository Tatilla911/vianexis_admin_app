import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../data/support_access_grants_repository.dart';
import '../data/support_tickets_repository.dart';
import '../domain/support_access_grant.dart';
import '../domain/support_access_grant_request.dart';
import '../domain/support_ticket.dart';
import '../domain/support_ticket_action_request.dart';

class SupportTicketListQuery {
  const SupportTicketListQuery({
    this.search = '',
    this.filter = SupportTicketListFilter.all,
  });

  final String search;
  final SupportTicketListFilter filter;

  SupportTicketListQuery copyWith({
    String? search,
    SupportTicketListFilter? filter,
  }) {
    return SupportTicketListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }
}

class SupportAccessGrantListQuery {
  const SupportAccessGrantListQuery({
    this.search = '',
    this.filter = SupportAccessGrantListFilter.all,
  });

  final String search;
  final SupportAccessGrantListFilter filter;

  SupportAccessGrantListQuery copyWith({
    String? search,
    SupportAccessGrantListFilter? filter,
  }) {
    return SupportAccessGrantListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }
}

final supportTicketListQueryProvider =
    NotifierProvider<SupportTicketListQueryNotifier, SupportTicketListQuery>(
      SupportTicketListQueryNotifier.new,
    );

class SupportTicketListQueryNotifier extends Notifier<SupportTicketListQuery> {
  @override
  SupportTicketListQuery build() => const SupportTicketListQuery();

  void setSearch(String value) => state = state.copyWith(search: value);

  void setFilter(SupportTicketListFilter filter) =>
      state = state.copyWith(filter: filter);
}

final supportAccessGrantListQueryProvider =
    NotifierProvider<SupportAccessGrantListQueryNotifier, SupportAccessGrantListQuery>(
      SupportAccessGrantListQueryNotifier.new,
    );

class SupportAccessGrantListQueryNotifier extends Notifier<SupportAccessGrantListQuery> {
  @override
  SupportAccessGrantListQuery build() => const SupportAccessGrantListQuery();

  void setSearch(String value) => state = state.copyWith(search: value);

  void setFilter(SupportAccessGrantListFilter filter) =>
      state = state.copyWith(filter: filter);
}

final supportTicketsProvider =
    AsyncNotifierProvider<SupportTicketsNotifier, List<SupportTicket>>(
      SupportTicketsNotifier.new,
    );

class SupportTicketsNotifier extends AsyncNotifier<List<SupportTicket>> {
  @override
  Future<List<SupportTicket>> build() => _load();

  Future<List<SupportTicket>> _load() {
    return ref.read(supportTicketsRepositoryProvider).fetchTickets();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<SupportTicket>>();
    state = await AsyncValue.guard(_load);
  }
}

final supportAccessGrantsProvider =
    AsyncNotifierProvider<SupportAccessGrantsNotifier, List<SupportAccessGrant>>(
      SupportAccessGrantsNotifier.new,
    );

class SupportAccessGrantsNotifier extends AsyncNotifier<List<SupportAccessGrant>> {
  @override
  Future<List<SupportAccessGrant>> build() => _load();

  Future<List<SupportAccessGrant>> _load() {
    return ref.read(supportAccessGrantsRepositoryProvider).fetchGrants();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<SupportAccessGrant>>();
    state = await AsyncValue.guard(_load);
  }
}

List<SupportTicket> filteredSupportTickets({
  required List<SupportTicket> items,
  required SupportTicketListQuery query,
}) {
  return items
      .where((item) => item.matchesFilter(query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

List<SupportAccessGrant> filteredSupportAccessGrants({
  required List<SupportAccessGrant> items,
  required SupportAccessGrantListQuery query,
}) {
  return items
      .where((item) => item.matchesFilter(query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredSupportTicketsProvider =
    Provider<AsyncValue<List<SupportTicket>>>((ref) {
      final query = ref.watch(supportTicketListQueryProvider);
      final tickets = ref.watch(supportTicketsProvider);
      return tickets.whenData(
        (items) => filteredSupportTickets(items: items, query: query),
      );
    });

final filteredSupportAccessGrantsProvider =
    Provider<AsyncValue<List<SupportAccessGrant>>>((ref) {
      final query = ref.watch(supportAccessGrantListQueryProvider);
      final grants = ref.watch(supportAccessGrantsProvider);
      return grants.whenData(
        (items) => filteredSupportAccessGrants(items: items, query: query),
      );
    });

final supportTicketDetailProvider =
    FutureProvider.autoDispose.family<SupportTicket, String>((ref, id) {
      return ref.watch(supportTicketsRepositoryProvider).fetchTicket(id);
    });

final supportAccessGrantDetailProvider =
    FutureProvider.autoDispose.family<SupportAccessGrant, String>((ref, id) {
      return ref.watch(supportAccessGrantsRepositoryProvider).fetchGrant(id);
    });

final supportSummaryProvider =
    AsyncNotifierProvider<SupportSummaryNotifier, SupportSummary>(
      SupportSummaryNotifier.new,
    );

class SupportSummaryNotifier extends AsyncNotifier<SupportSummary> {
  @override
  Future<SupportSummary> build() => _load();

  Future<SupportSummary> _load() async {
    final tickets = await ref.read(supportTicketsRepositoryProvider).fetchTickets();
    final grants = await ref.read(supportAccessGrantsRepositoryProvider).fetchGrants();
    return SupportSummary.fromTicketsAndGrants(tickets: tickets, grants: grants);
  }

  Future<void> refresh() async {
    state = const AsyncLoading<SupportSummary>();
    state = await AsyncValue.guard(_load);
  }
}

Future<void> refreshSupportTicketDetail(WidgetRef ref, String ticketId) async {
  ref.invalidate(supportTicketDetailProvider(ticketId));
}

Future<void> refreshSupportAccessGrantDetail(WidgetRef ref, String grantId) async {
  ref.invalidate(supportAccessGrantDetailProvider(grantId));
}

Future<SupportTicket> submitSupportTicketAction({
  required WidgetRef ref,
  required String ticketId,
  required SupportTicketActionRequest request,
}) async {
  final updated = await ref
      .read(supportTicketsRepositoryProvider)
      .submitAction(ticketId: ticketId, request: request);
  ref.invalidate(supportTicketDetailProvider(ticketId));
  await ref.read(supportTicketsProvider.notifier).refresh();
  await ref.read(supportSummaryProvider.notifier).refresh();
  return updated;
}

Future<SupportAccessGrant> createSupportAccessGrant({
  required WidgetRef ref,
  required SupportAccessGrantRequest request,
}) async {
  final grant = await ref
      .read(supportAccessGrantsRepositoryProvider)
      .createGrant(request);
  await ref.read(supportAccessGrantsProvider.notifier).refresh();
  await ref.read(supportSummaryProvider.notifier).refresh();
  return grant;
}

Future<SupportAccessGrant> revokeSupportAccessGrant({
  required WidgetRef ref,
  required String grantId,
  required SupportAccessGrantRequest request,
}) async {
  final grant = await ref
      .read(supportAccessGrantsRepositoryProvider)
      .revokeGrant(grantId: grantId, request: request);
  ref.invalidate(supportAccessGrantDetailProvider(grantId));
  await ref.read(supportAccessGrantsProvider.notifier).refresh();
  await ref.read(supportSummaryProvider.notifier).refresh();
  return grant;
}

Future<SupportTicket?> createSupportTicketFromSystemHealth({
  required WidgetRef ref,
  required String eventId,
  required String title,
  required String summary,
  String? companyId,
  String? companyName,
}) async {
  final repository = ref.read(supportTicketsRepositoryProvider);
  if (!repository.canCreateTicketFromSystemHealth) return null;

  final ticket = await repository.createTicketFromSystemHealthEvent(
    eventId: eventId,
    title: title,
    summary: summary,
    companyId: companyId,
    companyName: companyName,
  );
  if (ticket != null) {
    await ref.read(supportTicketsProvider.notifier).refresh();
    await ref.read(supportSummaryProvider.notifier).refresh();
  }
  return ticket;
}

String? mapSupportApiError(ApiException error) => error.messageKey;
