import 'package:flutter/material.dart';

import '../res/dimen.dart';
import '../res/style.dart';

class TitleText extends StatelessWidget {
  final String text;
  final TextAlign? align;
  final TextOverflow? overflow;
  final int? maxLines;

  final TextStyle _style;
  final double _offset;

  const TitleText.style1(this.text, {this.align, this.overflow, this.maxLines})
      : _style = styleTitle1,
        _offset = 2.0;

  TitleText.style2(
    BuildContext context,
    this.text, {
    this.align,
    this.overflow,
    this.maxLines,
  })  : _style = styleTitle2(context),
        _offset = 1.0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      // For large text, there is some additional leading padding for some
      // reason, so large text won't horizontally align with widgets around it.
      // Offset the leading padding to compensate for this.
      padding: EdgeInsets.only(
        left: paddingDefault - _offset,
        right: paddingDefault,
      ),
      child: Text(
        text,
        style: _style,
        textAlign: align,
        overflow: overflow,
        maxLines: maxLines,
      ),
    );
  }
}
