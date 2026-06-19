import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_router.dart';
import '../../core/localization/localization_resolver.dart';
import '../../features/system_health/presentation/system_health_providers.dart';
import '../../features/system_health/presentation/widgets/system_health_overview_card.dart';
import '../../l10n/app_localizations.dart';

class AdminDashboardScreen extends ConsumerWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final healthAsync = ref.watch(systemHealthSnapshotProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.dashboardTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.dashboardPlaceholderBody,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 20),
          healthAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => Card(
              child: ListTile(
                title: Text(resolveSystemHealthKey(context, 'systemHealthLoadError')),
                trailing: TextButton(
                  onPressed: () =>
                      ref.read(systemHealthSnapshotProvider.notifier).refresh(),
                  child: Text(l10n.errorRetryButton),
                ),
              ),
            ),
            data: (snapshot) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SystemHealthOverviewCard(
                  overview: snapshot.overview,
                  compact: true,
                ),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () => context.go(AdminRoutes.systemHealth),
                  child: Text(resolveSystemHealthKey(context, 'systemHealthOpenModule')),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Icon(Icons.shield_outlined, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(l10n.privacyNoOperationalContent),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
