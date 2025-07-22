import 'package:flutter/foundation.dart';

import '../wrappers/crashlytics_wrapper.dart';

class Log {
  final String _className;
  final bool _isDebug;

  const Log(this._className, {bool isDebug = kDebugMode}) : _isDebug = isDebug;

  String get _prefix => "AL-$_className: ";

  void d(String msg) {
    _log("D/$_prefix$msg");
  }

  void e(String msg) {
    _log("E/$_prefix$msg", StackTrace.current);
  }

  void w(String msg) {
    _log("W/$_prefix$msg");
  }

  /// Does [work] and measures performance in milliseconds. If [work] takes
  /// longer than [msThreshold] to finish, an error message is logged, otherwise
  /// only a debug message is logged.
  ///
  /// The value of [work] is returned. See [async] to measure asynchronous work.
  T sync<T>(String tag, int msThreshold, T Function() work) {
    var stopwatch = Stopwatch()..start();
    var result = work();
    _logElapsed(tag, stopwatch, msThreshold);
    return result;
  }

  /// Does [work] and measures performance in milliseconds. If [work] takes
  /// longer than [msThreshold] to finish, an error message is logged, otherwise
  /// only a debug message is logged.
  ///
  /// The value of [work] is returned. See [sync] to measure synchronous work.
  Future<T> async<T>(String tag, int msThreshold, Future<T> work) async {
    var stopwatch = Stopwatch()..start();
    var result = await work;
    _logElapsed(tag, stopwatch, msThreshold);
    return result;
  }

  void _logElapsed(String tag, Stopwatch watch, int msThreshold) {
    var elapsed = watch.elapsed.inMilliseconds;
    if (elapsed > msThreshold) {
      e("$tag exceeded threshold: ${elapsed}ms");
    } else {
      d("$tag took ${elapsed}ms");
    }
  }

  void _log(String msg, [StackTrace? stackTrace]) {
    // Don't engage Crashlytics at all if we're on a debug build. Even if
    // crash reporting is off, Crashlytics queues crashes to be sent later.
    if (_isDebug) {
      // ignore: avoid_print
      print(msg);
      return;
    }

    if (stackTrace == null) {
      CrashlyticsWrapper.get.log(msg);
    } else {
      CrashlyticsWrapper.get.recordError(
        msg,
        stackTrace,
        reason: "Logged error",
      );
    }
  }
}
