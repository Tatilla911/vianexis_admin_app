import 'package:flutter/material.dart';

import '../../domain/language_option.dart';

class LanguageSelector extends StatelessWidget {
  const LanguageSelector({
    super.key,
    required this.label,
    required this.selectedCode,
    required this.onChanged,
    this.options = LanguageOption.adminDefaults,
  });

  final String label;
  final String selectedCode;
  final ValueChanged<String> onChanged;
  final List<LanguageOption> options;

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      initialValue: options.any((option) => option.code == selectedCode)
          ? selectedCode
          : options.first.code,
      decoration: InputDecoration(labelText: label),
      items: options
          .map(
            (option) => DropdownMenuItem(
              value: option.code,
              child: Text(option.displayLabel),
            ),
          )
          .toList(growable: false),
      onChanged: (value) {
        if (value != null) onChanged(value);
      },
    );
  }
}
