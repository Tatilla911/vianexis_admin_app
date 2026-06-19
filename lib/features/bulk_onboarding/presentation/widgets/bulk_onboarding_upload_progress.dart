import 'package:flutter/material.dart';

import '../../../../core/localization/localization_resolver.dart';

class BulkOnboardingUploadProgress extends StatelessWidget {
  const BulkOnboardingUploadProgress({
    super.key,
    required this.progress,
  });

  final double? progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(resolveBulkOnboardingKey(context, 'bulkOnboardingUploadProgress')),
        const SizedBox(height: 8),
        LinearProgressIndicator(value: progress),
      ],
    );
  }
}
