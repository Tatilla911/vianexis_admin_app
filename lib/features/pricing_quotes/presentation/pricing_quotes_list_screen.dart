import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../public_intakes/domain/public_intake.dart';
import '../../public_intakes/presentation/public_intakes_providers.dart';
import 'pricing_quotes_providers.dart';
import 'widgets/pricing_quote_card.dart';

class PricingQuotesListScreen extends ConsumerWidget {
  const PricingQuotesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(adminAuthProvider).user;
    final canRead = user?.role.canReadPricingQuotes ?? false;
    final canDecide = user?.role.canDecidePricingQuotes ?? false;
    final quotesAsync = ref.watch(pricingQuotesProvider);
    final intakesAsync = ref.watch(publicIntakesProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navPricingQuotes)),
      floatingActionButton: canDecide
          ? FloatingActionButton.extended(
              onPressed: () => _createFromIntake(context, ref),
              icon: const Icon(Icons.add),
              label: Text(l10n.pricingQuotesCreateFromIntake),
            )
          : null,
      body: !canRead
          ? VianexisErrorView(
              title: l10n.errorPermissionDeniedTitle,
              message: l10n.errorPermissionDeniedBody,
            )
          : quotesAsync.when(
              skipLoadingOnReload: true,
              skipLoadingOnRefresh: true,
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView.fromError(
                context,
                error,
                fallbackMessage: l10n.pricingQuotesLoadError,
                onRetry: () => ref.read(pricingQuotesProvider.notifier).refresh(),
              ),
              data: (quotes) {
                if (quotes.isEmpty) {
                  return RefreshIndicator(
                    onRefresh: () =>
                        ref.read(pricingQuotesProvider.notifier).refresh(),
                    child: ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.4,
                          child: Center(child: Text(l10n.pricingQuotesEmpty)),
                        ),
                      ],
                    ),
                  );
                }

                final intakes = intakesAsync.asData?.value ?? const [];
                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(pricingQuotesProvider.notifier).refresh(),
                  child: ListView.separated(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 88),
                    itemCount: quotes.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final quote = quotes[index];
                      return PricingQuoteCard(
                        quote: quote,
                        partyName: partyNameForQuote(
                          quote: quote,
                          intakes: intakes,
                        ),
                        onTap: () => context.push(
                          AdminRoutes.pricingQuoteDetail(quote.id.toString()),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
    );
  }

  Future<void> _createFromIntake(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final quotes = ref.read(pricingQuotesProvider).asData?.value ?? const [];
    await ref.read(publicIntakesProvider.notifier).refresh();
    if (!context.mounted) return;
    final intakesAsync = ref.read(publicIntakesProvider);
    if (intakesAsync.hasError) {
      final error = intakesAsync.error;
      if (error is ApiException) {
        showApiExceptionSnackBar(context, error);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pricingQuotesIntakeLoadError)));
      }
      return;
    }
    final eligible = eligibleQuoteIntakes(
      intakes: intakesAsync.asData?.value ?? const [],
      quotes: quotes,
    );
    if (eligible.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.pricingQuotesNoEligibleIntakes)),
      );
      return;
    }

    final selected = await showModalBottomSheet<({int id, String? reason})>(
      context: context,
      isScrollControlled: true,
      builder: (context) => _CreateFromIntakeSheet(intakes: eligible),
    );
    if (selected == null || !context.mounted) return;

    try {
      final created = await submitCreateQuoteFromIntake(
        ref,
        publicIntakeId: selected.id,
        reason: selected.reason,
      );
      if (!context.mounted) return;
      context.push(AdminRoutes.pricingQuoteDetail(created.id.toString()));
    } catch (error) {
      if (!context.mounted) return;
      if (error is ApiException) {
        showApiExceptionSnackBar(context, error);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pricingQuotesCreateError)));
      }
    }
  }
}

class _CreateFromIntakeSheet extends StatefulWidget {
  const _CreateFromIntakeSheet({required this.intakes});

  final List<PublicIntake> intakes;

  @override
  State<_CreateFromIntakeSheet> createState() => _CreateFromIntakeSheetState();
}

class _CreateFromIntakeSheetState extends State<_CreateFromIntakeSheet> {
  String? _selectedId;
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            l10n.pricingQuotesCreateFromIntake,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          DropdownButtonFormField<String>(
            initialValue: _selectedId,
            decoration: InputDecoration(
              labelText: l10n.pricingQuotesSelectIntake,
            ),
            items: [
              for (final intake in widget.intakes)
                DropdownMenuItem(
                  value: intake.id,
                  child: Text(
                    [
                      intake.companyName,
                      intake.customerName,
                      '#${intake.id}',
                    ].whereType<String>().where((v) => v.isNotEmpty).join(' · '),
                  ),
                ),
            ],
            onChanged: (value) => setState(() => _selectedId = value),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _reasonController,
            decoration: InputDecoration(
              labelText: l10n.pricingQuotesCreateReason,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton(
            onPressed: _selectedId == null
                ? null
                : () => Navigator.of(context).pop((
                    id: int.parse(_selectedId!),
                    reason: _reasonController.text.trim().isEmpty
                        ? null
                        : _reasonController.text.trim(),
                  )),
            child: Text(l10n.pricingQuotesCreateAction),
          ),
        ],
      ),
    );
  }
}
