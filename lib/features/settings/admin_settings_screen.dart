import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/app_config.dart';
import '../../app/app_router.dart';
import '../../core/auth/admin_auth_state.dart';
import '../../core/auth/admin_user.dart';
import '../../core/localization/localization_resolver.dart';
import '../../core/widgets/app_environment_badge.dart';
import '../../core/widgets/vianexis_admin_card.dart';
import '../../core/widgets/vianexis_brand_header.dart';
import '../../core/widgets/vianexis_confirm_dialog.dart';
import '../../core/widgets/vianexis_section_header.dart';
import '../../l10n/app_localizations.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(adminAuthProvider).user;
    final showReleaseCenter =
        user?.canAccess(AdminDestination.releaseCenter) ?? false;
    final config = AppConfig.instance;
    final envLabel = resolveAppConfigKey(context, config.displayLabelKey);
    final apiHost = config.isApiConfigured
        ? (config.safeApiHostDisplay ??
            resolveAppConfigKey(context, 'appConfigApiConfigured'))
        : l10n.settingsBackendNotConfiguredValue;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const VianexisBrandHeader(showEnvironment: true),
          const SizedBox(height: 20),
          VianexisSectionHeader(title: l10n.settingsAccountSection),
          const SizedBox(height: 12),
          VianexisAdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _infoRow(context, l10n.settingsEmailLabel, user?.email ?? '—'),
                const SizedBox(height: 12),
                _infoRow(
                  context,
                  l10n.settingsRoleLabel,
                  user == null
                      ? '—'
                      : roleLabel(context, user.role.localizationKey()),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          VianexisSectionHeader(title: l10n.brandEnvironmentLabel),
          const SizedBox(height: 12),
          VianexisAdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const AppEnvironmentBadge(),
                const SizedBox(height: 12),
                _infoRow(context, l10n.settingsEnvironmentLabel, envLabel),
                const SizedBox(height: 12),
                _infoRow(
                  context,
                  resolveAppConfigKey(context, 'settingsApiHostLabel'),
                  apiHost,
                ),
                const SizedBox(height: 12),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.data?.version ?? '—';
                    return _infoRow(context, l10n.settingsVersionLabel, version);
                  },
                ),
                if (config.isProductionMisconfigured) ...[
                  const SizedBox(height: 12),
                  Text(
                    resolveAppConfigKey(
                      context,
                      'appConfigProductionMisconfigured',
                    ),
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.error,
                    ),
                  ),
                ],
              ],
            ),
          ),
          if (showReleaseCenter) ...[
            const SizedBox(height: 20),
            VianexisSectionHeader(title: l10n.settingsReleaseSection),
            const SizedBox(height: 12),
            VianexisAdminCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(l10n.settingsReleaseCenterBody),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => context.go(AdminRoutes.releaseCenter),
                    child: Text(l10n.settingsOpenReleaseCenter),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 20),
          VianexisSectionHeader(title: l10n.settingsNotificationsSection),
          const SizedBox(height: 12),
          VianexisAdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.settingsNotificationsBody),
                const SizedBox(height: 16),
                OutlinedButton(
                  onPressed: () => context.go(AdminRoutes.notificationPreferences),
                  child: Text(l10n.settingsOpenNotificationPreferences),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          VianexisSectionHeader(title: l10n.settingsSignOutSection),
          const SizedBox(height: 12),
          VianexisAdminCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.brandSecureAdminSession),
                const SizedBox(height: 8),
                Text(l10n.logoutConfirmBody),
                const SizedBox(height: 16),
                FilledButton.tonal(
                  onPressed: user == null
                      ? null
                      : () async {
                          final confirmed = await showVianexisConfirmDialog(
                            context: context,
                            title: l10n.logoutConfirmTitle,
                            body: l10n.logoutConfirmBody,
                            confirmLabel: l10n.authLogout,
                            isDestructive: true,
                          );
                          if (confirmed == true && context.mounted) {
                            await ref.read(adminAuthProvider.notifier).signOut();
                          }
                        },
                  child: Text(l10n.authLogout),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoRow(BuildContext context, String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 132,
          child: Text(
            label,
            style: Theme.of(context).textTheme.labelLarge,
          ),
        ),
        Expanded(
          child: Text(
            value,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
      ],
    );
  }
}
