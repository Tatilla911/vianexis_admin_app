import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../../l10n/app_localizations.dart';
import '../data/customer_communications_repository.dart';
import 'customer_communications_providers.dart';
import 'widgets/communication_thread_card.dart';
import 'widgets/customer_communications_filter_bar.dart';

class CustomerCommunicationsScreen extends ConsumerStatefulWidget {
  const CustomerCommunicationsScreen({super.key});

  @override
  ConsumerState<CustomerCommunicationsScreen> createState() =>
      _CustomerCommunicationsScreenState();
}

class _CustomerCommunicationsScreenState
    extends ConsumerState<CustomerCommunicationsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(customerCommunicationListQueryProvider);
    final threadsAsync = ref.watch(filteredCustomerCommunicationsProvider);
    final usesMock = ref.watch(customerCommunicationsRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.customerCommunicationsTitle),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationMockDataBadge',
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: VianexisMetadataNotice(
              message: resolveCustomerCommunicationsKey(
                context,
                'customerCommunicationPrivacyNotice',
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationSearchHint',
                ),
              ),
              onChanged: (value) => ref
                  .read(customerCommunicationListQueryProvider.notifier)
                  .setSearch(value),
            ),
          ),
          CustomerCommunicationsFilterBar(
            selected: query.filter,
            onSelected:
                ref.read(customerCommunicationListQueryProvider.notifier).setFilter,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: threadsAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView.fromError(
                context,
                error,
                fallbackMessage: resolveCustomerCommunicationsKey(
                  context,
                  'customerCommunicationLoadError',
                ),
                onRetry: () =>
                    ref.read(customerCommunicationsProvider.notifier).refresh(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        resolveCustomerCommunicationsKey(
                          context,
                          'customerCommunicationListEmpty',
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () =>
                      ref.read(customerCommunicationsProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        CommunicationThreadCard(thread: items[index]),
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
