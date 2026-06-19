import 'package:flutter/material.dart';

import 'vianexis_status_badge.dart';

class MockDataBadge extends StatelessWidget {
  const MockDataBadge({super.key, required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 16),
      child: Center(
        child: VianexisStatusBadge(
          label: label,
          tone: VianexisStatusTone.degraded,
        ),
      ),
    );
  }
}
