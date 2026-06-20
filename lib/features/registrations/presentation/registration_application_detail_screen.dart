import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/registration_application.dart';
import '../domain/registration_decision_request.dart';
import 'registration_providers.dart';
import 'widgets/ai_risk_badge.dart';
import 'widgets/registration_decision_dialog.dart';
import '../../translation/presentation/widgets/translation_panel.dart';

class RegistrationApplicationDetailScreen extends ConsumerWidget {
  const RegistrationApplicationDetailScreen({
    super.key,
    required this.applicationId,
  });

  final String applicationId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final detailAsync = ref.watch(registrationApplicationDetailProvider(applicationId));
    final user = ref.watch(adminAuthProvider).user;
    final canDecide = user?.role.canDecideRegistrations ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.registrationDetailTitle),
      ),
      body: detailAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage:
              resolveRegistrationKey(context, 'registrationDetailError'),
          onRetry: () => refreshRegistrationApplicationDetail(ref, applicationId),
        ),
        data: (application) => _DetailBody(
          application: application,
          applicationId: applicationId,
          canDecide: canDecide,
          onDecision: (type) => _handleDecision(context, ref, type),
        ),
      ),
    );
  }

  Future<void> _handleDecision(
    BuildContext context,
    WidgetRef ref,
    RegistrationDecisionType type,
  ) async {
    final request = await showRegistrationDecisionDialog(
      context: context,
      type: type,
    );
    if (request == null || !context.mounted) return;

    try {
      await submitRegistrationDecision(
        ref: ref,
        applicationId: applicationId,
        request: request,
      );

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveRegistrationKey(context, 'registrationDecisionSuccess'),
          ),
        ),
      );
    } on ApiException catch (error) {
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveRegistrationKey(context, 'registrationDecisionError'),
          ),
        ),
      );
    }
  }
}

class _DetailBody extends StatelessWidget {
  const _DetailBody({
    required this.application,
    required this.applicationId,
    required this.canDecide,
    required this.onDecision,
  });

  final RegistrationApplication application;
  final String applicationId;
  final bool canDecide;
  final ValueChanged<RegistrationDecisionType> onDecision;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final submitted = application.submittedAt;
    final reviewed = application.reviewedAt;

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        _SectionCard(
          title: resolveRegistrationKey(context, 'registrationSectionCompany'),
          children: [
            _InfoRow(
              label: resolveRegistrationKey(context, 'registrationFieldCompanyName'),
              value: application.companyName,
            ),
            _InfoRow(
              label: resolveRegistrationKey(context, 'registrationFieldCountry'),
              value: application.country ?? '—',
            ),
            _InfoRow(
              label: resolveRegistrationKey(context, 'registrationFieldVatNumber'),
              value: application.vatNumber ?? '—',
            ),
            _InfoRow(
              label: resolveRegistrationKey(context, 'registrationFieldRegistrationNumber'),
              value: application.registrationNumber ?? '—',
            ),
          ],
        ),
        _SectionCard(
          title: resolveRegistrationKey(context, 'registrationSectionContact'),
          children: [
            _InfoRow(
              label: resolveRegistrationKey(context, 'registrationFieldContactName'),
              value: application.contactName ?? '—',
            ),
            _InfoRow(
              label: resolveRegistrationKey(context, 'registrationFieldContactEmail'),
              value: application.contactEmail,
            ),
          ],
        ),
        _SectionCard(
          title: resolveRegistrationKey(context, 'registrationSectionStatus'),
          children: [
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                VianexisStatusBadge(
                  label: resolveRegistrationKey(
                    context,
                    application.status.localizationKey(),
                  ),
                  tone: VianexisStatusTone.unknown,
                ),
                AiRiskBadge(riskLevel: application.riskLevel),
              ],
            ),
            const SizedBox(height: 12),
            _InfoRow(
              label: resolveRegistrationKey(context, 'registrationFieldSubmittedAt'),
              value: submitted != null
                  ? DateFormat.yMMMd(locale).add_Hm().format(submitted)
                  : '—',
            ),
            if (reviewed != null)
              _InfoRow(
                label: resolveRegistrationKey(context, 'registrationFieldReviewedAt'),
                value: DateFormat.yMMMd(locale).add_Hm().format(reviewed),
              ),
            if (application.reviewedBy != null)
              _InfoRow(
                label: resolveRegistrationKey(context, 'registrationFieldReviewedBy'),
                value: application.reviewedBy!,
              ),
          ],
        ),
        _SectionCard(
          title: resolveRegistrationKey(context, 'registrationSectionAiReview'),
          children: [
            _InfoRow(
              label: resolveRegistrationKey(context, 'registrationFieldAiRecommendation'),
              value: application.aiRecommendation ?? '—',
            ),
            _InfoRow(
              label: resolveRegistrationKey(context, 'registrationFieldAiSummary'),
              value: application.aiSummary ?? '—',
            ),
            if ((application.aiSummary ?? '').trim().isNotEmpty) ...[
              const SizedBox(height: 12),
              TranslationPanel(
                sourceType: 'registration_application',
                sourceId: applicationId,
                sourceField: 'aiSummary',
                originalText: application.aiSummary!.trim(),
              ),
            ],
            _BulletList(
              title: resolveRegistrationKey(context, 'registrationFieldMissingInformation'),
              items: application.missingInformation,
              emptyLabel: resolveRegistrationKey(context, 'registrationNoneReported'),
            ),
            _BulletList(
              title: resolveRegistrationKey(context, 'registrationFieldDuplicateWarnings'),
              items: application.duplicateWarnings,
              emptyLabel: resolveRegistrationKey(context, 'registrationNoneReported'),
            ),
            _BulletList(
              title: resolveRegistrationKey(context, 'registrationFieldRiskFlags'),
              items: application.riskFlags.entries
                  .map((entry) => '${entry.key}: ${entry.value}')
                  .toList(growable: false),
              emptyLabel: resolveRegistrationKey(context, 'registrationNoneReported'),
            ),
          ],
        ),
        _SectionCard(
          title: resolveRegistrationKey(context, 'registrationSectionDocuments'),
          children: [
            Text(resolveRegistrationKey(context, 'registrationDocumentsMetadataOnly')),
            const SizedBox(height: 12),
            if (application.documentMetadataOnly.isEmpty)
              Text(resolveRegistrationKey(context, 'registrationDocumentsEmpty'))
            else
              for (final doc in application.documentMetadataOnly)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.description_outlined),
                  title: Text(doc.label),
                  subtitle: Text(
                    [
                      if (doc.documentType != null) doc.documentType,
                      if (doc.uploadedAt != null)
                        DateFormat.yMMMd(locale).format(doc.uploadedAt!),
                    ].whereType<String>().join(' · '),
                  ),
                ),
          ],
        ),
        if (canDecide && !application.status.isTerminal) ...[
          const SizedBox(height: 8),
          FilledButton(
            onPressed: () => onDecision(RegistrationDecisionType.approve),
            child: Text(resolveRegistrationKey(context, 'registrationActionApprove')),
          ),
          const SizedBox(height: 8),
          OutlinedButton(
            onPressed: () => onDecision(RegistrationDecisionType.requestInfo),
            child: Text(resolveRegistrationKey(context, 'registrationActionRequestInfo')),
          ),
          const SizedBox(height: 8),
          TextButton(
            onPressed: () => onDecision(RegistrationDecisionType.reject),
            child: Text(resolveRegistrationKey(context, 'registrationActionReject')),
          ),
        ],
      ],
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(label, style: Theme.of(context).textTheme.bodySmall),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({
    required this.title,
    required this.items,
    required this.emptyLabel,
  });

  final String title;
  final List<String> items;
  final String emptyLabel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: Theme.of(context).textTheme.bodySmall),
          const SizedBox(height: 4),
          if (items.isEmpty)
            Text(emptyLabel)
          else
            for (final item in items)
              Padding(
                padding: const EdgeInsets.only(bottom: 4),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('• '),
                    Expanded(child: Text(item)),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
