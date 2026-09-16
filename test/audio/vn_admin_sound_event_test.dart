import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:vianexis_admin_app/audio/vn_admin_sound_event_registry.dart';
import 'package:vianexis_admin_app/audio/vn_sound_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('screen_opened never plays sound', () {
    final def = VnAdminSoundEventRegistry.byId('screen_opened');
    expect(def, isNotNull);
    expect(def!.playsSound, isFalse);
  });

  test('critical system state allows only alarm', () {
    expect(
      VnAdminSoundEventRegistry.isSoundAllowed(
        'system_critical_state',
        'alarm1',
      ),
      isTrue,
    );
    expect(
      VnAdminSoundEventRegistry.isSoundAllowed(
        'system_critical_state',
        'message1',
      ),
      isFalse,
    );
  });

  test('event preference override persists per admin scope', () async {
    final prefs = VnSoundPreferences(userIdResolver: () async => 'admin-1');
    await prefs.setEventSoundId('support_ticket_new', 'message2');
    final stored = await prefs.eventPreference('support_ticket_new');
    expect(stored.selectedSoundId, 'message2');
    expect(stored.useDefault, isFalse);

    final other = VnSoundPreferences(userIdResolver: () async => 'admin-2');
    final otherPref = await other.eventPreference('support_ticket_new');
    expect(otherPref.useDefault, isTrue);
  });
}
