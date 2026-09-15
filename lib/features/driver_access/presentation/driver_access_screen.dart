import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../app/vianexis_brand.dart';
import '../../../core/api/admin_ops_feedback.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/auth/admin_user.dart';
import '../../../core/email/email_delivery_feedback.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/backend_dependency_card.dart';
import '../../../core/widgets/mock_data_badge.dart';
import '../../../core/widgets/vianexis_error_view.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../../../core/widgets/vianexis_metadata_notice.dart';
import '../../qr_codes/domain/platform_qr_code.dart';
import '../../qr_codes/presentation/widgets/qr_codes_management_dialog.dart';
import '../../applications/presentation/applications_inbox_screen.dart';
import '../data/driver_registration_requests_repository.dart';
import '../data/driver_access_repository.dart';
import '../domain/driver_access_profile.dart';
import '../domain/driver_operational_health_detail.dart';
import '../domain/driver_registration_email_status.dart';
import '../domain/driver_registration_request.dart';

class _DriverApprovalInFlightIds extends Notifier<Set<String>> {
  @override
  Set<String> build() => <String>{};

  bool tryAdd(String id) {
    if (state.contains(id)) return false;
    state = {...state, id};
    return true;
  }

  void removeId(String id) {
    state = {
      for (final existing in state)
        if (existing != id) existing,
    };
  }
}

final _driverApprovalInFlightIdsProvider =
    NotifierProvider<_DriverApprovalInFlightIds, Set<String>>(
      _DriverApprovalInFlightIds.new,
    );

String _driverHealthListLabel(
  BuildContext context,
  DriverOperationalHealthSummary health,
) {
  if (health.level == DriverOperationalHealthLevel.green) {
    return resolveDriverAccessKey(context, 'driverHealthOk');
  }
  if (health.level == DriverOperationalHealthLevel.red) {
    return resolveDriverAccessKey(context, 'driverHealthActionRequired');
  }
  if (health.activeIssueCount <= 1) {
    return resolveDriverAccessKey(context, 'driverHealthWarning');
  }
  return resolveDriverAccessKey(
    context,
    'driverHealthWarningsCount',
  ).replaceAll('{count}', '${health.activeIssueCount}');
}

String _driverHealthCategoryLabel(BuildContext context, String category) {
  return switch (category) {
    'profile_sync' => resolveDriverAccessKey(
      context,
      'driverHealthCategoryProfileSync',
    ),
    _ => category,
  };
}

IconData _driverHealthIcon(DriverOperationalHealthLevel level) {
  return switch (level) {
    DriverOperationalHealthLevel.green => Icons.check_circle_outline,
    DriverOperationalHealthLevel.yellow => Icons.warning_amber_outlined,
    DriverOperationalHealthLevel.red => Icons.error_outline,
  };
}

Color _driverHealthColor(DriverOperationalHealthLevel level) {
  return switch (level) {
    DriverOperationalHealthLevel.green => VianexisBrand.success,
    DriverOperationalHealthLevel.yellow => VianexisBrand.warning,
    DriverOperationalHealthLevel.red => VianexisBrand.danger,
  };
}

class DriverAccessScreen extends ConsumerWidget {
  const DriverAccessScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final listAsync = ref.watch(driverAccessListProvider);
    final pendingAsync = ref.watch(driverRegistrationRequestsProvider);
    final rejectedAsync = ref.watch(rejectedDriverRegistrationRequestsProvider);
    final usesMock = ref.watch(driverAccessRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(resolveDriverAccessKey(context, 'driverAccessTitle')),
        actions: [
          if (usesMock)
            MockDataBadge(
              label: resolveDriverAccessKey(context, 'driverAccessMockBadge'),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _PendingDriverRegistrationsSection(pendingAsync: pendingAsync),
          _RejectedDriverRegistrationsSection(rejectedAsync: rejectedAsync),
          VianexisMetadataNotice(
            message: resolveDriverAccessKey(
              context,
              'driverAccessPrivacyNotice',
            ),
          ),
          const SizedBox(height: 12),
          listAsync.when(
            loading: () => const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (error, _) => VianexisErrorView.fromError(
              context,
              error,
              fallbackMessage: resolveDriverAccessKey(
                context,
                'driverAccessLoadFailed',
              ),
              onRetry: () => ref.invalidate(driverAccessListProvider),
            ),
            data: (result) {
              if (!result.listEndpointReady) {
                return BackendDependencyCard(
                  title: resolveDriverAccessKey(
                    context,
                    'driverAccessBackendTitle',
                  ),
                  message: resolveDriverAccessKey(
                    context,
                    'driverAccessBackendMessage',
                  ),
                  endpointHint: 'GET /platform-admin/drivers',
                );
              }
              if (result.items.isEmpty) {
                return Text(
                  resolveDriverAccessKey(
                    context,
                    'driverAccessNoActiveDrivers',
                  ),
                );
              }
              return Column(
                children: [
                  for (final driver in result.items)
                    Card(
                      child: ListTile(
                        title: Text(driver.displayName),
                        subtitle: Text(
                          '${driver.companyName} · '
                          '${resolveDriverAccessKey(context, driver.registrationStatus.localizationKey)}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            if (driver.operationalHealth != null)
                              Tooltip(
                                message: _driverHealthListLabel(
                                  context,
                                  driver.operationalHealth!,
                                ),
                                child: Semantics(
                                  label: _driverHealthListLabel(
                                    context,
                                    driver.operationalHealth!,
                                  ),
                                  child: Icon(
                                    _driverHealthIcon(
                                      driver.operationalHealth!.level,
                                    ),
                                    color: _driverHealthColor(
                                      driver.operationalHealth!.level,
                                    ),
                                  ),
                                ),
                              ),
                            const Icon(Icons.chevron_right),
                          ],
                        ),
                        onTap: () => context.push(
                          AdminRoutes.driverAccessDetail(driver.id),
                        ),
                      ),
                    ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _PendingDriverRegistrationsSection extends ConsumerWidget {
  const _PendingDriverRegistrationsSection({required this.pendingAsync});

  final AsyncValue<DriverRegistrationRequestsPage> pendingAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final inFlightIds = ref.watch(_driverApprovalInFlightIdsProvider);
    return pendingAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: BackendDependencyCard(
          title: resolveDriverAccessKey(context, 'driverAccessPendingTitle'),
          message: resolveDriverAccessKey(
            context,
            'driverAccessPendingLoadFailed',
          ),
          endpointHint: 'GET /platform-admin/driver-registration-requests',
        ),
      ),
      data: (page) {
        if (!page.listEndpointReady) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: BackendDependencyCard(
              title: resolveDriverAccessKey(
                context,
                'driverAccessPendingTitle',
              ),
              message: resolveDriverAccessKey(
                context,
                'driverAccessPendingBackendMessage',
              ),
              endpointHint: 'GET /platform-admin/driver-registration-requests',
            ),
          );
        }
        if (page.items.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              resolveDriverAccessKey(context, 'driverAccessPendingEmpty'),
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              resolveDriverAccessKey(context, 'driverAccessPendingTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            for (final request in page.items)
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        request.fullName,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(request.email),
                      if (request.phone != null && request.phone!.isNotEmpty)
                        Text(request.phone!),
                      if (request.companyCode != null &&
                          request.companyCode!.isNotEmpty)
                        Text(
                          '${resolveDriverAccessKey(context, 'driverAccessPendingCompanyCode')}: ${request.companyCode}',
                        ),
                      if (request.createdAt != null)
                        Text(
                          '${resolveDriverAccessKey(context, 'driverAccessPendingCreatedAt')}: '
                          '${request.createdAt!.toLocal()}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      Text(
                        resolveDriverAccessKey(
                          context,
                          'driverAccessStatusPending',
                        ),
                      ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          FilledButton(
                            onPressed: inFlightIds.contains(request.id)
                                ? null
                                : () => _approve(context, ref, request),
                            child: Text(
                              resolveDriverAccessKey(
                                context,
                                'driverAccessPendingApprove',
                              ),
                            ),
                          ),
                          OutlinedButton(
                            onPressed: inFlightIds.contains(request.id)
                                ? null
                                : () => _reject(context, ref, request),
                            child: Text(
                              resolveDriverAccessKey(
                                context,
                                'driverAccessPendingReject',
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            const SizedBox(height: 12),
          ],
        );
      },
    );
  }

  Future<void> _approve(
    BuildContext context,
    WidgetRef ref,
    DriverRegistrationRequestItem request,
  ) async {
    if (!ref
        .read(_driverApprovalInFlightIdsProvider.notifier)
        .tryAdd(request.id)) {
      return;
    }
    try {
      final companyId = int.tryParse(
        request.companyId ?? request.matchedCompanyId ?? '',
      );
      final decision = await ref
          .read(driverRegistrationRequestsRepositoryProvider)
          .approve(request.id, companyId: companyId);
      ref.invalidate(driverRegistrationRequestsProvider);
      ref.invalidate(rejectedDriverRegistrationRequestsProvider);
      ref.invalidate(driverAccessListProvider);
      ref.invalidate(applicationsListProvider((type: null, status: null)));
      ref.invalidate(applicationsListProvider((type: 'driver', status: null)));
      if (!context.mounted) return;
      final emailStatus = resolveDriverRegistrationEmailStatus(
        context,
        decision.notificationEmailStatus,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            [
              resolveDriverAccessKey(
                context,
                'driverAccessPendingApproveSuccess',
              ),
              if (emailStatus.isNotEmpty) emailStatus,
            ].join(' · '),
          ),
        ),
      );
    } on ApiException catch (error) {
      logApiExceptionDiagnostics(error, applicationId: request.id);
      if (!context.mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveDriverAccessKey(context, 'driverAccessPendingApproveFailed'),
          ),
        ),
      );
    } finally {
      ref
          .read(_driverApprovalInFlightIdsProvider.notifier)
          .removeId(request.id);
    }
  }

  Future<void> _reject(
    BuildContext context,
    WidgetRef ref,
    DriverRegistrationRequestItem request,
  ) async {
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        final controller = TextEditingController();
        return AlertDialog(
          title: Text(
            resolveDriverAccessKey(
              dialogContext,
              'driverAccessPendingRejectTitle',
            ),
          ),
          content: TextField(
            controller: controller,
            decoration: InputDecoration(
              labelText: resolveDriverAccessKey(
                dialogContext,
                'driverAccessPendingRejectReason',
              ),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                resolveDriverAccessKey(
                  dialogContext,
                  'driverAccessPendingRejectCancel',
                ),
              ),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.of(dialogContext).pop(controller.text.trim()),
              child: Text(
                resolveDriverAccessKey(
                  dialogContext,
                  'driverAccessPendingRejectConfirm',
                ),
              ),
            ),
          ],
        );
      },
    );
    if (reason == null || reason.isEmpty) return;

    if (!ref
        .read(_driverApprovalInFlightIdsProvider.notifier)
        .tryAdd(request.id)) {
      return;
    }
    try {
      final decision = await ref
          .read(driverRegistrationRequestsRepositoryProvider)
          .reject(request.id, reviewNotes: reason);
      ref.invalidate(driverRegistrationRequestsProvider);
      ref.invalidate(rejectedDriverRegistrationRequestsProvider);
      ref.invalidate(driverAccessListProvider);
      ref.invalidate(applicationsListProvider((type: null, status: null)));
      ref.invalidate(applicationsListProvider((type: 'driver', status: null)));
      if (!context.mounted) return;
      final emailStatus = resolveDriverRegistrationEmailStatus(
        context,
        decision.notificationEmailStatus,
      );
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            [
              resolveDriverAccessKey(
                context,
                'driverAccessPendingRejectSuccess',
              ),
              if (emailStatus.isNotEmpty) emailStatus,
            ].join(' · '),
          ),
        ),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            resolveDriverAccessKey(context, 'driverAccessPendingRejectFailed'),
          ),
        ),
      );
    } finally {
      ref
          .read(_driverApprovalInFlightIdsProvider.notifier)
          .removeId(request.id);
    }
  }
}

class _RejectedDriverRegistrationsSection extends ConsumerWidget {
  const _RejectedDriverRegistrationsSection({required this.rejectedAsync});

  final AsyncValue<DriverRegistrationRequestsPage> rejectedAsync;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return rejectedAsync.when(
      loading: () => const Padding(
        padding: EdgeInsets.only(bottom: 12),
        child: LinearProgressIndicator(),
      ),
      error: (_, _) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: Text(
          resolveDriverAccessKey(context, 'driverAccessRejectedLoadFailed'),
        ),
      ),
      data: (page) {
        if (!page.listEndpointReady) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              resolveDriverAccessKey(context, 'driverAccessRejectedTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            if (page.items.isEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Text(
                  resolveDriverAccessKey(context, 'driverAccessRejectedEmpty'),
                ),
              )
            else
              for (final request in page.items)
                Card(
                  child: ExpansionTile(
                    title: Text(request.fullName),
                    subtitle: Text(
                      '${request.email} · ${resolveDriverAccessKey(context, 'driverAccessStatusRejected')}',
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                    children: [
                      if (request.updatedAt != null ||
                          request.createdAt != null)
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${resolveDriverAccessKey(context, 'driverAccessRejectedAt')}: '
                            '${(request.updatedAt ?? request.createdAt)!.toLocal()}',
                          ),
                        ),
                      const SizedBox(height: 8),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          '${resolveDriverAccessKey(context, 'driverAccessRejectedReason')}: '
                          '${(request.reviewNotes?.trim().isNotEmpty ?? false) ? request.reviewNotes!.trim() : '—'}',
                        ),
                      ),
                      if (request.notificationEmailStatus != null &&
                          request.notificationEmailStatus!
                              .trim()
                              .isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            '${driverRegistrationNotificationEmailLabel(context)}: '
                            '${resolveDriverRegistrationEmailStatus(context, request.notificationEmailStatus)}',
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
            const SizedBox(height: 12),
          ],
        );
      },
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
      await ref
          .read(driverAccessRepositoryProvider)
          .patchDriverStatus(
            driver.id,
            status: status,
            reason: 'Admin app status change',
          );
      ref.invalidate(driverAccessListProvider);
      ref.invalidate(driverAccessDetailProvider(widget.driverId));
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

  bool _opsBusy = false;

  Future<void> _runOps(
    Future<Map<String, dynamic>> Function() action, {
    required String successKey,
    bool expectEmailDelivery = false,
  }) async {
    if (_opsBusy) return;
    setState(() => _opsBusy = true);
    try {
      final result = await action();
      if (!mounted) return;
      final successText = resolveDriverAccessKey(context, successKey);
      final message = expectEmailDelivery
          ? emailDeliveryUserMessage(
              context,
              result,
              successFallback: successText,
            )
          : successText;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      ref.invalidate(driverAccessListProvider);
      ref.invalidate(driverAccessDetailProvider(widget.driverId));
    } catch (error) {
      if (!mounted) return;
      showAdminOpsFailureSnackBar(
        context,
        error,
        resolveKey: resolveDriverAccessKey,
        fallbackKey: 'driverAccessOpsFailed',
        endpointMissingKey: 'driverAccessOpsEndpointMissing',
        actionLabel: resolveDriverAccessKey(context, successKey),
      );
    } finally {
      if (mounted) setState(() => _opsBusy = false);
    }
  }

  Future<void> _confirmDelete(DriverAccessProfile driver) async {
    final reasonController = TextEditingController();
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            resolveDriverAccessKey(
              dialogContext,
              'driverAccessDeleteConfirmTitle',
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                resolveDriverAccessKey(
                  dialogContext,
                  'driverAccessDeleteConfirmBody',
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: reasonController,
                decoration: InputDecoration(
                  labelText: resolveDriverAccessKey(
                    dialogContext,
                    'driverAccessDeleteReasonLabel',
                  ),
                ),
                minLines: 2,
                maxLines: 4,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(false),
              child: Text(
                MaterialLocalizations.of(dialogContext).cancelButtonLabel,
              ),
            ),
            FilledButton(
              onPressed: () {
                if (reasonController.text.trim().length < 3) return;
                Navigator.of(dialogContext).pop(true);
              },
              child: Text(
                resolveDriverAccessKey(
                  dialogContext,
                  'driverAccessDeleteAction',
                ),
              ),
            ),
          ],
        );
      },
    );
    final reason = reasonController.text.trim();
    reasonController.dispose();
    if (confirmed != true || reason.length < 3) return;
    await _runOps(
      () => ref
          .read(driverAccessRepositoryProvider)
          .softDelete(driverProfileId: driver.id, reason: reason),
      successKey: 'driverAccessDeleteSuccess',
    );
  }

  @override
  Widget build(BuildContext context) {
    final detailAsync = ref.watch(driverAccessDetailProvider(widget.driverId));
    final listAsync = ref.watch(driverAccessListProvider);
    final deviceStatusAsync = ref.watch(
      driverDeviceNotificationStatusProvider(widget.driverId),
    );
    final healthAsync = ref.watch(
      driverOperationalHealthProvider(widget.driverId),
    );
    final usesMock = ref.watch(driverAccessRepositoryProvider).usesMockData;

    return Scaffold(
      appBar: AppBar(
        title: Text(resolveDriverAccessKey(context, 'driverAccessDetailTitle')),
      ),
      body: detailAsync.when(
        loading: () => const VianexisLoadingView(),
        error: (error, _) => VianexisErrorView.fromError(
          context,
          error,
          fallbackMessage: resolveDriverAccessKey(
            context,
            'driverAccessLoadFailed',
          ),
          onRetry: () {
            ref.invalidate(driverAccessDetailProvider(widget.driverId));
            ref.invalidate(driverAccessListProvider);
          },
        ),
        data: (driver) {
          if (driver == null) {
            return Center(
              child: Text(
                resolveDriverAccessKey(context, 'driverAccessNotFound'),
              ),
            );
          }
          final listReady =
              listAsync.asData?.value.listEndpointReady ?? !usesMock;
          final canChangeStatus = listReady && !usesMock;
          final canManageOps = usesMock || listReady;
          final canResendInvite =
              canManageOps &&
              driver.registrationStatus == DriverRegistrationStatus.invited;
          final isSuperAdmin =
              ref.watch(adminAuthProvider).user?.role == AdminRole.superAdmin;
          final canArchiveDriver = canManageOps && (usesMock || isSuperAdmin);
          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              VianexisMetadataNotice(
                message: resolveDriverAccessKey(
                  context,
                  'driverAccessPrivacyNotice',
                ),
              ),
              const SizedBox(height: 12),
              _field(context, 'driverAccessFieldName', driver.displayName),
              _field(context, 'driverAccessFieldCompany', driver.companyName),
              _field(
                context,
                'driverAccessRegistrationStatus',
                resolveDriverAccessKey(
                  context,
                  driver.registrationStatus.localizationKey,
                ),
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
              _DriverOperationalHealthSection(
                listHealth: driver.operationalHealth,
                healthAsync: healthAsync,
              ),
              const SizedBox(height: 12),
              Text(
                resolveDriverAccessKey(context, 'driverAccessOpsSection'),
                style: Theme.of(context).textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: (!canResendInvite || _opsBusy)
                        ? null
                        : () => _runOps(
                            () => ref
                                .read(driverAccessRepositoryProvider)
                                .resendInvite(driver.id),
                            successKey: 'driverAccessInviteResendSuccess',
                            expectEmailDelivery: true,
                          ),
                    icon: const Icon(Icons.mail_outline),
                    label: Text(
                      resolveDriverAccessKey(
                        context,
                        'driverAccessResendInviteAction',
                      ),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: (!canManageOps || _opsBusy)
                        ? null
                        : () => _runOps(
                            () => ref
                                .read(driverAccessRepositoryProvider)
                                .sendPasswordSetup(driver.id),
                            successKey: 'driverAccessPasswordSetupSuccess',
                            expectEmailDelivery: true,
                          ),
                    icon: const Icon(Icons.lock_reset_outlined),
                    label: Text(
                      resolveDriverAccessKey(
                        context,
                        'driverAccessSendPasswordSetupAction',
                      ),
                    ),
                  ),
                  if (canArchiveDriver)
                    OutlinedButton.icon(
                      onPressed: _opsBusy ? null : () => _confirmDelete(driver),
                      icon: const Icon(Icons.archive_outlined),
                      label: Text(
                        resolveDriverAccessKey(
                          context,
                          'driverAccessDeleteAction',
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),
              deviceStatusAsync.when(
                loading: () => const SizedBox.shrink(),
                error: (_, _) => const SizedBox.shrink(),
                data: (status) {
                  if (status == null) return const SizedBox.shrink();
                  if (status.sourceUnavailable) {
                    return const SizedBox.shrink();
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
              OutlinedButton.icon(
                onPressed: () => showQrCodesManagementDialog(
                  context,
                  entityType: QrEntityType.driver.apiValue,
                  entityId: int.tryParse(driver.id) ?? 0,
                  displayName: driver.displayName,
                  titleKey: 'qrCodesDriverTitle',
                  allowedPurposes: const [
                    QrPurpose.driverIdentity,
                    QrPurpose.driverAppLink,
                    QrPurpose.driverProfile,
                    QrPurpose.publicDriverId,
                    QrPurpose.passwordSetup,
                    QrPurpose.supportReference,
                  ],
                ),
                icon: const Icon(Icons.qr_code_2),
                label: Text(
                  resolveQrCodesKey(context, 'qrCodesGenerateAction'),
                ),
              ),
              const SizedBox(height: 12),
              if (canChangeStatus &&
                  driver.registrationStatus !=
                      DriverRegistrationStatus.invited &&
                  driver.registrationStatus !=
                      DriverRegistrationStatus.pending) ...[
                if (driver.registrationStatus !=
                    DriverRegistrationStatus.active)
                  FilledButton.icon(
                    onPressed: _statusChangeInProgress
                        ? null
                        : () => _changeStatus(driver, 'active'),
                    icon: const Icon(Icons.check_circle_outline),
                    label: Text(
                      resolveDriverAccessKey(context, 'driverAccessEnable'),
                    ),
                  ),
                if (driver.registrationStatus !=
                    DriverRegistrationStatus.disabled) ...[
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
              ] else if (!canChangeStatus)
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

class _DriverOperationalHealthSection extends StatelessWidget {
  const _DriverOperationalHealthSection({
    required this.listHealth,
    required this.healthAsync,
  });

  final DriverOperationalHealthSummary? listHealth;
  final AsyncValue<DriverOperationalHealthDetail?> healthAsync;

  @override
  Widget build(BuildContext context) {
    return healthAsync.when(
      loading: () => _healthCard(
        context,
        level: listHealth?.level,
        label: listHealth == null
            ? null
            : _driverHealthListLabel(context, listHealth!),
        showProgress: true,
      ),
      error: (_, _) => BackendDependencyCard(
        title: resolveDriverAccessKey(context, 'driverHealthSectionTitle'),
        message: resolveDriverAccessKey(context, 'driverHealthUnavailable'),
        endpointHint: 'GET /platform-admin/drivers/:id/operational-health',
      ),
      data: (detail) {
        if (detail == null) {
          if (listHealth == null) {
            return BackendDependencyCard(
              title: resolveDriverAccessKey(
                context,
                'driverHealthSectionTitle',
              ),
              message: resolveDriverAccessKey(
                context,
                'driverHealthUnavailable',
              ),
              endpointHint:
                  'GET /platform-admin/drivers/:id/operational-health',
            );
          }
          return _healthCard(
            context,
            level: listHealth!.level,
            label: _driverHealthListLabel(context, listHealth!),
            issues: const [],
            showNoIssues: false,
          );
        }

        final summary = DriverOperationalHealthSummary(
          level: detail.overallLevel,
          activeIssueCount: detail.activeIssueCount,
        );
        return _healthCard(
          context,
          level: detail.overallLevel,
          label: _driverHealthListLabel(context, summary),
          issues: detail.issues,
          retryHintKey: detail.remoteRetryHintKey,
          showNoIssues:
              detail.issues.isEmpty &&
              detail.overallLevel == DriverOperationalHealthLevel.green,
        );
      },
    );
  }

  Widget _healthCard(
    BuildContext context, {
    required DriverOperationalHealthLevel? level,
    required String? label,
    List<DriverOperationalHealthIssueView> issues = const [],
    String? retryHintKey,
    bool showProgress = false,
    bool showNoIssues = false,
  }) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (level != null) ...[
                  Icon(
                    _driverHealthIcon(level),
                    color: _driverHealthColor(level),
                  ),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    resolveDriverAccessKey(context, 'driverHealthSectionTitle'),
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
              ],
            ),
            if (label != null) ...[
              const SizedBox(height: 8),
              Text(
                '${resolveDriverAccessKey(context, 'driverHealthOverall')}: $label',
              ),
            ],
            if (showProgress) ...[
              const SizedBox(height: 8),
              const LinearProgressIndicator(minHeight: 2),
            ],
            if (showNoIssues) ...[
              const SizedBox(height: 8),
              Text(resolveDriverAccessKey(context, 'driverHealthNoIssues')),
            ],
            for (final issue in issues) ...[
              const Divider(height: 20),
              Text(
                _driverHealthCategoryLabel(context, issue.category),
                style: Theme.of(context).textTheme.titleSmall,
              ),
              Text(resolveDriverAccessKey(context, 'driverHealthStatusFailed')),
              Text(
                '${resolveDriverAccessKey(context, 'driverHealthLastAttempt')}: '
                '${issue.lastAttemptedAt?.toLocal().toString() ?? '—'}',
              ),
              Text(
                '${resolveDriverAccessKey(context, 'driverHealthAttemptCount')}: '
                '${issue.attemptCount}',
              ),
              Text(
                '${resolveDriverAccessKey(context, 'driverHealthSafeReason')}: '
                '${issue.safeErrorCode ?? issue.code}',
              ),
            ],
            if (level != null &&
                level != DriverOperationalHealthLevel.green) ...[
              const SizedBox(height: 8),
              Text(
                resolveDriverAccessKey(
                  context,
                  retryHintKey ?? 'driverHealthRetryOnDevice',
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
