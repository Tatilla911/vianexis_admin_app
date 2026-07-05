import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/platform_operations_snapshot.dart';

class OperationsApi {
  OperationsApi(this._apiClient);

  final ApiClient _apiClient;

  Future<PlatformOperationsSnapshot> fetchSnapshot() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/dashboard',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty platform operations dashboard response');
    }
    return PlatformOperationsSnapshot.fromJson(data);
  }
}

final operationsApiProvider = Provider<OperationsApi>(
  (ref) => OperationsApi(ref.watch(apiClientProvider)),
);
