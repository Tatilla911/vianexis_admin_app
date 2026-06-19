import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/support_tickets_repository.dart';
import 'support_providers.dart';
import 'widgets/support_filter_bars.dart';
import 'widgets/support_ticket_card.dart';

class SupportTicketsScreen extends ConsumerStatefulWidget {
  const SupportTicketsScreen({super.key});

  @override
  ConsumerState<SupportTicketsScreen> createState() => _SupportTicketsScreenState();
}

class _SupportTicketsScreenState extends ConsumerState<SupportTicketsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(supportTicketListQueryProvider);
    final ticketsAsync = ref.watch(filteredSupportTicketsProvider);
    final usesMock = ref.watch(supportTicketsRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.supportTicketsTitle),
        actions: [
          if (usesMock)
            Padding(
              padding: const EdgeInsets.only(right: 16),
              child: Center(
                child: Text(
                  resolveSupportKey(context, 'supportMockDataBadge'),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
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
                hintText: resolveSupportKey(context, 'supportTicketSearchHint'),
              ),
              onChanged: (value) =>
                  ref.read(supportTicketListQueryProvider.notifier).setSearch(value),
            ),
          ),
          SupportTicketFilterBar(
            selected: query.filter,
            onSelected: ref.read(supportTicketListQueryProvider.notifier).setFilter,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: ticketsAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView(
                message: resolveSupportKey(context, 'supportLoadError'),
                onRetry: () => ref.read(supportTicketsProvider.notifier).refresh(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        resolveSupportKey(context, 'supportTicketListEmpty'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.read(supportTicketsProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) =>
                        SupportTicketCard(ticket: items[index]),
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
