import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class VianexisLoadingView extends StatelessWidget {
  const VianexisLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          Text(l10n.loadingLabel),
        ],
      ),
    );
  }
}
