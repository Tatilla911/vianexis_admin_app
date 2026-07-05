import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/widgets/backend_dependency_card.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../l10n/app_localizations.dart';
import '../data/company_exchange_settings_repository.dart';
import '../domain/company_exchange_settings.dart';

class CompanyExchangeSettingsScreen extends ConsumerStatefulWidget {
  const CompanyExchangeSettingsScreen({super.key, required this.companyId});

  final String companyId;

  @override
  ConsumerState<CompanyExchangeSettingsScreen> createState() =>
      _CompanyExchangeSettingsScreenState();
}

class _CompanyExchangeSettingsScreenState
    extends ConsumerState<CompanyExchangeSettingsScreen> {
  bool? _palletEnabled;
  bool? _packagingEnabled;
  bool? _customItemsEnabled;
  bool _dirty = false;
  bool _saving = false;

  void _syncFromSettings(CompanyExchangeSettings settings) {
    _palletEnabled = settings.palletExchangeEnabled;
    _packagingEnabled = settings.packagingExchangeEnabled;
    _customItemsEnabled = settings.allowDriverCustomPackagingItems;
    _dirty = false;
  }

  Future<void> _save() async {
    if (!_dirty || _saving) return;
    setState(() => _saving = true);
    try {
      await saveCompanyExchangeSettings(
        ref,
        companyId: widget.companyId,
        patch: CompanyExchangeSettingsPatch(
          palletExchangeEnabled: _palletEnabled,
          packagingExchangeEnabled: _packagingEnabled,
          allowDriverCustomPackagingItems: _customItemsEnabled,
        ),
      );
      if (!mounted) return;
      setState(() {
        _dirty = false;
        _saving = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).companyExchangeSaved)),
      );
    } catch (_) {
      if (!mounted) return;
      setState(() => _saving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(AppLocalizations.of(context).companyExchangeSaveFailed),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(companyExchangeSettingsProvider(widget.companyId));
    final usesMock =
        ref.watch(companyExchangeSettingsRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.companyExchangeSettingsTitle),
        actions: [
          if (usesMock)
            MockDataBadge(label: l10n.companyExchangeMockDataBadge),
          if (_dirty)
            TextButton(
              onPressed: _saving ? null : _save,
              child: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(l10n.companyExchangeSave),
            ),
        ],
      ),
      body: settingsAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) {
          final liveMode = !usesMock;
          return VianexisErrorView.fromError(
            context,
            error,
            fallbackMessage: liveMode
                ? l10n.companyExchangeBackendDependency
                : l10n.companyExchangeLoadFailed,
            onRetry: () => ref.invalidate(
              companyExchangeSettingsProvider(widget.companyId),
            ),
          );
        },
        data: (settings) {
          if (!_dirty &&
              (_palletEnabled == null ||
                  _packagingEnabled == null ||
                  _customItemsEnabled == null)) {
            _syncFromSettings(settings);
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(
                    l10n.companyExchangePrivacyNotice,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                ),
              ),
              if (usesMock) ...[
                const SizedBox(height: 8),
                Card(
                  color: Theme.of(context).colorScheme.surfaceContainerHighest,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.companyExchangeMockNotice),
                  ),
                ),
              ],
              const SizedBox(height: 12),
              SwitchListTile(
                title: Text(l10n.companyExchangePalletEnabled),
                subtitle: Text(l10n.companyExchangePalletEnabledHint),
                value: _palletEnabled ?? settings.palletExchangeEnabled,
                onChanged: (value) => setState(() {
                  _palletEnabled = value;
                  _dirty = true;
                }),
              ),
              SwitchListTile(
                title: Text(l10n.companyExchangePackagingEnabled),
                subtitle: Text(l10n.companyExchangePackagingEnabledHint),
                value: _packagingEnabled ?? settings.packagingExchangeEnabled,
                onChanged: (value) => setState(() {
                  _packagingEnabled = value;
                  _dirty = true;
                }),
              ),
              SwitchListTile(
                title: Text(l10n.companyExchangeCustomItemsEnabled),
                subtitle: Text(l10n.companyExchangeCustomItemsEnabledHint),
                value:
                    _customItemsEnabled ?? settings.allowDriverCustomPackagingItems,
                onChanged: (value) => setState(() {
                  _customItemsEnabled = value;
                  _dirty = true;
                }),
              ),
              const SizedBox(height: 16),
              Text(
                l10n.companyExchangeDefaultPalletTypes,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  for (final type in settings.defaultPalletTypes)
                    Chip(label: Text(type)),
                ],
              ),
              const SizedBox(height: 16),
              Text(
                l10n.companyExchangeDefaultPackagingItems,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 4),
              Text(
                l10n.companyExchangeDefaultPackagingPlaceholder,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              for (final item in settings.defaultPackagingItems)
                ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.inventory_2_outlined),
                  title: Text(item.name),
                  subtitle: Text(
                    [
                      if (item.localizedNameKey != null) item.localizedNameKey!,
                      if (item.sortOrder > 0)
                        '${l10n.companyExchangeItemSortOrder}: ${item.sortOrder}',
                      if (item.notes != null && item.notes!.isNotEmpty) item.notes!,
                    ].join(' · '),
                  ),
                  trailing: item.active
                      ? null
                      : Text(
                          l10n.companyExchangeItemInactive,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                ),
              const SizedBox(height: 16),
              BackendDependencyCard(
                title: l10n.companyExchangePackagingCrudTitle,
                message: l10n.companyExchangePackagingCrudDependency,
                endpointHint:
                    'POST/PATCH/DELETE /companies/:id/exchange-settings/packaging-items (planned)',
              ),
              const SizedBox(height: 12),
              BackendDependencyCard(
                title: l10n.companyExchangeManualPalletRecordTitle,
                message: l10n.companyExchangeManualPalletRecordDependency,
                endpointHint:
                    'PATCH /companies/:id/exchange-settings allowDriverManualPalletRecord (planned)',
              ),
            ],
          );
        },
      ),
    );
  }
}
