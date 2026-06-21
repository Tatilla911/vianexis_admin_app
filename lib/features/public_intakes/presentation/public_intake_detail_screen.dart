import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../../l10n/app_localizations.dart';
import '../../translation/presentation/widgets/translation_panel.dart';
import '../domain/public_intake.dart';
import 'public_intakes_providers.dart';
import 'widgets/public_intake_consent_card.dart';
import 'widgets/public_intake_customer_card.dart';
import 'widgets/public_intake_language_badge.dart';
import 'widgets/public_intake_status_badge.dart';
import 'widgets/public_intake_status_dialog.dart';
import 'widgets/public_intake_type_badge.dart';

class PublicIntakeDetailScreen extends ConsumerWidget {
  const PublicIntakeDetailScreen({super.key, required this.intakeId});

  final String intakeId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final intakeAsync = ref.watch(publicIntakeDetailProvider(intakeId));
    final canChangeStatus =
        ref.watch(adminAuthProvider).user?.role.canChangePublicIntakeStatus ?? false;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.publicIntakeDetailTitle)),
      body: intakeAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolvePublicIntakeKey(context, 'publicIntakeDetailError'),
          onRetry: () => refreshPublicIntakeDetail(ref, intakeId),
        ),
        data: (intake) => ListView(
          padding: const EdgeInsets.all(16),
          children: [
            Text(
              intake.companyName ??
                  intake.customerName ??
                  intake.customerEmailDomain ??
                  resolvePublicIntakeKey(context, 'publicIntakeUnknownCustomer'),
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                PublicIntakeTypeBadge(type: intake.type),
                PublicIntakeStatusBadge(status: intake.status),
                PublicIntakeLanguageBadge(intake: intake),
              ],
            ),
            const SizedBox(height: 16),
            PublicIntakeCustomerCard(intake: intake),
            const SizedBox(height: 12),
            PublicIntakeConsentCard(intake: intake),
            const SizedBox(height: 12),
            _MessageSection(intake: intake),
            const SizedBox(height: 12),
            if (intake.fleetSize != null ||
                intake.requestedModules.isNotEmpty ||
                intake.requestedAiFeatures.isNotEmpty)
              _QuoteMetadataSection(intake: intake),
            const SizedBox(height: 12),
            _LinksSection(intake: intake),
            const SizedBox(height: 16),
            TranslationPanel(
              sourceType: 'public_intake',
              sourceId: intake.id,
              sourceField: 'messageOriginalText',
              originalText: intake.messageOriginalText ?? '',
              initialTargetLanguage: 'en',
            ),
            const SizedBox(height: 16),
            if (canChangeStatus)
              FilledButton(
                onPressed: () => _handleStatusChange(context, ref, intake),
                child: Text(resolvePublicIntakeKey(context, 'publicIntakeChangeStatusAction')),
              ),
            const SizedBox(height: 16),
            VianexisMetadataNotice(
              message: resolvePublicIntakeKey(context, 'publicIntakeEvidenceNotice'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleStatusChange(
    BuildContext context,
    WidgetRef ref,
    PublicIntake intake,
  ) async {
    final result = await showPublicIntakeStatusDialog(
      context: context,
      initialStatus: intake.status,
    );
    if (result == null || !context.mounted) return;

    try {
      await submitPublicIntakeStatusChange(
        ref: ref,
        intakeId: intakeId,
        status: result.status,
        reason: result.reason,
      );
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolvePublicIntakeKey(context, 'publicIntakeStatusSuccess')),
        ),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(resolvePublicIntakeKey(context, 'publicIntakeStatusError')),
        ),
      );
    }
  }
}

class _MessageSection extends StatelessWidget {
  const _MessageSection({required this.intake});

  final PublicIntake intake;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolvePublicIntakeKey(context, 'publicIntakeSectionMessage'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Text(
              resolvePublicIntakeKey(
                context,
                'publicIntakeFieldOriginalLanguage',
                params: {'lang': intake.messageOriginalLanguage.toUpperCase()},
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            SelectableText(intake.messageOriginalText ?? '—'),
          ],
        ),
      ),
    );
  }
}

class _QuoteMetadataSection extends StatelessWidget {
  const _QuoteMetadataSection({required this.intake});

  final PublicIntake intake;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolvePublicIntakeKey(context, 'publicIntakeSectionQuote'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (intake.fleetSize != null)
              Text(
                resolvePublicIntakeKey(
                  context,
                  'publicIntakeFieldFleetSize',
                  params: {'count': '${intake.fleetSize}'},
                ),
              ),
            if (intake.officeUsers != null)
              Text(
                resolvePublicIntakeKey(
                  context,
                  'publicIntakeFieldOfficeUsers',
                  params: {'count': '${intake.officeUsers}'},
                ),
              ),
            if (intake.driverApps != null)
              Text(
                resolvePublicIntakeKey(
                  context,
                  'publicIntakeFieldDriverApps',
                  params: {'count': '${intake.driverApps}'},
                ),
              ),
            if (intake.requestedModules.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(resolvePublicIntakeKey(context, 'publicIntakeFieldModules')),
              ...intake.requestedModules.map((m) => Text('• $m')),
            ],
            if (intake.requestedAiFeatures.isNotEmpty) ...[
              const SizedBox(height: 8),
              Text(resolvePublicIntakeKey(context, 'publicIntakeFieldAiFeatures')),
              ...intake.requestedAiFeatures.map((f) => Text('• $f')),
            ],
          ],
        ),
      ),
    );
  }
}

class _LinksSection extends StatelessWidget {
  const _LinksSection({required this.intake});

  final PublicIntake intake;

  @override
  Widget build(BuildContext context) {
    final threadId = intake.linkedCustomerCommunicationThreadId;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              resolvePublicIntakeKey(context, 'publicIntakeSectionLinks'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            if (threadId != null) ...[
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => context.push(
                  AdminRoutes.customerCommunicationDetail(threadId),
                ),
                icon: const Icon(Icons.forum_outlined),
                label: Text(
                  resolvePublicIntakeKey(context, 'publicIntakeOpenThreadAction'),
                ),
              ),
            ],
            if (intake.linkedQuoteRequestId != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(resolvePublicIntakeKey(context, 'publicIntakeLinkedQuote')),
                subtitle: Text(intake.linkedQuoteRequestId!),
                onTap: () => context.push(
                  AdminRoutes.billingQuoteRequestDetail(intake.linkedQuoteRequestId!),
                ),
              ),
            if (intake.linkedPricingIntakeId != null)
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(resolvePublicIntakeKey(context, 'publicIntakeLinkedPricing')),
                subtitle: Text(intake.linkedPricingIntakeId!),
                onTap: () => context.push(
                  AdminRoutes.billingPricingIntakeDetail(intake.linkedPricingIntakeId!),
                ),
              ),
            if (intake.createdAt != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  resolvePublicIntakeKey(
                    context,
                    'publicIntakeCreatedAt',
                    params: {
                      'date': DateFormat.yMMMd(
                        Localizations.localeOf(context).toString(),
                      ).format(intake.createdAt!.toLocal()),
                    },
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
          ],
        ),
      ),
    );
  }
}
