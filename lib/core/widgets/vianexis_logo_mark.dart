import 'package:flutter/material.dart';

import '../../app/vianexis_brand.dart';
import '../../l10n/app_localizations.dart';

/// ViaNexis logo/mark with safe asset fallback.
class VianexisLogoMark extends StatelessWidget {
  const VianexisLogoMark({
    super.key,
    this.size = 72,
    this.showTitle = true,
    this.compact = false,
    this.logoAssetPath,
    this.markAssetPath,
  });

  final double size;
  final bool showTitle;
  final bool compact;
  final String? logoAssetPath;
  final String? markAssetPath;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final mark = _MarkImage(
      size: size,
      assetPath: markAssetPath ?? VianexisBrand.markAsset,
    );

    if (!showTitle) {
      return mark;
    }

    if (compact) {
      return Row(
        children: [
          mark,
          const SizedBox(width: VianexisBrand.spaceMd),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n.brandAppName,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: VianexisBrand.textPrimary,
                    fontWeight: FontWeight.w700,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  l10n.brandControlCenterSubtitle,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: VianexisBrand.accentMuted,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      );
    }

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          logoAssetPath ?? VianexisBrand.logoAsset,
          height: size * 0.9,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => mark,
        ),
        const SizedBox(height: VianexisBrand.spaceMd),
        Text(
          l10n.brandAppName,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            color: VianexisBrand.textPrimary,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: VianexisBrand.spaceXs),
        Text(
          l10n.brandControlCenterSubtitle,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: VianexisBrand.accentMuted,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}

class _MarkImage extends StatelessWidget {
  const _MarkImage({required this.size, required this.assetPath});

  final double size;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Image.asset(
      assetPath,
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _TextMark(size: size),
    );
  }
}

class _TextMark extends StatelessWidget {
  const _TextMark({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(VianexisBrand.radiusMd),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [VianexisBrand.viaNexisBlue, Color(0xFF1E6091)],
        ),
        border: Border.all(color: VianexisBrand.goldAccent.withValues(alpha: 0.35)),
      ),
      alignment: Alignment.center,
      child: Text(
        'VN',
        style: TextStyle(
          color: VianexisBrand.textPrimary,
          fontWeight: FontWeight.w800,
          fontSize: size * 0.34,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}
