import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/system_health_repository.dart';
import 'system_health_providers.dart';
import 'widgets/system_health_event_card.dart';
import 'widgets/system_health_event_filter_bar.dart';
import 'widgets/system_health_overview_card.dart';
import 'widgets/system_health_service_card.dart';

class SystemHealthScreen extends ConsumerWidget {
  const SystemHealthScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final snapshotAsync = ref.watch(systemHealthSnapshotProvider);
    final eventsAsync = ref.watch(filteredSystemHealthEventsProvider);
    final filter = ref.watch(systemHealthEventFilterProvider);
    final usesMock = ref.watch(systemHealthRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.systemHealthTitle),
        actions: [
          if (usesMock)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  resolveSystemHealthKey(context, 'systemHealthMockDataBadge'),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
        ],
      ),
      body: snapshotAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView(
          message: resolveSystemHealthKey(context, 'systemHealthLoadError'),
          onRetry: () => ref.read(systemHealthSnapshotProvider.notifier).refresh(),
        ),
        data: (snapshot) {
          return RefreshIndicator(
            onRefresh: () => ref.read(systemHealthSnapshotProvider.notifier).refresh(),
            child: ListView(
              padding: const EdgeInsets.only(bottom: 24),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: SystemHealthOverviewCard(overview: snapshot.overview),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    resolveSystemHealthKey(context, 'systemHealthServicesTitle'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final crossAxisCount = constraints.maxWidth >= 900
                          ? 3
                          : constraints.maxWidth >= 600
                          ? 2
                          : 1;
                      return GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: crossAxisCount,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: crossAxisCount == 1 ? 2.8 : 1.6,
                        ),
                        itemCount: snapshot.services.length,
                        itemBuilder: (context, index) => SystemHealthServiceCard(
                          service: snapshot.services[index],
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    resolveSystemHealthKey(context, 'systemHealthEventsTitle'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const SizedBox(height: 8),
                SystemHealthEventFilterBar(
                  selected: filter.filter,
                  onSelected: ref.read(systemHealthEventFilterProvider.notifier).setFilter,
                ),
                const SizedBox(height: 8),
                eventsAsync.when(
                  loading: () => const Padding(
                    padding: EdgeInsets.all(24),
                    child: VianexisLoadingView(),
                  ),
                  error: (error, _) => Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(resolveSystemHealthKey(context, 'systemHealthLoadError')),
                  ),
                  data: (events) {
                    if (events.isEmpty) {
                      return Padding(
                        padding: const EdgeInsets.all(24),
                        child: Text(
                          resolveSystemHealthKey(context, 'systemHealthEventsEmpty'),
                          textAlign: TextAlign.center,
                        ),
                      );
                    }
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: [
                          for (final event in events)
                            SystemHealthEventCard(event: event),
                        ],
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
