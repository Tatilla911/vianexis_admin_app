import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_decision_request.dart';

void main() {
  group('RegistrationDecisionRequest', () {
    test('approve json omits empty notes', () {
      final request = RegistrationDecisionRequest(
        type: RegistrationDecisionType.approve,
        reviewNotes: '  ',
      );

      expect(request.toJson(), isEmpty);
      expect(request.endpointSuffix(), 'approve');
    });

    test('reject json includes review notes', () {
      final request = RegistrationDecisionRequest(
        type: RegistrationDecisionType.reject,
        reviewNotes: 'Incomplete documentation',
      );

      expect(
        request.toJson(),
        {'reviewNotes': 'Incomplete documentation'},
      );
      expect(request.endpointSuffix(), 'reject');
    });

    test('request info json includes review notes', () {
      final request = RegistrationDecisionRequest(
        type: RegistrationDecisionType.requestInfo,
        reviewNotes: 'Need VAT certificate',
        aiReviewSummary: 'Applicant missing VAT proof',
      );

      expect(
        request.toJson(),
        {
          'reviewNotes': 'Need VAT certificate',
          'aiReviewSummary': 'Applicant missing VAT proof',
        },
      );
      expect(request.endpointSuffix(), 'request-info');
    });
  });
}
