import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../core/auth/admin_auth_state.dart';
import '../../core/auth/admin_user.dart';
import '../../core/localization/localization_resolver.dart';
import '../../core/widgets/vianexis_admin_scaffold.dart';
import '../../l10n/app_localizations.dart';

class AdminSettingsScreen extends ConsumerWidget {
  const AdminSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(adminAuthProvider).user;

    return AdminFeatureScaffold(
      title: l10n.settingsTitle,
      body: l10n.settingsPlaceholderBody,
      showPrivacyNotice: false,
      footer: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (user != null)
            Card(
              child: ListTile(
                leading: const Icon(Icons.badge_outlined),
                title: Text(user.email),
                subtitle: Text(roleLabel(context, user.role.localizationKey())),
              ),
            ),
          const SizedBox(height: 12),
          FutureBuilder<PackageInfo>(
            future: PackageInfo.fromPlatform(),
            builder: (context, snapshot) {
              final version = snapshot.data?.version ?? '—';
              return Text(l10n.settingsAppVersion(version));
            },
          ),
          const SizedBox(height: 16),
          FilledButton.tonal(
            onPressed: () => ref.read(adminAuthProvider.notifier).signOut(),
            child: Text(l10n.authLogout),
          ),
        ],
      ),
    );
  }
}
