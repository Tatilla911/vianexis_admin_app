import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_router.dart';
import '../../l10n/app_localizations.dart';
import '../navigation/admin_back_navigation.dart';

/// App bar with predictable back: pop when possible, else parent/modules/dashboard.
class AdminScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const AdminScreenAppBar({
    super.key,
    required this.title,
    this.actions,
    this.fallbackRoute = AdminRoutes.dashboard,
  });

  final String title;
  final List<Widget>? actions;
  final String fallbackRoute;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final router = GoRouter.maybeOf(context);
    final canPop =
        Navigator.of(context).canPop() || (router?.canPop() ?? false);

    return AppBar(
      title: Text(title),
      actions: actions,
      leading: canPop
          ? BackButton(
              onPressed: () =>
                  handleAdminBack(context, fallbackRoute: fallbackRoute),
            )
          : IconButton(
              tooltip: l10n.navReturnToDashboard,
              icon: const Icon(Icons.home_outlined),
              onPressed: () => context.go(fallbackRoute),
            ),
    );
  }
}
