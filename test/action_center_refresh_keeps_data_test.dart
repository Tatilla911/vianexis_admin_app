import 'dart:async';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:vianexis_admin_app/features/action_center/data/action_center_repository.dart';
import 'package:vianexis_admin_app/features/action_center/domain/action_center_item.dart';
import 'package:vianexis_admin_app/features/action_center/domain/action_center_item_type.dart';
import 'package:vianexis_admin_app/features/action_center/presentation/action_center_providers.dart';

class _DelayedActionCenterRepository implements ActionCenterRepository {
  _DelayedActionCenterRepository(this._refresh);

  final Completer<ActionCenterSnapshot> _refresh;
  int _calls = 0;

  static const firstItem = ActionCenterItem(
    id: 'registration:101',
    type: ActionCenterItemType.registration,
    priority: ActionCenterPriority.high,
    title: 'Registration application pending review',
    summary: 'Baltic Freight OÜ',
    sourceType: 'registration_application',
    sourceId: '101',
    status: ActionCenterStatus.open,
  );

  @override
  bool get usesMockData => true;

  @override
  Future<ActionCenterSnapshot> fetchActionCenter() async {
    _calls++;
    if (_calls == 1) {
      return const ActionCenterSnapshot(items: [firstItem], total: 1);
    }
    return _refresh.future;
  }
}

void main() {
  test(
    'refresh keeps previous action-center items until the request completes',
    () async {
      final refresh = Completer<ActionCenterSnapshot>();
      final repo = _DelayedActionCenterRepository(refresh);
      final container = ProviderContainer(
        overrides: [actionCenterRepositoryProvider.overrideWithValue(repo)],
      );
      addTearDown(container.dispose);

      await container.read(actionCenterProvider.future);
      expect(container.read(actionCenterProvider).hasValue, isTrue);
      expect(
        container.read(actionCenterProvider).value!.items.single.id,
        'registration:101',
      );

      final pending = container.read(actionCenterProvider.notifier).refresh();
      await Future<void>.delayed(Duration.zero);

      expect(container.read(actionCenterProvider).hasValue, isTrue);
      expect(
        container.read(actionCenterProvider).value!.items.single.id,
        'registration:101',
      );

      refresh.complete(const ActionCenterSnapshot(items: [], total: 0));
      await pending;
      expect(container.read(actionCenterProvider).value!.items, isEmpty);
    },
  );
}
