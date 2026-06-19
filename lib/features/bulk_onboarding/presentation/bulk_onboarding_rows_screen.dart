import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/bulk_onboarding_row.dart';
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final rowsAsync = ref.watch(bulkOnboardingRowsProvider(widget.jobId));

    return Scaffold(
      appBar: AppBar(title: Text(l10n.bulkOnboardingRowsTitle)),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(16),
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
          Expanded(
            child: rowsAsync.when(
              loading: () => const VianexisLoadingView(),
              error: (error, _) => VianexisErrorView(
                message: resolveBulkOnboardingKey(context, 'bulkOnboardingRowsError'),
                onRetry: () =>
                    ref.invalidate(bulkOnboardingRowsProvider(widget.jobId)),
              ),
              data: (rows) {
                final filtered = rows
                    .where((row) => row.matchesFilter(_filter))
                    .toList(growable: false);
                if (filtered.isEmpty) {
                  return Center(
                    child: Text(
                      resolveBulkOnboardingKey(context, 'bulkOnboardingRowsEmpty'),
                    ),
                  );
                }
                return ListView.builder(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                  itemCount: filtered.length,
                  itemBuilder: (context, index) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: BulkOnboardingRowCard(row: filtered[index]),
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
      BulkOnboardingRowListFilter.invalid =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingRowFilterInvalid'),
      BulkOnboardingRowListFilter.warning =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingRowFilterWarning'),
      BulkOnboardingRowListFilter.duplicate =>
        resolveBulkOnboardingKey(context, 'bulkOnboardingRowFilterDuplicate'),
    };
  }
}
