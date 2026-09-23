import 'package:flutter/material.dart';

import '../../domain/driver_emergency_event.dart';
import '../../../../l10n/app_localizations.dart';

class EmergencyStatusBadge extends StatelessWidget {
  const EmergencyStatusBadge({super.key, required this.status});

  final EmergencyStatus status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (label, color) = switch (status) {
      EmergencyStatus.active => (
        l10n.emergenciesStatusActive,
        Theme.of(context).colorScheme.error,
      ),
      EmergencyStatus.acknowledged => (
        l10n.emergenciesStatusAcknowledged,
        Colors.orange,
      ),
      EmergencyStatus.resolved => (
        l10n.emergenciesStatusResolved,
        Colors.green,
      ),
      EmergencyStatus.cancelledByDriver => (
        l10n.emergenciesStatusCancelled,
        Colors.blueGrey,
      ),
      EmergencyStatus.unknown => (
        l10n.emergenciesStatusUnknown,
        Colors.grey,
      ),
    };
    return Chip(
      label: Text(label),
      visualDensity: VisualDensity.compact,
      side: BorderSide(color: color.withValues(alpha: 0.5)),
      backgroundColor: color.withValues(alpha: 0.12),
    );
  }
}
