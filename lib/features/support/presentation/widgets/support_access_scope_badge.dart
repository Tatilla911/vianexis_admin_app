import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../../../core/widgets/vianexis_status_badge.dart';
import '../../domain/support_access_scope_type.dart';

class SupportAccessScopeBadge extends StatelessWidget {
  const SupportAccessScopeBadge({super.key, required this.scopeType});

  final SupportAccessScopeType scopeType;

  @override
  Widget build(BuildContext context) {
    return VianexisStatusBadge(
      label: resolveSupportKey(context, scopeType.localizationKey()),
      tone: VianexisStatusTone.unknown,
    );
  }
}
