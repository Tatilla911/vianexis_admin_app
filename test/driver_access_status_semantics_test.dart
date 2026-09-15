import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/driver_access/domain/driver_access_profile.dart';

void main() {
  test('normalizes stored suspended/inactive to Disabled', () {
    expect(
      DriverRegistrationStatus.resolve(profileStatus: 'suspended'),
      DriverRegistrationStatus.disabled,
    );
    expect(
      DriverRegistrationStatus.resolve(profileStatus: 'inactive'),
      DriverRegistrationStatus.disabled,
    );
    expect(
      DriverRegistrationStatus.fromBackend('suspended'),
      DriverRegistrationStatus.disabled,
    );
  });

  test('does not invent Rejected as a driver status', () {
    expect(
      DriverRegistrationStatus.resolve(profileStatus: 'rejected'),
      isNot(DriverRegistrationStatus.disabled),
    );
    expect(
      DriverRegistrationStatus.values.contains(DriverRegistrationStatus.disabled),
      isTrue,
    );
  });

  test('fromJson prefers userStatus invited over profile status', () {
    final suspended = DriverAccessProfile.fromJson({
      'id': '1',
      'displayName': 'A',
      'companyName': 'C',
      'companyId': '9',
      'status': 'suspended',
    });
    expect(suspended.registrationStatus, DriverRegistrationStatus.disabled);

    final invited = DriverAccessProfile.fromJson({
      'id': '2',
      'displayName': 'B',
      'companyName': 'C',
      'companyId': '9',
      'status': 'active',
      'userStatus': 'invited',
    });
    expect(invited.registrationStatus, DriverRegistrationStatus.invited);
  });

  test('rejected is application-only and is not a driver row', () {
    expect(
      DriverAccessProfile.fromJson({
        'id': 'app-1',
        'displayName': 'Rejected Applicant',
        'status': 'rejected',
      }).registrationStatus,
      isNot(equals(DriverRegistrationStatus.disabled)),
    );
  });
}
