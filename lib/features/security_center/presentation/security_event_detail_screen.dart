import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/security_event.dart';
import 'security_center_providers.dart';
import 'widgets/security_event_severity_badge.dart';
import 'widgets/security_event_type_badge.dart';

class SecurityEventDetailScreen extends ConsumerWidget {
  const SecurityEventDetailScreen({super.key, required this.eventId});

  final String eventId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final eventsAsync = ref.watch(securityEventsProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.securityEventDetailTitle)),
      body: eventsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, _) => Center(
          child: Text(resolveSecurityKey(context, 'securityLoadError')),
        ),
        data: (items) {
          SecurityEvent? event;
          for (final item in items) {
            if (item.id == eventId) {
              event = item;
              break;
            }
          }
          if (event == null) {
            return Center(
              child: Text(resolveSecurityKey(context, 'securityEventDetailError')),
            );
          }
          return _SecurityEventDetailBody(event: event);
        },
      ),
    );
  }
}

class _SecurityEventDetailBody extends StatelessWidget {
  const _SecurityEventDetailBody({required this.event});

  final SecurityEvent event;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final created = event.createdAt;
    final createdLabel = created != null
        ? DateFormat.yMMMd(locale).add_Hm().format(created.toLocal())
        : '—';

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(event.title, style: Theme.of(context).textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(event.summary),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          children: [
            SecurityEventTypeBadge(type: event.type),
            SecurityEventSeverityBadge(severity: event.severity),
          ],
        ),
        const SizedBox(height: 20),
        _field(context, 'securityEventFieldSourceType', event.sourceType),
        if (event.sourceId != null)
          _field(context, 'securityEventFieldSourceId', event.sourceId!),
        if (event.actorEmail != null)
          _field(context, 'securityEventFieldActorEmail', event.actorEmail!),
        if (event.actorRole != null)
          _field(context, 'securityEventFieldActorRole', event.actorRole!),
        if (event.companyName != null)
          _field(context, 'securityEventFieldCompany', event.companyName!),
        if (event.correlationId != null)
          _field(context, 'securityEventFieldCorrelationId', event.correlationId!),
        _field(context, 'securityEventFieldCreatedAt', createdLabel),
        const SizedBox(height: 16),
        VianexisMetadataNotice(
          message: resolveSecurityKey(context, 'securityPrivacyNotice'),
        ),
      ],
    );
  }

  Widget _field(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 140,
            child: Text(
              resolveSecurityKey(context, key),
              style: Theme.of(context).textTheme.labelLarge,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
