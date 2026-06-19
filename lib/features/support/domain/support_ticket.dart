import 'support_access_grant.dart';
import 'support_access_grant_status.dart';
import 'support_ticket_priority.dart';
import 'support_ticket_status.dart';

enum SupportTicketCategory {
  registration,
  systemHealth,
  uploadIssue,
  billing,
  access,
  integration,
  other,
  unknown;

  static SupportTicketCategory fromBackendValue(String? raw) {
    if (raw == null || raw.trim().isEmpty) return other;
    return switch (raw.trim().toLowerCase()) {
      'registration' => registration,
      'system_health' => systemHealth,
      'upload_issue' => uploadIssue,
      'billing' => billing,
      'access' => access,
      'integration' => integration,
      'other' => other,
      _ => unknown,
    };
  }

  String localizationKey() {
    return switch (this) {
      SupportTicketCategory.registration => 'supportTicketCategoryRegistration',
      SupportTicketCategory.systemHealth => 'supportTicketCategorySystemHealth',
      SupportTicketCategory.uploadIssue => 'supportTicketCategoryUploadIssue',
      SupportTicketCategory.billing => 'supportTicketCategoryBilling',
      SupportTicketCategory.access => 'supportTicketCategoryAccess',
      SupportTicketCategory.integration => 'supportTicketCategoryIntegration',
      SupportTicketCategory.other => 'supportTicketCategoryOther',
      SupportTicketCategory.unknown => 'supportTicketCategoryUnknown',
    };
  }
}

enum SupportTicketListFilter {
  all,
  open,
  urgent,
  critical,
  systemHealth,
  waitingForCustomer,
  resolved,
}

extension SupportTicketListFilterX on SupportTicketListFilter {
  String localizationKey() {
    return switch (this) {
      SupportTicketListFilter.all => 'supportTicketFilterAll',
      SupportTicketListFilter.open => 'supportTicketFilterOpen',
      SupportTicketListFilter.urgent => 'supportTicketFilterUrgent',
      SupportTicketListFilter.critical => 'supportTicketFilterCritical',
      SupportTicketListFilter.systemHealth => 'supportTicketFilterSystemHealth',
      SupportTicketListFilter.waitingForCustomer => 'supportTicketFilterWaitingForCustomer',
      SupportTicketListFilter.resolved => 'supportTicketFilterResolved',
    };
  }
}

class SupportTicket {
  const SupportTicket({
    required this.id,
    this.companyId,
    this.companyName,
    this.requestedByUserId,
    this.requestedByName,
    this.requestedByEmail,
    required this.title,
    required this.summary,
    required this.status,
    required this.priority,
    required this.category,
    this.createdAt,
    this.updatedAt,
    this.lastActivityAt,
    this.linkedSystemHealthEventId,
    this.metadataOnly = const {},
    this.hasSupportAccessGrant = false,
    this.supportAccessGrantId,
  });

  final String id;
  final String? companyId;
  final String? companyName;
  final String? requestedByUserId;
  final String? requestedByName;
  final String? requestedByEmail;
  final String title;
  final String summary;
  final SupportTicketStatus status;
  final SupportTicketPriority priority;
  final SupportTicketCategory category;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final DateTime? lastActivityAt;
  final String? linkedSystemHealthEventId;
  final Map<String, dynamic> metadataOnly;
  final bool hasSupportAccessGrant;
  final String? supportAccessGrantId;

  bool matchesSearch(String query) {
    final normalized = query.trim().toLowerCase();
    if (normalized.isEmpty) return true;
    return [
      companyName,
      title,
      requestedByEmail,
      requestedByName,
    ].whereType<String>().any((value) => value.toLowerCase().contains(normalized));
  }

  bool matchesFilter(SupportTicketListFilter filter) {
    return switch (filter) {
      SupportTicketListFilter.all => true,
      SupportTicketListFilter.open => status.isOpenLike,
      SupportTicketListFilter.urgent => priority == SupportTicketPriority.urgent,
      SupportTicketListFilter.critical => priority == SupportTicketPriority.critical,
      SupportTicketListFilter.systemHealth =>
        category == SupportTicketCategory.systemHealth,
      SupportTicketListFilter.waitingForCustomer =>
        status == SupportTicketStatus.waitingForCustomer,
      SupportTicketListFilter.resolved =>
        status == SupportTicketStatus.resolved || status == SupportTicketStatus.closed,
    };
  }

  factory SupportTicket.fromJson(Map<String, dynamic> json) {
    final metadata = _asMap(json['metadataOnly'] ?? json['metadata']);

    return SupportTicket(
      id: json['id']?.toString() ?? '',
      companyId: json['companyId']?.toString(),
      companyName: json['companyName']?.toString(),
      requestedByUserId: (json['requestedByUserId'] ?? json['reporterUserId'])?.toString(),
      requestedByName: json['requestedByName']?.toString(),
      requestedByEmail: json['requestedByEmail']?.toString(),
      title: json['title']?.toString() ?? json['subject']?.toString() ?? '—',
      summary: json['summary']?.toString() ??
          json['descriptionSummary']?.toString() ??
          '—',
      status: SupportTicketStatus.fromBackendValue(json['status']?.toString()),
      priority: SupportTicketPriority.fromBackendValue(json['priority']?.toString()),
      category: SupportTicketCategory.fromBackendValue(json['category']?.toString()),
      createdAt: _parseDate(json['createdAt']),
      updatedAt: _parseDate(json['updatedAt']),
      lastActivityAt: _parseDate(
        json['lastActivityAt'] ?? json['updatedAt'] ?? json['createdAt'],
      ),
      linkedSystemHealthEventId: (json['linkedSystemHealthEventId'] ??
              metadata['linkedSystemHealthEventId'])
          ?.toString(),
      metadataOnly: metadata,
      hasSupportAccessGrant: json['hasSupportAccessGrant'] == true ||
          json['supportAccessGrantId'] != null,
      supportAccessGrantId: json['supportAccessGrantId']?.toString(),
    );
  }

  SupportTicket copyWith({
    SupportTicketStatus? status,
    DateTime? updatedAt,
    DateTime? lastActivityAt,
    bool? hasSupportAccessGrant,
    String? supportAccessGrantId,
  }) {
    return SupportTicket(
      id: id,
      companyId: companyId,
      companyName: companyName,
      requestedByUserId: requestedByUserId,
      requestedByName: requestedByName,
      requestedByEmail: requestedByEmail,
      title: title,
      summary: summary,
      status: status ?? this.status,
      priority: priority,
      category: category,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      lastActivityAt: lastActivityAt ?? this.lastActivityAt,
      linkedSystemHealthEventId: linkedSystemHealthEventId,
      metadataOnly: metadataOnly,
      hasSupportAccessGrant: hasSupportAccessGrant ?? this.hasSupportAccessGrant,
      supportAccessGrantId: supportAccessGrantId ?? this.supportAccessGrantId,
    );
  }

  static Map<String, dynamic> _asMap(Object? raw) {
    if (raw is Map<String, dynamic>) return raw;
    if (raw is Map) return Map<String, dynamic>.from(raw);
    return const {};
  }

  static DateTime? _parseDate(Object? raw) {
    if (raw == null) return null;
    if (raw is DateTime) return raw;
    return DateTime.tryParse(raw.toString());
  }
}

class SupportSummary {
  const SupportSummary({
    required this.openTicketsCount,
    required this.urgentCriticalTicketsCount,
    required this.activeSupportAccessGrantsCount,
    this.lastUpdatedAt,
  });

  final int openTicketsCount;
  final int urgentCriticalTicketsCount;
  final int activeSupportAccessGrantsCount;
  final DateTime? lastUpdatedAt;

  factory SupportSummary.fromTicketsAndGrants({
    required List<SupportTicket> tickets,
    required List<SupportAccessGrant> grants,
  }) {
    var open = 0;
    var urgentCritical = 0;
    for (final ticket in tickets) {
      if (ticket.status.isOpenLike) open++;
      if (ticket.priority.isUrgentLike && ticket.status.isOpenLike) {
        urgentCritical++;
      }
    }

    final activeGrants = grants
        .where((grant) => grant.status == SupportAccessGrantStatus.active)
        .length;

    return SupportSummary(
      openTicketsCount: open,
      urgentCriticalTicketsCount: urgentCritical,
      activeSupportAccessGrantsCount: activeGrants,
      lastUpdatedAt: DateTime.now().toUtc(),
    );
  }
}
