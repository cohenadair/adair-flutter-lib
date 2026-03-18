import 'package:flutter/material.dart';

class MinDivider extends StatelessWidget {
  final Color? color;

  const MinDivider({this.color});

  @override
  Widget build(BuildContext context) {
    return Divider(height: 1, color: color);
  }
}
