import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/api/api_client.dart';
import '../domain/public_intake.dart';
import '../domain/public_intake_status.dart';
import '../domain/public_intake_type.dart';

class PublicIntakesApi {
  PublicIntakesApi(this._apiClient);

  final ApiClient _apiClient;

  Future<PublicIntakesPage> listIntakes({
    PublicIntakeType? intakeType,
    PublicIntakeStatus? status,
    String? preferredLanguage,
    String? country,
    String? emailDomain,
    int limit = 100,
    int offset = 0,
  }) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/public-intakes',
      queryParameters: {
        if (intakeType != null && intakeType != PublicIntakeType.unknown)
          'intakeType': intakeType.backendValue,
        if (status != null && status != PublicIntakeStatus.unknown)
          'status': status.backendValue,
        if (preferredLanguage != null && preferredLanguage.trim().isNotEmpty)
          'preferredLanguage': preferredLanguage.trim(),
        if (country != null && country.trim().isNotEmpty)
          'country': country.trim(),
        if (emailDomain != null && emailDomain.trim().isNotEmpty)
          'emailDomain': emailDomain.trim(),
        'limit': limit,
        'offset': offset,
      },
    );

    final data = response.data;
    if (data == null) {
      return const PublicIntakesPage(items: [], total: 0);
    }
    return PublicIntakesPage.fromJson(data);
  }

  Future<PublicIntake> getIntake(String id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/platform-admin/public-intakes/$id',
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty public intake response');
    }
    return PublicIntake.fromDetailResponseJson(data);
  }

  Future<PublicIntake> updateStatus({
    required String intakeId,
    required PublicIntakeStatus status,
    String? reason,
  }) async {
    final response = await _apiClient.patch<Map<String, dynamic>>(
      '/platform-admin/public-intakes/$intakeId/status',
      data: {
        'status': status.backendValue,
        if (reason != null && reason.trim().isNotEmpty) 'reason': reason.trim(),
      },
    );
    final data = response.data;
    if (data == null) {
      throw StateError('Empty public intake status response');
    }
    return PublicIntake.fromDetailResponseJson(data);
  }
}

final publicIntakesApiProvider = Provider<PublicIntakesApi>(
  (ref) => PublicIntakesApi(ref.watch(apiClientProvider)),
);
