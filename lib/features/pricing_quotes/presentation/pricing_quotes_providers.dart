import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/admin_user.dart';
import '../../billing/presentation/billing_providers.dart';
import '../../public_intakes/domain/public_intake.dart';
import '../../public_intakes/domain/public_intake_type.dart';
import '../data/pricing_quotes_repository.dart';
import '../domain/pricing_quote.dart';
import '../domain/pricing_quote_status.dart';

extension AdminRolePricingQuotes on AdminRole {
  bool get canReadPricingQuotes => canAccess(AdminDestination.pricingQuotes);

  bool get canDecidePricingQuotes => canChangeBillingStatus;
}

final pricingQuotesProvider =
    AsyncNotifierProvider<PricingQuotesNotifier, List<PricingQuoteListItem>>(
      PricingQuotesNotifier.new,
    );

class PricingQuotesNotifier
    extends AsyncNotifier<List<PricingQuoteListItem>> {
  @override
  Future<List<PricingQuoteListItem>> build() => _load();

  Future<List<PricingQuoteListItem>> _load() {
    return ref.read(pricingQuotesRepositoryProvider).fetchQuotes();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<PricingQuoteListItem>>();
    state = await AsyncValue.guard(_load);
  }
}

final pricingQuoteDetailProvider = FutureProvider.autoDispose
    .family<PricingQuoteDetail, int>((ref, id) {
      return ref.watch(pricingQuotesRepositoryProvider).fetchQuote(id);
    });

class PricingQuotesDashboardSummary {
  const PricingQuotesDashboardSummary({
    required this.reviewRequiredCount,
    required this.newCount,
  });

  final int reviewRequiredCount;
  final int newCount;

  int get actionableCount => reviewRequiredCount + newCount;
}

final pricingQuotesDashboardSummaryProvider =
    Provider<AsyncValue<PricingQuotesDashboardSummary>>((ref) {
      return ref.watch(pricingQuotesProvider).whenData((items) {
        final reviewRequired = items
            .where((item) => item.status == PricingQuoteStatus.reviewRequired)
            .length;
        final newCount = items
            .where(
              (item) =>
                  item.status == PricingQuoteStatus.draft ||
                  item.status == PricingQuoteStatus.calculated,
            )
            .length;
        return PricingQuotesDashboardSummary(
          reviewRequiredCount: reviewRequired,
          newCount: newCount,
        );
      });
    });

List<PublicIntake> eligibleQuoteIntakes({
  required List<PublicIntake> intakes,
  required List<PricingQuoteListItem> quotes,
}) {
  final usedIntakeIds = quotes
      .map((quote) => quote.publicIntakeId?.toString())
      .whereType<String>()
      .toSet();
  return intakes
      .where((intake) => intake.type == PublicIntakeType.quoteRequest)
      .where((intake) => !usedIntakeIds.contains(intake.id))
      .toList(growable: false);
}

String? partyNameForQuote({
  required PricingQuoteListItem quote,
  List<PublicIntake> intakes = const [],
}) {
  if (quote.publicIntakeId != null) {
    for (final intake in intakes) {
      if (intake.id == quote.publicIntakeId.toString()) {
        final company = intake.companyName?.trim();
        if (company != null && company.isNotEmpty) return company;
        final customer = intake.customerName?.trim();
        if (customer != null && customer.isNotEmpty) return customer;
      }
    }
  }
  return null;
}

Future<PricingQuoteListItem> submitCreateQuoteFromIntake(
  WidgetRef ref, {
  required int publicIntakeId,
  String? reason,
}) async {
  final created = await ref
      .read(pricingQuotesRepositoryProvider)
      .createFromIntake(publicIntakeId: publicIntakeId, reason: reason);
  await ref.read(pricingQuotesProvider.notifier).refresh();
  return created;
}

Future<PricingQuoteListItem> submitRecalculateQuote(
  WidgetRef ref, {
  required int quoteId,
  required String reason,
}) async {
  final updated = await ref
      .read(pricingQuotesRepositoryProvider)
      .recalculate(id: quoteId, reason: reason);
  ref.invalidate(pricingQuoteDetailProvider(quoteId));
  await ref.read(pricingQuotesProvider.notifier).refresh();
  return updated;
}

Future<PricingQuoteListItem> submitQuoteAdjustment(
  WidgetRef ref, {
  required int quoteId,
  required PricingQuoteAdjustmentRequest request,
}) async {
  final updated = await ref
      .read(pricingQuotesRepositoryProvider)
      .applyAdjustment(id: quoteId, request: request);
  ref.invalidate(pricingQuoteDetailProvider(quoteId));
  await ref.read(pricingQuotesProvider.notifier).refresh();
  return updated;
}

Future<PricingQuoteListItem> submitApproveQuote(
  WidgetRef ref, {
  required int quoteId,
}) async {
  final updated = await ref
      .read(pricingQuotesRepositoryProvider)
      .approve(quoteId);
  ref.invalidate(pricingQuoteDetailProvider(quoteId));
  await ref.read(pricingQuotesProvider.notifier).refresh();
  return updated;
}

Future<PricingQuoteListItem> submitQuoteStatus(
  WidgetRef ref, {
  required int quoteId,
  required PricingQuoteStatus status,
}) async {
  final updated = await ref
      .read(pricingQuotesRepositoryProvider)
      .updateStatus(id: quoteId, status: status);
  ref.invalidate(pricingQuoteDetailProvider(quoteId));
  await ref.read(pricingQuotesProvider.notifier).refresh();
  return updated;
}
