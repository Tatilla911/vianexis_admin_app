import 'package:flutter_test/flutter_test.dart';

import 'package:vianexis_admin_app/features/qr_codes/domain/platform_qr_code.dart';

void main() {
  test('PlatformQrCode.fromJson maps secure create response', () {
    final code = PlatformQrCode.fromJson({
      'id': 12,
      'entityType': 'user',
      'entityId': 9,
      'displayName': 'admin@vianexis.eu',
      'status': 'active',
      'purpose': 'user_invite',
      'expiresAt': '2026-08-03T12:00:00.000Z',
      'maxUses': 1,
      'usedCount': 0,
      'resolveUrl': 'https://vianexis.eu/q/abc',
      'opaqueCode': 'abc',
      'environment': 'staging',
      'secure': true,
    });
    expect(code.id, 12);
    expect(code.purpose, 'user_invite');
    expect(code.displayPayload, 'https://vianexis.eu/q/abc');
    expect(code.secure, isTrue);
    expect(QrPurpose.tryParse(code.purpose), QrPurpose.userInvite);
  });

  test('CreatePlatformQrRequest serializes purpose fields', () {
    final body = const CreatePlatformQrRequest(
      entityType: 'company',
      entityId: 3,
      displayName: 'Acme',
      purpose: 'company_invite',
      companyId: 3,
      expiresInSeconds: 86400,
    ).toJson();
    expect(body['purpose'], 'company_invite');
    expect(body['expiresInSeconds'], 86400);
    expect(body.containsKey('token'), isFalse);
  });

  test('CreatePlatformQrRequest includes notifyEmail when set', () {
    final body = const CreatePlatformQrRequest(
      entityType: 'company',
      entityId: 3,
      displayName: 'Acme Logistics',
      purpose: 'company_invite',
      notifyEmail: 'invitee@example.com',
      preferredLanguage: 'hu',
      inviteeName: 'Jane Doe',
    ).toJson();
    expect(body['notifyEmail'], 'invitee@example.com');
    expect(body['preferredLanguage'], 'hu');
    expect(body['inviteeName'], 'Jane Doe');
  });

  test('PlatformQrCode.fromJson maps emailDelivery honesty fields', () {
    final code = PlatformQrCode.fromJson({
      'id': 12,
      'entityType': 'company',
      'entityId': 3,
      'displayName': 'Acme',
      'status': 'active',
      'purpose': 'company_invite',
      'resolveUrl': 'https://vianexis.eu/q/abc',
      'emailDelivery': {
        'sent': false,
        'skipped': true,
        'status': 'provider_not_configured',
        'statusReason': 'No provider',
      },
    });
    expect(code.emailDelivery?.sent, isFalse);
    expect(code.emailDelivery?.skipped, isTrue);
    expect(code.emailDelivery?.status, 'provider_not_configured');
    expect(code.emailDelivery?.isDeliveryDisabled, isTrue);
    expect(code.emailDelivery?.isSent, isFalse);
  });
}
