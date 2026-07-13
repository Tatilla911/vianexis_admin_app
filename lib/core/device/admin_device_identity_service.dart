import 'dart:io' show Platform;
import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Stable per-install device identity for backend session binding.
class AdminDeviceIdentityService {
  AdminDeviceIdentityService({FlutterSecureStorage? storage})
    : _storage = storage ?? const FlutterSecureStorage();

  static const deviceIdKey = 'vianexis_admin_device_id';
  static const appType = 'platform_admin_app';
  static const deviceName = 'ViaNexis Admin';

  final FlutterSecureStorage _storage;
  String? _cachedDeviceId;

  Future<String> getOrCreateDeviceId() async {
    if (_cachedDeviceId != null) return _cachedDeviceId!;
    final stored = await _storage.read(key: deviceIdKey);
    if (stored != null && stored.trim().isNotEmpty) {
      _cachedDeviceId = stored.trim();
      return _cachedDeviceId!;
    }
    final created = _generateUuidV4();
    await _storage.write(key: deviceIdKey, value: created);
    _cachedDeviceId = created;
    return created;
  }

  String resolvePlatform() {
    if (kIsWeb) return 'unknown';
    if (Platform.isAndroid) return 'android';
    if (Platform.isIOS) return 'ios';
    if (Platform.isMacOS) return 'desktop';
    return 'unknown';
  }

  static String _generateUuidV4() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (_) => random.nextInt(256));
    bytes[6] = (bytes[6] & 0x0f) | 0x40;
    bytes[8] = (bytes[8] & 0x3f) | 0x80;
    String hex(int value) => value.toRadixString(16).padLeft(2, '0');
    final b = bytes.map(hex).join();
    return '${b.substring(0, 8)}-${b.substring(8, 12)}-'
        '${b.substring(12, 16)}-${b.substring(16, 20)}-${b.substring(20)}';
  }
}

final adminDeviceIdentityServiceProvider = Provider<AdminDeviceIdentityService>(
  (ref) => AdminDeviceIdentityService(),
);
