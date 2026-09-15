import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/global_search/data/platform_admin_search_api.dart';
import 'package:vianexis_admin_app/features/global_search/domain/platform_admin_search_models.dart';
import 'package:vianexis_admin_app/features/global_search/presentation/global_search_sheet.dart';

void main() {
  group('PlatformAdminSearchResultType.fromBackend', () {
    test('maps each extended backend type', () {
      expect(
        PlatformAdminSearchResultType.fromBackend('company'),
        PlatformAdminSearchResultType.company,
      );
      expect(
        PlatformAdminSearchResultType.fromBackend('registration_application'),
        PlatformAdminSearchResultType.registration,
      );
      expect(
        PlatformAdminSearchResultType.fromBackend('driver'),
        PlatformAdminSearchResultType.driver,
      );
      expect(
        PlatformAdminSearchResultType.fromBackend('trip'),
        PlatformAdminSearchResultType.trip,
      );
      expect(
        PlatformAdminSearchResultType.fromBackend('document'),
        PlatformAdminSearchResultType.document,
      );
      expect(
        PlatformAdminSearchResultType.fromBackend('truck'),
        PlatformAdminSearchResultType.vehicle,
      );
      expect(
        PlatformAdminSearchResultType.fromBackend('trailer'),
        PlatformAdminSearchResultType.trailer,
      );
      expect(
        PlatformAdminSearchResultType.fromBackend('site'),
        PlatformAdminSearchResultType.site,
      );
      expect(
        PlatformAdminSearchResultType.fromBackend('audit_event'),
        PlatformAdminSearchResultType.auditEvent,
      );
    });
  });

  group('fromGroupedHits order', () {
    test('orders extended groups stably', () {
      final response = PlatformAdminSearchResponse.fromGroupedHits(
        query: 'x',
        hits: const [
          PlatformAdminSearchHit(
            id: 'a',
            type: PlatformAdminSearchResultType.auditEvent,
            title: 'evt',
          ),
          PlatformAdminSearchHit(
            id: '1',
            type: PlatformAdminSearchResultType.company,
            title: 'co',
          ),
          PlatformAdminSearchHit(
            id: 't',
            type: PlatformAdminSearchResultType.vehicle,
            title: 'truck',
          ),
        ],
      );
      expect(
        response.groups.map((g) => g.type).toList(),
        [
          PlatformAdminSearchResultType.company,
          PlatformAdminSearchResultType.vehicle,
          PlatformAdminSearchResultType.auditEvent,
        ],
      );
    });
  });

  group('bounded mock', () {
    test('100k drivers returns at most group limit', () async {
      final repo = BoundedMockPlatformAdminSearchRepository(
        driverCount: 100000,
        limit: 8,
      );
      final response = await repo.search('Driver');
      expect(response.total, lessThanOrEqualTo(8));
      expect(response.groups.single.items.length, lessThanOrEqualTo(8));
    });
  });

  group('query gate', () {
    test('allows length>=2 or pure numeric', () {
      expect(isGlobalSearchQueryRunnable('a'), isFalse);
      expect(isGlobalSearchQueryRunnable('ab'), isTrue);
      expect(isGlobalSearchQueryRunnable('7'), isTrue);
      expect(isGlobalSearchQueryRunnable('42'), isTrue);
    });
  });
}
