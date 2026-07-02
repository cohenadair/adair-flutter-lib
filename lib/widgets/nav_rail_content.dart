import 'package:adair_flutter_lib/res/theme.dart';
import 'package:flutter/material.dart';

class NavRailContent extends StatelessWidget {
  final Widget child;

  const NavRailContent({required this.child});
  @override
  Widget build(BuildContext context) {
    return Material(
      color:
          Theme.of(context).navigationRailTheme.backgroundColor ??
          Theme.of(context).colorScheme.surface,
      child: ClipRRect(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.radiusNavigationRailContent),
        ),
        child: Material(
          color: Theme.of(context).scaffoldBackgroundColor,
          child: child,
        ),
      ),
    );
  }
}
