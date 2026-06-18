import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_router.dart';
import '../../app/app_theme.dart';
import '../../l10n/app_localizations.dart';
import '../auth/admin_auth_state.dart';
import '../auth/admin_user.dart';
import 'vianexis_status_badge.dart';

class VianexisAdminScaffold extends ConsumerWidget {
  const VianexisAdminScaffold({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(adminAuthProvider).user;
    if (user == null) {
      return child;
    }

    final destinations = _visibleDestinations(user);
    final location = GoRouterState.of(context).matchedLocation;
    final selectedIndex = _indexForLocation(location, destinations);

    final isTablet =
        MediaQuery.sizeOf(context).width >= AppTheme.tabletBreakpoint;

    if (isTablet) {
      return Scaffold(
        body: Row(
          children: [
            NavigationRail(
              extended: MediaQuery.sizeOf(context).width >= 900,
              selectedIndex: selectedIndex,
              onDestinationSelected: (index) =>
                  _goToDestination(context, destinations[index]),
              labelType: NavigationRailLabelType.none,
              destinations: [
                for (final item in destinations)
                  NavigationRailDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.selectedIcon),
                    label: Text(_label(context, item.destination)),
                  ),
              ],
            ),
            const VerticalDivider(width: 1),
            Expanded(child: child),
          ],
        ),
      );
    }

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: selectedIndex,
        onDestinationSelected: (index) =>
            _goToDestination(context, destinations[index]),
        destinations: [
          for (final item in destinations)
            NavigationDestination(
              icon: Icon(item.icon),
              selectedIcon: Icon(item.selectedIcon),
              label: _label(context, item.destination),
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

  int _indexForLocation(String location, List<_NavItem> items) {
    final destination = AdminRoutes.destinationForLocation(location);
    if (destination == null) return 0;
    final index = items.indexWhere((item) => item.destination == destination);
    return index >= 0 ? index : 0;
  }

  void _goToDestination(BuildContext context, _NavItem item) {
    context.go(item.route);
  }

  String _label(BuildContext context, AdminDestination destination) {
    final l10n = AppLocalizations.of(context);
    return switch (destination) {
      AdminDestination.dashboard => l10n.navDashboard,
      AdminDestination.registrations => l10n.navRegistrations,
      AdminDestination.aiReviews => l10n.aiReviewsTitle,
      AdminDestination.supportTickets => l10n.supportTicketsTitle,
      AdminDestination.supportGrants => l10n.supportGrantsTitle,
      AdminDestination.systemHealth => l10n.navSystemHealth,
      AdminDestination.auditLogs => l10n.navAuditLogs,
      AdminDestination.settings => l10n.navSettings,
    };
  }
}

class _NavItem {
  const _NavItem({
    required this.destination,
    required this.route,
    required this.icon,
    required this.selectedIcon,
  });

  final AdminDestination destination;
  final String route;
  final IconData icon;
  final IconData selectedIcon;
}

const _allNavItems = <_NavItem>[
  _NavItem(
    destination: AdminDestination.dashboard,
    route: AdminRoutes.dashboard,
    icon: Icons.dashboard_outlined,
    selectedIcon: Icons.dashboard,
  ),
  _NavItem(
    destination: AdminDestination.registrations,
    route: AdminRoutes.registrations,
    icon: Icons.apartment_outlined,
    selectedIcon: Icons.apartment,
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
    destination: AdminDestination.systemHealth,
    route: AdminRoutes.systemHealth,
    icon: Icons.monitor_heart_outlined,
    selectedIcon: Icons.monitor_heart,
  ),
  _NavItem(
    destination: AdminDestination.auditLogs,
    route: AdminRoutes.auditLogs,
    icon: Icons.receipt_long_outlined,
    selectedIcon: Icons.receipt_long,
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
            Card(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.shield_outlined, size: 20),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(l10n.privacyNoOperationalContent),
                    ),
                  ],
                ),
              ),
            ),
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
