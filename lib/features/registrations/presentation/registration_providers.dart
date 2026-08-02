import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_exception.dart';
import '../../../core/auth/admin_user.dart';
import '../data/registration_applications_repository.dart';
import '../domain/registration_application.dart';
import '../domain/registration_application_status.dart';
import '../domain/registration_approval_outcome.dart';
import '../domain/registration_decision_request.dart';

extension AdminRoleRegistrationDecisions on AdminRole {
  /// View queue: super_admin and onboarding_reviewer.
  bool get canViewRegistrations {
    return this == AdminRole.superAdmin || this == AdminRole.onboardingReviewer;
  }

  /// Phase 1: company approve/reject/request-info is super_admin only
  /// (matches OnboardingService.requireSuperAdmin).
  bool get canDecideCompanyRegistrations {
    return this == AdminRole.superAdmin;
  }

  @Deprecated('Use canDecideCompanyRegistrations — Phase 1 super_admin only')
  bool get canDecideRegistrations => canDecideCompanyRegistrations;
}

class RegistrationListQuery {
  const RegistrationListQuery({
    this.search = '',
    this.filter = RegistrationListFilter.all,
  });

  final String search;
  final RegistrationListFilter filter;

  RegistrationListQuery copyWith({
    String? search,
    RegistrationListFilter? filter,
  }) {
    return RegistrationListQuery(
      search: search ?? this.search,
      filter: filter ?? this.filter,
    );
  }
}

final registrationListQueryProvider =
    NotifierProvider<RegistrationListQueryNotifier, RegistrationListQuery>(
      RegistrationListQueryNotifier.new,
    );

class RegistrationListQueryNotifier extends Notifier<RegistrationListQuery> {
  @override
  RegistrationListQuery build() => const RegistrationListQuery();

  void setSearch(String value) {
    state = state.copyWith(search: value);
  }

  void setFilter(RegistrationListFilter filter) {
    state = state.copyWith(filter: filter);
  }
}

final registrationApplicationsProvider =
    AsyncNotifierProvider<
      RegistrationApplicationsNotifier,
      List<RegistrationApplication>
    >(RegistrationApplicationsNotifier.new);

class RegistrationApplicationsNotifier
    extends AsyncNotifier<List<RegistrationApplication>> {
  @override
  Future<List<RegistrationApplication>> build() => _load();

  Future<List<RegistrationApplication>> _load() {
    return ref
        .read(registrationApplicationsRepositoryProvider)
        .fetchApplications();
  }

  Future<void> refresh() async {
    state = const AsyncLoading<List<RegistrationApplication>>();
    state = await AsyncValue.guard(_load);
  }
}

List<RegistrationApplication> filteredRegistrationApplications({
  required List<RegistrationApplication> items,
  required RegistrationListQuery query,
}) {
  return items
      .where((item) => item.matchesFilter(query.filter))
      .where((item) => item.matchesSearch(query.search))
      .toList(growable: false);
}

final filteredRegistrationApplicationsProvider =
    Provider<AsyncValue<List<RegistrationApplication>>>((ref) {
      final query = ref.watch(registrationListQueryProvider);
      final applications = ref.watch(registrationApplicationsProvider);
      return applications.whenData(
        (items) => filteredRegistrationApplications(items: items, query: query),
      );
    });

final registrationApplicationDetailProvider = FutureProvider.autoDispose
    .family<RegistrationApplication, String>((ref, id) {
      return ref
          .watch(registrationApplicationsRepositoryProvider)
          .fetchApplication(id);
    });

Future<void> refreshRegistrationApplicationDetail(
  WidgetRef ref,
  String applicationId,
) async {
  ref.invalidate(registrationApplicationDetailProvider(applicationId));
}

Future<RegistrationApprovalOutcome?> submitRegistrationDecision({
  required WidgetRef ref,
  required String applicationId,
  required RegistrationDecisionRequest request,
}) async {
  final outcome = await ref
      .read(registrationApplicationsRepositoryProvider)
      .submitDecision(applicationId: applicationId, request: request);
  ref.invalidate(registrationApplicationDetailProvider(applicationId));
  await ref.read(registrationApplicationsProvider.notifier).refresh();
  return outcome;
}

String? mapRegistrationApiError(ApiException error) {
  return error.messageKey;
}
