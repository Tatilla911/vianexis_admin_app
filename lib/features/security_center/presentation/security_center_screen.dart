import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../../l10n/app_localizations.dart';
import '../data/security_center_repository.dart';
import '../domain/security_event_filter.dart';
import 'security_center_providers.dart';
import 'widgets/security_event_card.dart';
import 'widgets/security_overview_card.dart';

class SecurityCenterScreen extends ConsumerStatefulWidget {
  const SecurityCenterScreen({super.key});

  @override
  ConsumerState<SecurityCenterScreen> createState() => _SecurityCenterScreenState();
}

class _SecurityCenterScreenState extends ConsumerState<SecurityCenterScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final overviewAsync = ref.watch(securityOverviewProvider);
    final eventsAsync = ref.watch(filteredSecurityEventsProvider);
    final query = ref.watch(securityEventListQueryProvider);
    final usesMock = ref.watch(securityCenterRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.securityCenterTitle),
        actions: [
          if (usesMock)
            MockDataBadge(label: resolveSecurityKey(context, 'securityMockDataBadge')),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: overviewAsync.when(
              loading: () => const LinearProgressIndicator(),
              error: (_, _) => Text(resolveSecurityKey(context, 'securityLoadError')),
              data: (overview) => SecurityOverviewCard(overview: overview, compact: true),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: resolveSecurityKey(context, 'securityEventSearchHint'),
              ),
              onChanged: (value) =>
                  ref.read(securityEventListQueryProvider.notifier).setSearch(value),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: SecurityEventFilter.values.map((filter) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: FilterChip(
                    label: Text(resolveSecurityKey(context, filter.localizationKey())),
                    selected: query.filter == filter,
                    onSelected: (_) =>
                        ref.read(securityEventListQueryProvider.notifier).setFilter(filter),
                  ),
                );
              }).toList(growable: false),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: eventsAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView.fromError(
                context,
                error,
                fallbackMessage: resolveSecurityKey(context, 'securityLoadError'),
                onRetry: () => refreshSecurityCenter(ref),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Text(resolveSecurityKey(context, 'securityEventListEmpty')),
                  );
                }
                return RefreshIndicator(
                  onRefresh: () => refreshSecurityCenter(ref),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final event = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: SecurityEventCard(
                          event: event,
                          onTap: () => context.push(
                            AdminRoutes.securityEventDetail(event.id),
                          ),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: VianexisMetadataNotice(
              message: resolveSecurityKey(context, 'securityPrivacyNotice'),
            ),
          ),
        ],
      ),
    );
  }
}
