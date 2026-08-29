import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../../public_intakes/domain/public_intake.dart';
import '../../public_intakes/presentation/public_intakes_providers.dart';
import '../domain/pricing_quote.dart';
import '../domain/pricing_quote_adjustment_type.dart';
import '../domain/pricing_quote_status.dart';
import 'pricing_quote_l10n.dart';
import 'pricing_quotes_providers.dart';

class PricingQuoteDetailScreen extends ConsumerWidget {
  const PricingQuoteDetailScreen({super.key, required this.quoteId});

  final String quoteId;

  int? get _id => int.tryParse(quoteId);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final id = _id;
    final user = ref.watch(adminAuthProvider).user;
    final canRead = user?.role.canReadPricingQuotes ?? false;
    final canDecide = user?.role.canDecidePricingQuotes ?? false;

    if (!canRead) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.navPricingQuotes)),
        body: VianexisErrorView(
          title: l10n.errorPermissionDeniedTitle,
          message: l10n.errorPermissionDeniedBody,
        ),
      );
    }

    if (id == null) {
      return Scaffold(
        appBar: AppBar(title: Text(l10n.navPricingQuotes)),
        body: VianexisErrorView(
          title: l10n.errorGenericTitle,
          message: l10n.pricingQuotesDetailError,
        ),
      );
    }

    final detailAsync = ref.watch(pricingQuoteDetailProvider(id));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navPricingQuotes)),
      body: detailAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: l10n.pricingQuotesDetailError,
          onRetry: () => ref.invalidate(pricingQuoteDetailProvider(id)),
        ),
        data: (quote) {
          final intakes =
              ref.watch(publicIntakesProvider).asData?.value ?? const [];
          PublicIntake? intake;
          if (quote.publicIntakeId != null) {
            for (final item in intakes) {
              if (item.id == quote.publicIntakeId.toString()) {
                intake = item;
                break;
              }
            }
          }
          return _QuoteDetailBody(
            quote: quote,
            intake: intake,
            canDecide: canDecide,
          );
        },
      ),
    );
  }
}

class _QuoteDetailBody extends ConsumerWidget {
  const _QuoteDetailBody({
    required this.quote,
    required this.canDecide,
    this.intake,
  });

  final PricingQuoteDetail quote;
  final PublicIntake? intake;
  final bool canDecide;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    final calc = quote.currentCalculation;
    final created = quote.createdAt == null
        ? l10n.pricingQuoteValueUnavailable
        : DateFormat.yMMMd(locale).add_Hm().format(quote.createdAt!.toLocal());
    final party =
        intake?.companyName?.trim().isNotEmpty == true
        ? intake!.companyName!
        : intake?.customerName?.trim().isNotEmpty == true
        ? intake!.customerName!
        : quote.companyId != null
        ? l10n.pricingQuoteCompanyId(quote.companyId.toString())
        : l10n.pricingQuoteUnknownParty;
    final contact = [
      intake?.customerName,
      intake?.customerEmailDomain,
    ].whereType<String>().where((value) => value.trim().isNotEmpty).join(' · ');
    final providerPending = quote.hasProviderValidationPending;
    final approveEnabled = canDecide && quote.canApprove;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(quote.publicReference, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            Chip(
              label: Text(
                '${pricingQuoteStatusLabel(l10n, quote.status)} (${quote.statusRaw})',
              ),
            ),
            Chip(
              label: Text(
                l10n.pricingQuoteRevisionLabel(quote.currentRevisionNumber.toString()),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        if (providerPending)
          Card(
            color: Theme.of(context).colorScheme.errorContainer,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(
                    Icons.gpp_maybe_outlined,
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      l10n.pricingQuoteFlagProviderValidationPending,
                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: Theme.of(context).colorScheme.onErrorContainer,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        if (providerPending) const SizedBox(height: 16),
        _section(context, l10n.pricingQuoteSectionIdentity),
        _field(context, l10n.pricingQuoteFieldCompany, party),
        if (contact.isNotEmpty)
          _field(context, l10n.pricingQuoteFieldContact, contact),
        _field(context, l10n.pricingQuoteFieldCreated, created),
        _field(
          context,
          l10n.pricingQuoteFieldQuestionnaireVersion,
          quote.questionnaireVersion,
        ),
        _field(
          context,
          l10n.pricingQuoteFieldPricingConfigVersion,
          quote.pricingConfigVersion,
        ),
        _field(
          context,
          l10n.pricingQuoteFieldRollout,
          formatPricingQuoteNumber(calc['licenseBasis'] ?? calc['rollout']),
        ),
        _field(
          context,
          l10n.pricingQuoteFieldLicences,
          formatPricingQuoteNumber(calc['operationalLicences']),
        ),
        _field(
          context,
          l10n.pricingQuoteFieldModules,
          _stringList(calc['paidModules']),
        ),
        const SizedBox(height: 16),
        _section(context, l10n.pricingQuoteSectionNormalizedInputs),
        _mapBlock(context, _asMap(calc['normalizedPricingInputs'])),
        if (_asMap(calc['normalizedPricingInputs']).isEmpty) ...[
          _field(
            context,
            l10n.pricingQuoteFieldLicenseBasis,
            formatPricingQuoteNumber(calc['licenseBasis']),
          ),
          _field(
            context,
            l10n.pricingQuoteFieldUsageItems,
            _stringList(calc['usageLineItems']),
          ),
        ],
        const SizedBox(height: 16),
        _section(context, l10n.pricingQuoteSectionRecurring),
        _field(
          context,
          l10n.pricingQuoteFieldRecurringTotal,
          formatPricingQuoteMoney(context, quote.recurringTotalNet),
        ),
        _mapMoneyBlock(context, _asMap(calc['recurringBreakdown'])),
        const SizedBox(height: 16),
        _section(context, l10n.pricingQuoteSectionSetup),
        _field(
          context,
          l10n.pricingQuoteFieldSetupTotal,
          formatPricingQuoteMoney(context, quote.oneTimeTotalNet),
        ),
        _mapMoneyBlock(context, _asMap(calc['oneTimeBreakdown'])),
        const SizedBox(height: 16),
        _section(context, l10n.pricingQuoteSectionDirectCosts),
        _field(
          context,
          l10n.pricingQuoteFieldDirectCost,
          formatPricingQuoteMoney(
            context,
            calc['directCostNet']?.toString(),
          ),
        ),
        _field(
          context,
          l10n.pricingQuoteFieldDirectContribution,
          '${formatPricingQuoteMoney(context, calc['directContributionNet']?.toString())} (${formatPricingQuoteNumber(calc['directContributionPercent'])}%)',
        ),
        _field(
          context,
          l10n.pricingQuoteFieldConfidence,
          pricingQuoteConfidenceLabel(l10n, quote.confidence),
        ),
        const SizedBox(height: 16),
        _section(context, l10n.pricingQuoteSectionFlags),
        if (quote.reviewFlags.isEmpty)
          Text(l10n.pricingQuoteNoFlags)
        else
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final flag in quote.reviewFlags)
                Chip(
                  label: Text(
                    '${pricingQuoteFlagLabel(l10n, flag)} ($flag)',
                  ),
                ),
            ],
          ),
        const SizedBox(height: 16),
        _section(context, l10n.pricingQuoteSectionRevisions),
        if (quote.revisions.isEmpty)
          Text(l10n.pricingQuoteNoRevisions)
        else
          for (final revision in quote.revisions)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                l10n.pricingQuoteRevisionLabel(revision.revisionNumber.toString()),
              ),
              subtitle: Text(
                [
                  if (revision.calculatedAt != null)
                    DateFormat.yMMMd(locale)
                        .add_Hm()
                        .format(revision.calculatedAt!.toLocal()),
                  if (revision.reason != null && revision.reason!.isNotEmpty)
                    revision.reason,
                  l10n.pricingQuoteRevisionReadOnly,
                ].join(' · '),
              ),
            ),
        const SizedBox(height: 16),
        _section(context, l10n.pricingQuoteSectionAdjustments),
        if (quote.adjustments.isEmpty)
          Text(l10n.pricingQuoteNoAdjustments)
        else
          for (final adjustment in quote.adjustments)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(
                '${pricingQuoteAdjustmentTypeLabel(l10n, adjustment.type)} (${adjustment.typeRaw})',
              ),
              subtitle: Text(
                [
                  if (adjustment.percent != null)
                    l10n.pricingQuoteAdjustmentPercent(
                      adjustment.percent!.toStringAsFixed(1),
                    ),
                  if (adjustment.amountNet != null)
                    formatPricingQuoteMoney(
                      context,
                      adjustment.amountNet.toString(),
                    ),
                  adjustment.reason,
                ].join(' · '),
              ),
            ),
        if (canDecide) ...[
          const SizedBox(height: 24),
          FilledButton.tonal(
            onPressed: () => _recalculate(context, ref),
            child: Text(l10n.pricingQuotesRecalculate),
          ),
          const SizedBox(height: 8),
          FilledButton.tonal(
            onPressed: () => _addAdjustment(context, ref),
            child: Text(l10n.pricingQuotesAddAdjustment),
          ),
          const SizedBox(height: 8),
          FilledButton(
            onPressed: approveEnabled ? () => _approve(context, ref) : null,
            child: Text(l10n.pricingQuotesApprove),
          ),
          if (!quote.canApprove) ...[
            const SizedBox(height: 8),
            Text(
              l10n.pricingQuotesApproveBlocked,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.error,
              ),
            ),
          ],
          if (quote.status.allowedManualTransitions.isNotEmpty) ...[
            const SizedBox(height: 16),
            Text(
              l10n.pricingQuotesChangeStatus,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                for (final next in quote.status.allowedManualTransitions)
                  OutlinedButton(
                    onPressed: () => _updateStatus(context, ref, next),
                    child: Text(
                      '${pricingQuoteStatusLabel(l10n, next)} (${next.backendValue})',
                    ),
                  ),
              ],
            ),
          ],
        ],
      ],
    );
  }

  Widget _section(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(title, style: Theme.of(context).textTheme.titleMedium),
    );
  }

  Widget _field(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          Text(value),
        ],
      ),
    );
  }

  Widget _mapBlock(BuildContext context, Map<String, dynamic> map) {
    if (map.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in map.entries)
          _field(context, entry.key, formatPricingQuoteNumber(entry.value)),
      ],
    );
  }

  Widget _mapMoneyBlock(BuildContext context, Map<String, dynamic> map) {
    if (map.isEmpty) return const SizedBox.shrink();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        for (final entry in map.entries)
          _field(
            context,
            entry.key,
            formatPricingQuoteMoney(context, entry.value?.toString()),
          ),
      ],
    );
  }

  Future<void> _recalculate(BuildContext context, WidgetRef ref) async {
    final reason = await _promptReason(
      context,
      title: AppLocalizations.of(context).pricingQuotesRecalculate,
    );
    if (reason == null || !context.mounted) return;
    await _runAction(context, () {
      return submitRecalculateQuote(ref, quoteId: quote.id, reason: reason);
    });
  }

  Future<void> _addAdjustment(BuildContext context, WidgetRef ref) async {
    final request = await showDialog<PricingQuoteAdjustmentRequest>(
      context: context,
      builder: (context) => const _AdjustmentDialog(),
    );
    if (request == null || !context.mounted) return;
    await _runAction(context, () {
      return submitQuoteAdjustment(
        ref,
        quoteId: quote.id,
        request: request,
      );
    });
  }

  Future<void> _approve(BuildContext context, WidgetRef ref) async {
    await _runAction(context, () {
      return submitApproveQuote(ref, quoteId: quote.id);
    });
  }

  Future<void> _updateStatus(
    BuildContext context,
    WidgetRef ref,
    PricingQuoteStatus status,
  ) async {
    await _runAction(context, () {
      return submitQuoteStatus(ref, quoteId: quote.id, status: status);
    });
  }

  Future<void> _runAction(
    BuildContext context,
    Future<void> Function() action,
  ) async {
    final l10n = AppLocalizations.of(context);
    try {
      await action();
    } catch (error) {
      if (!context.mounted) return;
      if (error is ApiException) {
        showApiExceptionSnackBar(context, error);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(l10n.pricingQuotesActionError)));
      }
    }
  }

  Future<String?> _promptReason(
    BuildContext context, {
    required String title,
  }) {
    return showDialog<String>(
      context: context,
      builder: (context) => _ReasonDialog(title: title),
    );
  }
}

class _ReasonDialog extends StatefulWidget {
  const _ReasonDialog({required this.title});

  final String title;

  @override
  State<_ReasonDialog> createState() => _ReasonDialogState();
}

class _ReasonDialogState extends State<_ReasonDialog> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        decoration: InputDecoration(labelText: l10n.pricingQuotesReason),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.pricingQuotesCancel),
        ),
        FilledButton(
          onPressed: () {
            final value = _controller.text.trim();
            if (value.isEmpty) return;
            Navigator.of(context).pop(value);
          },
          child: Text(l10n.pricingQuotesConfirm),
        ),
      ],
    );
  }
}

class _AdjustmentDialog extends StatefulWidget {
  const _AdjustmentDialog();

  @override
  State<_AdjustmentDialog> createState() => _AdjustmentDialogState();
}

class _AdjustmentDialogState extends State<_AdjustmentDialog> {
  PricingQuoteAdjustmentType _type = PricingQuoteAdjustmentType.discount;
  final _percentController = TextEditingController();
  final _amountController = TextEditingController();
  final _reasonController = TextEditingController();

  @override
  void dispose() {
    _percentController.dispose();
    _amountController.dispose();
    _reasonController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return AlertDialog(
      title: Text(l10n.pricingQuotesAddAdjustment),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<PricingQuoteAdjustmentType>(
              initialValue: _type,
              isExpanded: true,
              decoration: InputDecoration(labelText: l10n.pricingQuotesType),
              items: [
                for (final type in PricingQuoteAdjustmentType.values)
                  DropdownMenuItem(
                    value: type,
                    child: Text(
                      pricingQuoteAdjustmentTypeLabel(l10n, type),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _type = value);
              },
            ),
            TextField(
              controller: _percentController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.pricingQuotesPercent),
            ),
            TextField(
              controller: _amountController,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              decoration: InputDecoration(labelText: l10n.pricingQuotesAmount),
            ),
            TextField(
              controller: _reasonController,
              decoration: InputDecoration(labelText: l10n.pricingQuotesReason),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(l10n.pricingQuotesCancel),
        ),
        FilledButton(
          onPressed: () {
            final reason = _reasonController.text.trim();
            if (reason.isEmpty) return;
            Navigator.of(context).pop(
              PricingQuoteAdjustmentRequest(
                type: _type,
                percent: double.tryParse(_percentController.text.trim()),
                amountNet: double.tryParse(_amountController.text.trim()),
                reason: reason,
              ),
            );
          },
          child: Text(l10n.pricingQuotesConfirm),
        ),
      ],
    );
  }
}

Map<String, dynamic> _asMap(Object? raw) {
  if (raw is Map<String, dynamic>) return raw;
  if (raw is Map) return Map<String, dynamic>.from(raw);
  return const {};
}

String _stringList(Object? raw) {
  if (raw is List && raw.isNotEmpty) {
    return raw.map((item) => item.toString()).join(', ');
  }
  return '—';
}
