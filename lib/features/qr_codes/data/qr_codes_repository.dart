import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../domain/platform_qr_code.dart';
import 'qr_codes_api.dart';

abstract class QrCodesRepository {
  Future<List<PlatformQrCode>> list({
    String? entityType,
    int? entityId,
    String? purpose,
  });

  Future<PlatformQrCode> create(CreatePlatformQrRequest request);

  Future<PlatformQrCode> send(int id, SendPlatformQrRequest request);

  Future<PlatformQrCode> revoke(int id);

  Future<PlatformQrCode> regenerate(int id);

  bool get usesMockData;
}

class LiveQrCodesRepository implements QrCodesRepository {
  LiveQrCodesRepository(this._api);

  final QrCodesApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<List<PlatformQrCode>> list({
    String? entityType,
    int? entityId,
    String? purpose,
  }) async {
    final raw = await _api.list(
      entityType: entityType,
      entityId: entityId,
      purpose: purpose,
    );
    final items = (raw['items'] as List<dynamic>? ?? const [])
        .whereType<Map>()
        .map((e) => PlatformQrCode.fromJson(Map<String, dynamic>.from(e)))
        .toList();
    return items;
  }

  @override
  Future<PlatformQrCode> create(CreatePlatformQrRequest request) async {
    final raw = await _api.create(request.toJson());
    return PlatformQrCode.fromJson(raw);
  }

  @override
  Future<PlatformQrCode> send(int id, SendPlatformQrRequest request) async {
    final raw = await _api.send(id, request.toJson());
    return PlatformQrCode.fromJson(raw);
  }

  @override
  Future<PlatformQrCode> revoke(int id) async {
    final raw = await _api.revoke(id);
    return PlatformQrCode.fromJson(raw);
  }

  @override
  Future<PlatformQrCode> regenerate(int id) async {
    final raw = await _api.regenerate(id);
    return PlatformQrCode.fromJson(raw);
  }
}

class MockQrCodesRepository implements QrCodesRepository {
  final List<PlatformQrCode> _items = [];

  @override
  bool get usesMockData => true;

  @override
  Future<List<PlatformQrCode>> list({
    String? entityType,
    int? entityId,
    String? purpose,
  }) async {
    return _items
        .where(
          (item) =>
              (entityType == null || item.entityType == entityType) &&
              (entityId == null || item.entityId == entityId) &&
              (purpose == null || item.purpose == purpose),
        )
        .toList();
  }

  @override
  Future<PlatformQrCode> create(CreatePlatformQrRequest request) async {
    final hasEmail =
        request.notifyEmail != null && request.notifyEmail!.trim().isNotEmpty;
    final created = PlatformQrCode(
      id: _items.length + 1,
      entityType: request.entityType,
      entityId: request.entityId,
      displayName: request.displayName,
      status: 'active',
      purpose: request.purpose,
      expiresAt: DateTime.now().toUtc().add(const Duration(hours: 24)),
      maxUses: request.maxUses ?? 1,
      usedCount: 0,
      resolveUrl: 'https://vianexis.eu/q/mock-${_items.length + 1}',
      opaqueCode: 'mock-opaque-${_items.length + 1}',
      environment: 'staging',
      secure: true,
      createdAt: DateTime.now().toUtc(),
      emailDelivery: hasEmail
          ? const QrEmailDelivery(
              sent: false,
              skipped: true,
              status: 'provider_not_configured',
              statusReason: 'Email provider is not configured in mock mode.',
            )
          : null,
    );
    _items.insert(0, created);
    return created;
  }

  @override
  Future<PlatformQrCode> send(int id, SendPlatformQrRequest request) async {
    final index = _items.indexWhere((e) => e.id == id);
    if (index < 0) {
      throw StateError('QR not found');
    }
    final current = _items[index];
    final updated = current.copyWith(
      emailDelivery: const QrEmailDelivery(
        sent: false,
        skipped: true,
        status: 'provider_not_configured',
        statusReason: 'Email provider is not configured in mock mode.',
      ),
    );
    _items[index] = updated;
    return updated;
  }

  @override
  Future<PlatformQrCode> revoke(int id) async {
    final index = _items.indexWhere((e) => e.id == id);
    if (index < 0) {
      throw StateError('QR not found');
    }
    final current = _items[index];
    final updated = current.copyWith(
      status: 'revoked',
      revokedAt: DateTime.now().toUtc(),
    );
    _items[index] = updated;
    return updated;
  }

  @override
  Future<PlatformQrCode> regenerate(int id) async {
    await revoke(id);
    final previous = _items.firstWhere((e) => e.id == id);
    return create(
      CreatePlatformQrRequest(
        entityType: previous.entityType,
        entityId: previous.entityId,
        displayName: previous.displayName,
        purpose: previous.purpose ?? QrPurpose.supportReference.apiValue,
      ),
    );
  }
}

final qrCodesRepositoryProvider = Provider<QrCodesRepository>((ref) {
  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LiveQrCodesRepository(ref.watch(qrCodesApiProvider));
  }
  return MockQrCodesRepository();
});
