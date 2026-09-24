import 'dart:async';
import 'dart:io';

import 'package:adair_flutter_lib/utils/log.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';
import '../test_utils/async.dart';

void main() {
  late Log log;
  late MockCrashlyticsWrapper crashlytics;

  setUp(() {
    crashlytics = MockCrashlyticsWrapper();
    when(crashlytics.log(any)).thenAnswer((_) => Future.value());
    when(
      crashlytics.recordError(
        any,
        any,
        reason: anyNamed("reason"),
        fatal: anyNamed("fatal"),
      ),
    ).thenAnswer((_) => Future.value());
    CrashlyticsWrapper.set(crashlytics);

    log = Log("Test", isDebug: false);
  });

  test("e prints reason and exception together if not empty", () async {
    final statements = await capturePrintStatements(() {
      Log("Test", isDebug: true).e(Exception("Test"), reason: "Test reason");
    });
    expect(statements.length, 1);
    expect(statements.first.contains("Test reason (Exception: Test)"), isTrue);
  });

  test("e prints exception only", () async {
    final statements = await capturePrintStatements(() {
      Log("Test", isDebug: true).e(Exception("Test"));
    });
    expect(statements.length, 1);
    expect(statements.first.contains("E/AL-Test: Exception: Test"), isTrue);
  });

  test("sync logs error", () {
    log.sync("TAG", 50, () => sleep(const Duration(milliseconds: 60)));
    verify(
      crashlytics.recordError(
        any,
        any,
        reason: anyNamed("reason"),
        fatal: anyNamed("fatal"),
      ),
    ).called(1);
    verifyNever(crashlytics.log(any));
  });

  test("async logs error", () async {
    await log.async(
      "TAG",
      50,
      Future.delayed(const Duration(milliseconds: 60)),
    );
    verify(
      crashlytics.recordError(
        any,
        any,
        reason: anyNamed("reason"),
        fatal: anyNamed("fatal"),
      ),
    ).called(1);
    verifyNever(crashlytics.log(any));
  });

  test("p logs debug", () async {
    await log.async(
      "TAG",
      50,
      Future.delayed(const Duration(milliseconds: 40)),
    );
    verify(crashlytics.log(any)).called(1);
    verifyNever(
      crashlytics.recordError(
        any,
        any,
        reason: anyNamed("reason"),
        fatal: anyNamed("fatal"),
      ),
    );
  });

  test("Log prints only the message; omits exception", () async {
    final printed = await capturePrintStatements(
      () => Log("Test", isDebug: true).w("Message"),
    );
    expect(printed.length, 1);
    expect(printed[0], "W/AL-Test: Message");
  });

  test("Debug mode doesn't use Crashlytics", () async {
    log = Log("Test", isDebug: true);
    await log.async(
      "TAG",
      50,
      Future.delayed(const Duration(milliseconds: 40)),
    );
    verifyNever(crashlytics.log(any));
    verifyNever(
      crashlytics.recordError(
        any,
        any,
        reason: anyNamed("reason"),
        fatal: anyNamed("fatal"),
      ),
    );
  });

  test("Debug mode prints stack trace", () async {
    final printed = await capturePrintStatements(
      () => Log("Test", isDebug: true).e(
        Exception(),
        reason: "Test exception",
        stackTrace: StackTrace.fromString("Test stack trace"),
      ),
    );
    expect(printed, contains("E/AL-Test: Test exception (Exception)"));
    expect(printed, contains("Test stack trace"));
  });

  test("Debug mode does not print stack trace", () async {
    final printed = await capturePrintStatements(
      () => Log("Test", isDebug: true).w("Test warning"),
    );
    expect(printed.length, 1);
    expect(printed[0], "W/AL-Test: Test warning");
  });

  test("Reason and fatal are passed to Crashlytics error recording", () {
    when(
      crashlytics.recordError(
        any,
        any,
        reason: anyNamed("reason"),
        fatal: anyNamed("fatal"),
      ),
    ).thenAnswer((_) => Future.value());

    log = Log("Test", isDebug: false);
    log.e(
      Exception(),
      reason: "Test message",
      stackTrace: StackTrace.current,
      fatal: true,
    );

    final result = verify(
      crashlytics.recordError(
        any,
        any,
        reason: captureAnyNamed("reason"),
        fatal: captureAnyNamed("fatal"),
      ),
    );
    result.called(1);

    expect(result.captured.first, "E/AL-Test: Test message");
    expect(result.captured.last, true);
  });

  test("e without stack trace sends the caller's stack trace", () {
    log.e(Exception());

    final stackTrace =
        verify(
              crashlytics.recordError(
                any,
                captureAny,
                reason: anyNamed("reason"),
                fatal: anyNamed("fatal"),
              ),
            ).captured.single
            as StackTrace;
    final lines = stackTrace.toString().split("\n");
    expect(lines.first.contains("log_test.dart"), isTrue);
    expect(lines.any((line) => line.contains("utils/log.dart")), isFalse);
  });

  test("e with stack trace sends it unchanged", () {
    final stackTrace = StackTrace.fromString("Test stack trace");
    log.e(Exception(), stackTrace: stackTrace);

    verify(
      crashlytics.recordError(
        any,
        stackTrace,
        reason: anyNamed("reason"),
        fatal: anyNamed("fatal"),
      ),
    ).called(1);
  });

  test("Crashlytics log failure is printed instead of thrown", () async {
    when(crashlytics.log(any)).thenThrow(Exception("No Firebase app"));

    final printed = await capturePrintStatements(() => log.w("Message"));

    expect(printed.length, 1);
    expect(printed.first.contains("Failed to send log to Crashlytics"), isTrue);
    expect(printed.first.contains("W/AL-Test: Message"), isTrue);
  });

  test(
    "Crashlytics recordError failure is printed instead of thrown",
    () async {
      when(
        crashlytics.recordError(
          any,
          any,
          reason: anyNamed("reason"),
          fatal: anyNamed("fatal"),
        ),
      ).thenThrow(Exception("No Firebase app"));

      final printed = await capturePrintStatements(
        () => log.e(Exception(), reason: "Reason"),
      );

      expect(printed.length, 1);
      expect(
        printed.first.contains("Failed to send log to Crashlytics"),
        isTrue,
      );
      expect(printed.first.contains("E/AL-Test: Reason"), isTrue);
    },
  );

  test("sync error includes description", () {
    log.sync("TAG", 10, () {
      sleep(const Duration(milliseconds: 60));
      return 3;
    }, describe: (result) => "$result things");

    final exception =
        verify(
              crashlytics.recordError(
                captureAny,
                any,
                reason: anyNamed("reason"),
                fatal: anyNamed("fatal"),
              ),
            ).captured.single
            as TimeoutException;
    expect(exception.message, contains("threshold 10ms, 3 things"));
    expect(exception.duration, const Duration(milliseconds: 10));
  });

  test("sync error excludes description when not set", () {
    log.sync("TAG", 10, () => sleep(const Duration(milliseconds: 60)));

    final exception =
        verify(
              crashlytics.recordError(
                captureAny,
                any,
                reason: anyNamed("reason"),
                fatal: anyNamed("fatal"),
              ),
            ).captured.single
            as TimeoutException;
    expect(exception.message, contains("threshold 10ms)"));
  });

  test("sync debug includes description", () {
    log.sync("TAG", 1000, () => 3, describe: (result) => "$result things");

    expect(
      verify(crashlytics.log(captureAny)).captured.single,
      contains("threshold 1000ms, 3 things) within run threshold"),
    );
  });

  test("sync debug excludes description when not set", () {
    log.sync("TAG", 1000, () => 3);

    expect(
      verify(crashlytics.log(captureAny)).captured.single,
      contains("threshold 1000ms) within run threshold"),
    );
  });
}
