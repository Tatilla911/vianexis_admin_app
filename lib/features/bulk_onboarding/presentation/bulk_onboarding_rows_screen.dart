import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/bulk_onboarding_row.dart';
import '../domain/bulk_onboarding_row_status.dart';
import 'bulk_onboarding_providers.dart';
import 'widgets/bulk_onboarding_row_card.dart';

class BulkOnboardingRowsScreen extends ConsumerStatefulWidget {
  const BulkOnboardingRowsScreen({super.key, required this.jobId});

  final String jobId;

  @override
  ConsumerState<BulkOnboardingRowsScreen> createState() =>
      _BulkOnboardingRowsScreenState();
}

class _BulkOnboardingRowsScreenState extends ConsumerState<BulkOnboardingRowsScreen> {
  BulkOnboardingRowListFilter _filter = BulkOnboardingRowListFilter.all;
  final _searchController = TextEditingController();
  String _search = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  BulkOnboardingRowStatus? _statusForFilter(BulkOnboardingRowListFilter filter) {
    return switch (filter) {
      BulkOnboardingRowListFilter.all => null,
      BulkOnboardingRowListFilter.valid => BulkOnboardingRowStatus.valid,
      BulkOnboardingRowListFilter.invalid => BulkOnboardingRowStatus.invalid,
      BulkOnboardingRowListFilter.warning => BulkOnboardingRowStatus.warning,
      BulkOnboardingRowListFilter.duplicate => BulkOnboardingRowStatus.duplicate,
      BulkOnboardingRowListFilter.processed => BulkOnboardingRowStatus.processed,
      BulkOnboardingRowListFilter.failed => BulkOnboardingRowStatus.failed,
      BulkOnboardingRowListFilter.skipped => BulkOnboardingRowStatus.skipped,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rowsAsync = ref.watch(
      bulkOnboardingRowsProvider((
        jobId: widget.jobId,
        status: _statusForFilter(_filter),
        search: _search,
      )),
    );

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bulkOnboardingRowsTitle)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: resolveBulkOnboardingKey(
                  context,
                  'bulkOnboardingRowsSearchHint',
                ),
              ),
              onChanged: (value) => setState(() => _search = value),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                for (final filterOption in BulkOnboardingRowListFilter.values)
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: FilterChip(
                      selected: _filter == filterOption,
                      label: Text(_rowFilterLabel(context, filterOption)),
                      onSelected: (_) => setState(() => _filter = filterOption),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: rowsAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView(
                message: resolveBulkOnboardingKey(context, 'bulkOnboardingRowsError'),
                onRetry: () => ref.invalidate(
                  bulkOnboardingRowsProvider((
                    jobId: widget.jobId,
                    status: _statusForFilter(_filter),
                    search: _search,
                  )),
                ),
              ),
              data: (rows) {
                if (rows.isEmpty) {
                  return Center(
                    child: Text(
                      resolveBulkOnboardingKey(context, 'bulkOnboardingRowsEmpty'),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: rows.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BulkOnboardingRowCard(
                      row: rows[index],
                      onTap: () => context.push(
                        AdminRoutes.bulkOnboardingJobRowDetail(
                          widget.jobId,
                          rows[index].id,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  String _rowFilterLabel(BuildContext context, BulkOnboardingRowListFilter filter) {
    return switch (filter) {
      BulkOnboardingRowListFilter.all =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingRowFilterAll'),
      BulkOnboardingRowListFilter.valid =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingRowFilterValid'),
      BulkOnboardingRowListFilter.invalid =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingRowFilterInvalid'),
      BulkOnboardingRowListFilter.warning =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingRowFilterWarning'),
      BulkOnboardingRowListFilter.duplicate =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingRowFilterDuplicate'),
      BulkOnboardingRowListFilter.processed =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingRowFilterProcessed'),
      BulkOnboardingRowListFilter.failed =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingRowFilterFailed'),
      BulkOnboardingRowListFilter.skipped =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingRowFilterSkipped'),
    };
  }
}
