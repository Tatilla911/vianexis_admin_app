import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../app/app_router.dart';
import '../../l10n/app_localizations.dart';
import 'vianexis_admin_background.dart';
import 'vianexis_admin_card.dart';
import 'vianexis_logo_mark.dart';

class PermissionDeniedScreen extends StatelessWidget {
  const PermissionDeniedScreen({super.key, this.attemptedRoute});

  final String? attemptedRoute;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      body: VianexisAdminBackground(
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: VianexisAdminCard(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const VianexisLogoMark(showTitle: false, size: 64),
                      const SizedBox(height: 20),
                      Icon(
                        Icons.admin_panel_settings_outlined,
                        size: 48,
                        color: Theme.of(context).colorScheme.error,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.errorPermissionDeniedTitle,
                        style: Theme.of(context).textTheme.titleMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        l10n.errorPermissionDeniedBody,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 20),
                      FilledButton(
                        onPressed: () => context.go(AdminRoutes.dashboard),
                        child: Text(l10n.accessDeniedBackToDashboard),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
