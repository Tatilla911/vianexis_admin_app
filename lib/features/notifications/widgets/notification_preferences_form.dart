import 'package:flutter/material.dart';

import '../../../l10n/app_localizations.dart';
import '../domain/notification_preferences.dart';

class NotificationPreferencesForm extends StatefulWidget {
  const NotificationPreferencesForm({
    super.key,
    required this.initialValue,
    required this.onSave,
  });

  final NotificationPreferences initialValue;
  final ValueChanged<NotificationPreferences> onSave;

  @override
  State<NotificationPreferencesForm> createState() =>
      _NotificationPreferencesFormState();
}

class _NotificationPreferencesFormState
    extends State<NotificationPreferencesForm> {
  late NotificationPreferences _value;
  String? _error;

  @override
  void initState() {
    super.initState();
    _value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SwitchListTile(
              value: _value.systemHealth,
              onChanged: (v) => setState(() => _value = _value.copyWith(systemHealth: v)),
              title: Text(l10n.notificationsPrefSystemHealth),
            ),
            SwitchListTile(
              value: _value.security,
              onChanged: (v) => setState(() => _value = _value.copyWith(security: v)),
              title: Text(l10n.notificationsPrefSecurity),
            ),
            SwitchListTile(
              value: _value.support,
              onChanged: (v) => setState(() => _value = _value.copyWith(support: v)),
              title: Text(l10n.notificationsPrefSupport),
            ),
            SwitchListTile(
              value: _value.billing,
              onChanged: (v) => setState(() => _value = _value.copyWith(billing: v)),
              title: Text(l10n.notificationsPrefBilling),
            ),
            SwitchListTile(
              value: _value.release,
              onChanged: (v) => setState(() => _value = _value.copyWith(release: v)),
              title: Text(l10n.notificationsPrefRelease),
            ),
            if (_error != null)
              Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  _error == 'notificationsPrefValidationAtLeastOne'
                      ? l10n.notificationsPrefValidationAtLeastOne
                      : l10n.notificationsPrefValidationInAppOnly,
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
              ),
            const SizedBox(height: 12),
            FilledButton(
              onPressed: () {
                final error = _value.validate();
                if (error != null) {
                  setState(() => _error = error);
                  return;
                }
                setState(() => _error = null);
                widget.onSave(_value.copyWith(inAppOnly: true));
              },
              child: Text(l10n.notificationsSavePreferences),
            ),
            const SizedBox(height: 8),
            Text(l10n.notificationsPrefInAppOnlyHint),
          ],
        ),
      ),
    );
  }
}
