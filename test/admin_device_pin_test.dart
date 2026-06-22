import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/security/admin_device_pin_service.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    FlutterSecureStorage.setMockInitialValues({});
  });

  test('set, change, and remove PIN happy path', () async {
    final service = AdminDevicePinService();

    expect(await service.hasPin(), isFalse);
    await service.setPin('1234');
    expect(await service.hasPin(), isTrue);
    expect(await service.verifyPin('1234'), isTrue);

    final changed = await service.changePin(currentPin: '1234', newPin: '5678');
    expect(changed, isTrue);
    expect(await service.verifyPin('5678'), isTrue);

    await service.removePin(currentPin: '5678');
    expect(await service.hasPin(), isFalse);
  });

  test('invalid PIN length throws', () async {
    final service = AdminDevicePinService();
    expect(
      () => service.setPin('12'),
      throwsA(isA<AdminDevicePinException>()),
    );
  });

  test('change PIN rejects wrong current PIN', () async {
    final service = AdminDevicePinService();
    await service.setPin('1234');
    final ok = await service.changePin(currentPin: '9999', newPin: '5678');
    expect(ok, isFalse);
  });
}
