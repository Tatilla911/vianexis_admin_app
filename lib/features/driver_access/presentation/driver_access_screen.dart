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

class DriverAccessDetailScreen extends ConsumerStatefulWidget {
  const DriverAccessDetailScreen({super.key, required this.driverId});

  final String driverId;

  @override
  ConsumerState<DriverAccessDetailScreen> createState() =>
      _DriverAccessDetailScreenState();
}

class _DriverAccessDetailScreenState
    extends ConsumerState<DriverAccessDetailScreen> {
  bool _statusChangeInProgress = false;

  Future<void> _changeStatus(DriverAccessProfile driver, String status) async {
    if (_statusChangeInProgress) return;
    setState(() => _statusChangeInProgress = true);
    try {
      await ref.read(driverAccessRepositoryProvider).patchDriverStatus(
            driver.id,
            status: status,
            reason: 'Admin app status change',
          );
      ref.invalidate(driverAccessListProvider);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveDriverAccessKey(context, 'driverAccessStatusChangeSuccess'),
          ),
        ),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveDriverAccessKey(context, 'driverAccessStatusChangeFailed'),
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _statusChangeInProgress = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(driverAccessListProvider);
    final deviceStatusAsync = ref.watch(
      driverDeviceNotificationStatusProvider(widget.driverId),
    );

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
                (item) => item?.id == widget.driverId,
                orElse: () => null,
              );
          if (driver == null) {
            return Center(
              child: Text(resolveDriverAccessKey(context, 'driverAccessNotFound')),
            );
          }
          final canChangeStatus = result.listEndpointReady &&
              !ref.watch(driverAccessRepositoryProvider).usesMockData;
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
              deviceStatusAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, __) => BackendDependencyCard(
                  title: resolveDriverAccessKey(
                    context,
                    'driverAccessDeviceNotificationTitle',
                  ),
                  message: resolveDriverAccessKey(
                    context,
                    'driverAccessDeviceNotificationUnavailable',
                  ),
                  endpointHint:
                      'GET /platform-admin/drivers/:id/device-notification-status',
                ),
                data: (status) {
                  if (status == null) return const SizedBox.shrink();
                  if (status.sourceUnavailable) {
                    return BackendDependencyCard(
                      title: resolveDriverAccessKey(
                        context,
                        'driverAccessDeviceNotificationTitle',
                      ),
                      message: resolveDriverAccessKey(
                        context,
                        'driverAccessDeviceNotificationUnavailable',
                      ),
                      endpointHint: 'sourceUnavailable: true',
                    );
                  }
                  return Card(
                    child: ListTile(
                      leading: Icon(
                        status.hasPushToken
                            ? Icons.notifications_active_outlined
                            : Icons.notifications_off_outlined,
                      ),
                      title: Text(
                        resolveDriverAccessKey(
                          context,
                          'driverAccessDeviceNotificationTitle',
                        ),
                      ),
                      subtitle: Text(
                        status.hasPushToken
                            ? resolveDriverAccessKey(
                                context,
                                'driverAccessHasPushToken',
                              )
                            : resolveDriverAccessKey(
                                context,
                                'driverAccessNoPushToken',
                              ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              if (canChangeStatus) ...[
                if (driver.registrationStatus != DriverRegistrationStatus.active)
                  FilledButton.icon(
                    onPressed: _statusChangeInProgress
                        ? null
                        : () => _changeStatus(driver, 'active'),
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(
                      resolveDriverAccessKey(context, 'driverAccessEnable'),
                    ),
                  ),
                if (driver.registrationStatus != DriverRegistrationStatus.disabled) ...[
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: _statusChangeInProgress
                        ? null
                        : () => _changeStatus(driver, 'disabled'),
                    icon: const Icon(Icons.block_outlined),
                    label: Text(
                      resolveDriverAccessKey(context, 'driverAccessDisable'),
                    ),
                  ),
                ],
              ] else
                BackendDependencyCard(
                  title: resolveDriverAccessKey(
                    context,
                    'driverAccessEnableDisableTitle',
                  ),
                  message: resolveDriverAccessKey(
                    context,
                    'driverAccessEnableDisableDependency',
                  ),
                  endpointHint: 'PATCH /platform-admin/drivers/:id/status',
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
