import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/platform_companies_repository.dart';
import 'platform_companies_providers.dart';
import 'widgets/platform_company_card.dart';
import 'widgets/platform_company_filter_bar.dart';

class PlatformCompaniesScreen extends ConsumerStatefulWidget {
  const PlatformCompaniesScreen({super.key});

  @override
  ConsumerState<PlatformCompaniesScreen> createState() =>
      _PlatformCompaniesScreenState();
}

class _PlatformCompaniesScreenState
    extends ConsumerState<PlatformCompaniesScreen> {
  final _searchController = TextEditingController();
  final _scrollController = ScrollController();
  Timer? _searchDebounce;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchDebounce?.cancel();
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent - 240) {
      ref.read(platformCompaniesProvider.notifier).loadMore();
    }
  }

  void _onSearchChanged(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(const Duration(milliseconds: 300), () {
      if (!mounted) return;
      ref.read(platformCompanyListQueryProvider.notifier).setSearch(value);
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(platformCompanyListQueryProvider);
    final companiesAsync = ref.watch(platformCompaniesProvider);
    final usesMock = ref
        .watch(platformCompaniesRepositoryProvider)
        .usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.platformCompaniesTitle),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolvePlatformCompanyKey(
                context,
                'platformCompanyMockDataBadge',
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                resolvePlatformCompanyKey(
                  context,
                  'platformCompanyMetadataBadge',
                ),
                style: Theme.of(context).textTheme.labelSmall,
              ),
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () => ref.read(platformCompaniesProvider.notifier).refresh(),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  prefixIcon: const Icon(Icons.search),
                  hintText: resolvePlatformCompanyKey(
                    context,
                    'platformCompanySearchHint',
                  ),
                ),
                onChanged: _onSearchChanged,
              ),
            ),
            PlatformCompanyFilterBar(
              selected: query.filter,
              onSelected: ref
                  .read(platformCompanyListQueryProvider.notifier)
                  .setFilter,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: companiesAsync.when(
                skipLoadingOnReload: true,
                skipLoadingOnRefresh: true,
                loading: () => const VianexisLoadingView(),
                error: (error, _) => VianexisErrorView.fromError(
                  context,
                  error,
                  fallbackMessage: resolvePlatformCompanyKey(
                    context,
                    'platformCompanyListError',
                  ),
                  onRetry: () =>
                      ref.read(platformCompaniesProvider.notifier).refresh(),
                ),
                data: (listState) {
                  final companies = listState.items;
                  if (companies.isEmpty) {
                    return ListView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.sizeOf(context).height * 0.4,
                          child: Center(
                            child: Text(
                              resolvePlatformCompanyKey(
                                context,
                                'platformCompanyListEmpty',
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }
                  return ListView.builder(
                    controller: _scrollController,
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: companies.length + 1,
                    itemBuilder: (context, index) {
                      if (index >= companies.length) {
                        return _CompaniesListFooter(listState: listState);
                      }
                      final company = companies[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: PlatformCompanyCard(
                          company: company,
                          onTap: () => context.push(
                            AdminRoutes.platformCompanyDetail(company.id),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CompaniesListFooter extends ConsumerWidget {
  const _CompaniesListFooter({required this.listState});

  final PlatformCompaniesListState listState;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (listState.loadMoreError != null) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            Text(
              resolvePlatformCompanyKey(context, 'platformCompanyListError'),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: () =>
                  ref.read(platformCompaniesProvider.notifier).loadMore(),
              child: Text(
                resolvePlatformCompanyKey(
                  context,
                  'platformCompanyLoadMoreRetry',
                ),
              ),
            ),
          ],
        ),
      );
    }
    if (listState.loadingMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Column(
          children: [
            const SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            const SizedBox(height: 8),
            Text(
              resolvePlatformCompanyKey(context, 'platformCompanyLoadingMore'),
            ),
          ],
        ),
      );
    }
    if (!listState.hasMore) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 16),
        child: Center(
          child: Text(
            resolvePlatformCompanyKey(context, 'platformCompanyEndOfList'),
          ),
        ),
      );
    }
    return const SizedBox(height: 8);
  }
}
