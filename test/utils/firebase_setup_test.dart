import 'package:adair_flutter_lib/utils/firebase_setup.dart';
import 'package:adair_flutter_lib/wrappers/analytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/firebase_wrapper.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';

void main() {
  late StubbedManagers managers;

  FlutterExceptionHandler? savedFlutterOnError;
  bool Function(Object, StackTrace)? savedPlatformOnError;

  setUp(() async {
    managers = await StubbedManagers.create();

    when(
      managers.firebaseWrapper.initializeApp(options: anyNamed("options")),
    ).thenAnswer((_) async {});

    when(
      managers.analyticsWrapper.setAnalyticsCollectionEnabled(any),
    ).thenAnswer((_) async {});

    when(
      managers.crashlyticsWrapper.setCrashlyticsCollectionEnabled(any),
    ).thenAnswer((_) async {});
    when(
      managers.crashlyticsWrapper.setCustomKey(any, any),
    ).thenAnswer((_) async {});
    when(
      managers.crashlyticsWrapper.recordFlutterFatalError(any),
    ).thenAnswer((_) async {});
    when(
      managers.crashlyticsWrapper.recordError(
        any,
        any,
        fatal: anyNamed("fatal"),
      ),
    ).thenAnswer((_) async {});

    savedFlutterOnError = FlutterError.onError;
    savedPlatformOnError = PlatformDispatcher.instance.onError;
  });

  tearDown(() {
    FlutterError.onError = savedFlutterOnError;
    PlatformDispatcher.instance.onError = savedPlatformOnError;
    FirebaseWrapper.reset();
    AnalyticsWrapper.reset();
    CrashlyticsWrapper.reset();
  });

  test("setupFirebase sets FlutterError.onError", () async {
    FlutterError.onError = null;
    await setupFirebase(isRelease: false);
    expect(FlutterError.onError, isNotNull);
  });

  test("setupFirebase sets PlatformDispatcher.instance.onError", () async {
    PlatformDispatcher.instance.onError = null;
    await setupFirebase(isRelease: false);
    expect(PlatformDispatcher.instance.onError, isNotNull);
  });

  test("setupFirebase disables collection when not in release mode", () async {
    await setupFirebase(isRelease: false);
    verify(
      managers.crashlyticsWrapper.setCrashlyticsCollectionEnabled(false),
    ).called(1);
    verify(
      managers.analyticsWrapper.setAnalyticsCollectionEnabled(false),
    ).called(1);
  });

  test("setupFirebase enables collection in release mode", () async {
    await setupFirebase(isRelease: true);
    verify(
      managers.crashlyticsWrapper.setCrashlyticsCollectionEnabled(true),
    ).called(1);
    verify(
      managers.analyticsWrapper.setAnalyticsCollectionEnabled(true),
    ).called(1);
  });

  test("setupFirebase sets Locale custom key", () async {
    await setupFirebase(isRelease: false);
    verify(managers.crashlyticsWrapper.setCustomKey("Locale", any)).called(1);
  });

  test("Flutter error handler forwards to CrashlyticsWrapper", () async {
    await setupFirebase(isRelease: false);
    final details = FlutterErrorDetails(exception: Exception("test"));
    FlutterError.onError!(details);
    verify(
      managers.crashlyticsWrapper.recordFlutterFatalError(details),
    ).called(1);
  });

  test(
    "Platform error handler forwards to CrashlyticsWrapper with fatal true",
    () async {
      await setupFirebase(isRelease: false);
      final error = Exception("platform test");
      final stack = StackTrace.current;
      PlatformDispatcher.instance.onError!(error, stack);
      verify(
        managers.crashlyticsWrapper.recordError(error, stack, fatal: true),
      ).called(1);
    },
  );

  test("Platform error handler returns true", () async {
    await setupFirebase(isRelease: false);
    final result = PlatformDispatcher.instance.onError!(
      Exception("test"),
      StackTrace.current,
    );
    expect(result, isTrue);
  });
}
