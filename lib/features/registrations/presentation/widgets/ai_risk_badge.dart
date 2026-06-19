import 'package:flutter/material.dart';

import '../../../../app/app_theme.dart';
import '../../../../core/localization/localization_resolver.dart';
import '../../domain/registration_risk_level.dart';

class AiRiskBadge extends StatelessWidget {
  const AiRiskBadge({
    super.key,
    required this.riskLevel,
  });

  final RegistrationRiskLevel riskLevel;

  Color get _color => switch (riskLevel) {
    RegistrationRiskLevel.low => AppTheme.success,
    RegistrationRiskLevel.medium => AppTheme.warning,
    RegistrationRiskLevel.high => AppTheme.error,
    RegistrationRiskLevel.unknown => AppTheme.accentMuted,
  };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: _color.withValues(alpha: 0.48)),
      ),
      child: Text(
        resolveRegistrationKey(context, riskLevel.localizationKey()),
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: _color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
