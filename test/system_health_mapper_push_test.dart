import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/system_health/data/system_health_mapper.dart';
import 'package:vianexis_admin_app/features/system_health/domain/system_health_service_status.dart';
import 'package:vianexis_admin_app/features/system_health/domain/system_health_severity.dart';

void main() {
  group('SystemHealthMapper push mapping', () {
    test('does not warn on websocket-disabled alone', () {
      final snapshot = SystemHealthMapper.fromHealthResponse({
        'components': [
          {
            'component': 'messaging',
            'severity': 'warning',
            'detailSummary': 'ws=disabled',
          },
        ],
        'recentEvents': [],
        'infra': {
          'websocketEnabled': false,
          'websocketMode': 'disabled',
          'notificationFailures': 0,
          'pushQueueDepth': 0,
          'redis': {'enabled': true, 'connected': true, 'status': 'ok'},
          'worker': {
            'notificationPush': {
              'enabled': true,
              'lastRunAt': '2026-09-20T10:00:00.000Z',
              'lastProcessed': 3,
              'lastError': null,
              'pendingEstimate': 0,
            },
            'messageEscalation': {
              'lastRunAt': '2026-09-20T10:00:00.000Z',
              'lastError': null,
            },
          },
        },
      });

      final push = snapshot.services.firstWhere(
        (s) => s.serviceKey == SystemHealthServiceKey.pushNotificationService,
      );
      expect(push.severity, SystemHealthSeverity.info);
      expect(push.summary, isNot(contains('ws=')));
      expect(push.recommendedAction, isNull);
    });

    test('surfaces actionable push worker error details', () {
      final snapshot = SystemHealthMapper.fromHealthResponse({
        'components': [],
        'recentEvents': [],
        'infra': {
          'websocketEnabled': true,
          'websocketMode': 'local',
          'notificationFailures': 2,
          'pushQueueDepth': 12,
          'redis': {'enabled': true, 'connected': true, 'status': 'ok'},
          'worker': {
            'notificationPush': {
              'enabled': true,
              'lastRunAt': '2026-09-20T09:00:00.000Z',
              'lastProcessed': 0,
              'lastError': 'provider_unreachable',
              'pendingEstimate': 12,
            },
            'messageEscalation': {'lastError': null},
          },
        },
      });

      final push = snapshot.services.firstWhere(
        (s) => s.serviceKey == SystemHealthServiceKey.pushNotificationService,
      );
      expect(push.severity, SystemHealthSeverity.critical);
      expect(push.lastError, 'provider_unreachable');
      expect(push.currentState, 'error');
      expect(push.affectedPlatform, 'android,ios');
      expect(push.recommendedAction, isNotNull);
      expect(push.detailFields['queueDepth'], '12');
      expect(push.detailFields.values.join(), isNot(contains('token')));
    });
  });
}
