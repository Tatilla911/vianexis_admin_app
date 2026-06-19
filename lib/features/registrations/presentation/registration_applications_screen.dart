import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/registration_applications_repository.dart';
import 'registration_providers.dart';
import 'widgets/registration_application_card.dart';
import 'widgets/registration_status_filter_bar.dart';

class RegistrationApplicationsScreen extends ConsumerStatefulWidget {
  const RegistrationApplicationsScreen({super.key});

  @override
  ConsumerState<RegistrationApplicationsScreen> createState() =>
      _RegistrationApplicationsScreenState();
}

class _RegistrationApplicationsScreenState
    extends ConsumerState<RegistrationApplicationsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(registrationListQueryProvider);
    final applicationsAsync = ref.watch(filteredRegistrationApplicationsProvider);
    final usesMock = ref.watch(registrationApplicationsRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.registrationsTitle),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolveRegistrationKey(context, 'registrationMockDataBadge'),
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
                hintText: resolveRegistrationKey(context, 'registrationSearchHint'),
              ),
              onChanged: (value) =>
                  ref.read(registrationListQueryProvider.notifier).setSearch(value),
            ),
          ),
          RegistrationStatusFilterBar(
            selected: query.filter,
            onSelected: ref.read(registrationListQueryProvider.notifier).setFilter,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: applicationsAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView(
                message: resolveRegistrationKey(context, 'registrationListError'),
                onRetry: () =>
                    ref.read(registrationApplicationsProvider.notifier).refresh(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        resolveRegistrationKey(context, 'registrationListEmpty'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(registrationApplicationsProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        RegistrationApplicationCard(application: items[index]),
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
