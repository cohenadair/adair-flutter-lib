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

  Future<void> recordError(String message, StackTrace? stack, String reason) {
    return FirebaseCrashlytics.instance.recordError(
      message,
      stack,
      reason: reason,
    );
  }

  Future<void> setUserId(String identifier) {
    return FirebaseCrashlytics.instance.setUserIdentifier(identifier);
  }
}
