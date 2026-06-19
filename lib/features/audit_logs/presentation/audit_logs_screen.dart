import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/platform_audit_logs_repository.dart';
import 'audit_log_providers.dart';
import 'widgets/audit_log_card.dart';
import 'widgets/audit_log_filter_bar.dart';

class AuditLogsScreen extends ConsumerStatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  ConsumerState<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends ConsumerState<AuditLogsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(platformAuditLogListQueryProvider);
    final logsAsync = ref.watch(filteredPlatformAuditLogsProvider);
    final usesMock = ref.watch(platformAuditLogsRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.auditLogsTitle),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolveAuditLogKey(context, 'auditLogMockDataBadge'),
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
                hintText: resolveAuditLogKey(context, 'auditLogSearchHint'),
              ),
              onChanged: (value) =>
                  ref.read(platformAuditLogListQueryProvider.notifier).setSearch(value),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: null,
                child: Text(resolveAuditLogKey(context, 'auditLogDateRangeComingSoon')),
              ),
            ),
          ),
          AuditLogFilterBar(
            selected: query.filter,
            onSelected: ref.read(platformAuditLogListQueryProvider.notifier).setFilter,
          ),
          const SizedBox(height: 8),
          Expanded(
            child: logsAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView(
                message: resolveAuditLogKey(context, 'auditLogLoadError'),
                onRetry: () => ref.read(platformAuditLogsProvider.notifier).refresh(),
              ),
              data: (items) {
                if (items.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(
                        resolveAuditLogKey(context, 'auditLogListEmpty'),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () => ref.read(platformAuditLogsProvider.notifier).refresh(),
                  child: ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                    itemCount: items.length,
                    itemBuilder: (context, index) => AuditLogCard(log: items[index]),
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
