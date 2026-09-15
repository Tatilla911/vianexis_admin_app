import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/app_router.dart';
import '../../../core/localization/localization_resolver.dart';
import '../../../core/widgets/vianexis_loading_view.dart';
import '../data/platform_admin_search_api.dart';
import '../domain/platform_admin_search_models.dart';

Future<void> showGlobalSearchSheet(BuildContext context) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (context) => const GlobalSearchSheet(),
  );
}

bool isGlobalSearchQueryRunnable(String raw) {
  final query = raw.trim();
  if (query.isEmpty) return false;
  if (RegExp(r'^\d+$').hasMatch(query)) return true;
  return query.length >= 2;
}

class GlobalSearchSheet extends ConsumerStatefulWidget {
  const GlobalSearchSheet({super.key});

  @override
  ConsumerState<GlobalSearchSheet> createState() => _GlobalSearchSheetState();
}

class _GlobalSearchSheetState extends ConsumerState<GlobalSearchSheet> {
  final _controller = TextEditingController();
  Timer? _debounce;
  String _query = '';
  bool _loading = false;
  Object? _error;
  PlatformAdminSearchResponse? _response;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _runSearch(value);
    });
  }

  Future<void> _runSearch(String raw) async {
    final query = raw.trim();
    if (!isGlobalSearchQueryRunnable(query)) {
      setState(() {
        _query = query;
        _loading = false;
        _error = null;
        _response = null;
      });
      return;
    }

    setState(() {
      _query = query;
      _loading = true;
      _error = null;
    });

    try {
      final response = await ref
          .read(platformAdminSearchRepositoryProvider)
          .search(query);
      if (!mounted || _query != query) return;
      setState(() {
        _response = response;
        _loading = false;
      });
    } catch (error) {
      if (!mounted || _query != query) return;
      setState(() {
        _error = error;
        _loading = false;
        _response = null;
      });
    }
  }

  void _clearQuery() {
    _debounce?.cancel();
    _controller.clear();
    setState(() {
      _query = '';
      _loading = false;
      _error = null;
      _response = null;
    });
  }

  void _openHit(PlatformAdminSearchHit hit) {
    final companyId = hit.companyIdFromMetadata;
    final route = switch (hit.type) {
      PlatformAdminSearchResultType.company =>
        AdminRoutes.platformCompanyDetail(hit.id),
      PlatformAdminSearchResultType.registration =>
        AdminRoutes.registrationDetail(hit.id),
      PlatformAdminSearchResultType.driver =>
        AdminRoutes.driverAccessDetail(hit.id),
      PlatformAdminSearchResultType.trip => AdminRoutes.tripsOverview,
      PlatformAdminSearchResultType.document => AdminRoutes.tripsOverview,
      PlatformAdminSearchResultType.vehicle ||
      PlatformAdminSearchResultType.trailer ||
      PlatformAdminSearchResultType.site =>
        companyId != null
            ? AdminRoutes.platformCompanyDetail(companyId)
            : AdminRoutes.companies,
      PlatformAdminSearchResultType.auditEvent =>
        AdminRoutes.auditLogDetail(hit.id),
      PlatformAdminSearchResultType.other => null,
    };

    final snackbarMessage = switch (hit.type) {
      PlatformAdminSearchResultType.document =>
        resolveGlobalSearchKey(context, 'globalSearchDocumentFallback'),
      _ => null,
    };
    final messenger = ScaffoldMessenger.maybeOf(context);

    Navigator.of(context).pop();
    if (route != null) {
      context.push(route);
    }
    if (snackbarMessage != null) {
      messenger?.showSnackBar(SnackBar(content: Text(snackbarMessage)));
    }
  }

  void _showMore(PlatformAdminSearchGroup group) {
    final route = switch (group.type) {
      PlatformAdminSearchResultType.company => AdminRoutes.companies,
      PlatformAdminSearchResultType.registration => AdminRoutes.registrations,
      PlatformAdminSearchResultType.driver => AdminRoutes.drivers,
      PlatformAdminSearchResultType.trip ||
      PlatformAdminSearchResultType.document =>
        AdminRoutes.tripsOverview,
      PlatformAdminSearchResultType.vehicle ||
      PlatformAdminSearchResultType.trailer ||
      PlatformAdminSearchResultType.site =>
        AdminRoutes.companies,
      PlatformAdminSearchResultType.auditEvent => AdminRoutes.auditLogs,
      PlatformAdminSearchResultType.other => null,
    };
    Navigator.of(context).pop();
    if (route != null) {
      context.push(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.sizeOf(context).height * 0.9;
    return SizedBox(
      height: height,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    resolveGlobalSearchKey(context, 'globalSearchTitle'),
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _controller,
              autofocus: true,
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: resolveGlobalSearchKey(context, 'globalSearchHint'),
                suffixIcon: _controller.text.isEmpty
                    ? null
                    : IconButton(
                        tooltip: resolveGlobalSearchKey(
                          context,
                          'globalSearchClear',
                        ),
                        onPressed: _clearQuery,
                        icon: const Icon(Icons.clear),
                      ),
              ),
              onChanged: (value) {
                setState(() {});
                _onChanged(value);
              },
              textInputAction: TextInputAction.search,
              onSubmitted: _runSearch,
            ),
          ),
          const SizedBox(height: 8),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (!isGlobalSearchQueryRunnable(_query)) {
      return Center(
        child: Text(
          resolveGlobalSearchKey(context, 'globalSearchMinLength'),
        ),
      );
    }
    if (_loading) {
      return const VianexisLoadingView();
    }
    if (_error != null) {
      return Center(
        child: Text(resolveGlobalSearchKey(context, 'globalSearchError')),
      );
    }
    final response = _response;
    if (response == null ||
        (response.groups.isEmpty && !response.hasPartialErrors)) {
      return Center(
        child: Text(resolveGlobalSearchKey(context, 'globalSearchEmpty')),
      );
    }

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
      children: [
        if (response.hasPartialErrors)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Material(
              color: Theme.of(context).colorScheme.errorContainer,
              borderRadius: BorderRadius.circular(8),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Text(
                  resolveGlobalSearchKey(
                    context,
                    'globalSearchPartialError',
                  ),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.onErrorContainer,
                  ),
                ),
              ),
            ),
          ),
        for (final group in response.groups) ...[
          Padding(
            padding: const EdgeInsets.only(top: 12, bottom: 4),
            child: Text(
              resolveGlobalSearchKey(context, group.type.groupLocalizationKey),
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          for (final hit in group.items)
            ListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(hit.title),
              subtitle: hit.subtitle == null || hit.subtitle!.isEmpty
                  ? null
                  : Text(hit.subtitle!),
              trailing: const Icon(Icons.chevron_right),
              onTap: () => _openHit(hit),
            ),
          if (group.items.length >= response.groupLimit)
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton(
                onPressed: () => _showMore(group),
                child: Text(
                  resolveGlobalSearchKey(context, 'globalSearchShowMore'),
                ),
              ),
            ),
        ],
      ],
    );
  }
}
