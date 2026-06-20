import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../l10n/app_localizations.dart';
import '../../domain/billing_action_request.dart';
import '../../domain/pricing_intake_status.dart';
import '../../domain/quote_request_status.dart';
import '../../domain/subscription_status.dart';

enum BillingActionTarget {
  subscription,
  pricingIntake,
  quoteRequest,
}

class BillingActionDialogResult {
  const BillingActionDialogResult.subscription(this.subscriptionRequest)
      : pricingIntakeRequest = null,
        quoteRequestRequest = null;

  const BillingActionDialogResult.pricingIntake(this.pricingIntakeRequest)
      : subscriptionRequest = null,
        quoteRequestRequest = null;

  const BillingActionDialogResult.quoteRequest(this.quoteRequestRequest)
      : subscriptionRequest = null,
        pricingIntakeRequest = null;

  final BillingSubscriptionStatusRequest? subscriptionRequest;
  final BillingPricingIntakeStatusRequest? pricingIntakeRequest;
  final BillingQuoteRequestStatusRequest? quoteRequestRequest;
}

Future<BillingActionDialogResult?> showBillingActionDialog({
  required BuildContext context,
  required BillingActionTarget target,
  required String currentStatusLabel,
  SubscriptionStatus? subscriptionStatus,
  PricingIntakeStatus? pricingIntakeStatus,
  QuoteRequestStatus? quoteRequestStatus,
}) {
  return showDialog<BillingActionDialogResult>(
    context: context,
    builder: (dialogContext) => _BillingActionDialog(
      target: target,
      currentStatusLabel: currentStatusLabel,
      subscriptionStatus: subscriptionStatus,
      pricingIntakeStatus: pricingIntakeStatus,
      quoteRequestStatus: quoteRequestStatus,
    ),
  );
}

class _BillingActionDialog extends StatefulWidget {
  const _BillingActionDialog({
    required this.target,
    required this.currentStatusLabel,
    this.subscriptionStatus,
    this.pricingIntakeStatus,
    this.quoteRequestStatus,
  });

  final BillingActionTarget target;
  final String currentStatusLabel;
  final SubscriptionStatus? subscriptionStatus;
  final PricingIntakeStatus? pricingIntakeStatus;
  final QuoteRequestStatus? quoteRequestStatus;

  @override
  State<_BillingActionDialog> createState() => _BillingActionDialogState();
}

class _BillingActionDialogState extends State<_BillingActionDialog> {
  final _formKey = GlobalKey<FormState>();
  final _reasonController = TextEditingController();
  final _noteController = TextEditingController();

  SubscriptionStatus? _subscriptionStatus;
  PricingIntakeStatus? _pricingIntakeStatus;
  QuoteRequestStatus? _quoteRequestStatus;

  @override
  void initState() {
    super.initState();
    _subscriptionStatus = widget.subscriptionStatus;
    _pricingIntakeStatus = widget.pricingIntakeStatus;
    _quoteRequestStatus = widget.quoteRequestStatus;
  }

  bool get _requiresReason {
    return switch (widget.target) {
      BillingActionTarget.subscription =>
        _subscriptionStatus?.requiresReason ?? false,
      BillingActionTarget.pricingIntake =>
        _pricingIntakeStatus?.requiresReason ?? false,
      BillingActionTarget.quoteRequest =>
        _quoteRequestStatus?.requiresReason ?? false,
    };
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final reason = _reasonController.text.trim().isEmpty
        ? null
        : _reasonController.text.trim();
    final note = _noteController.text.trim().isEmpty
        ? null
        : _noteController.text.trim();

    final result = switch (widget.target) {
      BillingActionTarget.subscription => BillingActionDialogResult.subscription(
        BillingSubscriptionStatusRequest(
          status: _subscriptionStatus ?? SubscriptionStatus.unknown,
          reason: reason,
          note: note,
        ),
      ),
      BillingActionTarget.pricingIntake => BillingActionDialogResult.pricingIntake(
        BillingPricingIntakeStatusRequest(
          status: _pricingIntakeStatus ?? PricingIntakeStatus.unknown,
          reason: reason,
        ),
      ),
      BillingActionTarget.quoteRequest => BillingActionDialogResult.quoteRequest(
        BillingQuoteRequestStatusRequest(
          status: _quoteRequestStatus ?? QuoteRequestStatus.unknown,
          reason: reason,
        ),
      ),
    };

    Navigator.of(context).pop(result);
  }

  @override
  void dispose() {
    _reasonController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(resolveBillingKey(context, 'billingActionDialogTitle')),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(resolveBillingKey(context, 'billingActionAuditNotice')),
              const SizedBox(height: 12),
              Text(
                resolveBillingKey(
                  context,
                  'billingActionCurrentStatus',
                  params: {'status': widget.currentStatusLabel},
                ),
              ),
              const SizedBox(height: 16),
              _statusField(context),
              if (_requiresReason) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _reasonController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: resolveBillingKey(context, 'billingActionReasonLabel'),
                  ),
                  validator: (value) {
                    if (!_requiresReason) return null;
                    if (value == null || value.trim().length < 3) {
                      return resolveBillingKey(context, 'billingActionReasonRequired');
                    }
                    return null;
                  },
                ),
              ],
              if (widget.target == BillingActionTarget.subscription) ...[
                const SizedBox(height: 16),
                TextFormField(
                  controller: _noteController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: resolveBillingKey(context, 'billingActionNoteLabel'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(AppLocalizations.of(context).confirmDialogCancel),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(resolveBillingKey(context, 'billingActionConfirm')),
        ),
      ],
    );
  }

  Widget _statusField(BuildContext context) {
    return switch (widget.target) {
      BillingActionTarget.subscription => DropdownButtonFormField<SubscriptionStatus>(
        initialValue: _subscriptionStatus,
        decoration: InputDecoration(
          labelText: resolveBillingKey(context, 'billingActionStatusLabel'),
        ),
        items: SubscriptionStatus.values
            .where((status) => status != SubscriptionStatus.unknown)
            .map(
              (status) => DropdownMenuItem(
                value: status,
                child: Text(resolveBillingKey(context, status.localizationKey())),
              ),
            )
            .toList(growable: false),
        onChanged: (value) => setState(() => _subscriptionStatus = value),
        validator: (value) =>
            value == null ? resolveBillingKey(context, 'billingActionStatusRequired') : null,
      ),
      BillingActionTarget.pricingIntake => DropdownButtonFormField<PricingIntakeStatus>(
        initialValue: _pricingIntakeStatus,
        decoration: InputDecoration(
          labelText: resolveBillingKey(context, 'billingActionStatusLabel'),
        ),
        items: PricingIntakeStatus.values
            .where((status) => status != PricingIntakeStatus.unknown)
            .map(
              (status) => DropdownMenuItem(
                value: status,
                child: Text(resolveBillingKey(context, status.localizationKey())),
              ),
            )
            .toList(growable: false),
        onChanged: (value) => setState(() => _pricingIntakeStatus = value),
        validator: (value) =>
            value == null ? resolveBillingKey(context, 'billingActionStatusRequired') : null,
      ),
      BillingActionTarget.quoteRequest => DropdownButtonFormField<QuoteRequestStatus>(
        initialValue: _quoteRequestStatus,
        decoration: InputDecoration(
          labelText: resolveBillingKey(context, 'billingActionStatusLabel'),
        ),
        items: QuoteRequestStatus.values
            .where((status) => status != QuoteRequestStatus.unknown)
            .map(
              (status) => DropdownMenuItem(
                value: status,
                child: Text(resolveBillingKey(context, status.localizationKey())),
              ),
            )
            .toList(growable: false),
        onChanged: (value) => setState(() => _quoteRequestStatus = value),
        validator: (value) =>
            value == null ? resolveBillingKey(context, 'billingActionStatusRequired') : null,
      ),
    };
  }
}
