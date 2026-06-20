import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../../../../core/localization/localization_resolver.dart';
import '../../domain/release_overview.dart';

class ReleaseOverviewCard extends StatelessWidget {
  const ReleaseOverviewCard({
    super.key,
    required this.overview,
    this.compact = false,
  });

  final ReleaseOverview overview;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final locale = Localizations.localeOf(context).toString();
    final deployed = overview.lastDeploymentAt;
    final deployedLabel = deployed != null
        ? DateFormat.yMMMd(locale).add_Hm().format(deployed.toLocal())
        : '—';

    return Card(
      child: Padding(
        padding: EdgeInsets.all(compact ? 12 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveReleaseCenterKey(context, 'releaseOverviewTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _row(context, 'releaseFieldBackendVersion', overview.backendVersion),
            _row(context, 'releaseFieldEnvironment', overview.environment),
            _row(context, 'releaseFieldNodeEnv', overview.nodeEnv),
            _row(
              context,
              'releaseFieldMaintenanceMode',
              overview.maintenanceMode
                  ? resolveReleaseCenterKey(context, 'releaseYes')
                  : resolveReleaseCenterKey(context, 'releaseNo'),
            ),
            if (!compact) ...[
              if (overview.latestAdminAppVersion != null)
                _row(context, 'releaseFieldLatestAdminApp', overview.latestAdminAppVersion!),
              if (overview.latestDriverAppVersion != null)
                _row(context, 'releaseFieldLatestDriverApp', overview.latestDriverAppVersion!),
              const SizedBox(height: 8),
              Text(
                resolveReleaseCenterKey(
                  context,
                  'releaseFieldLastDeployment',
                  params: {'date': deployedLabel},
                ),
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 160,
            child: Text(
              resolveReleaseCenterKey(context, key),
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}

class ReleaseAppVersionsCard extends StatelessWidget {
  const ReleaseAppVersionsCard({super.key, required this.versions});

  final ReleaseAppVersions versions;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveReleaseCenterKey(context, 'releaseAppVersionsTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            if (versions.latestAdminAppVersion != null)
              _row(context, 'releaseFieldLatestAdminApp', versions.latestAdminAppVersion!),
            if (versions.latestDriverAppVersion != null)
              _row(context, 'releaseFieldLatestDriverApp', versions.latestDriverAppVersion!),
            if (versions.minimumSupportedAdminAppVersion != null)
              _row(
                context,
                'releaseFieldMinAdminApp',
                versions.minimumSupportedAdminAppVersion!,
              ),
            if (versions.minimumSupportedDriverAppVersion != null)
              _row(
                context,
                'releaseFieldMinDriverApp',
                versions.minimumSupportedDriverAppVersion!,
              ),
            const SizedBox(height: 12),
            if (versions.activeAdminAppVersions != null)
              _versionMap(context, 'releaseActiveAdminVersions', versions.activeAdminAppVersions!),
            if (versions.activeDriverAppVersions != null) ...[
              const SizedBox(height: 8),
              _versionMap(context, 'releaseActiveDriverVersions', versions.activeDriverAppVersions!),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(resolveReleaseCenterKey(context, key)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  Widget _versionMap(BuildContext context, String titleKey, Map<String, int> map) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(resolveReleaseCenterKey(context, titleKey)),
        const SizedBox(height: 4),
        for (final entry in map.entries)
          Text('${entry.key}: ${entry.value}'),
      ],
    );
  }
}

class ReleaseEnvironmentCard extends StatelessWidget {
  const ReleaseEnvironmentCard({super.key, required this.environment});

  final ReleaseEnvironment environment;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              resolveReleaseCenterKey(context, 'releaseEnvironmentTitle'),
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 12),
            _row(context, 'releaseFieldEnvironment', environment.environment),
            _row(context, 'releaseFieldNodeEnv', environment.nodeEnv),
            _row(context, 'releaseFieldMigrationStatus', environment.databaseMigrationStatus),
            _row(
              context,
              'releaseFieldDeploymentReady',
              environment.deploymentReady
                  ? resolveReleaseCenterKey(context, 'releaseYes')
                  : resolveReleaseCenterKey(context, 'releaseNo'),
            ),
            if (environment.apiBaseUrlPublicName != null)
              _row(context, 'releaseFieldApiPublicName', environment.apiBaseUrlPublicName!),
            if (environment.deploymentWarnings.isNotEmpty) ...[
              const SizedBox(height: 12),
              Text(resolveReleaseCenterKey(context, 'releaseDeploymentWarnings')),
              for (final warning in environment.deploymentWarnings)
                Text('• $warning'),
            ],
          ],
        ),
      ),
    );
  }

  Widget _row(BuildContext context, String key, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        children: [
          SizedBox(
            width: 180,
            child: Text(resolveReleaseCenterKey(context, key)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }
}
