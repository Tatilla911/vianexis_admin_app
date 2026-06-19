import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/system_health/domain/system_health_action_request.dart';

void main() {
  group('SystemHealthActionRequest', () {
    test('acknowledge json omits empty note', () {
      const request = SystemHealthActionRequest(
        type: SystemHealthActionType.acknowledge,
      );

      expect(request.toJson(), isEmpty);
      expect(request.endpointSuffix(), 'acknowledge');
      expect(request.httpMethod(), 'PATCH');
    });

    test('acknowledge json includes optional note', () {
      const request = SystemHealthActionRequest(
        type: SystemHealthActionType.acknowledge,
        note: 'Reviewed on call',
      );

      expect(request.toJson(), {'note': 'Reviewed on call'});
    });

    test('escalate json includes note and uses POST endpoint', () {
      const request = SystemHealthActionRequest(
        type: SystemHealthActionType.escalate,
        note: 'Needs infra team',
      );

      expect(request.toJson(), {'note': 'Needs infra team'});
      expect(request.endpointSuffix(), 'escalate');
      expect(request.httpMethod(), 'POST');
    });
  });
}
