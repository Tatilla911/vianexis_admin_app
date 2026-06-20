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
import '../domain/quote_request.dart';
import 'billing_providers.dart';
import 'widgets/billing_action_dialog.dart';

class QuoteRequestDetailScreen extends ConsumerWidget {
  const QuoteRequestDetailScreen({super.key, required this.quoteRequestId});

  final String quoteRequestId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final quoteAsync = ref.watch(quoteRequestDetailProvider(quoteRequestId));
    final canChangeStatus =
        ref.watch(adminAuthProvider).user?.role.canChangeBillingStatus ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.billingQuoteRequestDetailTitle)),
      body: quoteAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveBillingKey(context, 'billingDetailError'),
          onRetry: () => ref.invalidate(quoteRequestDetailProvider(quoteRequestId)),
        ),
        data: (quoteRequest) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              quoteRequest.companyName,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(
                resolveBillingKey(context, quoteRequest.status.localizationKey()),
              ),
            ),
            const SizedBox(height: 16),
            _sectionTitle(context, 'billingSectionContact'),
            _field(context, 'billingFieldContactEmail', quoteRequest.contactEmail),
            if (quoteRequest.companyId != null)
              _field(
                context,
                'billingFieldCompanyId',
                resolveBillingKey(
                  context,
                  'billingFieldCompanyId',
                  params: {'id': quoteRequest.companyId!},
                ),
              ),
            const SizedBox(height: 12),
            _sectionTitle(context, 'billingSectionFleet'),
            if (quoteRequest.fleetSize != null)
              _field(
                context,
                'billingMetricFleetSize',
                resolveBillingKey(
                  context,
                  'billingMetricFleetSize',
                  params: {'count': '${quoteRequest.fleetSize}'},
                ),
              ),
            if (quoteRequest.officeUsers != null)
              _field(
                context,
                'billingMetricOfficeUsers',
                resolveBillingKey(
                  context,
                  'billingMetricOfficeUsers',
                  params: {'count': '${quoteRequest.officeUsers}'},
                ),
              ),
            if (quoteRequest.driverUsers != null)
              _field(
                context,
                'billingMetricDriverAppsRequested',
                resolveBillingKey(
                  context,
                  'billingMetricDriverAppsRequested',
                  params: {'count': '${quoteRequest.driverUsers}'},
                ),
              ),
            if (quoteRequest.createdAt != null) ...[
              const SizedBox(height: 12),
              _field(
                context,
                'billingFieldCreatedAt',
                _formatDate(context, quoteRequest.createdAt!),
              ),
            ],
            const SizedBox(height: 16),
            if (canChangeStatus)
              FilledButton(
                onPressed: () => _handleStatusChange(context, ref, quoteRequest),
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
    QuoteRequest quoteRequest,
  ) async {
    final result = await showBillingActionDialog(
      context: context,
      target: BillingActionTarget.quoteRequest,
      currentStatusLabel: resolveBillingKey(
        context,
        quoteRequest.status.localizationKey(),
      ),
      quoteRequestStatus: quoteRequest.status,
    );
    if (result?.quoteRequestRequest == null || !context.mounted) return;

    final request = result!.quoteRequestRequest!;
    final validationError = request.validate();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveBillingKey(context, validationError))),
      );
      return;
    }

    try {
      await submitQuoteRequestStatusChange(
        ref,
        quoteRequestId: quoteRequestId,
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
