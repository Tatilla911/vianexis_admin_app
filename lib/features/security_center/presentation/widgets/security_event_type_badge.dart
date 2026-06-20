import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/security_event_type.dart';

class SecurityEventTypeBadge extends StatelessWidget {
  const SecurityEventTypeBadge({super.key, required this.type});

  final SecurityEventType type;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(resolveSecurityKey(context, type.localizationKey())),
    );
  }
}
