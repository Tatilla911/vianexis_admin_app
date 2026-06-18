import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

enum VianexisStatusTone {
  healthy,
  degraded,
  unknown,
}

class VianexisStatusBadge extends StatelessWidget {
  const VianexisStatusBadge({
    super.key,
    required this.label,
    required this.tone,
  });

  final String label;
  final VianexisStatusTone tone;

  Color get _color => switch (tone) {
    VianexisStatusTone.healthy => AppTheme.success,
    VianexisStatusTone.degraded => AppTheme.warning,
    VianexisStatusTone.unknown => AppTheme.accentMuted,
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
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: _color,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
