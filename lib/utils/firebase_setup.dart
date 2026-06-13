import 'dart:isolate';

import 'package:adair_flutter_lib/wrappers/analytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/firebase_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

typedef NonFatalMatcher = bool Function(Object error, StackTrace? stack);

/// Sets up Firebase Analytics, Crashlytics, and all unhandled error handlers.
/// Must be called after [Firebase.initializeApp] and before [runApp].
///
/// The [isRelease] parameter controls whether collection is enabled. Defaults
/// to [kReleaseMode] so collection is off in debug builds.
///
/// The [nonFatalMatcher] callback, if provided, is called for every unhandled
/// error. When it returns true the error is recorded as non-fatal, allowing
/// the app to survive. When it returns false (or is omitted) the error is
/// recorded as fatal, preserving existing behaviour.
Future<void> setupFirebase({
  bool isRelease = kReleaseMode,
  FirebaseOptions? options,
  NonFatalMatcher? nonFatalMatcher,
}) async {
  await FirebaseWrapper.get.initializeApp(options: options);

  await AnalyticsWrapper.get.setAnalyticsCollectionEnabled(isRelease);

  await CrashlyticsWrapper.get.setCrashlyticsCollectionEnabled(isRelease);
  await CrashlyticsWrapper.get.setCustomKey(
    "Locale",
    PlatformDispatcher.instance.locale.toString(),
  );

  // Catches widget build errors and other Flutter framework errors.
  FlutterError.onError = (details) {
    if (nonFatalMatcher?.call(details.exception, details.stack) == true) {
      CrashlyticsWrapper.get.recordError(
        details.exception,
        details.stack,
        fatal: false,
      );
    } else {
      CrashlyticsWrapper.get.recordFlutterFatalError(details);
    }
  };

  // Catches async Dart errors not caught by the Flutter framework.
  PlatformDispatcher.instance.onError = (error, stack) {
    CrashlyticsWrapper.get.recordError(
      error,
      stack,
      fatal: nonFatalMatcher?.call(error, stack) == false,
    );
    return true;
  };

  // Catches uncaught errors at the root isolate level.
  Isolate.current.addErrorListener(
    RawReceivePort((pair) async {
      await handleIsolateError(pair);
    }).sendPort,
  );
}

@visibleForTesting
Future<void> handleIsolateError(dynamic pair) async {
  final stackTrace = pair.last == null
      ? null
      : StackTrace.fromString(pair.last as String);
  await CrashlyticsWrapper.get.recordError(pair.first, stackTrace, fatal: true);
}
