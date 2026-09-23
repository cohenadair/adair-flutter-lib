import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:quiver/strings.dart';

import '../wrappers/crashlytics_wrapper.dart';

class Log {
  static const _logFileUri = "package:adair_flutter_lib/utils/log.dart";

  final String _className;
  final bool _isDebug;

  const Log(this._className, {bool isDebug = kDebugMode}) : _isDebug = isDebug;

  // TODO: Allow setting per app.
  String get _prefix => "AL-$_className: ";

  void d(String msg) {
    _log("D/$_prefix$msg");
  }

  void e(
    Object exception, {
    String? reason,
    StackTrace? stackTrace,
    bool fatal = false,
  }) {
    _log(
      reason == null ? null : "E/$_prefix$reason",
      exception: exception,
      stackTrace: stackTrace,
      fatal: fatal,
    );
  }

  void w(String msg) {
    _log("W/$_prefix$msg");
  }

  /// Does [work] and measures performance in milliseconds. If [work] takes
  /// longer than its threshold to finish, an error is logged, otherwise only
  /// a debug message is logged.
  ///
  /// The threshold is [msThreshold], plus [msPerItem] for each item counted by
  /// [countItems]. This allows work that grows with the amount of data, such
  /// as a report, to be measured against a budget per item, rather than a
  /// fixed time that users with more data will eventually exceed.
  ///
  /// If set, the result of [describe] is included in the error to provide
  /// context, such as the amount of data processed.
  ///
  /// [countItems] and [describe] are passed the result of [work], and are not
  /// included in the measured time.
  ///
  /// The value of [work] is returned. See [async] to measure asynchronous work.
  T sync<T>(
    String tag,
    int msThreshold,
    T Function() work, {
    double msPerItem = 0,
    int Function(T result)? countItems,
    String Function(T result)? describe,
  }) {
    var stopwatch = Stopwatch()..start();
    var result = work();
    stopwatch.stop();
    _logElapsed(
      tag,
      stopwatch,
      msThreshold,
      result,
      msPerItem: msPerItem,
      countItems: countItems,
      describe: describe,
    );
    return result;
  }

  /// Does [work] and measures performance in milliseconds. See [sync] for
  /// details on the threshold, [msPerItem], [countItems], and [describe].
  ///
  /// The value of [work] is returned. See [sync] to measure synchronous work.
  Future<T> async<T>(
    String tag,
    int msThreshold,
    Future<T> work, {
    double msPerItem = 0,
    int Function(T result)? countItems,
    String Function(T result)? describe,
  }) async {
    var stopwatch = Stopwatch()..start();
    var result = await work;
    stopwatch.stop();
    _logElapsed(
      tag,
      stopwatch,
      msThreshold,
      result,
      msPerItem: msPerItem,
      countItems: countItems,
      describe: describe,
    );
    return result;
  }

  void _logElapsed<T>(
    String tag,
    Stopwatch watch,
    int msThreshold,
    T result, {
    required double msPerItem,
    required int Function(T result)? countItems,
    required String Function(T result)? describe,
  }) {
    var elapsed = watch.elapsed.inMilliseconds;
    var itemCount = countItems?.call(result) ?? 0;
    var threshold = (msThreshold + msPerItem * itemCount).round();

    if (elapsed > threshold) {
      var details = [
        "${elapsed}ms",
        "threshold ${threshold}ms",
        if (countItems != null) "$itemCount items",
        if (describe != null) describe(result),
      ].join(", ");
      e(
        TimeoutException(
          "$tag ($details) exceeded run threshold",
          Duration(milliseconds: threshold),
        ),
      );
    } else {
      d("$tag took ${elapsed}ms");
    }
  }

  /// Handles the log message. In release builds, logs are sent to Firebase
  /// Crashlytics. Note that the [fatal] argument doesn't actually crash the
  /// app; it just displays the error as a fatal error in the Crashlytics web
  /// portal.
  void _log(
    String? msg, {
    Object? exception,
    StackTrace? stackTrace,
    bool fatal = false,
  }) {
    if (_isDebug) {
      if (isNotEmpty(msg) && exception != null) {
        // ignore: avoid_print
        print("$msg ($exception)");
      } else if (isNotEmpty(msg)) {
        // ignore: avoid_print
        print(msg);
      } else if (exception != null) {
        // ignore: avoid_print
        print("E/$_prefix$exception");
      }

      if (stackTrace != null) {
        // ignore: avoid_print
        print(stackTrace);
      }

      // Don't engage Crashlytics at all if we're on a debug build. Even if
      // crash reporting is off, Crashlytics queues crashes to be sent later.
      return;
    }

    try {
      if (exception == null) {
        assert(msg != null);
        CrashlyticsWrapper.get.log(msg!);
      } else {
        CrashlyticsWrapper.get.recordError(
          exception,
          stackTrace ?? _callerStackTrace(),
          reason: msg,
          fatal: fatal,
        );
      }
    } catch (error) {
      // Logging must never break the caller. This happens, for example, when
      // logging from a background isolate, where Firebase isn't initialized.
      // Crashlytics isn't available, so printing is the only option.
      // ignore: avoid_print
      print("E/${_prefix}Failed to send log to Crashlytics: $error; msg=$msg");
    }
  }

  /// Returns the current stack trace, without [Log]'s own frames. Crashlytics
  /// groups issues by the top app frame, so without trimming, every error
  /// logged without a stack trace would be grouped into a single issue.
  ///
  /// The VM stack trace format is preserved, since that's what Crashlytics
  /// parses.
  StackTrace _callerStackTrace() {
    return StackTrace.fromString(
      StackTrace.current
          .toString()
          .split("\n")
          .skipWhile((line) => line.contains(_logFileUri))
          .join("\n"),
    );
  }
}
