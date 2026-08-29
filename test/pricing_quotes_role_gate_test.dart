import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/core/auth/admin_user.dart';
import 'package:vianexis_admin_app/features/pricing_quotes/domain/pricing_quote_review_flag.dart';
import 'package:vianexis_admin_app/features/pricing_quotes/presentation/pricing_quotes_providers.dart';

void main() {
  test('BILLING_READ roles can access pricing quotes', () {
    expect(
      AdminRole.superAdmin.canAccess(AdminDestination.pricingQuotes),
      isTrue,
    );
    expect(
      AdminRole.billingAdmin.canAccess(AdminDestination.pricingQuotes),
      isTrue,
    );
    expect(
      AdminRole.supportAdmin.canAccess(AdminDestination.pricingQuotes),
      isTrue,
    );
    expect(
      AdminRole.onboardingReviewer.canAccess(AdminDestination.pricingQuotes),
      isFalse,
    );
  });

  test('BILLING_DECIDE is limited to super_admin and billing_admin', () {
    expect(AdminRole.superAdmin.canDecidePricingQuotes, isTrue);
    expect(AdminRole.billingAdmin.canDecidePricingQuotes, isTrue);
    expect(AdminRole.supportAdmin.canDecidePricingQuotes, isFalse);
    expect(AdminRole.onboardingReviewer.canDecidePricingQuotes, isFalse);
  });

  test('PROVIDER_VALIDATION_PENDING blocks approval', () {
    expect(
      PricingQuoteReviewFlag.canApproveWithFlags([
        'PROVIDER_VALIDATION_PENDING',
      ]),
      isFalse,
    );
    expect(PricingQuoteReviewFlag.canApproveWithFlags(const []), isTrue);
  });
}
