import 'package:flutter/material.dart';

import '../res/dimen.dart';

class Empty extends StatelessWidget {
  const Empty();

  @override
  Widget build(BuildContext context) {
    return const SizedBox();
  }
}

class EmptyOr extends StatelessWidget {
  final Widget Function(BuildContext) builder;

  /// Padding wrapped around the widget returned by [childBuilder].
  final EdgeInsets? padding;

  final bool isShowing;

  const EmptyOr({this.isShowing = true, this.padding, required this.builder});

  @override
  Widget build(BuildContext context) {
    return isShowing
        ? Padding(padding: padding ?? insetsZero, child: builder(context))
        : const Empty();
  }
}
