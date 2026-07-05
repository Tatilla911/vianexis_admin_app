import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/backend_dependency_card.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../data/driver_access_repository.dart';
import '../domain/driver_access_profile.dart';

class DriverAccessScreen extends ConsumerWidget {
  const DriverAccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(driverAccessListProvider);
    final usesMock = ref.watch(driverAccessRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(resolveDriverAccessKey(context, 'driverAccessTitle')),
        actions: [
          if (usesMock)
            MockDataBadge(label: resolveDriverAccessKey(context, 'driverAccessMockBadge')),
        ],
      ),
      body: listAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveDriverAccessKey(context, 'driverAccessLoadFailed'),
          onRetry: () => ref.invalidate(driverAccessListProvider),
        ),
        data: (result) {
          if (!result.listEndpointReady) {
            return ListView(
              padding: const EdgeInsets.all(16),
              children: [
                VianexisMetadataNotice(
                  message: resolveDriverAccessKey(context, 'driverAccessPrivacyNotice'),
                ),
                const SizedBox(height: 12),
                BackendDependencyCard(
                  title: resolveDriverAccessKey(context, 'driverAccessBackendTitle'),
                  message: resolveDriverAccessKey(context, 'driverAccessBackendMessage'),
                  endpointHint: 'GET /platform-admin/drivers (planned)',
                ),
              ],
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              VianexisMetadataNotice(
                message: resolveDriverAccessKey(context, 'driverAccessPrivacyNotice'),
              ),
              const SizedBox(height: 12),
              for (final driver in result.items)
                Card(
                  child: ListTile(
                    title: Text(driver.displayName),
                    subtitle: Text(
                      '${driver.companyName} · '
                      '${resolveDriverAccessKey(context, driver.registrationStatus.localizationKey)}',
                    ),
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () => context.push(AdminRoutes.driverAccessDetail(driver.id)),
                  ),
                ),
            ],
          );
        },
      ),
    );
  }
}

class DriverAccessDetailScreen extends ConsumerWidget {
  const DriverAccessDetailScreen({super.key, required this.driverId});

  final String driverId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(driverAccessListProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(resolveDriverAccessKey(context, 'driverAccessDetailTitle')),
      ),
      body: listAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveDriverAccessKey(context, 'driverAccessLoadFailed'),
          onRetry: () => ref.invalidate(driverAccessListProvider),
        ),
        data: (result) {
          final driver = result.items.cast<DriverAccessProfile?>().firstWhere(
                (item) => item?.id == driverId,
                orElse: () => null,
              );
          if (driver == null) {
            return Center(
              child: Text(resolveDriverAccessKey(context, 'driverAccessNotFound')),
            );
          }
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              VianexisMetadataNotice(
                message: resolveDriverAccessKey(context, 'driverAccessPrivacyNotice'),
              ),
              const SizedBox(height: 12),
              _field(context, 'driverAccessFieldName', driver.displayName),
              _field(context, 'driverAccessFieldCompany', driver.companyName),
              _field(
                context,
                'driverAccessRegistrationStatus',
                resolveDriverAccessKey(context, driver.registrationStatus.localizationKey),
              ),
              _field(
                context,
                'driverAccessFieldDeviceLabel',
                driver.deviceLabel ?? '—',
              ),
              _field(
                context,
                'driverAccessFieldActiveSessions',
                '${driver.activeSessionCount}',
              ),
              _field(
                context,
                'driverAccessFieldLastActivity',
                driver.lastActivityAt != null
                    ? driver.lastActivityAt!.toLocal().toString()
                    : '—',
              ),
              const SizedBox(height: 12),
              BackendDependencyCard(
                title: resolveDriverAccessKey(context, 'driverAccessEnableDisableTitle'),
                message: resolveDriverAccessKey(context, 'driverAccessEnableDisableDependency'),
                endpointHint: 'PATCH /platform-admin/drivers/:id/status (planned)',
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _field(BuildContext context, String labelKey, String value) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: Text(resolveDriverAccessKey(context, labelKey)),
      subtitle: Text(value),
    );
  }
}
