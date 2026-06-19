import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../core/auth/admin_auth_state.dart';
import '../../../app/app_router.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/bulk_onboarding_repository.dart';
import 'bulk_onboarding_providers.dart';
import 'widgets/bulk_onboarding_filter_bar.dart';
import 'widgets/bulk_onboarding_job_card.dart';

class BulkOnboardingJobsScreen extends ConsumerStatefulWidget {
  const BulkOnboardingJobsScreen({super.key});

  @override
  ConsumerState<BulkOnboardingJobsScreen> createState() =>
      _BulkOnboardingJobsScreenState();
}

class _BulkOnboardingJobsScreenState extends ConsumerState<BulkOnboardingJobsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(bulkOnboardingListQueryProvider);
    final jobsAsync = ref.watch(filteredBulkOnboardingJobsProvider);
    final usesMock = ref.watch(bulkOnboardingRepositoryProvider).usesMockData;
    final canUpload =
        ref.watch(adminAuthProvider).user?.role.canUploadBulkOnboarding ?? false;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.bulkOnboardingTitle),
        actions: [
          if (canUpload)
            IconButton(
              tooltip: resolveBulkOnboardingKey(context, 'bulkOnboardingUploadCsv'),
              onPressed: () => context.push(AdminRoutes.bulkOnboardingUpload),
              icon: const Icon(Icons.upload_file),
            ),
          if (usesMock)
            MockDataBadge(
              label: resolveBulkOnboardingKey(context, 'bulkOnboardingMockDataBadge'),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: resolveBulkOnboardingKey(context, 'bulkOnboardingSearchHint'),
              ),
              onChanged: (value) =>
                  ref.read(bulkOnboardingListQueryProvider.notifier).setSearch(value),
            ),
          ),
          BulkOnboardingFilterBar(
            selected: query.filter,
            onSelected: ref.read(bulkOnboardingListQueryProvider.notifier).setFilter,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: jobsAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView(
                message: resolveBulkOnboardingKey(context, 'bulkOnboardingListError'),
                onRetry: () => ref.read(bulkOnboardingJobsProvider.notifier).refresh(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        resolveBulkOnboardingKey(context, 'bulkOnboardingListEmpty'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(bulkOnboardingJobsProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length + 1,
                    itemBuilder: (context, index) {
                      if (index == items.length) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(
                            resolveBulkOnboardingKey(context, 'bulkOnboardingPrivacyNotice'),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                        );
                      }
                      final job = items[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: BulkOnboardingJobCard(
                          companyName: job.companyName,
                          status: job.status,
                          sourceFileName: job.sourceFileName,
                          totalRows: job.totalRows,
                          invalidRows: job.invalidRows,
                          riskLevelKey: job.riskLevel.localizationKey(),
                          onTap: () => context.push(AdminRoutes.bulkOnboardingJobDetail(job.id)),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
