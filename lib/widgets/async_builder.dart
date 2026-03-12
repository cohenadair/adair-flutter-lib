import 'package:adair_flutter_lib/utils/widget.dart';
import 'package:flutter/material.dart';
import 'package:quiver/strings.dart';

import '../utils/log.dart';

/// A [FutureBuilder] and [StreamBuilder] wrapper that renders the widget
/// returned by [loadingBuilder] (if not null) or an empty container while the
/// given [Future] is in progress.
///
/// If the future or stream throws an error, it will be logged to Firebase, and
/// the widget rendered is the one returned by [errorBuilder],
/// then [loadingBuilder], then lastly, an empty container.
///
/// It is recommended to use this widget in place of all [FutureBuilder] and
/// [StreamBuilder] instances, so that errors thrown by async operations are
/// caught and logged, rather than fail silently.
class AsyncBuilder<T> extends StatelessWidget {
  final Widget Function(BuildContext, T?) builder;
  final WidgetCallback? loadingBuilder;
  final WidgetCallback? errorBuilder;

  /// Generally, should be a brief description of what this future is used for,
  /// to better understand what went wrong, and to distinguish from other errors
  /// in Firebase.
  final String errorReason;
  final bool isErrorFatal;

  final _log = Log("SafeFutureBuilder<$T>");

  final Future<T>? _future;
  final Stream<T>? _stream;

  bool get _isFuture => _future != null;

  AsyncBuilder.future({
    required Future<T> future,
    required this.builder,
    required this.errorReason,
    this.loadingBuilder,
    this.errorBuilder,
    this.isErrorFatal = false,
  }) : assert(isNotEmpty(errorReason)),
       _future = future,
       _stream = null;

  AsyncBuilder.stream({
    required Stream<T> stream,
    required this.builder,
    required this.errorReason,
    this.loadingBuilder,
    this.errorBuilder,
    this.isErrorFatal = false,
  }) : assert(isNotEmpty(errorReason)),
       _future = null,
       _stream = stream;

  @override
  Widget build(BuildContext context) {
    return _isFuture
        ? FutureBuilder<T>(future: _future, builder: _buildFromSnapshot)
        : StreamBuilder<T>(stream: _stream, builder: _buildFromSnapshot);
  }

  Widget _buildFromSnapshot(BuildContext context, AsyncSnapshot<T> snapshot) {
    final isLoading = _isFuture
        ? snapshot.connectionState != ConnectionState.done
        : snapshot.connectionState == ConnectionState.waiting;

    if (isLoading) {
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
  }
}
