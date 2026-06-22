import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Local device PIN — protects admin app UI on shared devices only.
/// Does not replace backend authentication.
class AdminDevicePinService {
  AdminDevicePinService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  static const minPinLength = 4;
  static const maxPinLength = 8;
  static const _pinKey = 'admin_device_pin_value';

  final FlutterSecureStorage _storage;

  Future<bool> hasPin() async {
    final value = await _storage.read(key: _pinKey);
    return value != null && value.isNotEmpty;
  }

  Future<void> setPin(String pin) async {
    _assertValidPin(pin);
    await _storage.write(key: _pinKey, value: pin);
  }

  Future<bool> verifyPin(String pin) async {
    final stored = await _storage.read(key: _pinKey);
    return stored != null && stored == pin;
  }

  Future<bool> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    if (!await verifyPin(currentPin)) {
      return false;
    }
    await setPin(newPin);
    return true;
  }

  Future<void> removePin({required String currentPin}) async {
    if (!await verifyPin(currentPin)) {
      throw AdminDevicePinException.invalidCurrentPin;
    }
    await _storage.delete(key: _pinKey);
  }

  void _assertValidPin(String pin) {
    if (pin.length < minPinLength || pin.length > maxPinLength) {
      throw AdminDevicePinException.invalidLength;
    }
    if (!RegExp(r'^\d+$').hasMatch(pin)) {
      throw AdminDevicePinException.nonNumeric;
    }
  }

  Future<void> resetForTesting() async {
    await _storage.delete(key: _pinKey);
  }
}

enum AdminDevicePinException {
  invalidLength,
  nonNumeric,
  mismatch,
  invalidCurrentPin,
}

final adminDevicePinServiceProvider = Provider<AdminDevicePinService>((ref) {
  return AdminDevicePinService();
});
