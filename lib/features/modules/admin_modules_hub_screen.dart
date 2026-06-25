import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_router.dart';
import '../../core/auth/admin_auth_state.dart';
import '../../core/auth/admin_user.dart';
import '../../core/navigation/admin_shell_navigation.dart';
import '../../core/widgets/vianexis_admin_card.dart';
import '../../l10n/app_localizations.dart';

class AdminModulesHubScreen extends ConsumerWidget {
  const AdminModulesHubScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    final user = ref.watch(adminAuthProvider).user;
    if (user == null) {
      return const SizedBox.shrink();
    }

    final modules = _secondaryModules(user);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.modulesHubTitle),
        leading: IconButton(
          tooltip: l10n.navReturnToDashboard,
          icon: const Icon(Icons.home_outlined),
          onPressed: () => context.go(AdminRoutes.dashboard),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.modulesHubBody,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: MediaQuery.sizeOf(context).width >= 600 ? 3 : 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.15,
            children: [
              for (final module in modules)
                VianexisAdminCard(
                  onTap: () => context.go(module.route),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(module.icon, size: 28),
                      const SizedBox(height: 10),
                      Text(
                        module.label(context),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      if (module.description(context) != null) ...[
                        const SizedBox(height: 6),
                        Text(
                          module.description(context)!,
                          textAlign: TextAlign.center,
                          maxLines: 3,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  List<_ModuleTile> _secondaryModules(AdminUser user) {
    return _allModules
        .where(
          (module) =>
              !isMobilePrimaryDestination(module.destination) &&
              user.canAccess(module.destination),
        )
        .toList(growable: false);
  }
}

class _ModuleTile {
  const _ModuleTile({
    required this.destination,
    required this.route,
    required this.icon,
    required this.labelKey,
    this.descriptionKey,
  });

  final AdminDestination destination;
  final String route;
  final IconData icon;
  final String Function(BuildContext context) labelKey;
  final String? Function(BuildContext context)? descriptionKey;

  String label(BuildContext context) => labelKey(context);

  String? description(BuildContext context) => descriptionKey?.call(context);
}

List<_ModuleTile> get _allModules => [
  _ModuleTile(
    destination: AdminDestination.companies,
    route: AdminRoutes.companies,
    icon: Icons.business_outlined,
    labelKey: (c) => AppLocalizations.of(c).navCompanies,
  ),
  _ModuleTile(
    destination: AdminDestination.billing,
    route: AdminRoutes.billing,
    icon: Icons.payments_outlined,
    labelKey: (c) => AppLocalizations.of(c).navBilling,
  ),
  _ModuleTile(
    destination: AdminDestination.bulkOnboarding,
    route: AdminRoutes.bulkOnboarding,
    icon: Icons.upload_file_outlined,
    labelKey: (c) => AppLocalizations.of(c).navBulkOnboarding,
  ),
  _ModuleTile(
    destination: AdminDestination.aiReviews,
    route: AdminRoutes.aiReviews,
    icon: Icons.auto_awesome_outlined,
    labelKey: (c) => AppLocalizations.of(c).navAiReviews,
  ),
  _ModuleTile(
    destination: AdminDestination.supportTickets,
    route: AdminRoutes.supportTickets,
    icon: Icons.support_agent_outlined,
    labelKey: (c) => AppLocalizations.of(c).supportTicketsTitle,
  ),
  _ModuleTile(
    destination: AdminDestination.supportGrants,
    route: AdminRoutes.supportGrants,
    icon: Icons.vpn_key_outlined,
    labelKey: (c) => AppLocalizations.of(c).supportGrantsTitle,
  ),
  _ModuleTile(
    destination: AdminDestination.publicIntakes,
    route: AdminRoutes.publicIntakes,
    icon: Icons.public_outlined,
    labelKey: (c) => AppLocalizations.of(c).navPublicIntakes,
    descriptionKey: (c) => AppLocalizations.of(c).publicIntakeModuleDescription,
  ),
  _ModuleTile(
    destination: AdminDestination.systemHealth,
    route: AdminRoutes.systemHealth,
    icon: Icons.monitor_heart_outlined,
    labelKey: (c) => AppLocalizations.of(c).navSystemHealth,
  ),
  _ModuleTile(
    destination: AdminDestination.securityCenter,
    route: AdminRoutes.securityCenter,
    icon: Icons.security_outlined,
    labelKey: (c) => AppLocalizations.of(c).navSecurityCenter,
  ),
  _ModuleTile(
    destination: AdminDestination.auditLogs,
    route: AdminRoutes.auditLogs,
    icon: Icons.receipt_long_outlined,
    labelKey: (c) => AppLocalizations.of(c).navAuditLogs,
  ),
  _ModuleTile(
    destination: AdminDestination.notifications,
    route: AdminRoutes.notifications,
    icon: Icons.notifications_outlined,
    labelKey: (c) => AppLocalizations.of(c).navNotifications,
  ),
  _ModuleTile(
    destination: AdminDestination.adminUsers,
    route: AdminRoutes.adminUsers,
    icon: Icons.admin_panel_settings_outlined,
    labelKey: (c) => AppLocalizations.of(c).navAdminUsers,
  ),
  _ModuleTile(
    destination: AdminDestination.releaseCenter,
    route: AdminRoutes.releaseCenter,
    icon: Icons.rocket_launch_outlined,
    labelKey: (c) => AppLocalizations.of(c).navReleaseCenter,
  ),
  _ModuleTile(
    destination: AdminDestination.settings,
    route: AdminRoutes.settings,
    icon: Icons.settings_outlined,
    labelKey: (c) => AppLocalizations.of(c).navSettings,
  ),
];
