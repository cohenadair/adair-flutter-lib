import 'package:adair_flutter_lib/res/anim.dart';
import 'package:flutter/material.dart';

Future<T?> push<T>(
  BuildContext context,
  Widget page, {
  bool fullscreenDialog = false,
}) {
  return Navigator.of(context, rootNavigator: fullscreenDialog).push<T?>(
    MaterialPageRoute(
      builder: (context) => page,
      fullscreenDialog: fullscreenDialog,
    ),
  );
}

Future<T?> present<T>(BuildContext context, Widget page) {
  return push<T?>(context, page, fullscreenDialog: true);
}

/// Shows the given page immediately with a [FadeAnimation].
void fade(BuildContext context, Widget page, {bool opaque = false}) {
  Navigator.of(context, rootNavigator: true).push(
    PageRouteBuilder(
      opaque: opaque,
      pageBuilder: (_, __, ___) => page,
      transitionDuration: animDurationDefault,
      transitionsBuilder: (context, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    ),
  );
}
