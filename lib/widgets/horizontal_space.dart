import 'package:flutter/material.dart';

class HorizontalSpace extends StatelessWidget {
  final double size;

  const HorizontalSpace(this.size);

  @override
  Widget build(BuildContext context) => Container(width: size);
}
