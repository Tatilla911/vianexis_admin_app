import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../app/app_router.dart';
import '../../../core/auth/admin_auth_state.dart';
import '../../../core/widgets/vianexis_admin_scaffold.dart';
import '../../../l10n/app_localizations.dart';
import '../../registrations/presentation/registration_providers.dart';
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
    final listAsync = ref.watch(
      applicationsListProvider((type: _type, status: _status)),
    );

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
                    return Center(child: Text(l10n.applicationsEmpty));
                  }
                  return ListView.separated(
                    itemCount: items.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = items[index] as Map<String, dynamic>;
                      final id = item['id']?.toString() ?? '';
                      final type = item['applicationType']?.toString();
                      final status = item['status']?.toString() ?? '';
                      return ListTile(
                        title: Text(item['displayName']?.toString() ?? '—'),
                        subtitle: Text(
                          '${item['applicationType']} · $status · ${item['email']}',
                        ),
                        onTap: () {
                          if (type == 'company') {
                            context.go(AdminRoutes.registrations);
                            return;
                          }
                          context.push('${AdminRoutes.applications}/$id');
                        },
                      );
                    },
                  );
                },
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (e, _) =>
                    Center(child: Text(l10n.applicationsLoadError('$e'))),
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
  bool _loading = true;
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
      final data = await api.getApplication(int.parse(widget.id));
      setState(() => _detail = data);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      setState(() => _loading = false);
    }
  }

  Future<void> _approve() async {
    final api = ref.read(publicApplicationsApiProvider);
    await api.approve(int.parse(widget.id));
    await _load();
  }

  Future<void> _reject() async {
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
              child: Text(MaterialLocalizations.of(dialogContext).cancelButtonLabel),
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

    final api = ref.read(publicApplicationsApiProvider);
    await api.reject(int.parse(widget.id), reviewNotes: reason);
    await _load();
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
    final reviewNotes =
        source?['reviewNotes']?.toString() ??
        app?['reviewNotes']?.toString() ??
        '';
    final reviewedAtRaw =
        source?['reviewedAt']?.toString() ??
        app?['updatedAt']?.toString();
    final reviewedAt = reviewedAtRaw != null
        ? DateTime.tryParse(reviewedAtRaw)
        : null;
    final canDecide =
        ref.watch(adminAuthProvider).user?.role.canDecideCompanyRegistrations ??
        false;
    final locale = Localizations.localeOf(context).toString();

    return VianexisAdminScaffold(
      title: l10n.applicationDetailTitle(widget.id),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: _loading
            ? const Center(child: CircularProgressIndicator())
            : _error != null
            ? Center(child: Text(_error!))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${app?['applicationType']} · ${app?['status']}'),
                  Text(app?['email']?.toString() ?? ''),
                  if (app?['displayName'] != null) ...[
                    const SizedBox(height: 8),
                    Text(app!['displayName'].toString()),
                  ],
                  if (isRejected || reviewNotes.trim().isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Text(
                      l10n.applicationFieldReviewNotes,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      reviewNotes.trim().isNotEmpty ? reviewNotes.trim() : '—',
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
                    Text(l10n.applicationsCompanyUseRegistrations),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: () => context.go(AdminRoutes.registrations),
                      child: Text(l10n.applicationsOpenRegistrations),
                    ),
                  ] else if (canDecide && !isRejected)
                    Wrap(
                      spacing: 8,
                      children: [
                        FilledButton(
                          onPressed: _approve,
                          child: Text(l10n.registrationActionApprove),
                        ),
                        OutlinedButton(
                          onPressed: _reject,
                          child: Text(l10n.registrationActionReject),
                        ),
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}
