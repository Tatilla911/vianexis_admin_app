import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/audio/vn_sound_definition.dart';
import 'package:vianexis_admin_app/audio/vn_sound_registry.dart';

void main() {
  group('VnSoundRegistry', () {
    test('all 15 sound ids are unique', () {
      final ids = VnSoundRegistry.all.map((s) => s.id).toList();
      expect(ids.length, 15);
      expect(ids.toSet().length, 15);
    });

    test('defaults resolve to valid sounds in each category', () {
      for (final category in VnSoundCategory.values) {
        final defaultId = VnSoundRegistry.defaults[category];
        expect(defaultId, isNotNull);

        final def = VnSoundRegistry.defaultFor(category);
        expect(def.id, defaultId);
        expect(def.category, category);
      }
    });

    test('unknown id falls back to category default', () {
      for (final category in VnSoundCategory.values) {
        final resolved = VnSoundRegistry.resolve(
          category: category,
          selectedId: 'does_not_exist',
        );
        expect(resolved.id, VnSoundRegistry.defaults[category]);
        expect(resolved.category, category);
      }
    });

    test('forCategory returns only matching sounds', () {
      for (final category in VnSoundCategory.values) {
        final sounds = VnSoundRegistry.forCategory(category);
        expect(sounds, isNotEmpty);
        expect(sounds.every((s) => s.category == category), isTrue);
      }

      expect(VnSoundRegistry.forCategory(VnSoundCategory.alarm).length, 3);
      expect(VnSoundRegistry.forCategory(VnSoundCategory.message).length, 4);
      expect(VnSoundRegistry.forCategory(VnSoundCategory.ring).length, 4);
      expect(VnSoundRegistry.forCategory(VnSoundCategory.sign).length, 4);
    });

    test('byId returns null for empty or unknown ids', () {
      expect(VnSoundRegistry.byId(null), isNull);
      expect(VnSoundRegistry.byId(''), isNull);
      expect(VnSoundRegistry.byId('unknown'), isNull);
      expect(VnSoundRegistry.byId('alarm1')?.category, VnSoundCategory.alarm);
    });

    test('resolve prefers variant when category matches', () {
      final resolved = VnSoundRegistry.resolve(
        category: VnSoundCategory.message,
        selectedId: 'message1',
        variantId: 'message3',
      );
      expect(resolved.id, 'message3');
    });

    test('resolve rejects variant from wrong category', () {
      final resolved = VnSoundRegistry.resolve(
        category: VnSoundCategory.message,
        selectedId: 'message2',
        variantId: 'alarm1',
      );
      expect(resolved.id, 'message2');
    });
  });
}
