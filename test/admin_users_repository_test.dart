import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vianexis_admin_app/core/api/api_client.dart';
import 'package:vianexis_admin_app/core/api/auth_token_storage.dart';
import 'package:vianexis_admin_app/features/admin_users/data/admin_users_api.dart';
import 'package:vianexis_admin_app/features/admin_users/data/admin_users_repository.dart';
import 'package:vianexis_admin_app/features/admin_users/domain/admin_user_invite_request.dart';
import 'package:vianexis_admin_app/features/admin_users/domain/admin_user_role_update_request.dart';
import 'package:vianexis_admin_app/features/admin_users/domain/admin_user_status_update_request.dart';
import 'package:vianexis_admin_app/features/admin_users/domain/platform_admin_user.dart';
import 'package:vianexis_admin_app/features/admin_users/domain/platform_admin_user_role.dart';
import 'package:vianexis_admin_app/features/admin_users/domain/platform_admin_user_status.dart';
import 'package:vianexis_admin_app/features/admin_users/presentation/admin_users_providers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    FlutterSecureStorage.setMockInitialValues({});
  });

  group('PlatformAdminUser JSON', () {
    test('parses metadata-only admin user', () {
      final user = PlatformAdminUser.fromJson({
        'metadataOnly': true,
        'id': 42,
        'email': 'ops@test.local',
        'name': 'Ops Admin',
        'role': 'support_admin',
        'status': 'active',
        'createdAt': '2026-06-01T00:00:00.000Z',
        'failedLoginCount': 2,
      });

      expect(user.metadataOnly, isTrue);
      expect(user.id, '42');
      expect(user.role, PlatformAdminUserRole.supportAdmin);
      expect(user.status, PlatformAdminUserStatus.active);
      expect(user.failedLoginCount, 2);
    });
  });

  group('filteredAdminUsers', () {
    test('filters by status and search', () {
      final items = [
        const PlatformAdminUser(
          id: '1',
          email: 'active@test.local',
          role: PlatformAdminUserRole.supportAdmin,
          status: PlatformAdminUserStatus.active,
        ),
        const PlatformAdminUser(
          id: '2',
          email: 'invited@test.local',
          role: PlatformAdminUserRole.billingAdmin,
          status: PlatformAdminUserStatus.invited,
        ),
      ];

      final filtered = filteredAdminUsers(
        items: items,
        query: const AdminUserListQuery(
          search: 'invited',
          filter: AdminUserListFilter.invited,
        ),
      );

      expect(filtered, hasLength(1));
      expect(filtered.first.id, '2');
    });
  });

  group('LiveAdminUsersRepository', () {
    late LiveAdminUsersRepository repo;

    setUp(() {
      final dio = Dio(BaseOptions(baseUrl: 'https://api.test.local'));
      final apiClient = ApiClient(
        tokenStorage: AuthTokenStorage(),
        dio: dio,
        enableDebugLogging: false,
      );
      repo = LiveAdminUsersRepository(AdminUsersApi(apiClient));

      dio.interceptors.add(
        InterceptorsWrapper(
          onRequest: (options, handler) {
            if (options.path == '/platform-admin/admin-users') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'metadataOnly': true,
                    'items': [
                      {
                        'id': 7,
                        'email': 'live@test.local',
                        'role': 'super_admin',
                        'status': 'active',
                      },
                    ],
                  },
                ),
              );
              return;
            }
            if (options.path == '/platform-admin/admin-users/7/role') {
              handler.resolve(
                Response<Map<String, dynamic>>(
                  requestOptions: options,
                  statusCode: 200,
                  data: {
                    'metadataOnly': true,
                    'user': {
                      'id': 7,
                      'email': 'live@test.local',
                      'role': 'support_admin',
                      'status': 'active',
                    },
                  },
                ),
              );
              return;
            }
            handler.reject(
              DioException(requestOptions: options, message: 'Unexpected path'),
            );
          },
        ),
      );
    });

    test('fetches admin users metadata', () async {
      final users = await repo.fetchAdminUsers();
      expect(users, hasLength(1));
      expect(users.first.metadataOnly, isTrue);
      expect(repo.usesMockData, isFalse);
    });

    test('updates admin user role', () async {
      final updated = await repo.updateAdminUserRole(
        id: '7',
        request: const AdminUserRoleUpdateRequest(
          role: PlatformAdminUserRole.supportAdmin,
          reason: 'Coverage rotation',
        ),
      );
      expect(updated.role, PlatformAdminUserRole.supportAdmin);
    });
  });

  group('MockAdminUsersRepository', () {
    test('returns mock data and supports invite', () async {
      final repo = MockAdminUsersRepository();
      expect(repo.usesMockData, isTrue);

      final users = await repo.fetchAdminUsers();
      expect(users.length, greaterThan(1));

      final invited = await repo.inviteAdminUser(
        const AdminUserInviteRequest(
          email: 'new@test.local',
          name: 'New Admin',
          role: PlatformAdminUserRole.onboardingReviewer,
        ),
      );
      expect(invited.status, PlatformAdminUserStatus.invited);

      final updated = await repo.updateAdminUserStatus(
        id: invited.id,
        request: const AdminUserStatusUpdateRequest(
          status: PlatformAdminUserStatus.suspended,
          reason: 'Pending review',
        ),
      );
      expect(updated.status, PlatformAdminUserStatus.suspended);
    });
  });
}
