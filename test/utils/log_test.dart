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

  test("e prints reason and exception if not empty", () {
    var statements = capturePrintStatements(() {
      Log(
        "Test",
        isDebug: true,
      ).e(Exception("Test exception"), reason: "Test reason");
    });
    expect(statements.length, 2);
    expect(statements.first.contains("Test reason"), isTrue);
    expect(statements.last.contains("Test exception"), isTrue);
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

  test("Debug mode prints stack trace", () {
    final printed = capturePrintStatements(
      () => Log("Test", isDebug: true).e(
        Exception(),
        reason: "Test exception",
        stackTrace: StackTrace.fromString("Test stack trace"),
      ),
    );
    expect(printed, contains("E/AL-Test: Test exception"));
    expect(printed, contains("Test stack trace"));
  });

  test("Debug mode does not print stack trace", () {
    final printed = capturePrintStatements(
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

    var result = verify(
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
}
