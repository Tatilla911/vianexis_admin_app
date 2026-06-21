import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/public_intake_type.dart';

class PublicIntakeTypeBadge extends StatelessWidget {
  const PublicIntakeTypeBadge({super.key, required this.type});

  final PublicIntakeType type;

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(resolvePublicIntakeKey(context, type.localizationKey())),
    );
  }
}
