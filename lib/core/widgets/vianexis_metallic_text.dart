import 'package:flutter/material.dart';

import '../../app/vianexis_brand.dart';

/// Champagne metallic text matching the ViaNexis lockup treatment.
class VianexisMetallicText extends StatelessWidget {
  const VianexisMetallicText(
    this.text, {
    super.key,
    this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    final resolved = (style ?? VianexisBrand.displayStyle()).copyWith(
      color: Colors.white,
    );
    return ShaderMask(
      blendMode: BlendMode.srcIn,
      shaderCallback: VianexisBrand.metallicGoldShader,
      child: Text(
        text,
        style: resolved,
        textAlign: textAlign,
        maxLines: maxLines,
        overflow: overflow,
      ),
    );
  }
}
