import 'package:flutter/material.dart';

import '../../domain/public_intake.dart';

class PublicIntakeLanguageBadge extends StatelessWidget {
  const PublicIntakeLanguageBadge({super.key, required this.intake});

  final PublicIntake intake;

  @override
  Widget build(BuildContext context) {
    return Chip(
      avatar: const Icon(Icons.language, size: 16),
      label: Text(
        '${intake.preferredLanguage.toUpperCase()} · ${intake.sourceLocale.toUpperCase()}',
      ),
    );
  }
}
