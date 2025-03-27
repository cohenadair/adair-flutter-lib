import 'package:flutter/material.dart';

class VerticalSpace extends StatelessWidget {
  final double size;

  const VerticalSpace(this.size);

  @override
  Widget build(BuildContext context) => Container(height: size);
}
