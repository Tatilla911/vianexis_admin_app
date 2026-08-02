import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../../app/vianexis_brand.dart';
import '../../audio/vn_admin_sound_event_registry.dart';
import '../../audio/vn_audio_notification_service.dart';
import '../../audio/vn_sound_definition.dart';
import '../../audio/vn_sound_preferences.dart';
import '../../audio/vn_sound_registry.dart';
import '../../core/widgets/vianexis_admin_card.dart';
import '../../core/widgets/vianexis_metadata_notice.dart';
import '../../core/widgets/vianexis_section_header.dart';
import '../../l10n/app_localizations.dart';
import '../../services/alerts/admin_local_notification_service.dart';

/// Settings → Sounds and notifications.
class SoundSettingsScreen extends StatefulWidget {
  const SoundSettingsScreen({super.key});

  @override
  State<SoundSettingsScreen> createState() => _SoundSettingsScreenState();
}

class _SoundSettingsScreenState extends State<SoundSettingsScreen> {
  final VnSoundPreferences _prefs = VnSoundPreferences();
  final VnAudioNotificationService _audio = VnAudioNotificationService.instance;

  bool _loading = true;
  final Map<VnSoundCategory, String> _selected = {};
  final Map<VnSoundCategory, bool> _enabled = {};
  final Map<VnSoundCategory, double> _volume = {};
  final Map<String, AdminSoundEventPreference> _eventPrefs = {};

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void dispose() {
    _audio.stopPreview();
    super.dispose();
  }

  Future<void> _load() async {
    for (final category in VnSoundCategory.values) {
      _selected[category] = await _prefs.selectedSoundId(category);
      _enabled[category] = await _prefs.isCategoryEnabled(category);
      _volume[category] = await _prefs.volumeFor(category);
    }
    for (final event in VnAdminSoundEventRegistry.configurable()) {
      _eventPrefs[event.id] = await _prefs.eventPreference(event.id);
    }
    if (!mounted) return;
    setState(() => _loading = false);
  }

  String _categoryTitle(AppLocalizations l10n, VnSoundCategory category) {
    return switch (category) {
      VnSoundCategory.alarm => l10n.settingsSoundAlarm,
      VnSoundCategory.message => l10n.settingsSoundMessage,
      VnSoundCategory.ring => l10n.settingsSoundRing,
      VnSoundCategory.sign => l10n.settingsSoundSign,
    };
  }

  String _soundLabel(AppLocalizations l10n, String localizationKey) {
    return switch (localizationKey) {
      'settingsSoundAlarm1' => l10n.settingsSoundAlarm1,
      'settingsSoundAlarm2' => l10n.settingsSoundAlarm2,
      'settingsSoundAlarm3' => l10n.settingsSoundAlarm3,
      'settingsSoundMessage1' => l10n.settingsSoundMessage1,
      'settingsSoundMessage2' => l10n.settingsSoundMessage2,
      'settingsSoundMessage3' => l10n.settingsSoundMessage3,
      'settingsSoundMessage4' => l10n.settingsSoundMessage4,
      'settingsSoundRing1' => l10n.settingsSoundRing1,
      'settingsSoundRing2' => l10n.settingsSoundRing2,
      'settingsSoundRing3' => l10n.settingsSoundRing3,
      'settingsSoundRing4' => l10n.settingsSoundRing4,
      'settingsSoundSign1' => l10n.settingsSoundSign1,
      'settingsSoundSign2' => l10n.settingsSoundSign2,
      'settingsSoundSign3' => l10n.settingsSoundSign3,
      'settingsSoundSign4' => l10n.settingsSoundSign4,
      _ => localizationKey,
    };
  }

  String _adminEventLabel(AppLocalizations l10n, String eventId) {
    return switch (eventId) {
      'company_registration_new' => l10n.settingsSoundEventCompanyRegistration,
      'driver_registration_new' => l10n.settingsSoundEventDriverRegistration,
      'support_ticket_new' => l10n.settingsSoundEventSupportTicket,
      'support_access_request_new' => l10n.settingsSoundEventSupportAccess,
      'system_critical_state' => l10n.settingsSoundEventSystemCritical,
      'audit_security_event' => l10n.settingsSoundEventAuditSecurity,
      'billing_problem' => l10n.settingsSoundEventBilling,
      'bulk_onboarding_done' => l10n.settingsSoundEventBulkOnboarding,
      'approval_success' => l10n.settingsSoundEventApprovalSuccess,
      'incoming_contact' => l10n.settingsSoundEventIncomingContact,
      _ => eventId,
    };
  }

  Future<void> _select(VnSoundCategory category, String soundId) async {
    await _prefs.setSelectedSoundId(category, soundId);
    setState(() => _selected[category] = soundId);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(AppLocalizations.of(context).settingsSoundSelectionSaved),
      ),
    );
  }

  Future<void> _toggle(VnSoundCategory category, bool value) async {
    await _prefs.setCategoryEnabled(category, value);
    setState(() => _enabled[category] = value);
    if (!value) await _audio.stop(category);
  }

  Future<void> _preview(String soundId) async {
    if (_audio.previewSoundId == soundId) {
      await _audio.stopPreview();
      if (mounted) setState(() {});
      return;
    }
    await _audio.preview(soundId);
    if (mounted) setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsSoundTitle)),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              padding: EdgeInsets.fromLTRB(
                VianexisBrand.spaceXl,
                VianexisBrand.spaceXl,
                VianexisBrand.spaceXl,
                32 + MediaQuery.of(context).padding.bottom,
              ),
              children: [
                Text(
                  l10n.settingsSoundDescription,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: VianexisBrand.spaceMd),
                VianexisMetadataNotice(
                  message: l10n.settingsSoundSystemLimitations,
                ),
                const SizedBox(height: VianexisBrand.spaceLg),
                for (final category in VnSoundCategory.values) ...[
                  _categoryCard(l10n, category),
                  const SizedBox(height: VianexisBrand.spaceMd),
                ],
                VianexisAdminCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      VianexisSectionHeader(
                        title: l10n.settingsSoundPerEventTitle,
                      ),
                      Text(
                        l10n.settingsSoundPerEventDescription,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: VianexisBrand.spaceSm),
                      for (final event
                          in VnAdminSoundEventRegistry.configurable())
                        _eventTile(l10n, event),
                    ],
                  ),
                ),
                const SizedBox(height: VianexisBrand.spaceMd),
                FilledButton.icon(
                  onPressed: () async {
                    final granted = await AdminLocalNotificationService.instance
                        .requestPermission();
                    if (!context.mounted) return;
                    if (!granted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.settingsSoundPermissionDenied),
                        ),
                      );
                      return;
                    }
                    await AdminLocalNotificationService.instance.showTestAlert(
                      title: l10n.settingsSoundTestAlertTitle,
                      body: l10n.settingsSoundTestAlertBody,
                    );
                    if (!context.mounted) return;
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.settingsSoundTestAlertSent)),
                    );
                  },
                  icon: const Icon(Icons.notifications_active_outlined),
                  label: Text(l10n.settingsSoundTestAlert),
                ),
                const SizedBox(height: VianexisBrand.spaceMd),
                OutlinedButton(
                  onPressed: () async {
                    await _prefs.restoreDefaults();
                    await _load();
                  },
                  child: Text(l10n.settingsSoundRestoreDefault),
                ),
                if (kDebugMode) ...[
                  const SizedBox(height: VianexisBrand.spaceMd),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const DebugSoundShowcaseScreen(),
                        ),
                      );
                    },
                    child: const Text('Debug sound showcase'),
                  ),
                ],
              ],
            ),
    );
  }

  Widget _eventTile(
    AppLocalizations l10n,
    VnAdminSoundEventDefinition event,
  ) {
    final pref =
        _eventPrefs[event.id] ?? AdminSoundEventPreference(eventId: event.id);
    final allowed = VnAdminSoundEventRegistry.allowedSounds(event.id);
    final effectiveSoundId = (!pref.useDefault &&
            pref.selectedSoundId != null &&
            pref.selectedSoundId!.isNotEmpty)
        ? pref.selectedSoundId!
        : (event.defaultSoundId ??
              (allowed.isNotEmpty ? allowed.first.id : null));
    final dropdownValue = pref.useDefault || pref.selectedSoundId == null
        ? ''
        : pref.selectedSoundId!;

    return Padding(
      padding: const EdgeInsets.only(bottom: VianexisBrand.spaceMd),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: pref.enabled,
            onChanged: event.canBeMuted
                ? (enabled) async {
                    await _prefs.setEventEnabled(event.id, enabled);
                    setState(() {
                      _eventPrefs[event.id] = pref.copyWith(enabled: enabled);
                    });
                  }
                : null,
            title: Text(_adminEventLabel(l10n, event.id)),
            subtitle: Text(
              l10n.settingsSoundEventDefault(event.defaultSoundId ?? '—'),
            ),
            secondary: IconButton(
              tooltip: l10n.settingsSoundPreview,
              onPressed: effectiveSoundId == null
                  ? null
                  : () => _preview(effectiveSoundId),
              icon: const Icon(Icons.play_circle_outline),
            ),
          ),
          if (allowed.isNotEmpty) ...[
            Text(
              l10n.settingsSoundEventCustomSound,
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 4),
            DropdownButtonFormField<String>(
              initialValue: dropdownValue,
              isExpanded: true,
              items: [
                DropdownMenuItem(
                  value: '',
                  child: Text(l10n.settingsSoundEventUseCategoryDefault),
                ),
                for (final sound in allowed)
                  DropdownMenuItem(
                    value: sound.id,
                    child: Text(
                      '${_soundLabel(l10n, sound.localizationKey)} (${sound.id})',
                    ),
                  ),
              ],
              onChanged: !pref.enabled && event.canBeMuted
                  ? null
                  : (value) async {
                      final soundId = (value == null || value.isEmpty)
                          ? null
                          : value;
                      await _prefs.setEventSoundId(event.id, soundId);
                      final updated = await _prefs.eventPreference(event.id);
                      if (!mounted) return;
                      setState(() => _eventPrefs[event.id] = updated);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(l10n.settingsSoundSelectionSaved),
                        ),
                      );
                    },
            ),
          ],
        ],
      ),
    );
  }

  Widget _categoryCard(AppLocalizations l10n, VnSoundCategory category) {
    final sounds = VnSoundRegistry.forCategory(category);
    final selected = _selected[category] ?? sounds.first.id;
    final enabled = _enabled[category] ?? true;
    final volume = _volume[category] ?? 1.0;

    return VianexisAdminCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          VianexisSectionHeader(title: _categoryTitle(l10n, category)),
          SwitchListTile(
            contentPadding: EdgeInsets.zero,
            value: enabled,
            onChanged: (value) => _toggle(category, value),
            title: Text(
              enabled ? l10n.settingsSoundEnabled : l10n.settingsSoundMuted,
            ),
          ),
          if (category == VnSoundCategory.alarm) ...[
            Text(
              l10n.settingsSoundCriticalAlert,
              style: TextStyle(color: Theme.of(context).colorScheme.error),
            ),
            const SizedBox(height: VianexisBrand.spaceSm),
          ],
          Text(l10n.settingsSoundVolume),
          Slider(
            value: volume,
            onChanged: enabled
                ? (value) async {
                    setState(() => _volume[category] = value);
                    await _prefs.setVolume(category, value);
                  }
                : null,
          ),
          RadioGroup<String>(
            groupValue: selected,
            onChanged: enabled
                ? (value) {
                    if (value != null) _select(category, value);
                  }
                : (_) {},
            child: Column(
              children: [
                for (final sound in sounds)
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(_soundLabel(l10n, sound.localizationKey)),
                    subtitle: Text(sound.id),
                    leading: Radio<String>(value: sound.id),
                    trailing: IconButton(
                      tooltip: _audio.previewSoundId == sound.id
                          ? l10n.settingsSoundStopPreview
                          : l10n.settingsSoundPreview,
                      onPressed: enabled ? () => _preview(sound.id) : null,
                      icon: Icon(
                        _audio.previewSoundId == sound.id
                            ? Icons.stop_circle_outlined
                            : Icons.play_circle_outline,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Debug-only showcase of every ViaNexis sound asset.
class DebugSoundShowcaseScreen extends StatefulWidget {
  const DebugSoundShowcaseScreen({super.key});

  @override
  State<DebugSoundShowcaseScreen> createState() =>
      _DebugSoundShowcaseScreenState();
}

class _DebugSoundShowcaseScreenState extends State<DebugSoundShowcaseScreen> {
  final _audio = VnAudioNotificationService.instance;

  @override
  void dispose() {
    _audio.stopAll();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Sound showcase (debug)')),
      body: ListView(
        padding: const EdgeInsets.all(VianexisBrand.spaceXl),
        children: [
          for (final sound in VnSoundRegistry.all)
            ListTile(
              title: Text(sound.id),
              subtitle: Text(
                '${sound.category.name} · ${sound.assetPath}\n'
                'android raw: ${sound.androidResourceName}',
              ),
              isThreeLine: true,
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.play_arrow),
                    onPressed: () => _audio.preview(sound.id),
                  ),
                  if (sound.loopAllowed)
                    IconButton(
                      icon: const Icon(Icons.loop),
                      onPressed: () => _audio.playDefinition(sound, loop: true),
                    ),
                  IconButton(
                    icon: const Icon(Icons.stop),
                    onPressed: () => _audio.stop(sound.category),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
