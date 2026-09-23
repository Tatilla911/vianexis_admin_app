import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../l10n/app_localizations.dart';
import '../data/emergencies_repository.dart';
import '../domain/driver_emergency_event.dart';
import 'widgets/emergency_status_badge.dart';

class EmergencyDetailScreen extends ConsumerWidget {
  const EmergencyDetailScreen({super.key, required this.emergencyId});

  final String emergencyId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(emergencyDetailProvider(emergencyId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.emergenciesDetailTitle)),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.emergenciesDetailError)),
        data: (event) => _EmergencyDetailBody(event: event),
      ),
    );
  }
}

class _EmergencyDetailBody extends StatelessWidget {
  const _EmergencyDetailBody({required this.event});

  final DriverEmergencyEvent event;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final locale = Localizations.localeOf(context).toString();
    String format(DateTime? value) {
      if (value == null) return '—';
      return DateFormat.yMMMd(locale).add_Hm().format(value.toLocal());
    }

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        if (event.status.isActiveUnacknowledged) ...[
          Material(
            color: Theme.of(context).colorScheme.errorContainer,
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Icon(
                    Icons.warning_amber_rounded,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      l10n.emergenciesCriticalCardBody,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            EmergencyStatusBadge(status: event.status),
            Chip(label: Text(event.severity)),
          ],
        ),
        const SizedBox(height: 16),
        _field(
          context,
          l10n.emergenciesFieldCompany,
          event.companyId,
        ),
        _field(
          context,
          l10n.emergenciesFieldDriver,
          event.driverNameSnapshot ?? event.driverUserId,
        ),
        _field(
          context,
          l10n.emergenciesFieldVehicle,
          event.vehiclePlateSnapshot ?? '—',
        ),
        _field(
          context,
          l10n.emergenciesFieldTriggeredAt,
          format(event.triggeredAt),
        ),
        _field(
          context,
          l10n.emergenciesFieldCompanyAck,
          event.acknowledgedAt == null
              ? l10n.emergenciesAckPending
              : l10n.emergenciesAckAcknowledged,
        ),
        _field(
          context,
          l10n.emergenciesFieldAcknowledgedAt,
          format(event.acknowledgedAt),
        ),
        _field(
          context,
          l10n.emergenciesFieldCompanyNotification,
          event.companyNotificationStatus,
        ),
        _field(
          context,
          l10n.emergenciesFieldPlatformNotification,
          event.platformNotificationStatus,
        ),
        _field(
          context,
          l10n.emergenciesFieldAdminPush,
          event.adminPushStatus,
        ),
        const Divider(height: 32),
        Text(
          l10n.emergenciesLocationSection,
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        _field(
          context,
          l10n.emergenciesFieldLocality,
          event.locality ?? '—',
        ),
        _field(
          context,
          l10n.emergenciesFieldCoordinates,
          event.hasExactCoordinates
              ? '${event.latitude!.toStringAsFixed(6)}, ${event.longitude!.toStringAsFixed(6)}'
              : '—',
        ),
        _field(
          context,
          l10n.emergenciesFieldAccuracy,
          event.accuracyMeters == null
              ? '—'
              : l10n.emergenciesAccuracyMeters(event.accuracyMeters!.round()),
        ),
        _field(
          context,
          l10n.emergenciesFieldLocationCapturedAt,
          format(event.locationCapturedAt),
        ),
        _field(
          context,
          l10n.emergenciesFieldLocationSource,
          event.locationSource ?? '—',
        ),
        _field(
          context,
          l10n.emergenciesFieldLocationStatus,
          event.locationStatus.backendValue,
        ),
        if (event.hasExactCoordinates) ...[
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () => _openMaps(event.latitude!, event.longitude!),
            icon: const Icon(Icons.map_outlined),
            label: Text(l10n.emergenciesShowOnMap),
          ),
        ] else ...[
          const SizedBox(height: 12),
          Text(l10n.emergenciesLocationUnavailable),
        ],
      ],
    );
  }

  Widget _field(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: Theme.of(context).textTheme.labelMedium),
          Text(value, softWrap: true),
        ],
      ),
    );
  }

  Future<void> _openMaps(double lat, double lng) async {
    final uri = Uri.parse(
      'https://www.google.com/maps/search/?api=1&query=$lat,$lng',
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}
