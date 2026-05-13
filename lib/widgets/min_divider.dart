import 'package:flutter/material.dart';

class MinDivider extends StatelessWidget {
  final Color? color;
  final double? width;

  const MinDivider({this.color, this.width});

  @override
  Widget build(BuildContext context) {
    return width == null
        ? Divider(height: 1, color: color)
        : Container(
            width: width,
            height: 1,
            color: color ?? Theme.of(context).dividerColor,
          );
  }
}
