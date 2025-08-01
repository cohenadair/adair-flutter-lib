import 'package:adair_flutter_lib/res/theme.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../res/dimen.dart';

class Loading extends StatelessWidget {
  static const _size = 20.0;
  static const _strokeWidth = 2.0;

  final EdgeInsets padding;
  final String? label;
  final bool isCentered;
  final bool isAppBar;

  const Loading({
    this.padding = insetsZero,
    this.label,
    this.isCentered = true,
    this.isAppBar = false,
  });

  /// A [Loading] widget to be used in an [AppBar].
  const Loading.appBar()
    : this(
        padding: const EdgeInsets.only(
          right: paddingDefault,
          top: paddingDefault,
        ),
        isCentered: true,
        isAppBar: true,
      );

  const Loading.listItem() : this(isCentered: false, isAppBar: false);

  @override
  Widget build(BuildContext context) {
    var indicator = SizedBox.fromSize(
      size: const Size(_size, _size),
      child: CircularProgressIndicator(
        strokeWidth: _strokeWidth,
        color: isAppBar ? context.colorText : null,
      ),
    );

    if (isCentered || isNotEmpty(label)) {
      return Padding(
        padding: padding,
        child: Column(
          mainAxisAlignment: isCentered
              ? MainAxisAlignment.center
              : MainAxisAlignment.start,
          children: [
            indicator,
            Container(height: paddingDefault),
            isEmpty(label) ? const SizedBox() : Text(label!),
          ],
        ),
      );
    } else {
      return Padding(padding: padding, child: indicator);
    }
  }
}
