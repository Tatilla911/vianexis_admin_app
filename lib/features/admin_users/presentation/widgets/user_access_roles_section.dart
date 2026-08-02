import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/widgets/vianexis_error_view.dart';
import '../../../../core/widgets/vianexis_loading_view.dart';
import '../../../../l10n/app_localizations.dart';
import '../../data/user_access_api.dart';
import 'user_access_change_dialog.dart';

class UserAccessRolesSection extends ConsumerStatefulWidget {
  const UserAccessRolesSection({
    super.key,
    required this.userId,
    required this.canManage,
  });

  final String userId;
  final bool canManage;

  @override
  ConsumerState<UserAccessRolesSection> createState() =>
      _UserAccessRolesSectionState();
}

class _UserAccessRolesSectionState
    extends ConsumerState<UserAccessRolesSection> {
  Map<String, bool> _draft = {};
  bool _dirty = false;

  String _key(UserAccessCatalogEntry e) => '${e.targetType}:${e.targetKey}';

  void _syncDraft(List<UserAccessCatalogEntry> catalog) {
    if (_dirty) return;
    _draft = {
      for (final e in catalog) _key(e): e.active,
    };
  }

  Future<void> _save(List<UserAccessCatalogEntry> catalog) async {
    final saved = await showUserAccessChangeDialog(
      context: context,
      ref: ref,
      userId: widget.userId,
      baseline: catalog,
      draftEnabled: Map<String, bool>.from(_draft),
    );
    if (!saved || !mounted) return;
    setState(() {
      _dirty = false;
      _draft = {};
    });
    ref.invalidate(userAccessProvider(widget.userId));
  }

  void _reset(List<UserAccessCatalogEntry> catalog) {
    setState(() {
      _dirty = false;
      _draft = {
        for (final e in catalog) _key(e): e.active,
      };
    });
  }

  String _label(AppLocalizations l10n, UserAccessCatalogEntry entry) {
    return switch (entry.targetKey) {
      'super_admin' => l10n.roleSuperAdmin,
      'support_admin' => l10n.roleSupportAdmin,
      'onboarding_reviewer' => l10n.roleOnboardingReviewer,
      'billing_admin' => l10n.roleBillingAdmin,
      'company_admin' => l10n.adminUserAccessRoleCompanyAdmin,
      'dispatcher' => l10n.adminUserAccessRoleDispatcher,
      'driver' => l10n.adminUserAccessRoleDriver,
      'workshop' => l10n.adminUserAccessRoleWorkshop,
      'documentation' => l10n.adminUserAccessRoleDocumentation,
      'claims' => l10n.adminUserAccessRoleClaims,
      'driver_app' => l10n.adminUserAccessAppDriver,
      'company_portal' => l10n.adminUserAccessAppPortal,
      'platform_admin' => l10n.adminUserAccessAppPlatform,
      _ => entry.targetKey,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final async = ref.watch(userAccessProvider(widget.userId));
    return async.when(
      loading: () => const Padding(
        padding: EdgeInsets.symmetric(vertical: 16),
        child: VianexisLoadingView(),
      ),
      error: (error, _) => VianexisErrorView.fromError(
        context,
        error,
        fallbackMessage: l10n.adminUserAccessLoadError,
        onRetry: () => ref.invalidate(userAccessProvider(widget.userId)),
      ),
      data: (snapshot) {
        _syncDraft(snapshot.catalog);
        final roles = snapshot.catalog
            .where((e) => e.targetType != 'app_access')
            .toList();
        final apps = snapshot.catalog
            .where((e) => e.targetType == 'app_access')
            .toList();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.adminUserAccessSectionTitle,
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 4),
            Text(
              l10n.adminUserAccessSectionSubtitle,
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.adminUserAccessRolesHeading,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            ...roles.map((entry) => _tile(l10n, entry)),
            const SizedBox(height: 12),
            Text(
              l10n.adminUserAccessAppsHeading,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            ...apps.map((entry) => _tile(l10n, entry)),
            if (snapshot.pendingChangeRequests.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(
                l10n.adminUserAccessPendingHeading,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              ...snapshot.pendingChangeRequests.map((p) {
                return ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  title: Text(p['changeRequestId']?.toString() ?? '—'),
                  subtitle: Text(
                    '${p['status'] ?? ''} · ${p['reason'] ?? ''}',
                  ),
                );
              }),
            ],
            if (widget.canManage) ...[
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton(
                    onPressed: _dirty
                        ? () => _save(snapshot.catalog)
                        : null,
                    child: Text(l10n.adminUserAccessSaveChanges),
                  ),
                  OutlinedButton(
                    onPressed: _dirty
                        ? () => _reset(snapshot.catalog)
                        : null,
                    child: Text(l10n.adminUserAccessReset),
                  ),
                ],
              ),
            ],
          ],
        );
      },
    );
  }

  Widget _tile(AppLocalizations l10n, UserAccessCatalogEntry entry) {
    final key = _key(entry);
    final checked = _draft[key] ?? entry.active;
    final pending = entry.pendingChange != null;
    return CheckboxListTile(
      value: checked,
      onChanged: widget.canManage
          ? (value) {
              setState(() {
                _draft[key] = value ?? false;
                _dirty = true;
              });
            }
          : null,
      title: Text(_label(l10n, entry)),
      subtitle: Text(
        [
          entry.scope,
          if (entry.sensitive) l10n.adminUserAccessSensitive,
          if (pending) l10n.adminUserAccessPendingBadge,
          if (entry.dependencyWarnings.isNotEmpty)
            l10n.adminUserAccessDependencyWarning,
        ].join(' · '),
      ),
      controlAffinity: ListTileControlAffinity.leading,
      dense: true,
    );
  }
}
