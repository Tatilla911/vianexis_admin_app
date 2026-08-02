import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../core/api/api_exception.dart';
import '../../../core/api/api_exception_feedback.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/widgets/vianexis_admin_scaffold.dart';
import '../../../l10n/app_localizations.dart';
import '../../registrations/domain/registration_approval_outcome.dart';
import '../../registrations/presentation/registration_providers.dart';
import '../../driver_access/data/driver_access_repository.dart';
import '../../driver_access/data/driver_registration_requests_repository.dart';
import '../data/public_applications_api.dart';

final applicationsListProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, ({String? type, String? status})>((
      ref,
      query,
    ) async {
      final api = ref.watch(publicApplicationsApiProvider);
      return api.listApplications(type: query.type, status: query.status);
    });

class ApplicationsInboxScreen extends ConsumerStatefulWidget {
  const ApplicationsInboxScreen({super.key});

  @override
  ConsumerState<ApplicationsInboxScreen> createState() =>
      _ApplicationsInboxScreenState();
}

class _ApplicationsInboxScreenState
    extends ConsumerState<ApplicationsInboxScreen> {
  String? _type;
  String? _status;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final query = (type: _type, status: _status);
    final listAsync = ref.watch(applicationsListProvider(query));

    return VianexisAdminScaffold(
      title: l10n.applicationsTitle,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            MaterialBanner(
              content: Text(l10n.applicationsCompatBanner),
              actions: [
                TextButton(
                  onPressed: () => context.go(AdminRoutes.registrations),
                  child: Text(l10n.applicationsOpenRegistrations),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                FilterChip(
                  label: Text(l10n.applicationsFilterCompany),
                  selected: _type == 'company',
                  onSelected: (v) =>
                      setState(() => _type = v ? 'company' : null),
                ),
                FilterChip(
                  label: Text(l10n.applicationsFilterDriver),
                  selected: _type == 'driver',
                  onSelected: (v) =>
                      setState(() => _type = v ? 'driver' : null),
                ),
                FilterChip(
                  label: Text(l10n.applicationsFilterPartner),
                  selected: _type == 'partner',
                  onSelected: (v) =>
                      setState(() => _type = v ? 'partner' : null),
                ),
                FilterChip(
                  label: Text(l10n.applicationsFilterNew),
                  selected: _status == 'new',
                  onSelected: (v) => setState(() => _status = v ? 'new' : null),
                ),
                FilterChip(
                  label: Text(l10n.applicationsFilterRejected),
                  selected: _status == 'rejected',
                  onSelected: (v) =>
                      setState(() => _status = v ? 'rejected' : null),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: listAsync.when(
                data: (data) {
                  final items = (data['items'] as List<dynamic>? ?? []);
                  if (items.isEmpty) {
                    return RefreshIndicator(
                      onRefresh: () async {
                        ref.invalidate(applicationsListProvider(query));
                        await ref.read(applicationsListProvider(query).future);
                      },
                      child: ListView(
                        physics: const AlwaysScrollableScrollPhysics(),
                        children: [
                          SizedBox(
                            height: MediaQuery.sizeOf(context).height * 0.3,
                            child: Center(child: Text(l10n.applicationsEmpty)),
                          ),
                        ],
                      ),
                    );
                  }
                  return RefreshIndicator(
                    onRefresh: () async {
                      ref.invalidate(applicationsListProvider(query));
                      await ref.read(applicationsListProvider(query).future);
                    },
                    child: ListView.separated(
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const Divider(height: 1),
                      itemBuilder: (context, index) {
                        final item = items[index] as Map<String, dynamic>;
                        final id = item['id']?.toString() ?? '';
                        final status = item['status']?.toString() ?? '';
                        final reference =
                            item['applicationReference']?.toString() ??
                            (id.isEmpty ? '—' : 'APP-$id');
                        final displayName =
                            item['displayName']?.toString() ??
                            item['companyName']?.toString() ??
                            '—';
                        return ListTile(
                          title: Text(displayName),
                          subtitle: Text(
                            '$reference · ${item['applicationType']} · $status · ${item['email']}',
                          ),
                          onTap: () {
                            context.push('${AdminRoutes.applications}/$id');
                          },
                        );
                      },
                    ),
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) => Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(l10n.applicationsLoadError('$e')),
                      const SizedBox(height: 12),
                      FilledButton(
                        onPressed: () =>
                            ref.invalidate(applicationsListProvider(query)),
                        child: Text(l10n.platformCompanyAmendRetry),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ApplicationDetailScreen extends ConsumerStatefulWidget {
  const ApplicationDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ApplicationDetailScreen> createState() =>
      _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState
    extends ConsumerState<ApplicationDetailScreen> {
  Map<String, dynamic>? _detail;
  RegistrationApprovalOutcome? _approvalOutcome;
  bool _loading = true;
  bool _acting = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final api = ref.read(publicApplicationsApiProvider);
      final id = int.parse(widget.id);
      final data = await api.getApplication(id);
      if (!mounted) return;

      RegistrationApprovalOutcome? fromDetail;
      final app = data['application'];
      final appMap = app is Map ? Map<String, dynamic>.from(app) : null;
      final status = appMap?['status']?.toString().toLowerCase() ?? '';
      final type = appMap?['applicationType']?.toString();
      final isConvertedCompany =
          type == 'company' &&
          (status == 'converted' || status == 'approved');

      Map<String, dynamic>? invite;
      final embedded = data['activationInvite'];
      if (embedded is Map) {
        invite = Map<String, dynamic>.from(embedded);
      } else if (isConvertedCompany) {
        try {
          invite = await api.getActivationInvite(id);
        } catch (_) {
          invite = null;
        }
      }

      if (invite != null) {
        fromDetail = RegistrationApprovalOutcome.fromJson({
          ...invite,
          'companyId':
              invite['companyId'] ??
              appMap?['companyId'] ??
              (appMap?['source'] is Map
                  ? (appMap!['source'] as Map)['approvedCompanyId']
                  : null),
        });
      }

      setState(() {
        _detail = data;
        if (fromDetail != null) {
          _approvalOutcome = fromDetail;
        } else if (isConvertedCompany) {
          // Still allow send/resend even when invite status cannot be loaded.
          _approvalOutcome ??= RegistrationApprovalOutcome(
            companyId: appMap?['companyId']?.toString(),
            companyName: null,
            adminEmail: appMap?['email']?.toString(),
            emailInviteSent: false,
            inviteDeliveryStatus: 'not_requested',
            retryAllowed: true,
          );
        }
      });
    } catch (e) {
      if (!mounted) return;
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  Future<void> _invalidateRelated() async {
    ref.invalidate(applicationsListProvider((type: null, status: null)));
    ref.invalidate(applicationsListProvider((type: 'company', status: null)));
    ref.invalidate(applicationsListProvider((type: 'company', status: 'new')));
    ref.invalidate(applicationsListProvider((type: 'driver', status: null)));
    ref.invalidate(applicationsListProvider((type: 'driver', status: 'new')));
    ref.invalidate(driverRegistrationRequestsProvider);
    ref.invalidate(rejectedDriverRegistrationRequestsProvider);
    ref.invalidate(driverAccessListProvider);
    try {
      await ref.read(registrationApplicationsProvider.notifier).refresh();
    } catch (_) {
      // Registrations provider may be unavailable in isolated tests.
    }
  }

  Future<void> _approve() async {
    if (_acting) return;
    setState(() => _acting = true);
    try {
      final api = ref.read(publicApplicationsApiProvider);
      final result = await api.approve(int.parse(widget.id));
      await _invalidateRelated();
      await _load();
      if (!mounted) return;
      final outcome = RegistrationApprovalOutcome.fromJson(result);
      setState(() => _approvalOutcome = outcome);
      final l10n = AppLocalizations.of(context);
      final deliveryNote = _deliverySnackNote(l10n, outcome.inviteDeliveryStatus);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            outcome.companyId == null || outcome.companyId!.isEmpty
                ? '${l10n.registrationDecisionSuccess}$deliveryNote'
                : '${l10n.registrationDecisionSuccess} · ${l10n.registrationFieldCompanyId}: ${outcome.companyId}$deliveryNote',
          ),
        ),
      );
    } on ApiException catch (error) {
      logApiExceptionDiagnostics(error, applicationId: widget.id);
      if (!mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  String _deliverySnackNote(AppLocalizations l10n, String delivery) {
    return switch (delivery) {
      'sent' ||
      'accepted_by_provider' ||
      'queued' ||
      'console' ||
      'not_requested' ||
      'generated' => '',
      'provider_disabled' ||
      'skipped' => ' · ${l10n.registrationInviteDeliveryProviderDisabled}',
      'provider_not_configured' =>
        ' · ${l10n.registrationInviteDeliveryProviderNotConfigured}',
      'blocked_by_staging_allowlist' ||
      'staging_allowlist_missing' =>
        ' · ${l10n.registrationInviteDeliveryAllowlistBlocked}',
      'failed' ||
      'pending_or_failed' => ' · ${l10n.registrationInviteDeliveryFailed}',
      _ when delivery.isNotEmpty => ' · $delivery',
      _ => '',
    };
  }

  Future<void> _resendActivationInvite() async {
    if (_acting) return;
    setState(() => _acting = true);
    try {
      final api = ref.read(publicApplicationsApiProvider);
      final applicationId = int.parse(widget.id);
      final result = await api.resendActivationInvite(applicationId);
      if (!mounted) return;
      final outcome = RegistrationApprovalOutcome.fromJson(result);
      setState(() => _approvalOutcome = outcome);
      await _load();
      if (!mounted) return;
      final l10n = AppLocalizations.of(context);
      final delivery = outcome.inviteDeliveryStatus;
      final message = switch (delivery) {
        'sent' || 'accepted_by_provider' || 'queued' =>
          l10n.registrationInviteResendSuccess,
        'provider_disabled' || 'skipped' =>
          l10n.registrationInviteDeliveryProviderDisabled,
        'provider_not_configured' =>
          l10n.registrationInviteDeliveryProviderNotConfigured,
        'blocked_by_staging_allowlist' || 'staging_allowlist_missing' =>
          l10n.registrationInviteDeliveryAllowlistBlocked,
        'failed' || 'pending_or_failed' =>
          l10n.registrationInviteDeliveryFailed,
        _ => l10n.registrationInviteResendSuccess,
      };
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
    } on ApiException catch (error) {
      if (!mounted) return;
      showApiExceptionSnackBar(context, error);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  Future<void> _copyActivationLink(String? url) async {
    final l10n = AppLocalizations.of(context);
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.registrationInviteNoLink)),
      );
      return;
    }
    await Clipboard.setData(ClipboardData(text: url));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.registrationInviteLinkCopied)),
    );
  }

  Future<void> _reject() async {
    if (_acting) return;
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final reason = await showDialog<String>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(l10n.applicationRejectReasonTitle),
          content: TextField(
            controller: controller,
            maxLines: 4,
            decoration: InputDecoration(
              hintText: l10n.applicationRejectReasonHint,
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: Text(
                MaterialLocalizations.of(dialogContext).cancelButtonLabel,
              ),
            ),
            FilledButton(
              onPressed: () {
                final text = controller.text.trim();
                if (text.isEmpty) return;
                Navigator.of(dialogContext).pop(text);
              },
              child: Text(l10n.applicationRejectConfirm),
            ),
          ],
        );
      },
    );
    controller.dispose();
    if (reason == null || !mounted) return;

    setState(() => _acting = true);
    try {
      final api = ref.read(publicApplicationsApiProvider);
      await api.reject(int.parse(widget.id), reviewNotes: reason);
      await _invalidateRelated();
      await _load();
    } on ApiException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(apiExceptionMessage(context, error))),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) setState(() => _acting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final app = _detail?['application'] as Map<String, dynamic>?;
    final source = app?['source'] as Map<String, dynamic>?;
    final type = app?['applicationType']?.toString();
    final status = app?['status']?.toString() ?? '';
    final isCompany = type == 'company';
    final isRejected = status.toLowerCase() == 'rejected';
    final isConverted =
        status.toLowerCase() == 'converted' ||
        status.toLowerCase() == 'approved';
    final reviewNotes =
        source?['reviewNotes']?.toString() ??
        app?['reviewNotes']?.toString() ??
        '';
    final reviewedAtRaw =
        source?['reviewedAt']?.toString() ?? app?['updatedAt']?.toString();
    final reviewedAt = reviewedAtRaw != null
        ? DateTime.tryParse(reviewedAtRaw)
        : null;
    final canDecide =
        ref.watch(adminAuthProvider).user?.role.canDecideCompanyRegistrations ??
        false;
    final locale = Localizations.localeOf(context).toString();
    final reference =
        app?['applicationReference']?.toString() ?? 'APP-${widget.id}';
    final companyId =
        app?['companyId']?.toString() ??
        source?['approvedCompanyId']?.toString();
    final hasCompany =
        companyId != null &&
        companyId.isNotEmpty &&
        companyId != 'null' &&
        companyId != '0';
    final companyName =
        source?['companyName']?.toString() ??
        app?['companyName']?.toString() ??
        app?['displayName']?.toString() ??
        '';
    final contactName =
        source?['contactName']?.toString() ??
        (app?['metadata'] is Map
            ? (app!['metadata'] as Map)['contactName']?.toString()
            : null) ??
        '';
    final contactEmail =
        source?['contactEmail']?.toString() ?? app?['email']?.toString() ?? '';
    final contactPhone = source?['contactPhone']?.toString() ?? '';
    final assessment = _detail?['assessment'] as Map<String, dynamic>?;
    final approvalReady = assessment?['approvalReady'] == true;
    final companyApprovalBlocked = isCompany && !approvalReady;
    final canActOnApplication = canDecide && !isRejected && !isConverted;
    final canApproveOther = canActOnApplication && !isCompany;

    return VianexisAdminScaffold(
      title: l10n.applicationDetailTitle(widget.id),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(_error!),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _load,
                      child: Text(l10n.platformCompanyAmendRetry),
                    ),
                  ],
                ),
              )
            : RefreshIndicator(
                onRefresh: _load,
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  children: [
                    Text(
                      reference,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text('${app?['applicationType']} · ${app?['status']}'),
                    Text(contactEmail),
                    if (companyName.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Text(
                        l10n.applicationsCorrectionTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(companyName),
                    ],
                    if (contactName.isNotEmpty) ...[
                      const SizedBox(height: 8),
                      Text('${l10n.registrationFieldContactName}: $contactName'),
                    ],
                    if (contactPhone.isNotEmpty) ...[
                      const SizedBox(height: 4),
                      Text(contactPhone),
                    ],
                    if (isCompany && !hasCompany) ...[
                      const SizedBox(height: 16),
                      Text(l10n.applicationsCompanyPendingNoAmendment),
                    ],
                    if (companyApprovalBlocked) ...[
                      const SizedBox(height: 16),
                      Text(
                        l10n.applicationAwaitingDetailedIntake,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(l10n.applicationDetailedIntakeRequired),
                      if (assessment?['status'] != null) ...[
                        const SizedBox(height: 4),
                        Text(
                          '${l10n.platformCompanyAmendStatus}: ${assessment!['status']}',
                        ),
                      ],
                    ],
                    if (isCompany && hasCompany) ...[
                      const SizedBox(height: 16),
                      Text(
                        '${l10n.registrationFieldCompanyId}: $companyId',
                      ),
                      const SizedBox(height: 8),
                      FilledButton(
                        onPressed: () => context.push(
                          AdminRoutes.platformCompanyDetail(companyId),
                        ),
                        child: Text(l10n.applicationsOpenCompany),
                      ),
                    ],
                    if (isCompany && (isConverted || _approvalOutcome != null)) ...[
                      const SizedBox(height: 16),
                      Text(
                        l10n.applicationActivationInviteTitle,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 8),
                      if (_approvalOutcome?.userCreated == true)
                        Text(l10n.applicationActivationUserCreated),
                      if (_approvalOutcome?.userResolved == true)
                        Text(l10n.applicationActivationUserResolved),
                      if (_approvalOutcome?.inviteTokenId != null)
                        Text(
                          '${l10n.applicationActivationInviteCreated} (#${_approvalOutcome!.inviteTokenId})',
                        )
                      else if (_approvalOutcome?.inviteDeliveryStatus ==
                          'not_requested')
                        Text(l10n.registrationInviteNoLink),
                      if (_approvalOutcome != null)
                        Text(
                          '${l10n.applicationActivationEmailStatus}: ${_activationDeliveryLabel(l10n, _approvalOutcome!.inviteDeliveryStatus)}',
                        ),
                      if ((_approvalOutcome?.recipientEmailMasked ??
                              _approvalOutcome?.adminEmail) !=
                          null)
                        Text(
                          '${l10n.applicationActivationRecipient}: ${_approvalOutcome!.recipientEmailMasked ?? _approvalOutcome!.adminEmail}',
                        ),
                      if (_approvalOutcome?.activationUrlHost != null)
                        Text(
                          '${l10n.registrationFieldInviteStatus}: ${_approvalOutcome!.activationUrlHost}',
                        ),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: [
                          OutlinedButton(
                            onPressed: _acting
                                ? null
                                : () {
                                    _copyActivationLink(
                                      _approvalOutcome?.activationUrl,
                                    );
                                  },
                            child: Text(l10n.registrationInviteCopyLink),
                          ),
                          if (canDecide) ...[
                            FilledButton(
                              onPressed: _acting
                                  ? null
                                  : () {
                                      _resendActivationInvite();
                                    },
                              child: Text(l10n.applicationActivationResend),
                            ),
                          ],
                        ],
                      ),
                    ],
                    if (isRejected || reviewNotes.trim().isNotEmpty) ...[
                      const SizedBox(height: 16),
                      Text(
                        l10n.applicationFieldReviewNotes,
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        reviewNotes.trim().isNotEmpty
                            ? reviewNotes.trim()
                            : '—',
                      ),
                      if (reviewedAt != null) ...[
                        const SizedBox(height: 8),
                        Text(
                          '${l10n.applicationFieldReviewedAt}: '
                          '${DateFormat.yMMMd(locale).add_Hm().format(reviewedAt.toLocal())}',
                        ),
                      ],
                    ],
                    const SizedBox(height: 16),
                    if (isCompany) ...[
                      Text(l10n.applicationsCompanyDecisionHint),
                      const SizedBox(height: 12),
                      if (canActOnApplication)
                        Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            FilledButton(
                              onPressed: (_acting || companyApprovalBlocked)
                                  ? null
                                  : _approve,
                              child: Text(l10n.registrationActionApprove),
                            ),
                            OutlinedButton(
                              onPressed: _acting ? null : _reject,
                              child: Text(l10n.registrationActionReject),
                            ),
                            TextButton(
                              onPressed: () =>
                                  context.go(AdminRoutes.registrations),
                              child: Text(l10n.applicationsOpenRegistrations),
                            ),
                          ],
                        )
                      else
                        TextButton(
                          onPressed: () =>
                              context.go(AdminRoutes.registrations),
                          child: Text(l10n.applicationsOpenRegistrations),
                        ),
                    ] else if (canApproveOther)
                      Wrap(
                        spacing: 8,
                        children: [
                          FilledButton(
                            onPressed: _acting ? null : _approve,
                            child: Text(l10n.registrationActionApprove),
                          ),
                          OutlinedButton(
                            onPressed: _acting ? null : _reject,
                            child: Text(l10n.registrationActionReject),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
      ),
    );
  }

  String _activationDeliveryLabel(AppLocalizations l10n, String status) {
    return switch (status) {
      'sent' || 'accepted_by_provider' || 'queued' =>
        l10n.registrationInviteDeliverySent,
      'provider_disabled' || 'skipped' =>
        l10n.registrationInviteDeliveryProviderDisabled,
      'provider_not_configured' =>
        l10n.registrationInviteDeliveryProviderNotConfigured,
      'blocked_by_staging_allowlist' || 'staging_allowlist_missing' =>
        l10n.registrationInviteDeliveryAllowlistBlocked,
      'failed' || 'pending_or_failed' =>
        l10n.registrationInviteDeliveryFailed,
      'expired' => l10n.registrationInviteDeliveryExpired,
      'revoked' => l10n.registrationInviteDeliveryRevoked,
      'accepted' || 'consumed' => l10n.registrationInviteDeliveryAccepted,
      _ => status,
    };
  }
}
