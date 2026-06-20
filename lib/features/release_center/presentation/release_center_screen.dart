import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/app_environment_badge.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../../l10n/app_localizations.dart';
import '../data/release_center_repository.dart';
import 'release_center_providers.dart';
import 'widgets/release_overview_card.dart';

class ReleaseCenterScreen extends ConsumerStatefulWidget {
  const ReleaseCenterScreen({super.key});

  @override
  ConsumerState<ReleaseCenterScreen> createState() => _ReleaseCenterScreenState();
}

class _ReleaseCenterScreenState extends ConsumerState<ReleaseCenterScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final usesMock = ref.watch(releaseCenterRepositoryProvider).usesMockData;
    final overviewAsync = ref.watch(releaseOverviewProvider);
    final versionsAsync = ref.watch(releaseAppVersionsProvider);
    final environmentAsync = ref.watch(releaseEnvironmentProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.releaseCenterTitle),
        actions: [
          if (usesMock)
            MockDataBadge(label: resolveReleaseCenterKey(context, 'releaseMockDataBadge')),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                resolveReleaseCenterKey(context, 'releaseReadOnlyBadge'),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: resolveReleaseCenterKey(context, 'releaseTabOverview')),
            Tab(text: resolveReleaseCenterKey(context, 'releaseTabAppVersions')),
            Tab(text: resolveReleaseCenterKey(context, 'releaseTabEnvironment')),
          ],
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                overviewAsync.when(
                  loading: () => const VianexisLoadingView(),
                  error: (error, _) => VianexisErrorView.fromError(
                    context,
                    error,
                    fallbackMessage: resolveReleaseCenterKey(context, 'releaseLoadError'),
                    onRetry: () => ref.read(releaseOverviewProvider.notifier).refresh(),
                  ),
                  data: (overview) => RefreshIndicator(
                    onRefresh: () => refreshReleaseCenter(ref),
                    child: ListView(
                      padding: const EdgeInsets.all(16),
                      children: [ReleaseOverviewCard(overview: overview)],
                    ),
                  ),
                ),
                versionsAsync.when(
                  loading: () => const VianexisLoadingView(),
                  error: (error, _) => VianexisErrorView.fromError(
                    context,
                    error,
                    fallbackMessage: resolveReleaseCenterKey(context, 'releaseLoadError'),
                    onRetry: () => ref.invalidate(releaseAppVersionsProvider),
                  ),
                  data: (versions) => ListView(
                    padding: const EdgeInsets.all(16),
                    children: [ReleaseAppVersionsCard(versions: versions)],
                  ),
                ),
                environmentAsync.when(
                  loading: () => const VianexisLoadingView(),
                  error: (error, _) => VianexisErrorView.fromError(
                    context,
                    error,
                    fallbackMessage: resolveReleaseCenterKey(context, 'releaseLoadError'),
                    onRetry: () => ref.invalidate(releaseEnvironmentProvider),
                  ),
                  data: (environment) => ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      const AppEnvironmentBadge(),
                      const SizedBox(height: 16),
                      ReleaseEnvironmentCard(environment: environment),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: VianexisMetadataNotice(
              message: resolveReleaseCenterKey(context, 'releasePrivacyNotice'),
            ),
          ),
        ],
      ),
    );
  }
}
