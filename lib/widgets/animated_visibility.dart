import 'package:adair_flutter_lib/res/anim.dart';
import 'package:flutter/material.dart';

/// A wrapper for [AnimatedOpacity] with a default duration.
class AnimatedVisibility extends StatelessWidget {
  final bool isVisible;
  final double visibleOpacity;
  final Widget child;

  const AnimatedVisibility({
    this.isVisible = true,
    this.visibleOpacity = 1.0,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? visibleOpacity : 0.0,
      duration: animDurationDefault,
      child: child,
    );
  }
}
