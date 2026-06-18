import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../api/api_client.dart';
import '../api/api_exception.dart';
import '../localization/localization_keys.dart';
import 'admin_auth_repository.dart';
import 'admin_user.dart';

class AdminAuthState {
  const AdminAuthState({
    this.user,
    this.isLoading = false,
    this.errorMessageKey,
  });

  const AdminAuthState.unauthenticated()
    : user = null,
      isLoading = false,
      errorMessageKey = null;

  final AdminUser? user;
  final bool isLoading;
  final String? errorMessageKey;

  bool get isAuthenticated => user != null;

  AdminAuthState copyWith({
    AdminUser? user,
    bool clearUser = false,
    bool? isLoading,
    String? errorMessageKey,
    bool clearError = false,
  }) {
    return AdminAuthState(
      user: clearUser ? null : (user ?? this.user),
      isLoading: isLoading ?? this.isLoading,
      errorMessageKey: clearError ? null : (errorMessageKey ?? this.errorMessageKey),
    );
  }
}

final adminAuthRepositoryProvider = Provider<AdminAuthRepository>((ref) {
  return AdminAuthRepository(
    apiClient: ref.watch(apiClientProvider),
    tokenStorage: ref.watch(authTokenStorageProvider),
  );
});

class AdminAuthNotifier extends Notifier<AdminAuthState> {
  late final AdminAuthRepository _repository;

  @override
  AdminAuthState build() {
    _repository = ref.watch(adminAuthRepositoryProvider);
    return const AdminAuthState.unauthenticated();
  }

  Future<void> signIn({required String email, required String password}) async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final user = await _repository.signIn(email: email, password: password);
      state = AdminAuthState(user: user);
    } on ApiException catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessageKey: error.messageKey,
      );
    } catch (_) {
      state = state.copyWith(
        isLoading: false,
        errorMessageKey: LocalizationKeys.errorGenericBody,
      );
    }
  }

  Future<void> signOut() async {
    await _repository.signOut();
    state = const AdminAuthState.unauthenticated();
  }

  void setAuthenticatedUser(AdminUser user) {
    state = AdminAuthState(user: user);
  }
}

final adminAuthProvider = NotifierProvider<AdminAuthNotifier, AdminAuthState>(
  AdminAuthNotifier.new,
);
