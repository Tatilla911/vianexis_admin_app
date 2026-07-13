import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/admin_auth_session.dart';
import '../../../core/widgets/vianexis_admin_card.dart';
import '../../../core/widgets/vianexis_confirm_dialog.dart';
import '../../../core/widgets/vianexis_section_header.dart';
import '../../../core/widgets/vianexis_status_badge.dart';
import '../../../l10n/app_localizations.dart';
import '../domain/admin_session_display.dart';
import '../presentation/admin_active_sessions_provider.dart';

class AdminActiveSessionsSection extends ConsumerWidget {
  const AdminActiveSessionsSection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final sessionsAsync = ref.watch(adminActiveSessionsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        VianexisSectionHeader(title: l10n.authActiveSessions),
        const SizedBox(height: 12),
        VianexisAdminCard(
          child: sessionsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (_, _) => Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(l10n.authNetworkError),
                const SizedBox(height: 12),
                OutlinedButton(
                  onPressed: () =>
                      ref.read(adminActiveSessionsProvider.notifier).refresh(),
                  child: Text(l10n.errorRetryButton),
                ),
              ],
            ),
            data: (sessions) {
              if (sessions.isEmpty) {
                return Text(l10n.authUnknownDevice);
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  for (final session in sessions) ...[
                    _SessionTile(session: session),
                    if (session != sessions.last) const Divider(height: 24),
                  ],
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: sessions.length <= 1
                        ? null
                        : () async {
                            final confirmed = await showVianexisConfirmDialog(
                              context: context,
                              title: l10n.authLogoutAllOtherDevices,
                              body: l10n.authLogoutAllOtherDevices,
                              confirmLabel: l10n.authLogoutAllOtherDevices,
                              isDestructive: true,
                            );
                            if (confirmed == true && context.mounted) {
                              await ref
                                  .read(adminActiveSessionsProvider.notifier)
                                  .logoutAllOtherDevices();
                            }
                          },
                    child: Text(l10n.authLogoutAllOtherDevices),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}

class _SessionTile extends ConsumerWidget {
  const _SessionTile({required this.session});

  final AdminAuthSession session;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final deviceLabel = resolveSessionDeviceLabel(
      l10n,
      deviceName: session.deviceName,
      platform: session.platform,
      appType: session.appType,
    );
    final platformLabel = resolveSessionPlatformLabel(l10n, session.platform);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                deviceLabel,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            if (session.isCurrent)
              VianexisStatusBadge(
                label: l10n.authCurrentDevice,
                tone: VianexisStatusTone.healthy,
              ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          '${l10n.authLastActive}: ${formatSessionTimestamp(context, session.lastUsedAt ?? session.createdAt)}',
        ),
        const SizedBox(height: 4),
        Text(
          '${l10n.authSessionExpires}: ${formatSessionTimestamp(context, session.expiresAt)}',
        ),
        const SizedBox(height: 4),
        Text(platformLabel),
        if (!session.isCurrent) ...[
          const SizedBox(height: 12),
          OutlinedButton(
            onPressed: () async {
              final confirmed = await showVianexisConfirmDialog(
                context: context,
                title: l10n.authRemoveSession,
                body: deviceLabel,
                confirmLabel: l10n.authRemoveSession,
                isDestructive: true,
              );
              if (confirmed == true && context.mounted) {
                await ref
                    .read(adminActiveSessionsProvider.notifier)
                    .revokeSession(session.id);
              }
            },
            child: Text(l10n.authRemoveSession),
          ),
        ],
      ],
    );
  }
}
