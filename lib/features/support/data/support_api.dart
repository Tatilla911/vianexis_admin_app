import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/localization/localization_keys.dart';
import '../domain/support_access_grant.dart';
import '../domain/support_access_grant_request.dart';
import '../domain/support_ticket.dart';
import '../domain/support_ticket_action_request.dart';

class SupportApi {
  SupportApi(this._apiClient);

  final ApiClient _apiClient;

  Future<List<SupportTicket>> listTickets({int limit = 200}) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/support-tickets',
      queryParameters: {'limit': limit},
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(messageKey: LocalizationKeys.supportLoadError);
    }

    final items = data['items'];
    if (items is! List) return const [];

    return items
        .whereType<Map>()
        .map((item) => SupportTicket.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  Future<SupportTicket> getTicket(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/support-tickets/$id',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(messageKey: LocalizationKeys.supportLoadError);
    }

    final ticketJson = data['ticket'] ?? data;
    if (ticketJson is Map<String, dynamic>) {
      return SupportTicket.fromJson(ticketJson);
    }
    if (ticketJson is Map) {
      return SupportTicket.fromJson(Map<String, dynamic>.from(ticketJson));
    }
    throw const ApiException(messageKey: LocalizationKeys.supportLoadError);
  }

  Future<void> submitTicketAction({
    required String ticketId,
    required SupportTicketActionRequest request,
  }) async {
    await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/support-tickets/$ticketId/${request.endpointSuffix()}',
      data: request.toJson(),
    );
  }

  Future<List<SupportAccessGrant>> listGrants({int limit = 200}) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/support-access-grants',
      queryParameters: {'status': 'all', 'limit': limit},
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(messageKey: LocalizationKeys.supportLoadError);
    }

    final items = data['items'];
    if (items is! List) return const [];

    return items
        .whereType<Map>()
        .map((item) => SupportAccessGrant.fromJson(Map<String, dynamic>.from(item)))
        .toList(growable: false);
  }

  Future<SupportAccessGrant> getGrant(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/support-access-grants/$id',
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(messageKey: LocalizationKeys.supportLoadError);
    }

    final grantJson = data['grant'] ?? data;
    if (grantJson is Map<String, dynamic>) {
      return SupportAccessGrant.fromJson(grantJson);
    }
    if (grantJson is Map) {
      return SupportAccessGrant.fromJson(Map<String, dynamic>.from(grantJson));
    }
    throw const ApiException(messageKey: LocalizationKeys.supportLoadError);
  }

  Future<SupportAccessGrant> createGrant(SupportAccessGrantRequest request) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/support-access-grants',
      data: request.toJson(),
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(messageKey: LocalizationKeys.supportActionError);
    }

    final items = data['items'];
    if (items is List && items.isNotEmpty) {
      final first = items.first;
      if (first is Map<String, dynamic>) {
        return SupportAccessGrant.fromJson(first);
      }
      if (first is Map) {
        return SupportAccessGrant.fromJson(Map<String, dynamic>.from(first));
      }
    }

    final grantJson = data['grant'] ?? data;
    if (grantJson is Map<String, dynamic>) {
      return SupportAccessGrant.fromJson(grantJson);
    }
    if (grantJson is Map) {
      return SupportAccessGrant.fromJson(Map<String, dynamic>.from(grantJson));
    }

    throw const ApiException(messageKey: LocalizationKeys.supportActionError);
  }

  Future<void> revokeGrant({
    required String grantId,
    required SupportAccessGrantRequest request,
  }) async {
    await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/support-access-grants/$grantId/revoke',
      data: request.toJson(),
    );
  }

  Future<SupportTicket> createTicketFromHealthEvent({
    required String eventId,
    required String note,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/platform-admin/system-health/events/$eventId/create-support-ticket',
      data: {'note': note.trim()},
    );
    final data = response.data;
    if (data == null) {
      throw const ApiException(messageKey: LocalizationKeys.supportActionError);
    }

    final ticketJson = data['ticket'] ?? data;
    if (ticketJson is Map<String, dynamic>) {
      return SupportTicket.fromJson(ticketJson);
    }
    if (ticketJson is Map) {
      return SupportTicket.fromJson(Map<String, dynamic>.from(ticketJson));
    }
    throw const ApiException(messageKey: LocalizationKeys.supportActionError);
  }
}

final supportApiProvider = Provider<SupportApi>((ref) {
  return SupportApi(ref.watch(apiClientProvider));
});
