import 'dart:isolate';

import 'package:adair_flutter_lib/wrappers/analytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/firebase_wrapper.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

/// Sets up Firebase Analytics, Crashlytics, and all unhandled error handlers.
/// Must be called after [Firebase.initializeApp] and before [runApp].
///
/// The [isRelease] parameter controls whether collection is enabled. Defaults
/// to [kReleaseMode] so collection is off in debug builds.
Future<void> setupFirebase({
  bool isRelease = kReleaseMode,
  FirebaseOptions? options,
}) async {
  await FirebaseWrapper.get.initializeApp(options: options);

  await AnalyticsWrapper.get.setAnalyticsCollectionEnabled(isRelease);

  await CrashlyticsWrapper.get.setCrashlyticsCollectionEnabled(isRelease);
  await CrashlyticsWrapper.get.setCustomKey(
    "Locale",
    PlatformDispatcher.instance.locale.toString(),
  );

  // Catches widget build errors and other Flutter framework errors.
  FlutterError.onError = CrashlyticsWrapper.get.recordFlutterFatalError;

  // Catches async Dart errors not caught by the Flutter framework.
  PlatformDispatcher.instance.onError = (error, stack) {
    CrashlyticsWrapper.get.recordError(error, stack, fatal: true);
    return true;
  };

  // Catches uncaught errors at the root isolate level. Not exercised in unit
  // tests because spawning a second isolate that throws and reaching this
  // listener is not reliable in the test harness.
  Isolate.current.addErrorListener(
    RawReceivePort((pair) async {
      await CrashlyticsWrapper.get.recordError(
        pair.first,
        pair.last,
        fatal: true,
      );
    }).sendPort,
  );
}
