import 'package:adair_flutter_lib/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../utils/log.dart';

/// A [FutureBuilder] wrapper that renders the widget returned by
/// [loadingBuilder] (if not null) or an empty container while the given
/// [Future] is in progress.
///
/// If the future throws an error, it will be logged to Firebase, and the widget
/// rendered is the one returned by [errorBuilder], then [loadingBuilder], then
/// lastly, an empty container.
///
/// It is recommended to use this widget in place of all [FutureBuilder]
/// instances, so that errors thrown by [future] are caught and logged, rather
/// than fail silently.
class SafeFutureBuilder<T> extends StatelessWidget {
  final Future<T> future;
  final Widget Function(BuildContext, T?) builder;
  final WidgetCallback? loadingBuilder;
  final WidgetCallback? errorBuilder;

  /// Generally, should be a brief description of what this future is used for,
  /// to better understand what went wrong, and to distinguish from other errors
  /// in Firebase.
  final String errorReason;
  final bool isErrorFatal;

  final _log = Log("SafeFutureBuilder<$T>");

  SafeFutureBuilder({
    required this.future,
    required this.builder,
    required this.errorReason,
    this.loadingBuilder,
    this.errorBuilder,
    this.isErrorFatal = false,
  }) : assert(isNotEmpty(errorReason));

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<T>(
      future: future,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return loadingBuilder?.call(context) ?? const SizedBox();
        }

        if (snapshot.hasError) {
          _log.e(
            snapshot.error!,
            reason: errorReason,
            stackTrace: snapshot.stackTrace,
            fatal: isErrorFatal,
          );

          return errorBuilder?.call(context) ??
              loadingBuilder?.call(context) ??
              const SizedBox();
        }

        return builder(context, snapshot.data);
      },
    );
  }
}
