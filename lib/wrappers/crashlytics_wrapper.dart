import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';

class CrashlyticsWrapper {
  static var _instance = CrashlyticsWrapper._();

  static CrashlyticsWrapper get get => _instance;

  @visibleForTesting
  static void set(CrashlyticsWrapper manager) => _instance = manager;

  @visibleForTesting
  static void reset() => _instance = CrashlyticsWrapper._();

  CrashlyticsWrapper._();

  Future<void> log(String message) {
    return FirebaseCrashlytics.instance.log(message);
  }

  Future<void> setUserId(String identifier) {
    return FirebaseCrashlytics.instance.setUserIdentifier(identifier);
  }

  Future<void> setCustomKey(String key, Object value) {
    return FirebaseCrashlytics.instance.setCustomKey(key, value);
  }

  Future<void> recordError(
    dynamic message,
    StackTrace? stack, {
    dynamic reason,
    Iterable<Object> information = const [],
    bool? printDetails,
    bool fatal = false,
  }) {
    return FirebaseCrashlytics.instance.recordError(
      message,
      stack,
      reason: reason,
      information: information,
      printDetails: printDetails,
      fatal: fatal,
    );
  }
}
