import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/action_center_item.dart';

class ActionCenterApi {
  ActionCenterApi(this._apiClient);

  final ApiClient _apiClient;

  Future<ActionCenterSnapshot> getActionCenter() async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/action-center',
    );
    final data = response.data;
    if (data == null) {
      return const ActionCenterSnapshot(items: []);
    }
    return ActionCenterSnapshot.fromJson(data);
  }
}

final actionCenterApiProvider = Provider<ActionCenterApi>(
  (ref) => ActionCenterApi(ref.watch(apiClientProvider)),
);
