import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/app_config.dart';
import '../domain/public_intake.dart';
import '../domain/public_intake_status.dart';
import '../domain/public_intake_type.dart';
import 'public_intakes_api.dart';

abstract class PublicIntakesRepository {
  Future<List<PublicIntake>> fetchIntakes();

  Future<PublicIntake> fetchIntake(String id);

  Future<PublicIntake> updateStatus({
    required String intakeId,
    required PublicIntakeStatus status,
    String? reason,
  });

  bool get usesMockData;
}

class LivePublicIntakesRepository implements PublicIntakesRepository {
  LivePublicIntakesRepository(this._api);

  final PublicIntakesApi _api;

  @override
  bool get usesMockData => false;

  @override
  Future<List<PublicIntake>> fetchIntakes() async {
    final page = await _api.listIntakes(limit: 200);
    return page.items;
  }

  @override
  Future<PublicIntake> fetchIntake(String id) => _api.getIntake(id);

  @override
  Future<PublicIntake> updateStatus({
    required String intakeId,
    required PublicIntakeStatus status,
    String? reason,
  }) {
    return _api.updateStatus(
      intakeId: intakeId,
      status: status,
      reason: reason,
    );
  }
}

class MockPublicIntakesRepository implements PublicIntakesRepository {
  MockPublicIntakesRepository();

  final List<PublicIntake> _items = [
    PublicIntake(
      id: '1',
      type: PublicIntakeType.quoteRequest,
      sourceLocale: 'hu',
      preferredLanguage: 'hu',
      messageOriginalLanguage: 'hu',
      status: PublicIntakeStatus.newStatus,
      customerName: 'Kovács Anna',
      customerEmailDomain: 'example.com',
      companyName: 'NordTrans Kft.',
      country: 'HU',
      messageOriginalText: '20 teherautóra kérek árajánlatot.',
      fleetSize: 20,
      officeUsers: 4,
      driverApps: 20,
      requestedModules: const ['cmr', 'billing'],
      linkedCustomerCommunicationThreadId: '501',
      consentPrivacy: true,
      consentVersion: '2026-06',
      createdAt: DateTime.utc(2026, 6, 18, 10),
    ),
    PublicIntake(
      id: '2',
      type: PublicIntakeType.demoRequest,
      sourceLocale: 'en',
      preferredLanguage: 'en',
      messageOriginalLanguage: 'en',
      status: PublicIntakeStatus.reviewing,
      customerName: 'John Smith',
      customerEmailDomain: 'logistics.example',
      country: 'DE',
      messageOriginalText: 'We would like a pilot demo next week.',
      linkedCustomerCommunicationThreadId: '502',
      consentPrivacy: true,
      createdAt: DateTime.utc(2026, 6, 17, 14),
    ),
  ];

  @override
  bool get usesMockData => true;

  @override
  Future<List<PublicIntake>> fetchIntakes() async => List.unmodifiable(_items);

  @override
  Future<PublicIntake> fetchIntake(String id) async {
    return _items.firstWhere(
      (item) => item.id == id,
      orElse: () => throw StateError('Public intake not found'),
    );
  }

  @override
  Future<PublicIntake> updateStatus({
    required String intakeId,
    required PublicIntakeStatus status,
    String? reason,
  }) async {
    final index = _items.indexWhere((item) => item.id == intakeId);
    if (index < 0) throw StateError('Public intake not found');
    final updated = PublicIntake(
      id: _items[index].id,
      type: _items[index].type,
      sourceLocale: _items[index].sourceLocale,
      preferredLanguage: _items[index].preferredLanguage,
      messageOriginalLanguage: _items[index].messageOriginalLanguage,
      status: status,
      customerName: _items[index].customerName,
      customerEmailDomain: _items[index].customerEmailDomain,
      companyName: _items[index].companyName,
      country: _items[index].country,
      messageOriginalText: _items[index].messageOriginalText,
      linkedCustomerCommunicationThreadId:
          _items[index].linkedCustomerCommunicationThreadId,
      consentPrivacy: _items[index].consentPrivacy,
      consentVersion: _items[index].consentVersion,
      createdAt: _items[index].createdAt,
      metadataOnly: false,
    );
    _items[index] = updated;
    return updated;
  }
}

final publicIntakesRepositoryProvider = Provider<PublicIntakesRepository>((ref) {
  if (AppConfig.instance.shouldUseLiveRepositories) {
    return LivePublicIntakesRepository(ref.watch(publicIntakesApiProvider));
  }
  return MockPublicIntakesRepository();
});
