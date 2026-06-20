import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_audit_log_query.dart';

class AuditLogDateRangeButton extends StatelessWidget {
  const AuditLogDateRangeButton({
    super.key,
    required this.query,
    required this.onChanged,
    required this.onClear,
  });

  final PlatformAuditLogListQuery query;
  final void Function(DateTime? from, DateTime? to) onChanged;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final formatter = DateFormat.yMMMd(locale);
    final hasRange = query.dateFrom != null || query.dateTo != null;
    final label = hasRange
        ? resolveAuditLogKey(
            context,
            'auditLogDateRangeSelected',
            params: {
              'from': query.dateFrom != null ? formatter.format(query.dateFrom!.toLocal()) : '…',
              'to': query.dateTo != null ? formatter.format(query.dateTo!.toLocal()) : '…',
            },
          )
        : resolveAuditLogKey(context, 'auditLogDateRangeLabel');

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        OutlinedButton.icon(
          onPressed: () => _pickRange(context),
          icon: const Icon(Icons.date_range_outlined),
          label: Text(label),
        ),
        if (hasRange)
          TextButton(
            onPressed: onClear,
            child: Text(resolveAuditLogKey(context, 'auditLogDateRangeClear')),
          ),
      ],
    );
  }

  Future<void> _pickRange(BuildContext context) async {
    final now = DateTime.now();
    final initialRange = DateTimeRange(
      start: query.dateFrom ?? now.subtract(const Duration(days: 7)),
      end: query.dateTo ?? now,
    );
    final picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2020),
      lastDate: now.add(const Duration(days: 1)),
      initialDateRange: initialRange,
    );
    if (picked == null) return;
    onChanged(
      DateTime.utc(picked.start.year, picked.start.month, picked.start.day),
      DateTime.utc(picked.end.year, picked.end.month, picked.end.day),
    );
  }
}
