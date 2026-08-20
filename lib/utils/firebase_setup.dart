import 'dart:isolate';

import 'package:adair_flutter_lib/utils/log.dart';
import 'package:adair_flutter_lib/utils/properties_file.dart';
import 'package:adair_flutter_lib/wrappers/analytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/app_check_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/firebase_wrapper.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;

typedef NonFatalMatcher = bool Function(Object error, StackTrace? stack);

const _sensitivePropertiesPath = "assets/sensitive.properties";
const _keyAppCheckDebugToken = "appCheck.debugToken";

const _log = Log("firebase_setup");

/// Sets up Firebase Analytics, Crashlytics, and all unhandled error handlers.
/// Must be called after [Firebase.initializeApp] and before [runApp].
///
/// The [isRelease] parameter controls whether collection is enabled. Defaults
/// to [kReleaseMode] so collection is off in debug builds.
///
/// The [enableAppCheck] parameter controls whether Firebase App Check is
/// activated. Defaults to false; only apps whose Firebase project has
/// attestation providers (Play Integrity / App Attest) configured should
/// opt in. When enabled, release builds use the platform-native provider
/// and debug builds use the debug provider.
///
/// When [enableAppCheck] is true and this is a debug build, the debug
/// provider is pinned to the `appCheck.debugToken` value in the app's
/// `assets/sensitive.properties` file (registered once in the Firebase
/// console) instead of each device auto-generating and needing its own
/// token registered.
///
/// The [nonFatalMatcher] callback, if provided, is called for every unhandled
/// error. When it returns true the error is recorded as non-fatal, allowing
/// the app to survive. When it returns false (or is omitted) the error is
/// recorded as fatal, preserving existing behaviour.
///
/// The [ignoreMatcher] callback, if provided, is checked before
/// [nonFatalMatcher] for every unhandled error. When it returns true, the
/// error is not recorded to Crashlytics at all (and the app still survives,
/// same as a matched [nonFatalMatcher]). Use this for known, unactionable
/// third-party errors that would otherwise be pure noise in Crashlytics.
Future<void> setupFirebase({
  bool isRelease = kReleaseMode,
  bool enableAppCheck = false,
  FirebaseOptions? options,
  NonFatalMatcher? nonFatalMatcher,
  NonFatalMatcher? ignoreMatcher,
}) async {
  await FirebaseWrapper.get.initializeApp(options: options);

  if (enableAppCheck) {
    final debugToken = isRelease ? null : await _appCheckDebugToken();
    await AppCheckWrapper.get.activate(
      providerAndroid: isRelease
          ? const AndroidPlayIntegrityProvider()
          : AndroidDebugProvider(debugToken: debugToken),
      providerApple: isRelease
          ? const AppleAppAttestWithDeviceCheckFallbackProvider()
          : AppleDebugProvider(debugToken: debugToken),
    );
  }

  await AnalyticsWrapper.get.setAnalyticsCollectionEnabled(isRelease);

  await CrashlyticsWrapper.get.setCrashlyticsCollectionEnabled(isRelease);
  await CrashlyticsWrapper.get.setCustomKey(
    "Locale",
    PlatformDispatcher.instance.locale.toString(),
  );

  // Catches widget build errors and other Flutter framework errors.
  FlutterError.onError = (details) {
    if (ignoreMatcher?.call(details.exception, details.stack) == true) {
      return;
    }

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
    if (ignoreMatcher?.call(error, stack) == true) {
      return true;
    }

    CrashlyticsWrapper.get.recordError(
      error,
      stack,
      fatal: nonFatalMatcher == null || nonFatalMatcher(error, stack) == false,
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

Future<String?> _appCheckDebugToken() async {
  String? propertiesString;
  try {
    propertiesString = await rootBundle.loadString(_sensitivePropertiesPath);
  } catch (e) {
    _log.e(e, reason: "Failed to load $_sensitivePropertiesPath");
    return null;
  }
  return PropertiesFile(propertiesString).stringForKey(_keyAppCheckDebugToken);
}

@visibleForTesting
Future<void> handleIsolateError(dynamic pair) async {
  final stackTrace = pair.last == null
      ? null
      : StackTrace.fromString(pair.last as String);
  await CrashlyticsWrapper.get.recordError(pair.first, stackTrace, fatal: true);
}
