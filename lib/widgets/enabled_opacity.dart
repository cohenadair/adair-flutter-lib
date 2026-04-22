import 'package:flutter/material.dart';

/// An [Opacity] wrapper whose state depends on the [isEnabled] property.
class EnabledOpacity extends StatelessWidget {
  static const double _disabledOpacity = 0.5;
  static const double _enabledOpacity = 1.0;

  final bool isEnabled;
  final Widget child;

  const EnabledOpacity({super.key, required this.child, this.isEnabled = true});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      key: key,
      opacity: isEnabled ? _enabledOpacity : _disabledOpacity,
      child: child,
    );
  }
}
