import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/platform_company_member.dart';
import '../../domain/platform_company_summary.dart';
import '../platform_companies_providers.dart';

class CompanyMembersSection extends ConsumerStatefulWidget {
  const CompanyMembersSection({
    super.key,
    required this.companyId,
    this.usersSummary,
  });

  final String companyId;
  final PlatformCompanyUsersSummary? usersSummary;

  @override
  ConsumerState<CompanyMembersSection> createState() =>
      _CompanyMembersSectionState();
}

class _CompanyMembersSectionState extends ConsumerState<CompanyMembersSection> {
  PlatformCompanyMemberRoleFilter _roleFilter =
      PlatformCompanyMemberRoleFilter.all;

  @override
  Widget build(BuildContext context) {
    final membersAsync = ref.watch(
      platformCompanyMembersProvider(
        PlatformCompanyMembersQuery(
          companyId: widget.companyId,
          roleFilter: _roleFilter,
        ),
      ),
    );
    final byRole = widget.usersSummary?.usersByRole ?? const <String, int>{};

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          resolvePlatformCompanyKey(context, 'platformCompanyMembersSection'),
          style: Theme.of(context).textTheme.titleMedium,
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final filter in PlatformCompanyMemberRoleFilter.values)
              FilterChip(
                label: Text(_chipLabel(context, filter, byRole)),
                selected: _roleFilter == filter,
                onSelected: (_) {
                  setState(() => _roleFilter = filter);
                },
              ),
          ],
        ),
        const SizedBox(height: 12),
        membersAsync.when(
          loading: () => const LinearProgressIndicator(),
          error: (_, _) => Text(
            resolvePlatformCompanyKey(
              context,
              'platformCompanyMembersLoadError',
            ),
          ),
          data: (page) {
            if (page.items.isEmpty) {
              return Text(
                resolvePlatformCompanyKey(
                  context,
                  'platformCompanyMembersEmpty',
                ),
              );
            }
            return Column(
              children: [
                for (final member in page.items) _MemberCard(member: member),
              ],
            );
          },
        ),
      ],
    );
  }

  String _chipLabel(
    BuildContext context,
    PlatformCompanyMemberRoleFilter filter,
    Map<String, int> byRole,
  ) {
    final label = resolvePlatformCompanyKey(context, filter.l10nKey);
    if (byRole.isEmpty) return label;
    final count = filter == PlatformCompanyMemberRoleFilter.all
        ? (widget.usersSummary?.totalUsersCount ??
              filter.countFromSummary(byRole))
        : filter.countFromSummary(byRole);
    return '$label ($count)';
  }
}

class _MemberCard extends StatelessWidget {
  const _MemberCard({required this.member});

  final PlatformCompanyMember member;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final email = member.email?.trim() ?? '';
    final roleLabel = resolvePlatformCompanyKey(
      context,
      platformCompanyMemberRoleL10nKey(member.primaryRole),
    );
    final status = member.status?.trim();
    final invitation = member.invitationStatus?.trim();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(member.listDisplayName, style: theme.textTheme.titleSmall),
            if (email.isNotEmpty) ...[
              const SizedBox(height: 4),
              SelectableText(
                email,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
            const SizedBox(height: 8),
            Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                Chip(
                  label: Text(roleLabel),
                  visualDensity: VisualDensity.compact,
                ),
                if (status != null && status.isNotEmpty)
                  Chip(
                    label: Text(
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanyMemberStatus',
                        params: {'status': status},
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                if (member.hasInvitationStatus && invitation != null)
                  Chip(
                    label: Text(
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanyMemberInvitationStatus',
                        params: {'status': invitation},
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                  )
                else if ((status ?? '').toLowerCase() == 'invited')
                  Chip(
                    label: Text(
                      resolvePlatformCompanyKey(
                        context,
                        'platformCompanyMemberInvitationStatus',
                        params: {'status': invitation ?? status!},
                      ),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
              ],
            ),
            if (member.lastLoginAt != null) ...[
              const SizedBox(height: 6),
              Text(
                resolvePlatformCompanyKey(
                  context,
                  'platformCompanyMemberLastLogin',
                  params: {'date': _formatDate(context, member.lastLoginAt!)},
                ),
                style: theme.textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(BuildContext context, DateTime value) {
    return DateFormat.yMMMd(
      Localizations.localeOf(context).toString(),
    ).add_Hm().format(value.toLocal());
  }
}
