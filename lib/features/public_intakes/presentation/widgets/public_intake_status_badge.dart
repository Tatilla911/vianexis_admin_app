import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_status_badge.dart';
import '../../domain/public_intake_status.dart';

class PublicIntakeStatusBadge extends StatelessWidget {
  const PublicIntakeStatusBadge({super.key, required this.status});

  final PublicIntakeStatus status;

  @override
  Widget build(BuildContext context) {
    return VianexisStatusBadge(
      label: resolvePublicIntakeKey(context, status.localizationKey()),
      tone: _tone(status),
    );
  }

  VianexisStatusTone _tone(PublicIntakeStatus status) {
    return switch (status) {
      PublicIntakeStatus.converted => VianexisStatusTone.healthy,
      PublicIntakeStatus.rejected || PublicIntakeStatus.closed =>
        VianexisStatusTone.degraded,
      PublicIntakeStatus.quoted || PublicIntakeStatus.contacted =>
        VianexisStatusTone.unknown,
      _ => VianexisStatusTone.unknown,
    };
  }
}
