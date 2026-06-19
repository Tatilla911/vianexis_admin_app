import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/support/domain/support_access_grant.dart';
import 'package:vianexis_admin_app/features/support/domain/support_access_grant_status.dart';
import 'package:vianexis_admin_app/features/support/domain/support_access_scope_type.dart';
import 'package:vianexis_admin_app/features/support/domain/support_ticket.dart';
import 'package:vianexis_admin_app/features/support/domain/support_ticket_priority.dart';
import 'package:vianexis_admin_app/features/support/domain/support_ticket_status.dart';

void main() {
  group('SupportTicketStatus', () {
    test('parses backend values', () {
      expect(SupportTicketStatus.fromBackendValue('open'), SupportTicketStatus.open);
      expect(SupportTicketStatus.fromBackendValue('in_progress'), SupportTicketStatus.investigating);
      expect(SupportTicketStatus.fromBackendValue('waiting_on_customer'),
          SupportTicketStatus.waitingForCustomer);
      expect(SupportTicketStatus.fromBackendValue('closed'), SupportTicketStatus.closed);
    });
  });

  group('SupportTicketPriority', () {
    test('parses backend values', () {
      expect(SupportTicketPriority.fromBackendValue('urgent'), SupportTicketPriority.urgent);
      expect(SupportTicketPriority.fromBackendValue('critical'), SupportTicketPriority.critical);
    });
  });

  group('SupportAccessScopeType', () {
    test('parses backend values', () {
      expect(
        SupportAccessScopeType.fromBackendValue('system_health_issue'),
        SupportAccessScopeType.systemHealthIssue,
      );
      expect(SupportAccessScopeType.specificTrip.requiresScopeId, isTrue);
    });
  });

  group('SupportAccessGrantStatus', () {
    test('derives status from backend fields', () {
      expect(
        SupportAccessGrantStatus.derive(
          revokedAt: DateTime.utc(2026, 6, 18),
          expiresAt: DateTime.utc(2026, 6, 19),
          isActive: true,
        ),
        SupportAccessGrantStatus.revoked,
      );
    });
  });

  group('SupportTicket', () {
    test('parses list item json', () {
      final ticket = SupportTicket.fromJson({
        'id': 801,
        'companyId': 12,
        'subject': 'Upload queue stalled',
        'descriptionSummary': 'Metadata only summary',
        'status': 'open',
        'priority': 'urgent',
        'category': 'upload_issue',
        'createdAt': '2026-06-18T07:00:00.000Z',
        'updatedAt': '2026-06-18T08:30:00.000Z',
      });

      expect(ticket.id, '801');
      expect(ticket.title, 'Upload queue stalled');
      expect(ticket.summary, 'Metadata only summary');
      expect(ticket.priority, SupportTicketPriority.urgent);
      expect(ticket.category, SupportTicketCategory.uploadIssue);
    });

    test('matches filters and search', () {
      const ticket = SupportTicket(
        id: '1',
        title: 'Redis issue',
        summary: 'Queue down',
        status: SupportTicketStatus.open,
        priority: SupportTicketPriority.critical,
        category: SupportTicketCategory.systemHealth,
        companyName: 'NordTrans Kft.',
        requestedByEmail: 'anna@example.com',
      );

      expect(ticket.matchesFilter(SupportTicketListFilter.critical), isTrue);
      expect(ticket.matchesSearch('nordtrans'), isTrue);
    });
  });

  group('SupportAccessGrant', () {
    test('parses backend grant json', () {
      final grant = SupportAccessGrant.fromJson({
        'id': 901,
        'companyId': 12,
        'grantedByUserId': 1,
        'scope': ['portal_dashboard', 'audit'],
        'documentsAllowed': false,
        'reason': 'Investigate health metadata',
        'expiresAt': DateTime.now().toUtc().add(const Duration(hours: 2)).toIso8601String(),
        'createdAt': '2026-06-18T08:00:00.000Z',
        'isActive': true,
        'metadata': {'scopeType': 'system_health_issue', 'scopeId': '501'},
      });

      expect(grant.id, '901');
      expect(grant.scopeType, SupportAccessScopeType.systemHealthIssue);
      expect(grant.scopeId, '501');
      expect(grant.excludesSensitiveDocuments, isTrue);
      expect(grant.status, SupportAccessGrantStatus.active);
    });
  });
}
