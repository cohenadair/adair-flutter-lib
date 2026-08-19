import 'dart:convert';

import 'package:adair_flutter_lib/utils/firebase_setup.dart';
import 'package:adair_flutter_lib/wrappers/analytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/app_check_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:adair_flutter_lib/wrappers/firebase_wrapper.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_utils/stubbed_managers.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late StubbedManagers managers;

  FlutterExceptionHandler? savedFlutterOnError;
  bool Function(Object, StackTrace)? savedPlatformOnError;

  setUp(() async {
    managers = await StubbedManagers.create();

    when(
      managers.firebaseWrapper.initializeApp(options: anyNamed("options")),
    ).thenAnswer((_) async {});

    when(
      managers.appCheckWrapper.activate(
        providerAndroid: anyNamed("providerAndroid"),
        providerApple: anyNamed("providerApple"),
      ),
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
    AppCheckWrapper.reset();
    AnalyticsWrapper.reset();
    CrashlyticsWrapper.reset();
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMessageHandler("flutter/assets", null);
    rootBundle.evict("assets/sensitive.properties");
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

  test("setupFirebase does not activate App Check when disabled", () async {
    await setupFirebase(isRelease: false);
    verifyNever(
      managers.appCheckWrapper.activate(
        providerAndroid: anyNamed("providerAndroid"),
        providerApple: anyNamed("providerApple"),
      ),
    );
  });

  test(
    "setupFirebase activates App Check with production providers in release mode",
    () async {
      await setupFirebase(isRelease: true, enableAppCheck: true);
      final captured = verify(
        managers.appCheckWrapper.activate(
          providerAndroid: captureAnyNamed("providerAndroid"),
          providerApple: captureAnyNamed("providerApple"),
        ),
      ).captured;
      expect(captured[0], isA<AndroidPlayIntegrityProvider>());
      expect(captured[1], isA<AppleAppAttestWithDeviceCheckFallbackProvider>());
    },
  );

  test(
    "setupFirebase activates App Check with a debug token in debug mode",
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler("flutter/assets", (message) async {
            final key = utf8.decode(message!.buffer.asUint8List());
            if (key != "assets/sensitive.properties") {
              return null;
            }
            return ByteData.sublistView(
              Uint8List.fromList(utf8.encode("appCheck.debugToken=test-token")),
            );
          });

      await setupFirebase(isRelease: false, enableAppCheck: true);

      final captured = verify(
        managers.appCheckWrapper.activate(
          providerAndroid: captureAnyNamed("providerAndroid"),
          providerApple: captureAnyNamed("providerApple"),
        ),
      ).captured;
      expect((captured[0] as AndroidDebugProvider).debugToken, "test-token");
      expect((captured[1] as AppleDebugProvider).debugToken, "test-token");
    },
  );

  test(
    "setupFirebase activates App Check with a null debug token when the properties file fails to load",
    () async {
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMessageHandler("flutter/assets", (message) async => null);

      await setupFirebase(isRelease: false, enableAppCheck: true);

      final captured = verify(
        managers.appCheckWrapper.activate(
          providerAndroid: captureAnyNamed("providerAndroid"),
          providerApple: captureAnyNamed("providerApple"),
        ),
      ).captured;
      expect((captured[0] as AndroidDebugProvider).debugToken, isNull);
      expect((captured[1] as AppleDebugProvider).debugToken, isNull);
    },
  );

  test("Flutter error handler forwards to CrashlyticsWrapper", () async {
    await setupFirebase(isRelease: false);
    final details = FlutterErrorDetails(exception: Exception("test"));
    FlutterError.onError!(details);
    verify(
      managers.crashlyticsWrapper.recordFlutterFatalError(details),
    ).called(1);
  });

  test(
    "Flutter error handler calls recordError as non-fatal when matcher returns true",
    () async {
      await setupFirebase(isRelease: false, nonFatalMatcher: (_, _) => true);
      final details = FlutterErrorDetails(exception: Exception("test"));
      FlutterError.onError!(details);
      verify(
        managers.crashlyticsWrapper.recordError(
          details.exception,
          details.stack,
          fatal: false,
        ),
      ).called(1);
      verifyNever(managers.crashlyticsWrapper.recordFlutterFatalError(any));
    },
  );

  test(
    "Flutter error handler calls recordFlutterFatalError when matcher returns false",
    () async {
      await setupFirebase(isRelease: false, nonFatalMatcher: (_, _) => false);
      final details = FlutterErrorDetails(exception: Exception("test"));
      FlutterError.onError!(details);
      verify(
        managers.crashlyticsWrapper.recordFlutterFatalError(details),
      ).called(1);
      verifyNever(
        managers.crashlyticsWrapper.recordError(
          any,
          any,
          fatal: anyNamed("fatal"),
        ),
      );
    },
  );

  test(
    "Flutter error handler calls recordFlutterFatalError when no matcher is provided",
    () async {
      await setupFirebase(isRelease: false);
      final details = FlutterErrorDetails(exception: Exception("test"));
      FlutterError.onError!(details);
      verify(
        managers.crashlyticsWrapper.recordFlutterFatalError(details),
      ).called(1);
      verifyNever(
        managers.crashlyticsWrapper.recordError(
          any,
          any,
          fatal: anyNamed("fatal"),
        ),
      );
    },
  );

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

  test(
    "Platform error handler calls recordError as non-fatal when matcher returns true",
    () async {
      await setupFirebase(isRelease: false, nonFatalMatcher: (_, _) => true);
      final error = Exception("platform test");
      final stack = StackTrace.current;
      PlatformDispatcher.instance.onError!(error, stack);
      verify(
        managers.crashlyticsWrapper.recordError(error, stack, fatal: false),
      ).called(1);
    },
  );

  test(
    "Platform error handler calls recordError as fatal when matcher returns false",
    () async {
      await setupFirebase(isRelease: false, nonFatalMatcher: (_, _) => false);
      final error = Exception("platform test");
      final stack = StackTrace.current;
      PlatformDispatcher.instance.onError!(error, stack);
      verify(
        managers.crashlyticsWrapper.recordError(error, stack, fatal: true),
      ).called(1);
    },
  );

  test(
    "Platform error handler calls recordError as fatal when no matcher is provided",
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

  test(
    "handleIsolateError converts string stack trace to StackTrace before forwarding",
    () async {
      const stackString = "some stack trace string";
      await handleIsolateError(["test error", stackString]);
      final captured = verify(
        managers.crashlyticsWrapper.recordError(
          any,
          captureAny,
          fatal: anyNamed("fatal"),
        ),
      ).captured.single;
      expect(captured.toString(), stackString);
    },
  );

  test(
    "handleIsolateError passes null stack trace when pair.last is null",
    () async {
      await handleIsolateError(["test error", null]);
      verify(
        managers.crashlyticsWrapper.recordError(
          any,
          null,
          fatal: anyNamed("fatal"),
        ),
      ).called(1);
    },
  );
}
