import 'dart:io';

import 'package:adair_flutter_lib/utils/log.dart';
import 'package:adair_flutter_lib/wrappers/crashlytics_wrapper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../mocks/mocks.mocks.dart';

void main() {
  late Log log;
  late MockCrashlyticsWrapper crashlytics;

  setUp(() {
    crashlytics = MockCrashlyticsWrapper();
    when(crashlytics.log(any)).thenAnswer((_) => Future.value());
    when(
      crashlytics.recordError(any, any, reason: anyNamed("reason")),
    ).thenAnswer((_) => Future.value());
    CrashlyticsWrapper.set(crashlytics);

    log = Log("Test", isDebug: false);
  });

  test("sync logs error", () {
    log.sync("TAG", 50, () => sleep(const Duration(milliseconds: 60)));
    verify(
      crashlytics.recordError(any, any, reason: anyNamed("reason")),
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
      crashlytics.recordError(any, any, reason: anyNamed("reason")),
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
    verifyNever(crashlytics.recordError(any, any, reason: anyNamed("reason")));
  });

  test("Debug mode doesn't use Crashlytics", () async {
    log = Log("Test", isDebug: true);
    await log.async(
      "TAG",
      50,
      Future.delayed(const Duration(milliseconds: 40)),
    );
    verifyNever(crashlytics.log(any));
    verifyNever(crashlytics.recordError(any, any, reason: anyNamed("reason")));
  });
}
