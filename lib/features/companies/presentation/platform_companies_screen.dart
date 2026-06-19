import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/localization/localization_resolver.dart';
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

class _PlatformCompaniesScreenState extends ConsumerState<PlatformCompaniesScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(platformCompanyListQueryProvider);
    final companiesAsync = ref.watch(filteredPlatformCompaniesProvider);
    final usesMock = ref.watch(platformCompaniesRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.platformCompaniesTitle),
        actions: [
          if (usesMock)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Center(
                child: Text(
                  resolvePlatformCompanyKey(context, 'platformCompanyMockDataBadge'),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ),
          Padding(
            padding: const EdgeInsets.only(right: 8),
            child: Center(
              child: Text(
                resolvePlatformCompanyKey(context, 'platformCompanyMetadataBadge'),
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
                onChanged: (value) =>
                    ref.read(platformCompanyListQueryProvider.notifier).setSearch(value),
              ),
            ),
            PlatformCompanyFilterBar(
              selected: query.filter,
              onSelected: ref.read(platformCompanyListQueryProvider.notifier).setFilter,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: companiesAsync.when(
                loading: () => const VianexisLoadingView(),
                error: (error, _) => VianexisErrorView(
                  message: resolvePlatformCompanyKey(context, 'platformCompanyListError'),
                  onRetry: () =>
                      ref.read(platformCompaniesProvider.notifier).refresh(),
                ),
                data: (companies) {
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
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    itemCount: companies.length,
                    itemBuilder: (context, index) {
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
