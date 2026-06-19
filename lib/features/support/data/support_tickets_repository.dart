import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/support_ticket.dart';
import '../domain/support_ticket_action_request.dart';
import '../domain/support_ticket_priority.dart';
import '../domain/support_ticket_status.dart';
import 'support_api.dart';
import '../../system_health/data/system_health_api.dart';

abstract class SupportTicketsRepository {
  Future<List<SupportTicket>> fetchTickets();

  Future<SupportTicket> fetchTicket(String id);

  Future<SupportTicket> submitAction({
    required String ticketId,
    required SupportTicketActionRequest request,
  });

  Future<SupportTicket?> createTicketFromSystemHealthEvent({
    required String eventId,
    required String title,
    required String summary,
    String? companyId,
    String? companyName,
  });

  bool get usesMockData;

  bool get canCreateTicketFromSystemHealth;
}

class LiveSupportTicketsRepository implements SupportTicketsRepository {
  LiveSupportTicketsRepository(this._api, {SystemHealthApi? systemHealthApi})
    : _systemHealthApi = systemHealthApi;

  final SupportApi _api;
  final SystemHealthApi? _systemHealthApi;
  List<SupportTicket>? _cachedTickets;

  @override
  bool get usesMockData => false;

  @override
  bool get canCreateTicketFromSystemHealth =>
      _systemHealthApi?.eventsEndpointAvailable ?? false;

  @override
  Future<List<SupportTicket>> fetchTickets() async {
    final tickets = await _api.listTickets();
    _cachedTickets = tickets;
    return tickets;
  }

  @override
  Future<SupportTicket> fetchTicket(String id) async {
    try {
      return await _api.getTicket(id);
    } on ApiException catch (error) {
      if (error.kind != ApiExceptionKind.notFound) rethrow;
      final cached = _cachedTickets;
      if (cached != null) {
        return cached.firstWhere(
          (ticket) => ticket.id == id,
          orElse: () => throw error,
        );
      }
      rethrow;
    }
  }

  @override
  Future<SupportTicket> submitAction({
    required String ticketId,
    required SupportTicketActionRequest request,
  }) async {
    try {
      await _api.submitTicketAction(ticketId: ticketId, request: request);
    } on ApiException catch (error) {
      if (error.kind == ApiExceptionKind.notFound) {
        throw const ApiException(
          messageKey: LocalizationKeys.supportActionUnavailable,
          kind: ApiExceptionKind.notFound,
        );
      }
      rethrow;
    }

    final updated = await fetchTicket(ticketId);
    return switch (request.type) {
      SupportTicketActionType.acknowledge => updated.copyWith(
        status: SupportTicketStatus.acknowledged,
        lastActivityAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
      SupportTicketActionType.close => updated.copyWith(
        status: SupportTicketStatus.closed,
        lastActivityAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    };
  }

  @override
  Future<SupportTicket?> createTicketFromSystemHealthEvent({
    required String eventId,
    required String title,
    required String summary,
    String? companyId,
    String? companyName,
  }) async {
    if (!canCreateTicketFromSystemHealth) return null;

    try {
      return await _api.createTicketFromHealthEvent(
        eventId: eventId,
        note: summary.trim().isNotEmpty ? summary : title,
      );
    } on ApiException catch (error) {
      if (error.kind == ApiExceptionKind.notFound) {
        throw const ApiException(
          messageKey: LocalizationKeys.supportActionUnavailable,
          kind: ApiExceptionKind.notFound,
        );
      }
      rethrow;
    }
  }
}

class MockSupportTicketsRepository implements SupportTicketsRepository {
  MockSupportTicketsRepository();

  late List<SupportTicket> _tickets = _buildTickets();

  @override
  bool get usesMockData => true;

  @override
  bool get canCreateTicketFromSystemHealth => true;

  @override
  Future<List<SupportTicket>> fetchTickets() async {
    await Future<void>.delayed(const Duration(milliseconds: 250));
    return _tickets;
  }

  @override
  Future<SupportTicket> fetchTicket(String id) async {
    await Future<void>.delayed(const Duration(milliseconds: 150));
    return _tickets.firstWhere(
      (ticket) => ticket.id == id,
      orElse: () => throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      ),
    );
  }

  @override
  Future<SupportTicket> submitAction({
    required String ticketId,
    required SupportTicketActionRequest request,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final index = _tickets.indexWhere((ticket) => ticket.id == ticketId);
    if (index < 0) {
      throw const ApiException(
        messageKey: LocalizationKeys.errorGenericBody,
        kind: ApiExceptionKind.notFound,
      );
    }

    final current = _tickets[index];
    final updated = switch (request.type) {
      SupportTicketActionType.acknowledge => current.copyWith(
        status: SupportTicketStatus.acknowledged,
        lastActivityAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
      SupportTicketActionType.close => current.copyWith(
        status: SupportTicketStatus.closed,
        lastActivityAt: DateTime.now().toUtc(),
        updatedAt: DateTime.now().toUtc(),
      ),
    };

    final next = [..._tickets];
    next[index] = updated;
    _tickets = next;
    return updated;
  }

  @override
  Future<SupportTicket?> createTicketFromSystemHealthEvent({
    required String eventId,
    required String title,
    required String summary,
    String? companyId,
    String? companyName,
  }) async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    final ticket = SupportTicket(
      id: '${900 + _tickets.length}',
      companyId: companyId,
      companyName: companyName,
      title: title,
      summary: summary,
      status: SupportTicketStatus.open,
      priority: SupportTicketPriority.high,
      category: SupportTicketCategory.systemHealth,
      linkedSystemHealthEventId: eventId,
      createdAt: DateTime.now().toUtc(),
      updatedAt: DateTime.now().toUtc(),
      lastActivityAt: DateTime.now().toUtc(),
      metadataOnly: {'source': 'system_health', 'eventId': eventId},
    );
    _tickets = [ticket, ..._tickets];
    return ticket;
  }

  static List<SupportTicket> _buildTickets() {
    return [
      SupportTicket(
        id: '801',
        companyId: '12',
        companyName: 'NordTrans Kft.',
        requestedByUserId: '44',
        requestedByName: 'Anna Kovács',
        requestedByEmail: 'anna@nordtrans.example',
        title: 'Upload queue stalled',
        summary: 'Document upload metadata checks failing. No file content included.',
        status: SupportTicketStatus.open,
        priority: SupportTicketPriority.urgent,
        category: SupportTicketCategory.uploadIssue,
        createdAt: DateTime.utc(2026, 6, 18, 7, 0),
        updatedAt: DateTime.utc(2026, 6, 18, 8, 30),
        lastActivityAt: DateTime.utc(2026, 6, 18, 8, 30),
        metadataOnly: const {'queue': 'upload_validation'},
      ),
      SupportTicket(
        id: '802',
        companyId: '12',
        companyName: 'NordTrans Kft.',
        requestedByUserId: '44',
        requestedByName: 'Anna Kovács',
        requestedByEmail: 'anna@nordtrans.example',
        title: 'Redis queue unavailable',
        summary: 'Platform health event escalated to support.',
        status: SupportTicketStatus.investigating,
        priority: SupportTicketPriority.critical,
        category: SupportTicketCategory.systemHealth,
        linkedSystemHealthEventId: '501',
        hasSupportAccessGrant: true,
        supportAccessGrantId: '901',
        createdAt: DateTime.utc(2026, 6, 18, 6, 0),
        updatedAt: DateTime.utc(2026, 6, 18, 9, 0),
        lastActivityAt: DateTime.utc(2026, 6, 18, 9, 0),
        metadataOnly: const {'linkedEvent': '501'},
      ),
      SupportTicket(
        id: '803',
        companyId: '15',
        companyName: 'Baltic Freight OÜ',
        requestedByUserId: '51',
        requestedByName: 'Marko Tamm',
        requestedByEmail: 'marko@baltic.example',
        title: 'Billing entitlement mismatch',
        summary: 'Subscription metadata does not match portal entitlement flags.',
        status: SupportTicketStatus.waitingForCustomer,
        priority: SupportTicketPriority.normal,
        category: SupportTicketCategory.billing,
        createdAt: DateTime.utc(2026, 6, 17, 14, 0),
        updatedAt: DateTime.utc(2026, 6, 18, 5, 0),
        lastActivityAt: DateTime.utc(2026, 6, 18, 5, 0),
      ),
    ];
  }
}

final supportTicketsRepositoryProvider = Provider<SupportTicketsRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  if (apiClient.isConfigured) {
    return LiveSupportTicketsRepository(
      ref.watch(supportApiProvider),
      systemHealthApi: ref.watch(systemHealthApiProvider),
    );
  }
  return MockSupportTicketsRepository();
});
