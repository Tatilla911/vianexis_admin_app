import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/platform_audit_logs_repository.dart';
import 'audit_log_providers.dart';
import 'widgets/audit_log_card.dart';
import 'widgets/audit_log_date_range_button.dart';
import 'widgets/audit_log_filter_bar.dart';

class AuditLogsScreen extends ConsumerStatefulWidget {
  const AuditLogsScreen({super.key});

  @override
  ConsumerState<AuditLogsScreen> createState() => _AuditLogsScreenState();
}

class _AuditLogsScreenState extends ConsumerState<AuditLogsScreen> {
  final _searchController = TextEditingController();
  bool _isExporting = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _exportCsv() async {
    final repository = ref.read(platformAuditLogsRepositoryProvider);
    if (!repository.exportAvailable) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveAuditLogKey(context, 'auditLogExportUnavailable'))),
      );
      return;
    }

    setState(() => _isExporting = true);
    try {
      final query = ref.read(platformAuditLogListQueryProvider);
      final csv = await repository.exportCsv(query: query);
      await Clipboard.setData(ClipboardData(text: csv));
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveAuditLogKey(context, 'auditLogExportCopied'))),
      );
    } on ApiException catch (error) {
      if (!mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(resolveAuditLogKey(context, 'auditLogExportFailed'))),
      );
    } finally {
      if (mounted) setState(() => _isExporting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = ref.watch(platformAuditLogListQueryProvider);
    final logsAsync = ref.watch(filteredPlatformAuditLogsProvider);
    final usesMock = ref.watch(platformAuditLogsRepositoryProvider).usesMockData;
    final exportAvailable = ref.watch(platformAuditLogsExportAvailableProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.auditLogsTitle),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolveAuditLogKey(context, 'auditLogMockDataBadge'),
            ),
          IconButton(
            tooltip: resolveAuditLogKey(context, 'auditLogExportCsv'),
            onPressed: exportAvailable && !_isExporting ? _exportCsv : null,
            icon: _isExporting
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.download_outlined),
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
            child: AuditLogDateRangeButton(
              query: query,
              onChanged: (from, to) => ref
                  .read(platformAuditLogListQueryProvider.notifier)
                  .setDateRange(from, to),
              onClear: () =>
                  ref.read(platformAuditLogListQueryProvider.notifier).clearDateRange(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: Text(
              resolveAuditLogKey(context, 'auditLogExportSafetyNotice'),
              style: Theme.of(context).textTheme.bodySmall,
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
              error: (error, _) => VianexisErrorView.fromError(
                context,
                error,
                fallbackMessage: resolveAuditLogKey(context, 'auditLogLoadError'),
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
