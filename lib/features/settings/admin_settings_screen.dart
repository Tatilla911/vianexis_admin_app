import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../app/app_environment.dart';
import '../../core/api/api_config.dart';
import '../../core/auth/admin_auth_state.dart';
import '../../core/auth/admin_user.dart';
import '../../core/localization/localization_resolver.dart';
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
    final environment = AppEnvironment.fromDefine(
      const String.fromEnvironment(AppEnvironment.dartDefineKey),
    ).value;
    final apiBaseUrl = ApiConfig.isConfigured
        ? ApiConfig.baseUrl
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
                _infoRow(context, l10n.settingsApiBaseUrlLabel, apiBaseUrl),
                const SizedBox(height: 12),
                _infoRow(context, l10n.settingsEnvironmentLabel, environment),
                const SizedBox(height: 12),
                FutureBuilder<PackageInfo>(
                  future: PackageInfo.fromPlatform(),
                  builder: (context, snapshot) {
                    final version = snapshot.data?.version ?? '—';
                    return _infoRow(context, l10n.settingsVersionLabel, version);
                  },
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
