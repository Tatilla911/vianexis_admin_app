import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/widgets/vianexis_admin_scaffold.dart';
import '../data/public_applications_api.dart';

final applicationsListProvider = FutureProvider.autoDispose
    .family<Map<String, dynamic>, ({String? type, String? status})>((ref, query) async {
  final api = ref.watch(publicApplicationsApiProvider);
  return api.listApplications(type: query.type, status: query.status);
});

class ApplicationsInboxScreen extends ConsumerStatefulWidget {
  const ApplicationsInboxScreen({super.key});

  @override
  ConsumerState<ApplicationsInboxScreen> createState() => _ApplicationsInboxScreenState();
}

class _ApplicationsInboxScreenState extends ConsumerState<ApplicationsInboxScreen> {
  String? _type;
  String? _status;

  @override
  Widget build(BuildContext context) {
    final listAsync = ref.watch(applicationsListProvider((type: _type, status: _status)));

    return VianexisAdminScaffold(
      title: 'Jelentkezések',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              FilterChip(
                label: const Text('Cég'),
                selected: _type == 'company',
                onSelected: (v) => setState(() => _type = v ? 'company' : null),
              ),
              FilterChip(
                label: const Text('Sofőr'),
                selected: _type == 'driver',
                onSelected: (v) => setState(() => _type = v ? 'driver' : null),
              ),
              FilterChip(
                label: const Text('Partner'),
                selected: _type == 'partner',
                onSelected: (v) => setState(() => _type = v ? 'partner' : null),
              ),
              FilterChip(
                label: const Text('Új'),
                selected: _status == 'new',
                onSelected: (v) => setState(() => _status = v ? 'new' : null),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child: listAsync.when(
              data: (data) {
                final items = (data['items'] as List<dynamic>? ?? []);
                if (items.isEmpty) {
                  return const Center(child: Text('Nincs jelentkezés'));
                }
                return ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final item = items[index] as Map<String, dynamic>;
                    final id = item['id']?.toString() ?? '';
                    return ListTile(
                      title: Text(item['displayName']?.toString() ?? '—'),
                      subtitle: Text(
                        '${item['applicationType']} · ${item['status']} · ${item['email']}',
                      ),
                      onTap: () => context.push('${AdminRoutes.applications}/$id'),
                    );
                  },
                );
              },
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => Center(child: Text('Hiba: $e')),
            ),
          ),
        ],
      ),
    );
  }
}

class ApplicationDetailScreen extends ConsumerStatefulWidget {
  const ApplicationDetailScreen({super.key, required this.id});

  final String id;

  @override
  ConsumerState<ApplicationDetailScreen> createState() => _ApplicationDetailScreenState();
}

class _ApplicationDetailScreenState extends ConsumerState<ApplicationDetailScreen> {
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
    final api = ref.read(publicApplicationsApiProvider);
    await api.reject(int.parse(widget.id), reviewNotes: 'Rejected from admin app');
    await _load();
  }

  @override
  Widget build(BuildContext context) {
    final app = _detail?['application'] as Map<String, dynamic>?;
    return VianexisAdminScaffold(
      title: 'Jelentkezés #${widget.id}',
      child: _loading
          ? const Center(child: CircularProgressIndicator())
          : _error != null
              ? Center(child: Text(_error!))
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${app?['applicationType']} · ${app?['status']}'),
                    Text(app?['email']?.toString() ?? ''),
                    const SizedBox(height: 16),
                    Wrap(
                      spacing: 8,
                      children: [
                        FilledButton(onPressed: _approve, child: const Text('Jóváhagyás')),
                        OutlinedButton(onPressed: _reject, child: const Text('Elutasítás')),
                      ],
                    ),
                  ],
                ),
    );
  }
}
