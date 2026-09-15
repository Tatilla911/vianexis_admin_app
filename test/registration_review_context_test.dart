import 'package:flutter_test/flutter_test.dart';

import 'package:vianexis_admin_app/features/registrations/domain/registration_application.dart';
import 'package:vianexis_admin_app/features/registrations/domain/registration_review_context.dart';
import 'package:vianexis_admin_app/core/api/api_error_mapping.dart';
import 'package:vianexis_admin_app/core/localization/localization_keys.dart';

void main() {
  group('RegistrationApplication detail review context', () {
    test('parses assessment, commercial review, risk and eligibility', () {
      final app = RegistrationApplication.fromDetailResponseJson({
        'application': {
          'id': 7,
          'companyName': 'ViaNexis Transport',
          'contactEmail': 'ops@example.com',
          'status': 'pending',
          'needsHumanReview': true,
        },
        'assessment': {
          'id': 3,
          'status': 'submitted',
          'version': 1,
          'submittedAt': '2026-08-30T10:00:00.000Z',
          'approvalReady': true,
          'blockingReason': null,
          'sections': ['companyOfficial', 'companySize', 'operations'],
        },
        'commercialReview': {
          'pricingStatus': 'SUGGESTION_AVAILABLE',
          'assessmentId': 3,
          'quoteId': null,
          'pricingIntakeId': null,
          'suggestion': {
            'kind': 'suggestion',
            'notFinal': true,
            'suggestedPackage': 'starter',
            'monthly': {'net': 149},
            'oneTime': {'net': 250},
            'inputs': {
              'modules': ['trips', 'documents'],
            },
          },
          'missingPricingFields': [],
          'engineQuoteLinked': false,
          'noteKey': 'registration.commercial.suggestionAvailable',
        },
        'riskResolution': {
          'status': 'UNRESOLVED',
          'reasonCode': 'AI_REVIEW_NOT_AVAILABLE',
          'reasonMessageKey': 'registration.risk.notEvaluable',
        },
        'approvalEligibility': {
          'canApprove': true,
          'blockers': [],
          'existingCompanyId': null,
          'quoteRequiredForRegistrationApproval': false,
        },
        'aiReviews': [],
      });

      expect(app.assessment?.approvalReady, isTrue);
      expect(app.commercialReview?.pricingStatus,
          RegistrationCommercialPricingStatus.suggestionAvailable);
      expect(app.commercialReview?.monthlyNet, '149');
      expect(app.riskResolution?.isUnresolved, isTrue);
      expect(app.canApproveFromServer, isTrue);
    });

    test('blocks approve when membership exists', () {
      final app = RegistrationApplication.fromDetailResponseJson({
        'application': {
          'id': 7,
          'companyName': 'ViaNexis Transport',
          'contactEmail': 'ops@example.com',
          'status': 'pending',
        },
        'approvalEligibility': {
          'canApprove': false,
          'blockers': [
            {
              'code': 'MEMBERSHIP_ALREADY_EXISTS',
              'messageKey': 'registration.membershipAlreadyExists',
            },
          ],
          'existingCompanyId': 12,
          'quoteRequiredForRegistrationApproval': false,
        },
      });
      expect(app.canApproveFromServer, isFalse);
      expect(app.approvalEligibility?.blockers.first.code,
          'MEMBERSHIP_ALREADY_EXISTS');
    });
  });

  group('registration approve error mapping', () {
    test('maps MEMBERSHIP_ALREADY_EXISTS to dedicated key', () {
      expect(
        apiExceptionMessageKeyForStatus(
          statusCode: 409,
          path: '/platform-admin/registration-applications/7/approve',
          responseData: const {
            'errorCode': 'MEMBERSHIP_ALREADY_EXISTS',
          },
        ),
        LocalizationKeys.registrationMembershipAlreadyExists,
      );
    });

    test('maps REGISTRATION_ALREADY_PROCESSED', () {
      expect(
        apiExceptionMessageKeyForStatus(
          statusCode: 409,
          path: '/platform-admin/registration-applications/7/approve',
          responseData: const {
            'errorCode': 'REGISTRATION_ALREADY_PROCESSED',
          },
        ),
        LocalizationKeys.registrationAlreadyProcessed,
      );
    });
  });
}
