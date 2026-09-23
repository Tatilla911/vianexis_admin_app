import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../l10n/app_localizations.dart';
import '../data/emergencies_repository.dart';
import '../domain/driver_emergency_event.dart';
import 'widgets/emergency_critical_banner.dart';
import 'widgets/emergency_status_badge.dart';

class EmergenciesListScreen extends ConsumerWidget {
  const EmergenciesListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(openEmergenciesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.emergenciesTitle),
        actions: [
          IconButton(
            onPressed: () => ref.invalidate(openEmergenciesProvider),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: async.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => Center(child: Text(l10n.emergenciesLoadError)),
        data: (page) {
          final active = page.items
              .where((item) => item.status.isActiveUnacknowledged)
              .toList();
          if (page.items.isEmpty) {
            return Center(child: Text(l10n.emergenciesEmpty));
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              if (active.isNotEmpty)
                EmergencyCriticalBanner(
                  count: active.length,
                  onTap: () {
                    if (active.isNotEmpty) {
                      context.go(AdminRoutes.emergencyDetail(active.first.id));
                    }
                  },
                ),
              const SizedBox(height: 12),
              ...page.items.map((item) {
                final locale = Localizations.localeOf(context).toString();
                final triggered = item.triggeredAt == null
                    ? '—'
                    : DateFormat.yMMMd(
                        locale,
                      ).add_Hm().format(item.triggeredAt!.toLocal());
                return Card(
                  color: item.status.isActiveUnacknowledged
                      ? Theme.of(context).colorScheme.errorContainer
                      : null,
                  child: ListTile(
                    title: Text(
                      item.driverNameSnapshot ??
                          l10n.emergenciesDriverFallback(item.driverUserId),
                    ),
                    subtitle: Text(
                      [
                        item.vehiclePlateSnapshot ?? l10n.emergenciesNoVehicle,
                        item.locality ?? l10n.emergenciesNoLocality,
                        triggered,
                      ].join(' · '),
                    ),
                    trailing: EmergencyStatusBadge(status: item.status),
                    onTap: () =>
                        context.go(AdminRoutes.emergencyDetail(item.id)),
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
