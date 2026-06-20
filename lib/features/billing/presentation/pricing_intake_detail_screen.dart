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
import '../domain/pricing_intake.dart';
import 'billing_providers.dart';
import 'widgets/billing_action_dialog.dart';

class PricingIntakeDetailScreen extends ConsumerWidget {
  const PricingIntakeDetailScreen({super.key, required this.intakeId});

  final String intakeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final intakeAsync = ref.watch(pricingIntakeDetailProvider(intakeId));
    final canChangeStatus =
        ref.watch(adminAuthProvider).user?.role.canChangeBillingStatus ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.billingPricingIntakeDetailTitle)),
      body: intakeAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveBillingKey(context, 'billingDetailError'),
          onRetry: () => ref.invalidate(pricingIntakeDetailProvider(intakeId)),
        ),
        data: (intake) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              intake.companyName ??
                  resolveBillingKey(
                    context,
                    'billingFieldCompanyId',
                    params: {'id': intake.companyId},
                  ),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Chip(
              label: Text(resolveBillingKey(context, intake.status.localizationKey())),
            ),
            const SizedBox(height: 16),
            _sectionTitle(context, 'billingSectionContact'),
            _field(context, 'billingFieldContactEmail', intake.contactEmail ?? '—'),
            _field(context, 'billingFieldCountry', intake.country ?? '—'),
            const SizedBox(height: 12),
            _sectionTitle(context, 'billingSectionFleet'),
            if (intake.fleetSize != null)
              _field(
                context,
                'billingMetricFleetSize',
                resolveBillingKey(
                  context,
                  'billingMetricFleetSize',
                  params: {'count': '${intake.fleetSize}'},
                ),
              ),
            if (intake.officeUsers != null)
              _field(
                context,
                'billingMetricOfficeUsers',
                resolveBillingKey(
                  context,
                  'billingMetricOfficeUsers',
                  params: {'count': '${intake.officeUsers}'},
                ),
              ),
            if (intake.driverApps != null)
              _field(
                context,
                'billingMetricDriverAppsRequested',
                resolveBillingKey(
                  context,
                  'billingMetricDriverAppsRequested',
                  params: {'count': '${intake.driverApps}'},
                ),
              ),
            const SizedBox(height: 12),
            _sectionTitle(context, 'billingSectionModules'),
            if (intake.requestedModules.isEmpty)
              Text(resolveBillingKey(context, 'billingNoneReported'))
            else
              ...intake.requestedModules.map(
                (module) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $module'),
                ),
              ),
            const SizedBox(height: 12),
            _sectionTitle(context, 'billingSectionAiFeatures'),
            if (intake.requestedAiFeatures.isEmpty)
              Text(resolveBillingKey(context, 'billingNoneReported'))
            else
              ...intake.requestedAiFeatures.map(
                (feature) => Padding(
                  padding: const EdgeInsets.only(bottom: 4),
                  child: Text('• $feature'),
                ),
              ),
            if (intake.needsHumanReview) ...[
              const SizedBox(height: 12),
              Text(
                resolveBillingKey(context, 'billingPricingIntakeNeedsReview'),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.error,
                ),
              ),
            ],
            if (intake.createdAt != null) ...[
              const SizedBox(height: 12),
              _field(
                context,
                'billingFieldCreatedAt',
                _formatDate(context, intake.createdAt!),
              ),
            ],
            const SizedBox(height: 16),
            if (canChangeStatus)
              FilledButton(
                onPressed: () => _handleStatusChange(context, ref, intake),
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
    PricingIntake intake,
  ) async {
    final result = await showBillingActionDialog(
      context: context,
      target: BillingActionTarget.pricingIntake,
      currentStatusLabel: resolveBillingKey(
        context,
        intake.status.localizationKey(),
      ),
      pricingIntakeStatus: intake.status,
    );
    if (result?.pricingIntakeRequest == null || !context.mounted) return;

    final request = result!.pricingIntakeRequest!;
    final validationError = request.validate();
    if (validationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveBillingKey(context, validationError))),
      );
      return;
    }

    try {
      await submitPricingIntakeStatusChange(
        ref,
        intakeId: intakeId,
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
