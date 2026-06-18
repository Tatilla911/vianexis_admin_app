import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../app/app_environment.dart';
import 'api_config.dart';
import 'auth_token_storage.dart';

final authTokenStorageProvider = Provider<AuthTokenStorage>(
  (ref) => AuthTokenStorage(),
);

final apiConfigProvider = Provider<ApiConfig>((ref) {
  return ApiConfig(
    environment: AppEnvironment.fromDefine(
      const String.fromEnvironment(AppEnvironment.dartDefineKey),
    ),
    tokenStorage: ref.watch(authTokenStorageProvider),
  );
});

final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient(ref.watch(apiConfigProvider));
});

/// Shared Dio instance for future interceptors (auth refresh, logging).
final dioProvider = Provider<Dio>((ref) => ref.watch(apiClientProvider).dio);
