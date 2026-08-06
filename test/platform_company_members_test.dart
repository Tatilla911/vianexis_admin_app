import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/companies/domain/platform_company_member.dart';

void main() {
  group('PlatformCompanyMember JSON parsing', () {
    test('parses member list page with email and roles', () {
      final page = PlatformCompanyMembersPage.fromJson({
        'companyId': 42,
        'items': [
          {
            'membershipId': 7,
            'userId': 7,
            'companyId': 42,
            'displayName': 'Ada Lovelace',
            'firstName': null,
            'lastName': null,
            'email': 'ada@example.com',
            'phone': '+361234567',
            'primaryRole': 'company_owner',
            'additionalRoles': ['finance'],
            'status': 'active',
            'invitationStatus': 'none',
            'emailDeliveryStatus': null,
            'joinedAt': '2026-01-02T10:00:00.000Z',
            'lastLoginAt': '2026-08-01T08:15:00.000Z',
            'driverProfileId': null,
            'createdAt': '2026-01-02T10:00:00.000Z',
            'updatedAt': '2026-08-01T08:15:00.000Z',
          },
          {
            'membershipId': 8,
            'userId': 8,
            'companyId': 42,
            'displayName': '',
            'email': 'docs@example.com',
            'primaryRole': 'documentation',
            'additionalRoles': [],
            'status': 'invited',
            'invitationStatus': 'pending',
            'emailDeliveryStatus': 'sent',
            'joinedAt': '2026-07-01T00:00:00.000Z',
            'lastLoginAt': null,
            'driverProfileId': null,
            'createdAt': '2026-07-01T00:00:00.000Z',
            'updatedAt': '2026-07-01T00:00:00.000Z',
          },
        ],
        'total': 2,
        'limit': 50,
        'offset': 0,
        'metadataOnly': false,
      });

      expect(page.companyId, '42');
      expect(page.total, 2);
      expect(page.metadataOnly, isFalse);
      expect(page.items, hasLength(2));

      final owner = page.items.first;
      expect(owner.membershipId, '7');
      expect(owner.email, 'ada@example.com');
      expect(owner.primaryRole, 'company_owner');
      expect(owner.additionalRoles, ['finance']);
      expect(owner.listDisplayName, 'Ada Lovelace');
      expect(owner.lastLoginAt, isNotNull);
      expect(owner.hasInvitationStatus, isFalse);

      final invited = page.items.last;
      expect(invited.listDisplayName, 'docs@example.com');
      expect(invited.primaryRole, 'documentation');
      expect(invited.hasInvitationStatus, isTrue);
      expect(invited.invitationStatus, 'pending');
    });

    test('role filter matches owners and other', () {
      const owner = PlatformCompanyMember(
        membershipId: '1',
        userId: '1',
        companyId: '1',
        email: 'o@ex.com',
        primaryRole: 'company_admin',
      );
      const finance = PlatformCompanyMember(
        membershipId: '2',
        userId: '2',
        companyId: '1',
        email: 'f@ex.com',
        primaryRole: 'finance',
      );

      expect(
        PlatformCompanyMemberRoleFilter.owners.matches(owner),
        isTrue,
      );
      expect(
        PlatformCompanyMemberRoleFilter.other.matches(finance),
        isTrue,
      );
      expect(
        PlatformCompanyMemberRoleFilter.drivers.matches(owner),
        isFalse,
      );
      expect(
        platformCompanyMemberRoleL10nKey('claims_insurance'),
        'platformCompanyRoleClaimsInsurance',
      );
      expect(
        platformCompanyMemberRoleL10nKey('finance'),
        'platformCompanyRoleFinance',
      );
    });
  });
}
