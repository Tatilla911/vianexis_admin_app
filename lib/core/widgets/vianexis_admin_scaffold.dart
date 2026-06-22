import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_router.dart';
import '../../app/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../api/api_unauthorized_binding.dart';
import '../auth/admin_auth_state.dart';
import '../auth/admin_user.dart';
import '../connectivity/connectivity_status_provider.dart';
import '../navigation/admin_shell_navigation.dart';
import 'backend_mode_banner.dart';
import 'offline_banner.dart';
import 'vianexis_admin_background.dart';
import 'vianexis_metadata_notice.dart';
import 'vianexis_status_badge.dart';

class VianexisAdminScaffold extends ConsumerWidget {
  const VianexisAdminScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.watch(apiUnauthorizedBindingProvider);
    final user = ref.watch(adminAuthProvider).user;
    if (user == null) {
      return child;
    }

    final isOnline = ref.watch(connectivityOnlineProvider);
    final allVisible = _visibleDestinations(user);
    final location = GoRouterState.of(context).matchedLocation;
    final isTablet =
        MediaQuery.sizeOf(context).width >= AppTheme.tabletBreakpoint;

    final content = Column(
      children: [
        OfflineBanner(isOnline: isOnline),
        const BackendModeBanner(),
        Expanded(
          child: VianexisAdminBackground(
            showWatermark: false,
            child: child,
          ),
        ),
      ],
    );

    if (isTablet) {
      final selectedIndex = _indexForLocation(location, allVisible);
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: MediaQuery.sizeOf(context).width >= 900,
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) =>
                  _goToDestination(context, allVisible[index]),
              labelType: NavigationRailLabelType.none,
              destinations: [
                for (final item in allVisible)
                  NavigationRailDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: Text(_label(context, item.destination)),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: content),
          ],
        ),
      );
    }

    final mobileItems = _mobileNavItems(user, allVisible);
    final selectedIndex = _mobileIndexForLocation(location, mobileItems);

    return Scaffold(
      body: content,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        labelBehavior: NavigationDestinationLabelBehavior.onlyShowSelected,
        onDestinationSelected: (index) =>
            _goToDestination(context, mobileItems[index]),
        destinations: [
          for (final item in mobileItems)
            NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: _mobileLabel(context, item),
            ),
        ],
      ),
    );
  }

  List<_NavItem> _visibleDestinations(AdminUser user) {
    return _allNavItems
        .where((item) => user.canAccess(item.destination))
        .toList(growable: false);
  }

  List<_NavItem> _mobileNavItems(AdminUser user, List<_NavItem> allVisible) {
    final primary = <_NavItem>[];
    for (final destination in mobilePrimaryDestinations) {
      final match = allVisible.where((item) => item.destination == destination);
      if (match.isNotEmpty) {
        primary.add(match.first);
      }
    }

    final hasSecondary = allVisible.any(
      (item) => !isMobilePrimaryDestination(item.destination),
    );

    if (hasSecondary) {
      primary.add(_moreNavItem);
    }

    assert(
      primary.length <= mobileBottomNavMaxItems,
      'Mobile nav must not exceed $mobileBottomNavMaxItems items',
    );

    return primary;
  }

  int _indexForLocation(String location, List<_NavItem> items) {
    final destination = AdminRoutes.destinationForLocation(location);
    if (destination == null) return 0;
    final index = items.indexWhere((item) => item.destination == destination);
    return index >= 0 ? index : 0;
  }

  int _mobileIndexForLocation(String location, List<_NavItem> mobileItems) {
    if (shouldHighlightMoreTab(
      location,
      AdminRoutes.destinationForLocation(location),
    )) {
      final moreIndex = mobileItems.indexWhere((item) => item.isMore);
      if (moreIndex >= 0) return moreIndex;
    }

    final destination = AdminRoutes.destinationForLocation(location);
    if (destination != null) {
      final index = mobileItems.indexWhere(
        (item) => item.destination == destination,
      );
      if (index >= 0) return index;
    }

    return 0;
  }

  void _goToDestination(BuildContext context, _NavItem item) {
    context.go(item.route);
  }

  String _label(BuildContext context, AdminDestination destination) {
    final l10n = AppLocalizations.of(context);
    return switch (destination) {
      AdminDestination.dashboard => l10n.navDashboard,
      AdminDestination.actionCenter => l10n.navActionCenter,
      AdminDestination.registrations => l10n.navRegistrations,
      AdminDestination.companies => l10n.navCompanies,
      AdminDestination.billing => l10n.navBilling,
      AdminDestination.bulkOnboarding => l10n.navBulkOnboarding,
      AdminDestination.aiReviews => l10n.navAiReviews,
      AdminDestination.supportTickets => l10n.supportTicketsTitle,
      AdminDestination.supportGrants => l10n.supportGrantsTitle,
      AdminDestination.customerCommunications => l10n.customerCommunicationsTitle,
      AdminDestination.publicIntakes => l10n.navPublicIntakes,
      AdminDestination.systemHealth => l10n.navSystemHealth,
      AdminDestination.securityCenter => l10n.navSecurityCenter,
      AdminDestination.auditLogs => l10n.navAuditLogs,
      AdminDestination.notifications => l10n.navNotifications,
      AdminDestination.adminUsers => l10n.navAdminUsers,
      AdminDestination.releaseCenter => l10n.navReleaseCenter,
      AdminDestination.settings => l10n.navSettings,
    };
  }

  String _mobileLabel(BuildContext context, _NavItem item) {
    if (item.isMore) {
      return AppLocalizations.of(context).navMore;
    }
    return _label(context, item.destination);
  }
}

class _NavItem {
  const _NavItem({
    required this.destination,
    required this.route,
    required this.icon,
    required this.selectedIcon,
    this.isMore = false,
  });

  final AdminDestination destination;
  final String route;
  final IconData icon;
  final IconData selectedIcon;
  final bool isMore;
}

const _moreNavItem = _NavItem(
  destination: AdminDestination.settings,
  route: AdminRoutes.modulesHub,
  icon: Icons.apps_outlined,
  selectedIcon: Icons.apps,
  isMore: true,
);

const _allNavItems = <_NavItem>[
  _NavItem(
    destination: AdminDestination.dashboard,
    route: AdminRoutes.dashboard,
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
  ),
  _NavItem(
    destination: AdminDestination.actionCenter,
    route: AdminRoutes.actionCenter,
    icon: Icons.inbox_outlined,
    selectedIcon: Icons.inbox,
  ),
  _NavItem(
    destination: AdminDestination.registrations,
    route: AdminRoutes.registrations,
    icon: Icons.apartment_outlined,
    selectedIcon: Icons.apartment,
  ),
  _NavItem(
    destination: AdminDestination.companies,
    route: AdminRoutes.companies,
    icon: Icons.business_outlined,
    selectedIcon: Icons.business,
  ),
  _NavItem(
    destination: AdminDestination.billing,
    route: AdminRoutes.billing,
    icon: Icons.payments_outlined,
    selectedIcon: Icons.payments,
  ),
  _NavItem(
    destination: AdminDestination.bulkOnboarding,
    route: AdminRoutes.bulkOnboarding,
    icon: Icons.upload_file_outlined,
    selectedIcon: Icons.upload_file,
  ),
  _NavItem(
    destination: AdminDestination.aiReviews,
    route: AdminRoutes.aiReviews,
    icon: Icons.auto_awesome_outlined,
    selectedIcon: Icons.auto_awesome,
  ),
  _NavItem(
    destination: AdminDestination.supportTickets,
    route: AdminRoutes.supportTickets,
    icon: Icons.support_agent_outlined,
    selectedIcon: Icons.support_agent,
  ),
  _NavItem(
    destination: AdminDestination.supportGrants,
    route: AdminRoutes.supportGrants,
    icon: Icons.vpn_key_outlined,
    selectedIcon: Icons.vpn_key,
  ),
  _NavItem(
    destination: AdminDestination.customerCommunications,
    route: AdminRoutes.customerCommunications,
    icon: Icons.forum_outlined,
    selectedIcon: Icons.forum,
  ),
  _NavItem(
    destination: AdminDestination.publicIntakes,
    route: AdminRoutes.publicIntakes,
    icon: Icons.public_outlined,
    selectedIcon: Icons.public,
  ),
  _NavItem(
    destination: AdminDestination.systemHealth,
    route: AdminRoutes.systemHealth,
    icon: Icons.monitor_heart_outlined,
    selectedIcon: Icons.monitor_heart,
  ),
  _NavItem(
    destination: AdminDestination.securityCenter,
    route: AdminRoutes.securityCenter,
    icon: Icons.security_outlined,
    selectedIcon: Icons.security,
  ),
  _NavItem(
    destination: AdminDestination.auditLogs,
    route: AdminRoutes.auditLogs,
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
  ),
  _NavItem(
    destination: AdminDestination.adminUsers,
    route: AdminRoutes.adminUsers,
    icon: Icons.admin_panel_settings_outlined,
    selectedIcon: Icons.admin_panel_settings,
  ),
  _NavItem(
    destination: AdminDestination.releaseCenter,
    route: AdminRoutes.releaseCenter,
    icon: Icons.rocket_launch_outlined,
    selectedIcon: Icons.rocket_launch,
  ),
  _NavItem(
    destination: AdminDestination.settings,
    route: AdminRoutes.settings,
    icon: Icons.settings_outlined,
    selectedIcon: Icons.settings,
  ),
];

/// Shared layout for metadata-only placeholder screens.
class AdminFeatureScaffold extends StatelessWidget {
  const AdminFeatureScaffold({
    super.key,
    required this.title,
    required this.body,
    this.showPrivacyNotice = true,
    this.footer,
  });

  final String title;
  final String body;
  final bool showPrivacyNotice;
  final Widget? footer;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: Navigator.of(context).canPop()
            ? BackButton(onPressed: () => context.pop())
            : IconButton(
                tooltip: l10n.navReturnToDashboard,
                icon: const Icon(Icons.home_outlined),
                onPressed: () => context.go(AdminRoutes.dashboard),
              ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: Center(
              child: VianexisStatusBadge(
                label: l10n.privacyMetadataOnlyBadge,
                tone: VianexisStatusTone.unknown,
              ),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                body,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
            ),
          ),
          if (showPrivacyNotice) ...[
            const SizedBox(height: 16),
            VianexisMetadataNotice(message: l10n.privacyNoOperationalContent),
          ],
          if (footer != null) ...[
            const SizedBox(height: 16),
            footer!,
          ],
        ],
      ),
    );
  }
}
