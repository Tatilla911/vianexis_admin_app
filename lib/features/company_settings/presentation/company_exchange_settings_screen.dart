import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  bool _packagingActionInProgress = false;

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
        SnackBar(
          content: Text(AppLocalizations.of(context).companyExchangeSaved),
        ),
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

  Future<void> _showPackagingItemDialog([DefaultPackagingItem? item]) async {
    final l10n = AppLocalizations.of(context);
    final nameController = TextEditingController(text: item?.name ?? '');
    final sortOrderController = TextEditingController(
      text: item?.sortOrder == null ? '' : item!.sortOrder.toString(),
    );
    final notesController = TextEditingController(text: item?.notes ?? '');
    final formKey = GlobalKey<FormState>();

    final patch = await showDialog<PackagingItemPatch>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            item == null
                ? l10n.companyExchangeAddPackagingItem
                : l10n.companyExchangeEditPackagingItem,
          ),
          content: Form(
            key: formKey,
            child: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        labelText: l10n.companyExchangePackagingItemName,
                      ),
                      textInputAction: TextInputAction.next,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return l10n.companyExchangePackagingItemNameRequired;
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: sortOrderController,
                      decoration: InputDecoration(
                        labelText: l10n.companyExchangePackagingItemSortOrder,
                      ),
                      keyboardType: TextInputType.number,
                      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      controller: notesController,
                      decoration: InputDecoration(
                        labelText: l10n.companyExchangePackagingItemNotes,
                      ),
                      minLines: 2,
                      maxLines: 4,
                    ),
                  ],
                ),
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text(l10n.companyExchangeCancel),
            ),
            FilledButton(
              onPressed: () {
                if (!formKey.currentState!.validate()) return;
                Navigator.of(context).pop(
                  PackagingItemPatch(
                    name: nameController.text.trim(),
                    sortOrder:
                        int.tryParse(sortOrderController.text.trim()) ?? 0,
                    notes: notesController.text.trim().isEmpty
                        ? null
                        : notesController.text.trim(),
                    isActive: item?.active ?? true,
                  ),
                );
              },
              child: Text(l10n.companyExchangeSavePackagingItem),
            ),
          ],
        );
      },
    );

    nameController.dispose();
    sortOrderController.dispose();
    notesController.dispose();

    if (patch == null) return;

    setState(() => _packagingActionInProgress = true);
    try {
      if (item == null) {
        await createCompanyPackagingItem(
          ref,
          companyId: widget.companyId,
          patch: patch,
        );
      } else {
        await patchCompanyPackagingItem(
          ref,
          companyId: widget.companyId,
          itemId: item.id,
          patch: patch,
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.companyExchangePackagingItemSaved)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.companyExchangePackagingItemSaveFailed)),
      );
    } finally {
      if (mounted) {
        setState(() => _packagingActionInProgress = false);
      }
    }
  }

  Future<void> _setPackagingItemActive(
    DefaultPackagingItem item,
    bool active,
  ) async {
    final l10n = AppLocalizations.of(context);
    setState(() => _packagingActionInProgress = true);
    try {
      if (active) {
        await patchCompanyPackagingItem(
          ref,
          companyId: widget.companyId,
          itemId: item.id,
          patch: const PackagingItemPatch(isActive: true),
        );
      } else {
        await deactivateCompanyPackagingItem(
          ref,
          companyId: widget.companyId,
          itemId: item.id,
        );
      }
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.companyExchangePackagingItemSaved)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.companyExchangePackagingItemSaveFailed)),
      );
    } finally {
      if (mounted) {
        setState(() => _packagingActionInProgress = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final settingsAsync = ref.watch(
      companyExchangeSettingsProvider(widget.companyId),
    );
    final usesMock = ref
        .watch(companyExchangeSettingsRepositoryProvider)
        .usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.companyExchangeSettingsTitle),
        actions: [
          if (usesMock) MockDataBadge(label: l10n.companyExchangeMockDataBadge),
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
                    _customItemsEnabled ??
                    settings.allowDriverCustomPackagingItems,
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
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.companyExchangeDefaultPackagingItems,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                  ),
                  FilledButton.icon(
                    onPressed: _packagingActionInProgress
                        ? null
                        : () => _showPackagingItemDialog(),
                    icon: const Icon(Icons.add),
                    label: Text(l10n.companyExchangeAddPackagingItem),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                l10n.companyExchangeDefaultPackagingPlaceholder,
                style: Theme.of(context).textTheme.bodySmall,
              ),
              const SizedBox(height: 8),
              if (settings.defaultPackagingItems.isEmpty)
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Text(l10n.companyExchangePackagingItemEmpty),
                  ),
                )
              else
                for (final item in settings.defaultPackagingItems)
                  Card(
                    child: ListTile(
                      leading: Icon(
                        item.active
                            ? Icons.inventory_2_outlined
                            : Icons.inventory_2,
                      ),
                      title: Text(item.name),
                      subtitle: Text(
                        [
                          if (item.localizedNameKey != null)
                            item.localizedNameKey!,
                          if (item.sortOrder > 0)
                            '${l10n.companyExchangeItemSortOrder}: ${item.sortOrder}',
                          if (item.notes != null && item.notes!.isNotEmpty)
                            item.notes!,
                          if (!item.active) l10n.companyExchangeItemInactive,
                        ].join(' · '),
                      ),
                      trailing: Wrap(
                        spacing: 4,
                        children: [
                          IconButton(
                            tooltip: l10n.companyExchangeEditPackagingItem,
                            onPressed: _packagingActionInProgress
                                ? null
                                : () => _showPackagingItemDialog(item),
                            icon: const Icon(Icons.edit_outlined),
                          ),
                          IconButton(
                            tooltip: item.active
                                ? l10n.companyExchangeDeactivatePackagingItem
                                : l10n.companyExchangeReactivatePackagingItem,
                            onPressed: _packagingActionInProgress
                                ? null
                                : () => _setPackagingItemActive(
                                    item,
                                    !item.active,
                                  ),
                            icon: Icon(
                              item.active
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              const SizedBox(height: 16),
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
