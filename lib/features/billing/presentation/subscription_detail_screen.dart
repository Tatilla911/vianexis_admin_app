import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/platform_subscription.dart';
import 'billing_providers.dart';
import 'widgets/billing_action_dialog.dart';
import 'widgets/subscription_status_badge.dart';

class SubscriptionDetailScreen extends ConsumerWidget {
  const SubscriptionDetailScreen({super.key, required this.subscriptionId});

  final String subscriptionId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final subscriptionAsync = ref.watch(subscriptionDetailProvider(subscriptionId));
    final canChangeStatus =
        ref.watch(adminAuthProvider).user?.role.canChangeBillingStatus ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.billingSubscriptionDetailTitle)),
      body: subscriptionAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveBillingKey(context, 'billingDetailError'),
          onRetry: () => ref.invalidate(subscriptionDetailProvider(subscriptionId)),
        ),
        data: (subscription) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              subscription.companyName ??
                  resolveBillingKey(
                    context,
                    'billingFieldCompanyId',
                    params: {'id': subscription.companyId},
                  ),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            SubscriptionStatusBadge(status: subscription.status),
            const SizedBox(height: 16),
            _sectionTitle(context, 'billingSectionPlan'),
            _field(context, 'billingFieldPlan', subscription.planName ?? '—'),
            _field(context, 'billingFieldBillingCycle', subscription.billingCycle ?? '—'),
            _field(context, 'billingFieldCurrency', subscription.currency ?? '—'),
            _field(
              context,
              'billingFieldPricingSource',
              subscription.pricingSource ?? '—',
            ),
            _field(
              context,
              'billingFieldOperatingModel',
              subscription.operatingModel ?? '—',
            ),
            const SizedBox(height: 12),
            _sectionTitle(context, 'billingSectionUsage'),
            if (subscription.seatsIncluded != null && subscription.seatsUsed != null)
              _field(
                context,
                'billingMetricSeats',
                resolveBillingKey(
                  context,
                  'billingMetricSeats',
                  params: {
                    'used': '${subscription.seatsUsed}',
                    'included': '${subscription.seatsIncluded}',
                  },
                ),
              ),
            if (subscription.driverAppsIncluded != null &&
                subscription.driverAppsUsed != null)
              _field(
                context,
                'billingMetricDriverApps',
                resolveBillingKey(
                  context,
                  'billingMetricDriverApps',
                  params: {
                    'used': '${subscription.driverAppsUsed}',
                    'included': '${subscription.driverAppsIncluded}',
                  },
                ),
              ),
            _field(
              context,
              'billingFieldAiAddOn',
              subscription.aiAddOnEnabled == true
                  ? resolveBillingKey(context, 'billingYes')
                  : resolveBillingKey(context, 'billingNo'),
            ),
            const SizedBox(height: 12),
            _sectionTitle(context, 'billingSectionDates'),
            if (subscription.startedAt != null)
              _field(
                context,
                'billingFieldStartedAt',
                _formatDate(context, subscription.startedAt!),
              ),
            if (subscription.renewsAt != null)
              _field(
                context,
                'billingFieldRenewsAt',
                _formatDate(context, subscription.renewsAt!),
              ),
            if (subscription.cancelledAt != null)
              _field(
                context,
                'billingFieldCancelledAt',
                _formatDate(context, subscription.cancelledAt!),
              ),
            if (subscription.lastPaymentStatus != null)
              _field(
                context,
                'billingFieldLastPaymentStatus',
                subscription.lastPaymentStatus!,
              ),
            const SizedBox(height: 16),
            if (canChangeStatus)
              FilledButton(
                onPressed: () => _handleStatusChange(context, ref, subscription),
                child: Text(resolveBillingKey(context, 'billingChangeStatusAction')),
              ),
            const SizedBox(height: 16),
            VianexisMetadataNotice(
              message: resolveBillingKey(context, 'billingPrivacyNotice'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleStatusChange(
    BuildContext context,
    WidgetRef ref,
    PlatformSubscription subscription,
  ) async {
    final result = await showBillingActionDialog(
      context: context,
      target: BillingActionTarget.subscription,
      currentStatusLabel: resolveBillingKey(
        context,
        subscription.status.localizationKey(),
      ),
      subscriptionStatus: subscription.status,
    );
    if (result?.subscriptionRequest == null || !context.mounted) return;

    final request = result!.subscriptionRequest!;
    final validationError = request.validate();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveBillingKey(context, validationError))),
      );
      return;
    }

    try {
      await submitSubscriptionStatusChange(
        ref,
        subscriptionId: subscriptionId,
        request: request,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveBillingKey(context, 'billingActionSuccess'))),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveBillingKey(context, 'billingActionError'))),
      );
    }
  }

  Widget _sectionTitle(BuildContext context, String key) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        resolveBillingKey(context, key),
        style: Theme.of(context).textTheme.titleSmall,
      ),
    );
  }

  Widget _field(BuildContext context, String labelKey, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: Text(
              resolveBillingKey(context, labelKey),
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            flex: 3,
            child: Text(value, style: Theme.of(context).textTheme.bodyMedium),
          ),
        ],
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime date) {
    final locale = Localizations.localeOf(context).toString();
    return DateFormat.yMMMd(locale).add_Hm().format(date.toLocal());
  }
}
