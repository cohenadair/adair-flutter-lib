import 'dart:async';

import 'package:adair_install_attribution/install_attribution_manager.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  const channel = MethodChannel("adair_install_attribution");
  late List<String> calls;

  setUp(() {
    InstallAttributionManager.reset();
    calls = [];
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, null);
  });

  void stubRegister(Future<Object?> Function() answer) {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
        .setMockMethodCallHandler(channel, (call) {
          calls.add(call.method);
          return answer();
        });
  }

  Future<void> initAndSettle() async {
    await InstallAttributionManager.get.init();
    await pumpEventQueue();
  }

  test("init logs the native API that was called", () async {
    stubRegister(() async => "Native API");

    await expectLater(
      initAndSettle,
      prints(contains("Registered install attribution via Native API")),
    );
    expect(calls, ["register"]);
  });

  test("init logs and swallows native errors", () async {
    stubRegister(() async => throw PlatformException(code: "register_failed"));

    await expectLater(
      initAndSettle,
      prints(contains("Registering install attribution")),
    );
  });

  test("init logs SKAN unknown error as a warning", () async {
    stubRegister(
      () async => throw PlatformException(
        code: "register_failed",
        details: {"domain": "SKANErrorDomain", "code": 10},
      ),
    );

    await expectLater(
      initAndSettle,
      prints(contains("W/AL-InstallAttributionManager: Registering install")),
    );
  });

  test("init logs other SKAN errors as errors", () async {
    stubRegister(
      () async => throw PlatformException(
        code: "register_failed",
        details: {"domain": "SKANErrorDomain", "code": 3},
      ),
    );

    await expectLater(
      initAndSettle,
      prints(contains("E/AL-InstallAttributionManager: Registering install")),
    );
  });

  test("init logs same error code from another domain as an error", () async {
    stubRegister(
      () async => throw PlatformException(
        code: "register_failed",
        details: {"domain": "NSCocoaErrorDomain", "code": 10},
      ),
    );

    await expectLater(
      initAndSettle,
      prints(contains("E/AL-InstallAttributionManager: Registering install")),
    );
  });

  test("init returns before the native call completes", () async {
    final completer = Completer<Object?>();
    stubRegister(() => completer.future);

    await InstallAttributionManager.get.init();
    expect(completer.isCompleted, isFalse);

    await pumpEventQueue();
    expect(calls, ["register"]);
  });
}
