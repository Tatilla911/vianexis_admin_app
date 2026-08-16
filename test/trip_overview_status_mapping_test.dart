import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/trips_overview/domain/trip_overview_item.dart';

void main() {
  group('mapTripOverviewStatus', () {
    test('keeps exact backend active as active', () {
      expect(mapTripOverviewStatus('active'), TripOverviewStatus.active);
      expect(normalizeTripCanonicalStatus('active'), 'active');
    });

    test('does not collapse completion_pending to active', () {
      expect(
        mapTripOverviewStatus('completion_pending'),
        isNot(TripOverviewStatus.active),
      );
      expect(
        mapTripOverviewStatus('completion_pending'),
        TripOverviewStatus.unknown,
      );
      expect(
        normalizeTripCanonicalStatus('completion_pending'),
        'completion_pending',
      );
    });

    test('does not collapse in_progress, assigned, or unknown to active', () {
      expect(mapTripOverviewStatus('in_progress'), TripOverviewStatus.unknown);
      expect(mapTripOverviewStatus('assigned'), TripOverviewStatus.unknown);
      expect(
        mapTripOverviewStatus('pending_acceptance'),
        TripOverviewStatus.unknown,
      );
      expect(mapTripOverviewStatus('future_status'), TripOverviewStatus.unknown);
      expect(mapTripOverviewStatus(''), TripOverviewStatus.unknown);
      expect(mapTripOverviewStatus(null), TripOverviewStatus.unknown);
    });

    test('does not collapse cancelled or deleted to active', () {
      expect(mapTripOverviewStatus('cancelled'), TripOverviewStatus.unknown);
      expect(normalizeTripCanonicalStatus('cancelled'), 'cancelled');
      expect(mapTripOverviewStatus('deleted'), TripOverviewStatus.unknown);
      expect(normalizeTripCanonicalStatus('deleted'), 'deleted');
    });

    test('keeps exact backend completed as completed', () {
      expect(mapTripOverviewStatus('completed'), TripOverviewStatus.completed);
      expect(normalizeTripCanonicalStatus('completed'), 'completed');
    });

    test('fromJson preserves canonical diagnostic status', () {
      final item = TripOverviewItem.fromJson({
        'id': '9',
        'reference': 'TR-9',
        'companyName': 'Acme',
        'driverName': 'Ada',
        'status': 'completion_pending',
      });
      expect(item.status, isNot(TripOverviewStatus.active));
      expect(item.canonicalStatus, 'completion_pending');
      expect(
        tripOverviewDiagnosticStatusLabel(
          status: item.status,
          canonicalStatus: item.canonicalStatus,
          resolve: (key) => key,
        ),
        'completion_pending',
      );
    });
  });
}
