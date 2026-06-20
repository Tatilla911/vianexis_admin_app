import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/release_center_repository.dart';
import '../domain/email_delivery_status.dart';
import '../domain/observability_status.dart';
import '../domain/release_overview.dart';

final releaseOverviewProvider =
    AsyncNotifierProvider<ReleaseOverviewNotifier, ReleaseOverview>(
      ReleaseOverviewNotifier.new,
    );

class ReleaseOverviewNotifier extends AsyncNotifier<ReleaseOverview> {
  @override
  Future<ReleaseOverview> build() => _load();

  Future<ReleaseOverview> _load() {
    return ref.read(releaseCenterRepositoryProvider).fetchOverview();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<ReleaseOverview>();
    state = await AsyncValue.guard(_load);
  }
}

final releaseAppVersionsProvider =
    FutureProvider.autoDispose<ReleaseAppVersions>((ref) {
      return ref.watch(releaseCenterRepositoryProvider).fetchAppVersions();
    });

final releaseEnvironmentProvider =
    FutureProvider.autoDispose<ReleaseEnvironment>((ref) {
      return ref.watch(releaseCenterRepositoryProvider).fetchEnvironment();
    });

final emailDeliveryStatusProvider =
    FutureProvider.autoDispose<EmailDeliveryStatus>((ref) {
      return ref.watch(releaseCenterRepositoryProvider).fetchEmailDeliveryStatus();
    });

final observabilityStatusProvider =
    FutureProvider.autoDispose<ObservabilityStatus>((ref) {
      return ref.watch(releaseCenterRepositoryProvider).fetchObservabilityStatus();
    });

Future<void> refreshReleaseCenter(WidgetRef ref) async {
  ref.invalidate(releaseAppVersionsProvider);
  ref.invalidate(releaseEnvironmentProvider);
  ref.invalidate(emailDeliveryStatusProvider);
  ref.invalidate(observabilityStatusProvider);
  await ref.read(releaseOverviewProvider.notifier).refresh();
}
