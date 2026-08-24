import 'package:adair_flutter_lib/res/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Renders [asset] tinted a single colour — [color] if given, otherwise the
/// current [BuildContexts.colorApp]. [maxWidth] and [maxHeight] behave like
/// [SizedBox]'s width/height: either, both, or neither may be given. If only
/// one is given, the other follows automatically to preserve the asset's own
/// aspect ratio. If both are given, the asset scales to fit within that box
/// (never stretched or cropped), anchored by [alignment].
class TintedSvgPicture extends StatelessWidget {
  final String asset;
  final double? maxWidth;
  final double? maxHeight;
  final Color? color;
  final Alignment alignment;

  const TintedSvgPicture(
    this.asset, {
    this.maxWidth,
    this.maxHeight,
    this.color,
    this.alignment = Alignment.center,
  }) : assert(asset != "", "asset must not be empty");

  @override
  Widget build(BuildContext context) {
    final picture = SvgPicture.asset(
      asset,
      colorFilter: ColorFilter.mode(color ?? context.colorApp, BlendMode.srcIn),
    );

    if (maxWidth == null && maxHeight == null) {
      return picture;
    }

    return SizedBox(
      width: maxWidth,
      height: maxHeight,
      child: FittedBox(
        fit: BoxFit.contain,
        alignment: alignment,
        child: picture,
      ),
    );
  }
}
