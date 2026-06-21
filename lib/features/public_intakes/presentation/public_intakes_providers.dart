import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/auth/admin_user.dart';
import '../data/public_intakes_repository.dart';
import '../domain/public_intake.dart';
import '../domain/public_intake_filter.dart';
import '../domain/public_intake_status.dart';

extension AdminRolePublicIntakes on AdminRole {
  bool get canChangePublicIntakeStatus {
    return this == AdminRole.superAdmin ||
        this == AdminRole.supportAdmin ||
        this == AdminRole.onboardingReviewer;
  }
}

final publicIntakeListQueryProvider =
    NotifierProvider<PublicIntakeListQueryNotifier, PublicIntakeListQuery>(
      PublicIntakeListQueryNotifier.new,
    );

class PublicIntakeListQueryNotifier extends Notifier<PublicIntakeListQuery> {
  @override
  PublicIntakeListQuery build() => const PublicIntakeListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(PublicIntakeListFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

final publicIntakesProvider =
    AsyncNotifierProvider<PublicIntakesNotifier, List<PublicIntake>>(
      PublicIntakesNotifier.new,
    );

class PublicIntakesNotifier extends AsyncNotifier<List<PublicIntake>> {
  @override
  Future<List<PublicIntake>> build() => _load();

  Future<List<PublicIntake>> _load() {
    return ref.read(publicIntakesRepositoryProvider).fetchIntakes();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<PublicIntake>>();
    state = await AsyncValue.guard(_load);
  }
}

List<PublicIntake> filteredPublicIntakes({
  required List<PublicIntake> items,
  required PublicIntakeListQuery query,
}) {
  return items
      .where((item) => publicIntakeMatchesFilter(item, query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredPublicIntakesProvider =
    Provider<AsyncValue<List<PublicIntake>>>((ref) {
      final query = ref.watch(publicIntakeListQueryProvider);
      final intakes = ref.watch(publicIntakesProvider);
      return intakes.whenData(
        (items) => filteredPublicIntakes(items: items, query: query),
      );
    });

final publicIntakeDetailProvider =
    FutureProvider.autoDispose.family<PublicIntake, String>((ref, id) {
      return ref.watch(publicIntakesRepositoryProvider).fetchIntake(id);
    });

final publicIntakeSummaryProvider = Provider<AsyncValue<PublicIntakeSummary>>((ref) {
  return ref.watch(publicIntakesProvider).whenData((items) {
    final newCount = items
        .where((item) => item.status == PublicIntakeStatus.newStatus)
        .length;
    final highPriority = items
        .where(
          (item) =>
              item.status == PublicIntakeStatus.newStatus &&
              item.type.isHighPriority,
        )
        .length;
    return PublicIntakeSummary(newCount: newCount, highPriorityCount: highPriority);
  });
});

class PublicIntakeSummary {
  const PublicIntakeSummary({
    required this.newCount,
    required this.highPriorityCount,
  });

  final int newCount;
  final int highPriorityCount;
}

Future<void> refreshPublicIntakeDetail(WidgetRef ref, String intakeId) async {
  ref.invalidate(publicIntakeDetailProvider(intakeId));
}

Future<PublicIntake> submitPublicIntakeStatusChange({
  required WidgetRef ref,
  required String intakeId,
  required PublicIntakeStatus status,
  String? reason,
}) async {
  final updated = await ref
      .read(publicIntakesRepositoryProvider)
      .updateStatus(intakeId: intakeId, status: status, reason: reason);
  ref.invalidate(publicIntakeDetailProvider(intakeId));
  await ref.read(publicIntakesProvider.notifier).refresh();
  return updated;
}
